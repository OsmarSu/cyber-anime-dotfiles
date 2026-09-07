#!/usr/bin/env python3
"""
waybar-hypr-bridge.py
Translates legacy Hyprland IPC dispatch commands from Waybar into
Hyprland 0.56 Lua-compatible dispatcher calls.
"""
import os
import sys
import re
import socket
import signal
import select

signal.signal(signal.SIGHUP, signal.SIG_IGN)

LOG_FILE = "/tmp/waybar-bridge.log"

def log(msg):
    try:
        with open(LOG_FILE, "a") as f:
            f.write(f"{msg}\n")
    except Exception:
        pass

def get_hypr_sig():
    sig = os.environ.get('HYPRLAND_INSTANCE_SIGNATURE')
    if sig:
        if sig.endswith('-wb'):
            sig = sig[:-3]
        if os.path.exists(f'/run/user/{os.getuid()}/hypr/{sig}/.socket.sock'):
            return sig
    base = f'/run/user/{os.getuid()}/hypr'
    if not os.path.isdir(base):
        return None
    for entry in os.listdir(base):
        if entry.endswith('-wb'):
            continue
        sock = os.path.join(base, entry, '.socket.sock')
        if os.path.exists(sock):
            try:
                s = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
                s.settimeout(0.5)
                s.connect(sock)
                s.close()
                return entry
            except Exception:
                continue
    return None

sig = get_hypr_sig()
if not sig:
    log("Could not find active Hyprland instance signature")
    sys.exit(1)

real_dir = f'/run/user/{os.getuid()}/hypr/{sig}'
real_sock = os.path.join(real_dir, '.socket.sock')
real_sock2 = os.path.join(real_dir, '.socket2.sock')

bridge_sig = f'{sig}-wb'
bridge_dir = f'/run/user/{os.getuid()}/hypr/{bridge_sig}'
os.makedirs(bridge_dir, exist_ok=True)

# Symlink .socket2.sock
bridge_sock2 = os.path.join(bridge_dir, '.socket2.sock')
try:
    if os.path.islink(bridge_sock2) or os.path.exists(bridge_sock2):
        os.remove(bridge_sock2)
    os.symlink(real_sock2, bridge_sock2)
except Exception as e:
    print(f"Error linking socket2: {e}", file=sys.stderr)

# Setup bridge .socket.sock
bridge_sock = os.path.join(bridge_dir, '.socket.sock')
if os.path.exists(bridge_sock):
    try:
        os.remove(bridge_sock)
    except Exception:
        pass

server = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
server.bind(bridge_sock)
server.listen(32)

def cleanup(*args):
    try:
        server.close()
    except Exception:
        pass
    for path in (bridge_sock, bridge_sock2):
        try:
            if os.path.islink(path) or os.path.exists(path):
                os.remove(path)
        except Exception:
            pass
    try:
        os.rmdir(bridge_dir)
    except Exception:
        pass
    sys.exit(0)

signal.signal(signal.SIGTERM, cleanup)
signal.signal(signal.SIGINT, cleanup)

def translate(raw: bytes) -> bytes:
    try:
        text = raw.decode('utf-8', errors='replace')
    except Exception:
        return raw

    orig = text

    def clean_ws(ws):
        if ws.startswith('name:'):
            return ws[5:]
        return ws

    # Replace /dispatch workspace <id> or dispatch workspace <id>
    def repl_ws(m):
        prefix = m.group(1) # e.g. '/dispatch ' or 'dispatch '
        ws = clean_ws(m.group(2))
        return f'{prefix}hl.dsp.focus({{ workspace = "{ws}" }})'

    text = re.sub(r'(/??dispatch\s+)workspace\s+([^\s;]+)', repl_ws, text)
    text = re.sub(r'(/??dispatch\s+)focusworkspaceoncurrentmonitor\s+([^\s;]+)', repl_ws, text)

    # Window move to workspace
    def repl_move(m):
        prefix = m.group(1)
        ws = clean_ws(m.group(2))
        return f'{prefix}hl.dsp.window.move({{ workspace = "{ws}" }})'
    text = re.sub(r'(/??dispatch\s+)movetoworkspace\s+([^\s;]+)', repl_move, text)

    def repl_movesilent(m):
        prefix = m.group(1)
        ws = clean_ws(m.group(2))
        return f'{prefix}hl.dsp.window.move({{ workspace = "{ws}", follow = false }})'
    text = re.sub(r'(/??dispatch\s+)movetoworkspacesilent\s+([^\s;]+)', repl_movesilent, text)

    # Special workspaces
    def repl_special(m):
        prefix = m.group(1)
        name = clean_ws(m.group(2) or "")
        return f'{prefix}hl.dsp.workspace.toggle_special("{name}")'
    text = re.sub(r'(/??dispatch\s+)togglespecialworkspace\s*([^\s;]*)', repl_special, text)

    if text != orig:
        log(f"TRANSLATED: {orig.strip()} -> {text.strip()}")
    else:
        log(f"PASSTHROUGH: {orig.strip()}")

    return text.encode('utf-8')

# Event loop
inputs = [server]
log("Bridge started successfully")
while True:
    try:
        readable, _, _ = select.select(inputs, [], [], 10.0)
        for s in readable:
            if s is server:
                client, _ = server.accept()
                try:
                    client.settimeout(2.0)
                    data = client.recv(8192)
                    if not data:
                        client.close()
                        continue
                    
                    translated = translate(data)
                    real = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
                    real.settimeout(2.0)
                    real.connect(real_sock)
                    real.sendall(translated)
                    
                    # Read response
                    res = b''
                    while True:
                        chunk = real.recv(8192)
                        if not chunk:
                            break
                        res += chunk
                        if len(chunk) < 8192:
                            break
                    real.close()
                    client.sendall(res)
                except Exception as e:
                    log(f"Handler error: {e}")
                finally:
                    try:
                        client.close()
                    except Exception:
                        pass
    except KeyboardInterrupt:
        break
    except Exception as e:
        log(f"Loop error: {e}")

cleanup()
