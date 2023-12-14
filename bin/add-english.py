#!/usr/bin/env python

# Prepare a CSV file for import into Anki:
# fetch transcription and pronunciation
# Usage:
# 1) Prepare a CSV file:
# word1|translation2
# word1|translation2
# 2) Filter it in NeoVim via this program:
# :%!add-english.py
# A column with transcription and pronunciation will be appended, media files downloaded to the Anki collection
# 3) Add one more column for examples if necessary
# 4) Import the CSV into Anki

import requests
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


def Fetch(word):
    url = "https://www.oxfordlearnersdictionaries.com/search/english/direct/"

    response = requests.get(f"{url}?q={word}", headers=headers)
    soup = BeautifulSoup(response.text, 'html.parser')
    defs = []
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


# separator:Pipe
# notetype:Yaryna English
# deck:School:Yaryna:English
# columns:Front|Back|Transcription|Example

os.makedirs(media_dir, exist_ok=True)

data = []

csv_reader = csv.reader(sys.stdin, delimiter='|')
for row in csv_reader:
    front = row[0]
    back = row[1]
    trans, pronun_url = Fetch(front)[0]
    pronun = os.path.basename(pronun_url)
    file_name = os.path.join(media_dir, pronun)
    response = requests.get(pronun_url, headers=headers)
    if response.status_code == 200:
        with open(file_name, 'wb') as file:
            file.write(response.content)
    data.append([front, back, trans + f"[sound:{pronun}]", ''])
    # print(data[-1])

csv_writer = csv.writer(sys.stdout, delimiter='|')
csv_writer.writerows(data)
