#!/bin/bash
# DAB MCP Server Wrapper Template
#
# This wrapper launches a Data API Builder (DAB) MCP server with a
# bidirectional proxy that strips null annotations/_meta fields from
# responses. DAB v1.7.92 serializes these as null, but the MCP spec
# requires object-or-absent. Claude Code's client rejects the nulls.
#
# Usage:
#   1. Copy this file to mcp/<server-name>/start-dab.sh
#   2. Set ASPNETCORE_URLS to a unique port (5000, 5001, 5002, etc.)
#   3. Adjust DOTNET_ROOT if .NET 8 is installed elsewhere
#   4. chmod +x start-dab.sh
#
# Prerequisites:
#   - .NET 8 runtime (brew install dotnet@8 on macOS)
#   - DAB CLI (dotnet tool install --global Microsoft.DataApiBuilder)
#   - MCP_TIMEOUT=30000 in shell profile (DAB takes ~10s to start)

# --- CUSTOMIZE THESE ---
export ASPNETCORE_URLS=http://127.0.0.1:5000  # Change port per server
# -----------------------

export DOTNET_ROOT=/opt/homebrew/opt/dotnet@8/libexec
DAB_PORT="${ASPNETCORE_URLS##*:}"
DAB_PORT="${DAB_PORT:-5000}"
cd "$(dirname "$0")"

# Kill any stale DAB process holding our port from a previous session
for pid in $(lsof -iTCP:"$DAB_PORT" -sTCP:LISTEN -t 2>/dev/null); do
  kill "$pid" 2>/dev/null
done

exec python3 -u -c "
import sys, json, subprocess, threading

proc = subprocess.Popen(
    ['$HOME/.dotnet/tools/dab', 'start', '--mcp-stdio'],
    stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=sys.stderr,
    bufsize=0
)

def forward_stdin():
    try:
        for line in sys.stdin.buffer:
            proc.stdin.write(line)
            proc.stdin.flush()
    except (BrokenPipeError, OSError):
        pass
    finally:
        try: proc.stdin.close()
        except OSError: pass

def strip_nulls(d):
    if isinstance(d, dict):
        return {k: strip_nulls(v) for k, v in d.items()
                if not (k in ('annotations', '_meta') and v is None)}
    if isinstance(d, list):
        return [strip_nulls(i) for i in d]
    return d

threading.Thread(target=forward_stdin, daemon=True).start()

for raw in proc.stdout:
    line = raw.decode('utf-8', errors='replace').strip()
    if not line:
        continue
    try:
        obj = json.loads(line)
        sys.stdout.write(json.dumps(strip_nulls(obj)) + '\n')
        sys.stdout.flush()
    except (json.JSONDecodeError, ValueError):
        sys.stdout.write(line + '\n')
        sys.stdout.flush()

proc.wait()
"
