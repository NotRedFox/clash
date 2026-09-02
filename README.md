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

Either way you get an icon on your home screen, and opening it hides the browser
bars so it behaves like a normal app.

---

## What each tab does

**Scan.** Screenshot the card pick screen and load it. It finds the cards,
identifies them from their artwork, and ranks them best to worst with every
modifier and rating. Pick the layout first: Chaos draft for the three card
screen, Mega draft for the larger one.

Recognition works by feature matching. It finds distinctive corners in the card
artwork, describes the pattern of brightness around each one, and counts how
many of those descriptions appear in the reference art in `cards/`. Matches then
have to agree on where the object sits, so scattered coincidental matches are
discarded and only geometrically consistent ones count.

Nothing needs labelling or training. The reference art is the only input, and
elixir cost never removes a candidate, since one misread digit would eliminate
the right card before it could be compared.

Tap a result to correct it if it gets one wrong.

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

The cards sit in fixed positions on the pick screen, so they are cropped by
proportion rather than by pointing at them. Each layout in `LAYOUTS` defines
those positions.

Identification is feature matching, written from scratch with no dependencies:

1. Both images are letterboxed to a common size, so nothing is stretched.
2. Distinctive corners are detected and spread out, so one busy area of the card
   cannot supply every point.
3. Each corner gets a 128 bit descriptor built from brightness comparisons
   around it, packed into four 32 bit words so matching is fast enough to run
   against all 74 references in real time.
4. Descriptors are matched with a ratio test, so a match only counts when it is
   clearly better than the runner up.
5. Surviving matches must agree on roughly the same offset. Real matches on the
   same artwork cluster together, coincidental ones scatter.

Cards rank by geometrically consistent matches first, then match quality, then
raw match count. A result is only reported confidently when the winner has at
least six consistent matches and nearly twice as many as second place.

This replaced an earlier approach that compared grids of average colour. That
version could tell a Golem from a Tombstone but failed on cards whose artwork
does not fill the frame, and the difference is large: on a test screenshot the
colour method separated the correct card from the runner up by 0.2 points, while
feature matching separated them by more than ten geometrically consistent
matches.

Elixir cost is read and displayed but never used to filter, because a single
misread digit removes the correct card before it can be compared.

Run `get-cards.sh` once to populate `cards/`. The images have to be served from
the same origin as the page, otherwise the browser will not let it read them.

---

## Credits

Wave odds and modifier list from RoyaleAPI. Tier placements based on community
tier lists.

Not affiliated with Supercell.
