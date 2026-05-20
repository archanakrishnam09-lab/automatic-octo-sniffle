#!/bin/bash

# Simple Bash Vulnerability Scanner
# Usage: ./vulnscan.sh <target-ip-or-domain>

TARGET=$1

if [ -z "$TARGET" ]; then
    echo "Usage: $0 <target>"
    exit 1
fi

echo "====================================="
echo " Simple Vulnerability Scanner"
echo " Target: $TARGET"
echo "====================================="

# Check if nmap exists
if ! command -v nmap &> /dev/null; then
    echo "[!] nmap is not installed."
    exit 1
fi

echo ""
echo "[*] Running port scan..."
nmap -Pn -sV "$TARGET" -oN scan_results.txt

echo ""
echo "[*] Checking for common vulnerabilities..."

# Simple checks
echo ""
echo "[+] Open SSH?"
grep "22/tcp open" scan_results.txt && echo "    -> SSH service detected"

echo ""
echo "[+] Open FTP?"
grep "21/tcp open" scan_results.txt && echo "    -> FTP service detected (check anonymous login)"

echo ""
echo "[+] Open HTTP?"
grep "80/tcp open" scan_results.txt && echo "    -> Web server detected"

echo ""
echo "[+] Open HTTPS?"
grep "443/tcp open" scan_results.txt && echo "    -> Secure web server detected"

echo ""
echo "[*] Running basic NSE vulnerability scripts..."
nmap --script vuln "$TARGET" -oN vuln_results.txt

echo ""
echo "====================================="
echo " Scan Completed"
echo " Results saved to:"
echo "  - scan_results.txt"
echo "  - vuln_results.txt"
echo "====================================="
