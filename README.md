# Brotato – Weapon Borders

Colors each weapon on the **weapon selection** screen by the highest danger you've beaten while *starting* with it, per zone, using the same colors as the character borders.

- A run counts as beaten if you survive wave 20 or kill the final boss. In endless mode it counts as soon as wave 20 is survived.
- In co-op, every player's starting weapon gets credit.
- Mod page: https://humanspeak.com/mods/brotato/weapon-borders
- Data lives in `%APPDATA%\Brotato\mod_weapon_borders.json`. It only tracks runs started with the mod installed.
- Built for Brotato 1.2.0.0 / Mod Loader 6.3.0.

## Build / install
```powershell
./build.ps1 -Install   # builds dist/Humanspeak-WeaponBorders.zip and copies it into a subscribed Workshop item folder (Steam only loads subscribed items)
```
Logs: `%APPDATA%\Brotato\logs\` (search for `Humanspeak-WeaponBorders`).

## Publishing to the Steam Workshop
1. `./build.ps1` → `dist/Humanspeak-WeaponBorders.zip`
2. Run `GodotWorkshopUtility.exe` (Brotato install folder) with Steam open, and upload the zip with `workshop/preview.png`.
3. Title: `workshop/title.txt`. Description (Steam BBCode): `workshop/description.bbcode`.
4. Publish as **Private**, subscribe, test a run, then switch to **Public**.
5. Delete the local test copy from the host Workshop item folder (see `build.ps1`) so the mod doesn't load twice.
