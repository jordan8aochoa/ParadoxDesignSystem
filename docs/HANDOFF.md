# Windows ↔ Mac mini Handoff

The Swift compiler runs only on macOS, so this repo's "real" build lives on the Mac mini. Windows is where Claude/you write code and tokens; Mac mini compiles, tests, runs the simulator, and returns screenshots.

```
Windows                                   Mac mini
─────────────────                         ───────────────────
write code & tokens   ──── git push ────▶ git pull
                                          xcodegen generate
                                          xcodebuild
                                          simulator screenshot
                      ◀─── scp ────────── handoff-screenshots/latest.png
```

## One-time setup

### 1. Mac mini

```bash
brew install xcodegen
# Xcode 16+ installed via the App Store
git clone <repo> ~/code/ParadoxDesignSystem
cd ~/code/ParadoxDesignSystem && swift build  # warm caches
```

### 2. SSH key from Windows to Mac

On Windows (PowerShell):

```powershell
ssh-keygen -t ed25519 -C "windows-handoff"   # press enter to accept defaults
cat $HOME\.ssh\id_ed25519.pub                 # copy this
```

On the Mac mini:

```bash
mkdir -p ~/.ssh && chmod 700 ~/.ssh
echo "<paste pub key>" >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
# Enable Remote Login: System Settings → General → Sharing → Remote Login ON
```

Test from Windows:

```powershell
ssh jordan@macmini.local "echo ok"
```

### 3. Configure the handoff script

Edit `Scripts/handoff-to-mac.ps1` and update the placeholders:

```powershell
$MacHost     = "jordan@macmini.local"       # your real user@host
$MacRepoPath = "~/code/ParadoxDesignSystem" # actual clone path on Mac
```

## Usage

```powershell
pwsh Scripts/handoff-to-mac.ps1 "made the elevation shadows tighter"
```

What happens:

1. Windows: `git add -A` → `git commit -m "handoff: ..."` → `git push`.
2. Mac: `ssh` triggers `Scripts/mac-build-playground.sh` which `git pull`s, runs `swift build`, `swift test`, `xcodegen generate`, `xcodebuild`, installs + launches in simulator, captures `handoff-screenshots/latest.png`.
3. Windows: `scp` pulls the screenshot back to `$HOME\handoff-screenshots\playground-<timestamp>.png`.

## Troubleshooting

| Symptom | Fix |
|---|---|
| `ssh: connection refused` | Enable Remote Login in macOS Sharing settings. |
| `xcodegen: command not found` | `brew install xcodegen` on the Mac. |
| `simulator not available` | Open Xcode → Settings → Platforms → install latest iOS Simulator. |
| Screenshot blank | The app crashed on launch — check `xcodebuild` output and the simulator's console. |
| Build hangs on Windows side | Cancel; SSH may be waiting for password — verify key-based auth works without prompt. |
