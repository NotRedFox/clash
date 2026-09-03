# Chaos Draft

A reference tool for Clash Royale's Chaos mode and the draft modes.

Every card has three modifiers, one common, one rare and one epic. This shows
all of them with a rating from real win rates, works out how likely your deck is
to hand you something good, and identifies cards straight from a screenshot.

**Live:** https://notredfox.github.io/clash/

- 66 cards, 198 modifiers, every name, effect and rating
- Screenshot recognition for three draft layouts, no labelling or training
- Deck analysis against the real wave odds
- Works offline once loaded, installable to a phone home screen
- No accounts, no tracking, no model downloads

---

## How to put it on your phone

It runs as a web app. No app store, no install, works on iPhone and Android.

### iPhone

1. Open the link above in Safari. It has to be Safari, not Chrome.
2. Tap the Share button, the square with the arrow.
3. Scroll down and tap **Add to Home Screen**.
4. Tap Add.

### Android

1. Open the link in Chrome.
2. Tap the three dots, top right.
3. Tap **Add to Home screen**, or **Install app** if it offers that.
4. Tap Add.

Either way you get an icon on your home screen, and opening it hides the browser
bars so it behaves like a normal app.

---

## What each tab does

**Scan.** Pick the layout, load a screenshot, and it identifies the cards from
their artwork and ranks them by rating with every modifier listed.

Three layouts, each with its own measured card positions:

| Mode | Cards |
|------|-------|
| Triple draft | 3 |
| Draft | 2 |
| Mega draft | 36, top 8 shown |

Mega draft finds all 36 cards but only lists the eight worth taking, since
nobody reads 36 entries on a timer.

Tap any card name to correct it, and pick from the closest matches.

**Cards.** All 50 cards. Three boxes each for common, rare and epic. The bar
underneath shows the split, so a card with two S mods and one B reads as 67%
gold, 33% purple. Tap a name to see what the modifiers actually do.

**Deck.** Pick your 8. It shows a deck rating and, for each of the five waves,
the chance that at least one of your two offers is S or A tier.


---

## How the numbers work

### Wave odds

Chaos gives you five picks, and the rarity you are offered shifts as the match
goes on.

| Wave | Clock | Common | Rare | Epic |
|------|-------|--------|------|------|
| 1 | 2:56 | 90% | 10% | 0% |
| 2 | 2:11 | 20% | 80% | 0% |
| 3 | 1:26 | 0% | 50% | 50% |
| 4 | 0:26 | 0% | 20% | 80% |
| 5 | OT | 0% | 0% | 100% |

No epics at all before wave 3. A deck built around famous epic modifiers has two
dead picks at the start.

You can also only modify each card once. Taking a weak common on your best card
early locks you out of its epic later.

### Deck rating

Average of every card's three modifier scores. The wave bars use the rarity odds
above against your 8 cards, and work out the chance that at least one of the two
offers is S or A.

### Ratings

Every modifier carries RoyaleAPI's rating, derived from real win rates across
millions of battles. Letters are bands over that rating: S is 70 and above, A is
52, B is 38, C is 25, D below that. The bands live in the `BANDS` array in
`index.html`.

---

## Editing the data

Card data is the `RAW` array in `index.html`. One line per card:

```js
["Knight", ["Truly of the Round Table","+200% hitpoints, -50% speed",71],
           ["An Absolute Stunner","Stun attack",36],
           ["Not This Guy Again!","Spawn Mega Knight",52]],
```

Name, then common, rare and epic. Each modifier is its name, its effect and its
rating.

All of it comes from RoyaleAPI: modifier names and effects from the CHAOS mode
writeup, ratings from the live modifier stats page. Eight pool cards show no data
because their modifiers are not catalogued yet.

---

## Card recognition

No model, no downloads, no training, no labelling. Everything runs in the
browser against the 74 card images in `cards/`.

Card positions are measured, not guessed. The mega grid came from locating the
magenta elixir badges in a real screenshot, which gave six columns spaced 0.1196
apart and six rows spaced 0.0719 apart.

Each crop is described six ways, identically for the screenshot and the
reference, always letterboxed so nothing is stretched:

| Signal | What it captures |
|--------|------------------|
| Spatial palette | 6x8 grid of hue, saturation and value. Hue is stored as a vector so red near 0 and red near 1 are not opposites |
| Global palette | 12 hue bins weighted by saturation, plus separate light and dark grey bins |
| HSV histogram | 12 x 3 x 3, compared with chi-squared |
| Brightness grid | 8x10, mean exposure removed |
| Edge grid | 8x10, contrast normalised |
| Keypoints | corners with 128 bit descriptors, matched with a ratio test and checked for geometric agreement |

Ranking happens in two stages, because colour is good at "this looks like that"
and bad at "this is that":

1. Colour narrows 74 references to 12 candidates and then steps back.
2. Those 12 are ranked on structure: keypoints 35%, geometry 25%, spatial colour
   15%, palette 10%, histogram 5%, brightness 5%, edges 5%.

Feature evidence is discounted by how much of it there is. Under 50 keypoints
counts for a third of its weight; over 80 counts fully. Geometry is scored on
its own curve, so one consistent match is worth almost nothing while six or more
is worth full marks. A candidate whose structure and geometry agree gets a
bonus; strong structure alone does not.

Mega boards are solved as a whole. The 36 cards on a board are distinct, checked
empirically on a real screenshot where the most similar pair of tiles scored 46
against a median of 67, so slots are assigned by Hungarian matching rather than
each picking its own favourite independently.

Elixir cost is never used to filter. One misread digit would remove the correct
card before it could be compared.

### What was tried and rejected

Perceptual hashing, colour grids alone, template registration, and CLIP
embeddings via Transformers.js. CLIP worked mathematically, self similarity of
1.000 and clean reference separation, but could not separate cards from
screenshot crops: Giant against Wizard scored 0.87, Dark Prince against Prince
0.93. It was removed rather than kept, since a 90MB model download is a heavy
price for no accuracy.

Run `get-cards.sh` once to populate `cards/`. The images must be served from the
same origin as the page, otherwise the browser will not let it read their
pixels.

---

## Credits and licence

Wave odds, modifier names, effects and ratings from RoyaleAPI. Ratings are
derived from real win rates across millions of battles. Card images are
Supercell's, used under their Fan Content Policy.

This material is unofficial and is not endorsed by Supercell. For more
information see Supercell's Fan Content Policy:
https://supercell.com/en/fan-content-policy/

Not affiliated with Supercell.
