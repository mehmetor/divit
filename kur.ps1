# Divit — akademik yazım tezgâhı · Windows kurulumu
#
# Tek komut (PowerShell'e yapıştırın):
#   irm https://raw.githubusercontent.com/mehmetor/divit/main/kur.ps1 | iex
#
# Git ya da yönetici hakkı gerekmez. Yeniden çalıştırmak güvenlidir:
# hocanın dosyalarına dokunmaz, yalnızca Divit'i günceller.
#
# Sınama değişkenleri (geliştirici için):
#   $env:DIVIT_TEST = "1"          Claude uygulaması ve komut satırı kurulmaz, kılavuz açılmaz
#   $env:DIVIT_KAYNAK_ZIP = "yol"  GitHub yerine yerel repo zip'i kullan
#   $env:DIVIT_HEDEF = "yol"       Divit klasörünün yeri (varsayılan: Belgeler\Divit)

$ErrorActionPreference = 'Continue'
$ProgressPreference = 'SilentlyContinue'            # indirmeler çok daha hızlı olur
try { [Console]::OutputEncoding = [Text.Encoding]::UTF8 } catch {}
try { [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 } catch {}

$Repo        = if ($env:DIVIT_REPO) { $env:DIVIT_REPO } else { 'mehmetor/divit' }
$Dal         = if ($env:DIVIT_DAL)  { $env:DIVIT_DAL }  else { 'main' }
$PandocSurum = '3.11'
$Test        = [bool]$env:DIVIT_TEST
$Belgeler    = [Environment]::GetFolderPath('MyDocuments')     # OneDrive yönlendirmesini de bilir
$Hedef       = if ($env:DIVIT_HEDEF) { $env:DIVIT_HEDEF } else { Join-Path $Belgeler 'Divit' }
$Ev          = if ($env:USERPROFILE) { $env:USERPROFILE } else { $HOME }
$Araclar     = Join-Path $Ev '.divit\araclar'
$PazarUrl    = "https://raw.githubusercontent.com/$Repo/$Dal/.claude-plugin/marketplace.json"
$script:Uyarilar = 0

function Adim($t)  { Write-Host ""; Write-Host "> $t" -ForegroundColor Green }
function Bilgi($t) { Write-Host "  $t" }
function Uyari($t) { Write-Host "  UYARI: $t" -ForegroundColor Yellow; $script:Uyarilar++ }
function Indir($url, $dosya) {
  try { Invoke-WebRequest -Uri $url -OutFile $dosya -UseBasicParsing; return $true } catch { return $false }
}
function YazUtf8($yol, $metin) {                     # BOM'suz UTF-8: Claude Code JSON'u sorunsuz okur
  [IO.File]::WriteAllText($yol, $metin, (New-Object Text.UTF8Encoding $false))
}

$Gecici = Join-Path ([IO.Path]::GetTempPath()) ("divit-" + [guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Force -Path $Gecici | Out-Null

Write-Host ""
Write-Host "Divit - akademik yazim tezgahi / kurulum" -ForegroundColor White

# ---------------------------------------------------------------- 1
Adim "1/6 Claude uygulamasi"
$claudeUygulama = Test-Path "$env:LOCALAPPDATA\AnthropicClaude"
if (-not $claudeUygulama -and (Get-Command Get-AppxPackage -ErrorAction SilentlyContinue)) {
  $claudeUygulama = [bool](Get-AppxPackage -Name '*Claude*' -ErrorAction SilentlyContinue)
}
if ($claudeUygulama) { Bilgi "Kurulu." }
elseif ($Test) { Bilgi "(sinama: atlandi)" }
else {
  $kuruldu = $false
  if (Get-Command winget -ErrorAction SilentlyContinue) {
    Bilgi "Kuruluyor (winget)..."
    winget install --id Anthropic.Claude -e --silent --accept-package-agreements --accept-source-agreements | Out-Null
    $kuruldu = ($LASTEXITCODE -eq 0)
  }
  if (-not $kuruldu) {
    $mimari = if ($env:PROCESSOR_ARCHITECTURE -eq 'ARM64') { 'arm64' } else { 'x64' }
    $kurucu = Join-Path $Gecici 'ClaudeSetup.exe'
    if (Indir "https://claude.ai/api/desktop/win32/$mimari/setup/latest/redirect" $kurucu) {
      Bilgi "Kurulum penceresi aciliyor; bitince bu pencereye donun."
      Start-Process -FilePath $kurucu -Wait
    } else { Uyari "Indirilemedi. https://claude.ai/download adresinden elle kurun." }
  } else { Bilgi "Kuruldu." }
}

# ---------------------------------------------------------------- 2
Adim "2/6 Claude Code (eklenti kurulumu icin)"
$env:Path = "$Ev\.local\bin;$env:Path"
if (Get-Command claude -ErrorAction SilentlyContinue) {
  Bilgi ("Kurulu: " + (& claude --version 2>$null | Select-Object -First 1))
}
elseif ($Test) { Bilgi "(sinama: atlandi)" }
else {
  # Ayrı süreçte: resmî kurucu 'exit' derse bu betik kapanmasın.
  powershell -NoProfile -ExecutionPolicy Bypass -Command "irm https://claude.ai/install.ps1 | iex" | Out-Null
  $env:Path = "$Ev\.local\bin;$env:Path"
  if (Get-Command claude -ErrorAction SilentlyContinue) { Bilgi "Kuruldu." }
  else { Uyari "Kurulamadi. Eklenti, uygulama ilk acildiginda kendiliginden inecek." }
}

# ---------------------------------------------------------------- 3
Adim "3/6 Word donusturucu (pandoc $PandocSurum)"
$Pandoc = Join-Path $Araclar 'pandoc.exe'
$pandocTamam = (Test-Path $Pandoc) -and ((& $Pandoc --version 2>$null | Out-String) -match [regex]::Escape($PandocSurum))
if ($pandocTamam) { Bilgi "Kurulu." }
else {
  $zip = Join-Path $Gecici 'pandoc.zip'
  $url = "https://github.com/jgm/pandoc/releases/download/$PandocSurum/pandoc-$PandocSurum-windows-x86_64.zip"
  if (Indir $url $zip) {
    Expand-Archive -Path $zip -DestinationPath (Join-Path $Gecici 'pandoc') -Force
    $bul = Get-ChildItem -Path (Join-Path $Gecici 'pandoc') -Recurse -Filter 'pandoc.exe' | Select-Object -First 1
    New-Item -ItemType Directory -Force -Path $Araclar | Out-Null
    Copy-Item $bul.FullName $Pandoc -Force
    Unblock-File $Pandoc -ErrorAction SilentlyContinue
    if (& $Pandoc --version 2>$null) { Bilgi "Kuruldu." } else { Uyari "pandoc calismadi. Word dosyalari PDF olarak verilmeli." }
  } else { Uyari "pandoc indirilemedi. Word dosyalari PDF olarak verilmeli." }
}

# ---------------------------------------------------------------- 4
Adim "4/6 Divit klasoru"
$repoZip = Join-Path $Gecici 'repo.zip'
if ($env:DIVIT_KAYNAK_ZIP) { Copy-Item $env:DIVIT_KAYNAK_ZIP $repoZip }
elseif (-not (Indir "https://codeload.github.com/$Repo/zip/refs/heads/$Dal" $repoZip)) {
  Write-Host "HATA: Divit indirilemedi. Internet baglantisini kontrol edin." -ForegroundColor Red; return
}
Expand-Archive -Path $repoZip -DestinationPath (Join-Path $Gecici 'repo') -Force
$Sablon = Get-ChildItem -Path (Join-Path $Gecici 'repo') -Directory -Recurse -Depth 2 |
          Where-Object { $_.Name -eq 'Divit' -and $_.Parent.Name -eq 'hoca-paketi' } | Select-Object -First 1
if (-not $Sablon) { Write-Host "HATA: Divit sablonu bulunamadi." -ForegroundColor Red; return }
$S = $Sablon.FullName

if (Test-Path $Hedef) {
  Bilgi "Klasor zaten var. Kisisel dosyalara dokunmadan Divit dosyalari guncelleniyor."
  foreach ($f in @('CLAUDE.md', 'KILAVUZ.html', 'tez-kontrol\CLAUDE.md')) {
    $h = Join-Path $Hedef $f
    New-Item -ItemType Directory -Force -Path (Split-Path $h) | Out-Null
    Copy-Item (Join-Path $S $f) $h -Force
  }
  New-Item -ItemType Directory -Force -Path (Join-Path $Hedef '.claude\rules') | Out-Null
  Copy-Item (Join-Path $S '.claude\rules\*') (Join-Path $Hedef '.claude\rules') -Recurse -Force
  foreach ($d in Get-ChildItem (Join-Path $S '.divit') -Directory) {
    New-Item -ItemType Directory -Force -Path (Join-Path $Hedef ".divit\$($d.Name)") | Out-Null
  }
  foreach ($p in Get-ChildItem (Join-Path $S '.divit\profil') -Filter '*.md') {   # yeni profil dosyaları
    $h = Join-Path $Hedef ".divit\profil\$($p.Name)"
    if (-not (Test-Path $h)) { Copy-Item $p.FullName $h }
  }
} else {
  New-Item -ItemType Directory -Force -Path $Hedef | Out-Null
  # Tek geçiş; -Force gizli sayılan öğeleri (.claude, .divit) de kapsar.
  Get-ChildItem $S -Force | ForEach-Object { Copy-Item $_.FullName $Hedef -Recurse -Force }
  Bilgi "Olusturuldu: $Hedef"
}
# Ayarlar Divit'e aittir, her kurulumda yenilenir. Hocanın "bir daha sorma"
# izinleri settings.local.json'da durur; ona dokunulmaz.
$pandocYolu = $Pandoc -replace '\\', '/'
$ayar = [IO.File]::ReadAllText((Join-Path $S '.claude\settings.json')).Replace('__PANDOC__', $pandocYolu)
YazUtf8 (Join-Path $Hedef '.claude\settings.json') $ayar
$yerel = Join-Path $Hedef '.claude\settings.local.json'
if (-not (Test-Path $yerel)) { YazUtf8 $yerel "{`n  `"enabledPlugins`": { `"divit@divit`": true }`n}`n" }
Get-ChildItem $Hedef -Recurse -File -ErrorAction SilentlyContinue | Unblock-File -ErrorAction SilentlyContinue
Get-ChildItem $Hedef -Recurse -Force -Filter '.gitkeep' -ErrorAction SilentlyContinue | Remove-Item -Force   # git kalintisi

# ---------------------------------------------------------------- 5
Adim "5/6 Divit eklentisi"
if ($Test -and -not $env:CLAUDE_CONFIG_DIR) { Bilgi "(sinama: atlandi)" }
elseif (Get-Command claude -ErrorAction SilentlyContinue) {
  & claude plugin marketplace add $PazarUrl *> $null
  if ($LASTEXITCODE -ne 0) { & claude plugin marketplace update divit *> $null }
  & claude plugin install divit@divit *> $null
  if ($LASTEXITCODE -ne 0) { & claude plugin update divit@divit *> $null }
  if ($LASTEXITCODE -eq 0) { Bilgi "Kuruldu." }
  else { Uyari "Simdi kurulamadi; uygulama ilk acildiginda kendiliginden inecek." }
} else { Bilgi "Uygulama ilk acildiginda kendiliginden inecek." }

# ---------------------------------------------------------------- 6
Adim "6/6 Masaustu kisayolu ve kilavuz"
$masaustu = [Environment]::GetFolderPath('Desktop')
if ($masaustu) { $kisayol = Join-Path $masaustu 'Divit.lnk' }
if ($masaustu -and -not (Test-Path $kisayol)) {
  try {
    $k = (New-Object -ComObject WScript.Shell).CreateShortcut($kisayol)
    $k.TargetPath = $Hedef; $k.Save()
    Bilgi "Masaustune 'Divit' klasor kisayolu kondu."
  } catch { }
}
if (-not $Test) { Invoke-Item (Join-Path $Hedef 'KILAVUZ.html') }

Remove-Item $Gecici -Recurse -Force -ErrorAction SilentlyContinue
Write-Host ""
if ($script:Uyarilar -gt 0) { Write-Host "Kurulum bitti ($($script:Uyarilar) uyari - yukariya bakin)." -ForegroundColor White }
else { Write-Host "Kurulum bitti." -ForegroundColor White }
Write-Host @"

Simdi:
  1. Claude uygulamasini acin (Baslat menusu > Claude). Hocanin hesabiyla giris yapin.
  2. Ustteki "Code" sekmesine tiklayin.
  3. "Local" secin > "Select folder" > Belgeler > Divit.
  4. "merhaba" yazin. Divit gerisini kendisi sorar.

"@
