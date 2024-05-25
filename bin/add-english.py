#!/usr/bin/env python

# Prepare a CSV file for import into Anki:
# fetch transcription and pronunciation
# Usage:
# 1) Prepare a CSV file:
# word1|translation2
# word1|translation2
# 2) Filter it in NeoVim via this program:
# :%!add-english.py
# A column with transcription and pronunciation will be appended, media files
#  downloaded to the Anki collection
# 3) Add one more column for examples if necessary
# 4) Import the CSV into Anki

import aiohttp
import asyncio
import random
from bs4 import BeautifulSoup
import csv
import os
import sys


media_dir = "/home/sakhnik/.local/share/Anki2/new/collection.media"

user_agents = [
  "Mozilla/5.0 (Windows NT 10.0; rv:91.0) Gecko/20100101 Firefox/91.0",
  "Mozilla/5.0 (Windows NT 10.0; rv:78.0) Gecko/20100101 Firefox/78.0",
  "Mozilla/5.0 (X11; Linux x86_64; rv:95.0) Gecko/20100101 Firefox/95.0"
  ]

random_user_agent = random.choice(user_agents)
headers = {
    'User-Agent': random_user_agent
}


async def fetch(session, url):
    try:
        async with session.get(url) as response:
            response.raise_for_status()
            return await response.text()
    except aiohttp.ClientError as e:
        print(f"Error fetching {url}: {e}")
        return None


async def fetch_word(session, word):
    url = "https://www.oxfordlearnersdictionaries.com/search/english/direct/"
    defs = []
    async with session.get(f"{url}?q={word}") as response:
        response.raise_for_status()
        soup = BeautifulSoup(await response.text(), 'html.parser')
        for phon_br in soup.find_all('div', 'phons_br'):
            row = []
            for t in phon_br.find_all('span', 'phon'):
                row.append(t.text)
                break
            for t in phon_br.find_all('div', 'pron-uk'):
                row.append(t.get('data-src-ogg', t.get('data-src-mp3')))
                break
            defs.append(row)
    return defs


async def process_row(session, row):
    front = row[0]
    back = row[1]
    trans, pronun_url = (await fetch_word(session, front))[0]
    pronun = os.path.basename(pronun_url)
    file_name = os.path.join(media_dir, pronun)
    async with session.get(pronun_url) as response:
        response.raise_for_status()
        with open(file_name, 'wb') as file:
            while True:
                chunk = await response.content.read(1024)
                if not chunk:
                    break
                file.write(chunk)
    return [front, back, trans + f"[sound:{pronun}]", '']


async def main():
    # separator:Pipe
    # notetype:Yaryna English
    # deck:School:Yaryna:English
    # columns:Front|Back|Transcription|Example

    os.makedirs(media_dir, exist_ok=True)

    async with aiohttp.ClientSession(headers=headers) as session:
        csv_reader = csv.reader(sys.stdin, delimiter='|')
        tasks = [process_row(session, row) for row in csv_reader]
        result_rows = await asyncio.gather(*tasks)

    csv_writer = csv.writer(sys.stdout, delimiter='|')
    csv_writer.writerows(result_rows)


asyncio.run(main())
