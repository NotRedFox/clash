#!/bin/bash
# Downloads the card art into the repo so the browser can read it
# without hitting CORS. Run once from inside ~/clash.
set -u
mkdir -p cards
ok=0; fail=0

slugs="goblin-barrel skeleton-army goblin-demolisher skeleton-barrel goblin-drill
suspicious-bush royal-hogs barbarian-barrel goblin-hut vines the-log golem ronin
knight berserker fireball baby-dragon musketeer poison mega-knight electro-wizard
graveyard giant barbarian-hut arrows rascals goblin-giant bandit heal-spirit witch
mortar firecracker zappies executioner night-witch tesla flying-machine
three-musketeers tombstone inferno-dragon wizard hunter furnace pekka
elite-barbarians princess zap dart-goblin electro-spirit inferno-tower ram-rider
rune-giant mother-witch ice-spirit royal-delivery ice-wizard elixir-golem
royal-giant dark-prince x-bow fisherman rocket lava-hound valkyrie giant-snowball
rage bomber mini-pekka prince hog-rider fire-spirit miner skeletons goblins"

for s in $slugs; do
  for url in \
    "https://cdn.royaleapi.com/static/img/cards-150/$s.png" \
    "https://royaleapi.github.io/cr-api-assets/cards/$s.png" \
    "https://cdn.royaleapi.com/static/img/cards/$s.png"
  do
    if curl -sfL --max-time 15 "$url" -o "cards/$s.png" && [ -s "cards/$s.png" ]; then
      echo "ok   $s"; ok=$((ok+1)); break
    fi
  done
  if [ ! -s "cards/$s.png" ]; then
    echo "MISS $s"; rm -f "cards/$s.png"; fail=$((fail+1))
  fi
done

echo
echo "downloaded $ok, missing $fail"
