#!/usr/bin/env python

import sys
import requests
import random
from bs4 import BeautifulSoup

word = sys.argv[1]
url = f"https://www.oxfordlearnersdictionaries.com/search/english/direct/?q={word}"

user_agents = [
  "Mozilla/5.0 (Windows NT 10.0; rv:91.0) Gecko/20100101 Firefox/91.0",
  "Mozilla/5.0 (Windows NT 10.0; rv:78.0) Gecko/20100101 Firefox/78.0",
  "Mozilla/5.0 (X11; Linux x86_64; rv:95.0) Gecko/20100101 Firefox/95.0"
  ]
random_user_agent = random.choice(user_agents)
headers = {
    'User-Agent': random_user_agent
}

response = requests.get(url, headers=headers)
soup = BeautifulSoup(response.text, 'html.parser')
for t in soup.find_all('span', 'phon'):
    print(t.text)
for t in soup.find_all('div', 'pron-uk'):
    print(t.get('data-src-ogg', t.get('data-src-mp3')))
