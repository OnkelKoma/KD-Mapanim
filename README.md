<div align="center">

# 🗺️ kd_mapanim

**Your character pulls out a paper map whenever you open the pause menu.**

Press `ESC` or `P`, and everyone around you can see you studying the map. Close the menu and you put it away.

![FiveM](https://img.shields.io/badge/FiveM-cerulean-f40552?style=flat-square)
![Lua](https://img.shields.io/badge/Lua-5.4-2C2D72?style=flat-square&logo=lua)
![Standalone](https://img.shields.io/badge/Standalone-yes-00b894?style=flat-square)
![QBCore](https://img.shields.io/badge/QBCore-supported-d63031?style=flat-square)
![ESX](https://img.shields.io/badge/ESX-supported-0984e3?style=flat-square)
![License](https://img.shields.io/badge/license-MIT-green?style=flat-square)

<!-- Add a preview here: <img src="docs/images/preview.gif" alt="Player holding a paper map while the pause menu is open" width="820"> -->

</div>

---

## ✨ Features

- **Map in hand:** plays the tourist map animation with `prop_tourist_map_01` in the right hand
- **Synced:** the prop is networked, so other players see who is looking at the map
- **Weapon handling:** your weapon is put away while you hold the map and comes back when you close the menu
- **Smart blocking:** no map in vehicles, or when dead, swimming, ragdolled, falling, climbing or parachuting
- **Player toggle:** `/mapanim` turns it on or off for each player, and the choice is saved on their PC
- **Export for other scripts:** block it while a player is cuffed, carried or doing an emote
- **Standalone:** works with ESX, QBCore, QBox or no framework at all
- **Lightweight:** client only, no dependencies, ~0.00 ms idle

---

## 🚀 Installation

1. **Download** the [latest release](../../releases/latest) and extract it.
2. Rename the folder to `kd_mapanim` if needed and drop it into your `resources` folder.
3. Add it to your `server.cfg`:
   ```cfg
   ensure kd_mapanim
   ```
4. Restart your server. Done.

---

## ⚙️ Configuration

Everything is in [`config.lua`](config.lua):

```lua
Config.Anim = {
    dict = 'amb@world_human_tourist_map@male@base',
    name = 'base',
    flag = 49,                 -- loop + upper body only
}

Config.Prop = {
    model  = `prop_tourist_map_01`,
    bone   = 28422,            -- right hand
    offset = vec3(0.0, 0.0, 0.0),
    rot    = vec3(0.0, 0.0, 0.0),
}

Config.HolsterWeapon = true    -- put the weapon away while holding the map

Config.Block = {
    inVehicle = true,
    dead      = true,
    swimming  = true,
    ragdoll   = true,          -- also covers falling / climbing / parachuting
}

Config.Command = 'mapanim'     -- on/off command, or false to remove it
```

> [!TIP]
> Want a different look? Swap `Config.Anim` and `Config.Prop` for any animation and prop, for example a phone or a clipboard.

---

## 🔌 API

### Client exports

```lua
-- Block the map animation (e.g. while cuffed or carried)
exports.kd_mapanim:SetDisabled(true)
exports.kd_mapanim:SetDisabled(false)

-- Is the player holding the map right now?
local holding = exports.kd_mapanim:IsActive()
```

Each resource has its own block flag, so two scripts can't unblock each other by accident. A flag is cleared automatically if its resource stops.

### Commands

| Command | Permission | Description |
|---|---|---|
| `/mapanim` | Everyone | Turn the map animation on or off for yourself |

---

## ❓ FAQ

<details>
<summary><b>The map sits wrong in the hand</b></summary>

Adjust `Config.Prop.offset` and `Config.Prop.rot` in `config.lua`.
</details>

<details>
<summary><b>It also shows on the Settings / Stats tabs, not only the map</b></summary>

Yes. GTA has no reliable way to tell which pause menu tab is open, so the map shows whenever the pause menu is open.
</details>

<details>
<summary><b>It clashes with my emote or handcuff script</b></summary>

Call `exports.kd_mapanim:SetDisabled(true)` from that script while the emote or cuffs are active, and `false` afterwards.
</details>

---

## 📝 License

[MIT](LICENSE). Use it, modify it, ship it. Credit is appreciated but not required.

<div align="center">
<sub>Made with ☕ by <a href="https://komadev.dk">Koma Development</a></sub>
</div>
