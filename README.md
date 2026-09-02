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

**Scan.** Screenshot the draft, load it here, tap each card. The first time it
sees a card's art you tell it which card it is. After that it recognises it
automatically. It gets faster the more you use it.

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

### Tier scores

S 95, A 82, B 64, C 46, D 28, F 10. These live at the top of `index.html` in the
`TIER` object. Change them and everything re-ranks.

---

## Editing the data

Card data is the `RAW` array in `index.html`. One line per card:

```js
["Knight", ["D","+200% health, -50% speed"], ["A","Permastun hit attack"], ["A","Turns into Mega Knight"]],
```

Name, then common, rare and epic. Each modifier is a tier letter and its effect.

Modifier effects and rarity slots come from the community list and are accurate.
**The tier letters are estimates and need replacing.** That is the main thing
this project still needs.

---

## Card recognition

The scan tab uses a perceptual hash. It shrinks the tapped crop to 9x8 pixels in
greyscale, then compares each pixel to its right hand neighbour. That gives 64
bits describing the shape of the brightness rather than exact pixels, so it
survives different screen sizes and screenshot scaling.

Matching is by Hamming distance. Under 12 bits different counts as the same card.

Two things to tune if recognition is unreliable. The crop size is set to one
eighth of the screenshot width. `THRESH` at the top controls how strict matching
is: lower it if it confuses similar cards, raise it if it fails on cards you have
already taught it.

Fingerprints are stored in your browser. They do not leave your device.

---

## Android app version

There is a WebView wrapper that runs this as a real Android app with a floating
overlay. It needs the `SYSTEM_ALERT_WINDOW` permission and a foreground service.
Not included in this repo yet.

Not possible on iOS. Apple does not allow drawing over other apps.

---

## Credits

Wave odds and modifier list from RoyaleAPI. Tier placements based on community
tier lists.

Not affiliated with Supercell.
