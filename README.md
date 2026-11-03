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

## CI/CD
`.github/workflows/publish.yml` runs on every **push to `main`** (i.e. merged PRs). It:
1. Syntax-checks every `.gd` file with gdtoolkit 3 (`gdparse`), validates `manifest.json`, builds the zip with `build.ps1` (pwsh), checks the zip layout, and uploads it as a build artifact.
2. Publishes the zip to the existing Workshop item with `steamcmd +workshop_build_item`. Only the content and a change note (PR title, number and short SHA) are updated; the title, description and preview stay as they are on Steam.

**Skipping a publish:** add the `skip-publish` label to the PR before merging. Direct pushes with no PR always publish.

**Configuration** (Settings → Secrets and variables → Actions):
| Name | Type | Value |
| --- | --- | --- |
| `WORKSHOP_ITEM_ID` | variable | Workshop item ID (number in the item's URL) |
| `STEAM_USERNAME` | secret | Steam account login name |
| `STEAM_CONFIG_VDF` | secret | base64 of a logged-in steamcmd `config/config.vdf` |

If the variable or either secret is missing, the publish job is skipped with a notice and the workflow still succeeds.

**First upload is manual:** the item must exist before CI can update it. Do the first upload with `GodotWorkshopUtility.exe` (see above), then set `WORKSHOP_ITEM_ID`.

**Producing `STEAM_CONFIG_VDF`** (no password is stored in GitHub):
1. Use a dedicated Humanspeak Steam account that owns Brotato and is a contributor/owner of the Workshop item.
2. On a PC, install [steamcmd](https://developer.valvesoftware.com/wiki/SteamCMD), run `steamcmd +login <username> +quit`, and enter the password and Steam Guard code.
3. Base64 the resulting `config/config.vdf` (in the steamcmd folder on Windows, `~/Steam/config/` on Linux) and save it as the secret:
   - PowerShell: `[Convert]::ToBase64String([IO.File]::ReadAllBytes("C:\steamcmd\config\config.vdf")) | Set-Clipboard`
   - Linux/macOS: `base64 -w0 ~/Steam/config/config.vdf`
4. The cached session eventually expires (or is invalidated by a password change or a Steam Guard reset). When the publish job fails with a login error, repeat steps 2–3 and update the secret.
