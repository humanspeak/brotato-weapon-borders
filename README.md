# Brotato – Weapon Borders

Colors each weapon on the **weapon selection** screen by the highest danger you've beaten while *starting* with it, per zone, using the same colors as the character borders.

- A run counts as beaten if you survive wave 20 or kill the final boss. In endless mode it counts as soon as wave 20 is survived.
- In co-op, every player's starting weapon gets credit.
- Data lives in `%APPDATA%\Brotato\mod_weapon_borders.json`. It only tracks runs started with the mod installed.
- Built for Brotato 1.2.0.0 / Mod Loader 6.3.0.

## Build / install
```powershell
./build.ps1 -Install   # builds dist/Humanspeak-WeaponBorders.zip and copies it into a subscribed Workshop item folder (Steam only loads subscribed items)
```
Logs: `%APPDATA%\Brotato\logs\` (search for `Humanspeak-WeaponBorders`).
