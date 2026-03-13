#!/usr/bin/python3

import requests
from bs4 import BeautifulSoup
import re
import sys
import os

#For Windows
#INSTALL BEAUTIFUL SOUP WITH PIP and you can do this interactively with PowerShell core or your built-in PowerShell: 
#python -m pip install --user requests beautifulsoup4

#For Linux

# Option 1: Install via apt (system packages)
#sudo apt update
#sudo apt install python3-pip python3-bs4 python3-requests

# Option 2: Install via pip (user/local install, recommended for latest versions)
#python3 -m pip install --user requests beautifulsoup4


def get_fresh_libgen_download_url(md5: str) -> str | None:
    """Returns the current working get.php URL with fresh key."""
    ads_url = f"https://libgen.la/ads.php?md5={md5}"

    headers = {
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 "
                      "(KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36",
        "Referer": ads_url,
        "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"
    }

    try:
        r = requests.get(ads_url, headers=headers, timeout=15)
        r.raise_for_status()

        soup = BeautifulSoup(r.text, "html.parser")

        # Find the download link
        link = soup.find("a", href=lambda h: h and "get.php?md5=" in h)

        if not link:
            print("❌ Could not find download link on ads.php")
            return None

        relative_url = link["href"]
        full_url = "https://libgen.la/" + relative_url

        print(f"✅ Fresh download URL: {full_url}")
        return full_url

    except Exception as e:
        print(f"❌ Error fetching ads.php: {e}")
        return None


def download_file(url: str, md5: str):
    """Downloads the file with proper headers and saves it to the current working directory."""

    headers = {
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 "
                      "(KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36",
        "Referer": f"https://libgen.la/ads.php?md5={md5}"
    }

    with requests.get(url, headers=headers, stream=True, timeout=60) as r:
        r.raise_for_status()

        # Extract filename from Content-Disposition header
        cd = r.headers.get("Content-Disposition", "")
        filename_match = re.findall('filename="?([^"]+)"?', cd)
        filename = filename_match[0] if filename_match else f"{md5}.unknown"

        download_path = os.path.join(os.getcwd(), filename)

        print(f"📥 Downloading as: {filename}")
        print(f"📂 Saving to: {download_path}")
        print(f"📦 Size: {r.headers.get('Content-Length', 'unknown')} bytes")

        with open(download_path, "wb") as f:
            for chunk in r.iter_content(chunk_size=8192):
                f.write(chunk)

        print("✅ Download complete!")


# ========================== USAGE ==========================

if __name__ == "__main__":

    # Your MD5 from the old link
    MD5 = "8638619c05f6042d1b70b3658a2dba7b"

    fresh_url = get_fresh_libgen_download_url(MD5)

    if fresh_url:
        download_file(fresh_url, MD5)
