# kd_mapanim

A small, free FiveM script by **Koma Development** ([komadev.dk](https://komadev.dk)).

When a player opens the pause menu or the map (`ESC` / `P`), their character pulls out a paper map and holds it until the menu closes. Other players see it too, so you can tell who is looking at the map.

- Plays the tourist map animation with a map prop in the hand
- The prop is synced, so everyone around sees it
- Weapons are put away while holding the map and given back afterwards
- Skips the animation in vehicles, when dead, swimming, ragdolled, falling, climbing or parachuting
- `/mapanim` lets each player turn it on or off for themselves (saved on their PC)
- Export to block it from other scripts (cuffs, carry, emotes …)
- Standalone: works with ESX, QBCore or no framework
- ~0.00 ms idle

## Installation

1. Download and put `kd_mapanim` in your resources folder.
2. Add `ensure kd_mapanim` to your `server.cfg`.
3. Restart the server. Done.

## Configuration

Everything is in `config.lua`:

| Option | What it does |
|---|---|
| `Config.Anim` | Animation dictionary, name and flag |
| `Config.Prop` | Prop model, bone and offset/rotation |
| `Config.HolsterWeapon` | Put the weapon away while the map is open |
| `Config.Block` | Turn each blocking situation (vehicle, dead, swimming, ragdoll) on/off |
| `Config.Command` | Name of the on/off command, or `false` to remove it |

## Exports (client)

```lua
-- Block the animation, e.g. while the player is cuffed or being carried
exports.kd_mapanim:SetDisabled(true)
exports.kd_mapanim:SetDisabled(false)

-- Is the player holding the map right now?
local holding = exports.kd_mapanim:IsActive()
```

Each resource has its own block flag, and it is cleared automatically if that resource stops.

## License

MIT. See [LICENSE](LICENSE). You can use, change and share it; keep the copyright notice.
