#!/bin/bash
# ctrlcheck - mini NIST 800-53 host compliance scanner

PASS=0; FAIL=0
GREEN="\033[32m"; RED="\033[31m"; RESET="\033[0m"

pass() { echo -e "${GREEN}[PASS]${RESET} $1  $2"; PASS=$((PASS+1)); }
fail() { echo -e "${RED}[FAIL]${RESET} $1  $2  -> Fix: $3"; FAIL=$((FAIL+1)); }

check_firewall() {
  if /usr/libexec/ApplicationFirewall/socketfilterfw --getglobalstate | grep -q "enabled"; then
    pass "SC-7" "Firewall enabled"
  else
    fail "SC-7" "Firewall disabled" "System Settings > Network > Firewall"
  fi
}

check_filevault() {
  if fdesetup status | grep -q "On"; then
    pass "SC-28" "FileVault disk encryption on"
  else
    fail "SC-28" "FileVault off" "System Settings > Privacy & Security > FileVault"
  fi
}

echo "=== ctrlcheck: $(hostname) - $(date) ==="
check_firewall
check_filevault
echo "--- $PASS passed, $FAIL failed ---"
