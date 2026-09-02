# Chaos Draft

A reference tool for Clash Royale's Chaos mode and the draft modes.

Every card has three modifiers, one common, one rare, one epic. This shows all of
them with a tier rating, works out how likely your deck is to hand you something
good, and compares cards you have been offered.

**Live version:** https://notredfox.github.io/clash/

---

## Put it on your phone

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

You get an icon on your home screen. Opening it hides the browser bars, so it
behaves like a normal app. It also works offline once loaded.

---

## What each tab does

**Scan.** Screenshot the draft and load it here. It finds the three cards and
identifies them by comparing their colour signature against the card art in
`cards/`. Tap a result to correct it if it gets one wrong, and it remembers.

**Cards.** All 50 cards. Three boxes each for common, rare and epic. The bar
underneath shows the split, so a card with two S mods and one B reads as 67%
gold, 33% purple. Tap a name to see what the modifiers actually do.

**Deck.** Pick your 8. It shows a deck rating and, for each of the five waves,
the chance that at least one of your two offers is S or A tier.

**Draft.** Two modes. Double and triple draft takes up to 3 cards. Mega draft
takes up to 12 and lets you flip between best first and worst first.

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

The three cards sit in fixed positions on the pick screen, so the app crops them
by proportion rather than asking you to point at them.

Each crop is reduced to a 4x4 grid of average colour, 48 numbers, and compared
against the same signature computed from every image in `cards/`. Colour is used
rather than brightness because it survives the difference between the card icon
and the framed card in game. A brightness hash breaks ties.

A match is only accepted when the best candidate is clearly ahead of the runner
up, so an uncertain card asks rather than guessing. Corrections are stored in
your browser and take priority afterwards.

Tuning lives in `identifyRef`: the distance ceiling and the margin the winner
needs over second place.

Run `get-cards.sh` once to populate `cards/`. The images have to be served from
the same origin as the page, otherwise the browser will not let it read them.

---

## Credits

Wave odds and modifier list from RoyaleAPI. Tier placements based on community
tier lists.

Not affiliated with Supercell.
