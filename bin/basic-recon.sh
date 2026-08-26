#!/bin/bash
# Basic recon tool for MIRA pre-analysis
# Usage: basic-recon.sh <domain|ip> [output_file]

set -euo pipefail

if [[ $# -lt 1 ]]; then
    echo "Usage: $0 <domain|ip> [output_file]"
    exit 1
fi

TARGET="$1"
SAFE_TARGET=$(echo "$TARGET" | sed 's|[/:]|_|g')
OUTPUT="${2:-recon_${SAFE_TARGET}_$(date +%Y%m%d_%H%M%S).txt}"

WORDLIST="/usr/share/wordlists/seclists/Discovery/Web-Content/directory-list-2.3-medium.txt"

# Fallback wordlist if first doesn't exist
if [[ ! -f "$WORDLIST" ]]; then
    WORDLIST="$HOME/tools/SecLists-master/Discovery/Web-Content/DirBuster-2007_directory-list-2.3-medium.txt"
fi

if [[ ! -f "$WORDLIST" ]]; then
    echo "Error: directory-list-2.3-medium.txt not found"
    exit 1
fi

TMPDIR=$(mktemp -d)
trap "rm -rf $TMPDIR" EXIT

echo "[*] Starting recon for $TARGET"
echo "[*] Output: $OUTPUT"
echo

# Clear output file
> "$OUTPUT"

# Helper function
run_cmd() {
    local cmd="$1"
    local outfile="$2"
    
    echo "\$ $cmd" | tee -a "$OUTPUT"
    eval "$cmd" > "$outfile" 2>&1 || true
    cat "$outfile" | tee -a "$OUTPUT"
    echo "" | tee -a "$OUTPUT"
}

# 1. Port scan + service detection
echo "[1/4] Port scanning with nmap..."

NMAP_CMD="nmap -Pn -sV -T4 --top-ports 1000 $TARGET -oG $TMPDIR/nmap.gnmap"
echo "\$ $NMAP_CMD" | tee -a "$OUTPUT"
nmap -Pn -sV -T4 --top-ports 1000 "$TARGET" -oG "$TMPDIR/nmap.gnmap" 2>&1 | tee -a "$OUTPUT" "$TMPDIR/nmap.txt" || true
echo "" | tee -a "$OUTPUT"

# Extract open ports for httpx (format: host:port)
grep -oP '\d+/open' "$TMPDIR/nmap.gnmap" 2>/dev/null | grep -oP '^\d+' | while read port; do echo "$TARGET:$port"; done > "$TMPDIR/hosts_with_ports.txt" || touch "$TMPDIR/hosts_with_ports.txt"

# 2. HTTP probing
echo "[2/4] HTTP probing with httpx..."

if [[ -s "$TMPDIR/hosts_with_ports.txt" ]]; then
    run_cmd "httpx -list $TMPDIR/hosts_with_ports.txt -silent -sc -td -title -follow-redirects" "$TMPDIR/httpx.txt"
    
    # Extract live URLs for ffuf
    grep -oP '^https?://[^\s]+' "$TMPDIR/httpx.txt" 2>/dev/null | sort -u > "$TMPDIR/live_urls.txt" || touch "$TMPDIR/live_urls.txt"
else
    echo "[!] No open ports found, trying httpx on $TARGET directly..." | tee -a "$OUTPUT"
    run_cmd "httpx -target $TARGET -silent -sc -td -title -follow-redirects" "$TMPDIR/httpx.txt"
    
    grep -oP '^https?://[^\s]+' "$TMPDIR/httpx.txt" 2>/dev/null | sort -u > "$TMPDIR/live_urls.txt" || touch "$TMPDIR/live_urls.txt"
fi

# 3. Content discovery with ffuf
echo "[3/4] Content discovery with ffuf..."

if [[ -s "$TMPDIR/live_urls.txt" ]]; then
    while IFS= read -r url; do
        # Probe random path to detect wildcard/catch-all responses
        CATCHALL_SIZE=$(curl -s -o /dev/null -w "%{size_download}" --max-time 10 "${url}/zzqqxxwwyy123456")
        CATCHALL_STATUS=$(curl -s -o /dev/null -w "%{http_code}" --max-time 10 "${url}/zzqqxxwwyy123456")
        FFUF_FILTER="-ac"
        if [[ "$CATCHALL_STATUS" == "200" && "$CATCHALL_SIZE" =~ ^[0-9]+$ && "$CATCHALL_SIZE" -gt 0 ]]; then
            FFUF_FILTER="-fs $CATCHALL_SIZE"
            echo "[*] Wildcard response detected (status 200, size $CATCHALL_SIZE), filtering with -fs" | tee -a "$OUTPUT"
        fi
        
        FFUF_CMD="ffuf -u ${url}/FUZZ -w $WORDLIST -mc 200,204,301,302,307,401,403 -fc 404 $FFUF_FILTER -t 10 -s"
        echo "\$ $FFUF_CMD" | tee -a "$OUTPUT"
        
        ffuf -u "${url}/FUZZ" -w "$WORDLIST" -mc 200,204,301,302,307,401,403 -fc 404 $FFUF_FILTER -t 10 -s 2>&1 | tee -a "$OUTPUT" || true
        
        echo "" | tee -a "$OUTPUT"
    done < "$TMPDIR/live_urls.txt"
else
    echo "[!] No live URLs found, skipping ffuf" | tee -a "$OUTPUT"
    echo "" | tee -a "$OUTPUT"
fi

# 4. Nuclei scan
echo "[4/4] Running nuclei..."

if [[ -s "$TMPDIR/live_urls.txt" ]]; then
    run_cmd "nuclei -list $TMPDIR/live_urls.txt -severity medium,high,critical -silent -stats -rl 50" "$TMPDIR/nuclei.txt"
else
    echo "[!] No live URLs found, skipping nuclei" | tee -a "$OUTPUT"
    echo "" | tee -a "$OUTPUT"
fi

echo "[*] Recon complete!"
echo "[*] Results saved to: $OUTPUT"
