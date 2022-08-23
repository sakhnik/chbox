#!/usr/bin/env python

# Fetch English transcription and pronunciation for an entered word.
# Copy them to the clipboard by clicking on the button.

import requests
import random
from bs4 import BeautifulSoup
import gi
gi.require_version("Gtk", "4.0")
from gi.repository import Gtk


user_agents = [
  "Mozilla/5.0 (Windows NT 10.0; rv:91.0) Gecko/20100101 Firefox/91.0",
  "Mozilla/5.0 (Windows NT 10.0; rv:78.0) Gecko/20100101 Firefox/78.0",
  "Mozilla/5.0 (X11; Linux x86_64; rv:95.0) Gecko/20100101 Firefox/95.0"
  ]


def Fetch(word):
    url = f"https://www.oxfordlearnersdictionaries.com/search/english/direct/?q={word}"

    random_user_agent = random.choice(user_agents)
    headers = {
        'User-Agent': random_user_agent
    }

    response = requests.get(url, headers=headers)
    soup = BeautifulSoup(response.text, 'html.parser')
    defs = []
    for phon_br in soup.find_all('div', 'phons_br'):
        row = []
        for t in phon_br.find_all('span', 'phon'):
            row.append(t.text)
        for t in phon_br.find_all('div', 'pron-uk'):
            row.append(t.get('data-src-ogg', t.get('data-src-mp3')))
        defs.append(row)
    return defs


def FillTheGrid(grid, word, on_click):
    while True:
        if grid.get_child_at(0, 1) is not None:
            grid.remove_row(1)
        else:
            break

    defs = Fetch(word)
    for r, row in enumerate(defs):
        for c, d in enumerate(row):
            btn = Gtk.Button(label=d)
            grid.attach(btn, c, r, 1, 1)
            btn.connect('clicked', on_click)


def on_activate(app):
    win = Gtk.ApplicationWindow(application=app)

    entry = Gtk.Entry()
    entry.set_placeholder_text("Type and English word and press Enter")

    grid = Gtk.Grid()

    box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
    box.append(entry)
    box.append(grid)

    def OnClick(x):
        x.get_clipboard().set(x.get_label())
        entry.grab_focus()

    entry.connect('activate',
                  lambda x: FillTheGrid(grid, x.get_text(), OnClick))

    win.set_child(box)
    win.present()


app = Gtk.Application(application_id='org.gtk.Example')
app.connect('activate', on_activate)
app.run(None)
