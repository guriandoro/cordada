#!/usr/bin/env bash
# Cordada preflight: is this machine ready for the workshop?
#
# Read-only. It installs nothing and changes nothing.
# Run it from anywhere:  ./preflight.sh   (or: bash cordada/preflight.sh)
#
# Tested on macOS and Linux. Windows is untested: use WSL (Ubuntu) and run
# everything, including Claude Code, inside it. Git Bash may work but has not
# been tried.
#
# Exit 0 when levels 1 to 4 are possible. bd (beads) is only needed for
# level 5, so a missing bd is a warning, not a failure.

set -u

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
fail=0
warn=0

ok()      { printf '  OK       %s\n' "$1"; }
missing() { printf '  MISSING  %s\n           fix: %s\n' "$1" "$2"; fail=1; }
warning() { printf '  WARN     %s\n           fix: %s\n' "$1" "$2"; warn=1; }

echo "Cordada preflight ($(uname -s))"
echo

# git
if command -v git >/dev/null 2>&1; then
  ok "git $(git --version 2>/dev/null | awk '{print $3}')"
else
  missing "git" "install git (macOS: xcode-select --install; Debian/Ubuntu: sudo apt install git)"
fi

# Claude Code
if command -v claude >/dev/null 2>&1; then
  ver="$(claude --version 2>/dev/null | head -n 1)"
  ok "claude ${ver:-version unknown}"

  # Login check. 'claude auth status' only reads the saved login and prints JSON
  # with a loggedIn field. Older versions may not have the command: then we say
  # we could not check, and do not guess.
  if out="$(claude auth status --json 2>/dev/null)" && [ -n "$out" ]; then
    case "$out" in
      *'"loggedIn": true'*|*'"loggedIn":true'*) ok "claude: logged in" ;;
      *'"loggedIn"'*) missing "claude: not logged in" "run 'claude' once and sign in (or: claude auth login)" ;;
      *) warning "claude: could not read login status" "start 'claude' and check that it does not ask you to sign in" ;;
    esac
  else
    warning "claude: could not check login ('claude auth status' failed or is missing)" "start 'claude' and check that it does not ask you to sign in"
  fi
else
  missing "claude (Claude Code)" "install it: https://code.claude.com/docs (no account? pair up, or follow the speaker's screen)"
fi

# python3 >= 3.9 (the sample repo and the guard hook need it)
if command -v python3 >/dev/null 2>&1; then
  pyver="$(python3 -c 'import sys; print("%d.%d" % sys.version_info[:2])' 2>/dev/null)"
  if python3 -c 'import sys; sys.exit(0 if sys.version_info >= (3, 9) else 1)' 2>/dev/null; then
    ok "python3 $pyver"
  else
    missing "python3 3.9 or later (found ${pyver:-unknown})" "install a newer Python 3 (macOS: brew install python; Linux: your package manager)"
  fi
else
  missing "python3" "install Python 3.9 or later (macOS: brew install python; Debian/Ubuntu: sudo apt install python3)"
fi

# bd (beads), level 5 only
if command -v bd >/dev/null 2>&1; then
  bdver="$(bd --version 2>/dev/null | head -n 1)"
  ok "bd: ${bdver:-version unknown}"
else
  warning "bd (beads), needed only for level 5" "macOS: brew install beads; other platforms: https://github.com/steveyegge/beads"
fi

# The clone itself
if [ -x "$here/sample/create.sh" ]; then
  ok "sample/create.sh"
elif [ -f "$here/sample/create.sh" ]; then
  missing "sample/create.sh is not executable" "chmod +x $here/sample/create.sh"
else
  missing "sample/create.sh" "run this script from a full clone: git clone https://github.com/guriandoro/cordada"
fi

if [ -f "$here/plugins/cordada/.claude-plugin/plugin.json" ]; then
  ok "plugins/cordada"
else
  missing "plugins/cordada" "run this script from a full clone: git clone https://github.com/guriandoro/cordada"
fi

echo
if [ $fail -ne 0 ]; then
  echo "Verdict: NOT READY. Fix the MISSING lines above, or plan to pair up."
  exit 1
elif [ $warn -ne 0 ]; then
  echo "Verdict: READY for levels 1 to 4. Read the WARN lines before the workshop."
else
  echo "Verdict: READY for all five levels."
fi
exit 0
