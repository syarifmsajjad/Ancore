#!/bin/bash

RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
CYAN='\033[1;36m'
RESET='\033[0m'

echo -e "\033[1;35m
    _    _   _  ____ ___  ____  _____ 
   / \  | \ | |/ ___/ _ \|  _ \| ____|
  / _ \ |  \| | |  | | | | |_) |  _|  
 / ___ \| |\  | |__| |_| |  _ <| |___ 
/_/   \_\_| \_|\____\___/|_| \_\_____|

Automated Endpoint Crawler for Online Resources

\033[1;34m       By @syarif07
\033[0m"

usage() {
  echo -e "${YELLOW}Usage: $0 -t <target_domain> -o <output_file>${RESET}"
  exit 1
}

while [[ "$#" -gt 0 ]]; do
  case $1 in
    -t) target_domain="$2"; shift 2;;
    -o) output_file="$2"; shift 2;;
    *) usage ;;
  esac
done

if [ -z "$target_domain" ]; then
  usage
fi

output_result() {
  local source=$1
  local url=$2
  echo -e "${GREEN}[$source]${RESET} => ${CYAN}$url${RESET}"
  if [ -n "$output_file" ]; then
    echo "$url" >> "$output_file"
  fi
}

crawl_waybackmachine() {
  local domain=$1
  echo -e "${BLUE}\nFetching data from Wayback Machine for domain:${RESET} ${CYAN}$domain${RESET}"
  curl -sk "https://web.archive.org/cdx/search/cdx?url=*.${domain}/*&output=text&fl=original&collapse=urlkey" | \
  sort -u | while read -r url; do
    output_result "Wayback Machine" "$url"
  done
}

crawl_virustotal() {
  local domain=$1
  local api_keys=("<VIRUSTOTAL_API_KEY_1>" "<VIRUSTOTAL_API_KEY_2>" "<VIRUSTOTAL_API_KEY_3>")
  local api_key_index=0

  echo -e "${BLUE}\nFetching data from VirusTotal for domain:${RESET} ${CYAN}$domain${RESET}"
  for api_key in "${api_keys[@]}"; do
    local URL="https://www.virustotal.com/vtapi/v2/domain/report?apikey=$api_key&domain=$domain"
    response=$(curl -s "$URL" | jq -r '.undetected_urls[][0]')
    
    if [[ -n "$response" ]]; then
      echo "$response" | while read -r url; do
        output_result "VirusTotal" "$url"
      done
      return
    fi
    api_key_index=$(( (api_key_index + 1) % ${#api_keys[@]} ))
    sleep 20
  done
}

crawl_urlscan() {
  local domain=$1
  echo -e "${BLUE}\nFetching data from URLScan for domain:${RESET} ${CYAN}$domain${RESET}"
  curl -sk "https://urlscan.io/api/v1/search/?q=domain:$domain&size=10000" | \
  jq -r '.results[].task.url' | sort -u | while read -r url; do
    output_result "URLScan" "$url"
  done
}

crawl_otxalienvault() {
  local domain=$1
  local page=1
  local limit=50

  echo -e "${BLUE}\nFetching data from OTX AlienVault for domain:${RESET} ${CYAN}$domain${RESET}"
  while true; do
    result=$(curl -sk "https://otx.alienvault.com/api/v1/indicators/domain/$domain/url_list?limit=$limit&page=$page" | \
      jq -r '.url_list[].url' | sort -u)

    if [[ -z "$result" ]]; then
      echo -e "${YELLOW}Tidak ada lagi data pada page $page.${RESET}"
      break
    fi

    echo "$result" | while read -r url; do
      output_result "OTX AlienVault" "$url"
    done
    ((page++))
  done
}

if [ -n "$output_file" ]; then
  > "$output_file"  
fi

crawl_waybackmachine "$target_domain"
crawl_virustotal "$target_domain"
crawl_urlscan "$target_domain"
crawl_otxalienvault "$target_domain"

echo -e "${GREEN}Crawling selesai!${RESET}"
if [ -n "$output_file" ]; then
  echo -e "${YELLOW}Hasil output disimpan di $output_file${RESET}"
fi