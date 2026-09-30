# Divit — yazım tezgâhı · Windows kurulumu
#
# Tek komut (PowerShell'e yapıştırın):
#   irm https://raw.githubusercontent.com/mehmetor/divit/main/kur.ps1 | iex
# Kitap yazarı için:
#   $env:DIVIT_TUR='yazar'; irm https://divit.simetri.app/kur.ps1 | iex
#
# Git ya da yönetici hakkı gerekmez. Yeniden çalıştırmak güvenlidir:
# kullanıcının dosyalarına dokunmaz, yalnızca Divit'i günceller.
#
# Kullanıcı türü (akademisyen | yazar) klasörleri, kılavuzun açılış
# sekmesini ve açık eklentileri belirler. Öncelik: DIVIT_TUR >
# .divit\profil\kimlik.md'deki "Kullanıcı türü:" satırı > akademisyen.
# Tür satırı yalnız doldurulmamış (şablon) profile yazılır. Dolu profilin
# türüyle çelişen DIVIT_TUR verilirse betik hiçbir şeye dokunmadan durur:
# aynı bilgisayarda ikinci kullanım ayrı klasördür (DIVIT_HEDEF).
#
# Kanal (yayın dalı): DIVIT_DAL > klasördeki .divit\kanal.txt > main.
# İzinli: main, yeni, deneme, deneme-*. Klasör kanalını kanal.txt'de
# hatırlar; "güncelle" aynı kanalda kalır.
#
# Sınama değişkenleri (geliştirici için):
#   $env:DIVIT_TEST = "1"          Claude uygulaması ve komut satırı kurulmaz, kılavuz açılmaz
#   $env:DIVIT_KAYNAK_ZIP = "yol"  GitHub yerine yerel repo zip'i kullan
#   $env:DIVIT_HEDEF = "yol"       Divit klasörünün yeri (varsayılan: Belgeler\Divit)
#   $env:DIVIT_TUR = "yazar"       kullanıcı türü (akademisyen | yazar)
#   $env:DIVIT_DAL = "deneme"      kanal (yayın dalı)

$ErrorActionPreference = 'Continue'
$ProgressPreference = 'SilentlyContinue'            # indirmeler çok daha hızlı olur
try { [Console]::OutputEncoding = [Text.Encoding]::UTF8 } catch {}
try { [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 } catch {}

$Repo        = if ($env:DIVIT_REPO) { $env:DIVIT_REPO } else { 'mehmetor/divit' }
$PandocSurum = '3.11'
$PdfcpuSurum = '0.15.0'
$PopplerSurum = '26.09.0-0'
$Test        = [bool]$env:DIVIT_TEST
$Belgeler    = [Environment]::GetFolderPath('MyDocuments')     # OneDrive yönlendirmesini de bilir
$Hedef       = if ($env:DIVIT_HEDEF) { $env:DIVIT_HEDEF } else { Join-Path $Belgeler 'Divit' }
$Hedef       = [IO.Path]::GetFullPath($Hedef)
$Ev          = if ($env:USERPROFILE) { $env:USERPROFILE } else { $HOME }
$Araclar     = Join-Path $Ev '.divit\araclar'
$script:Uyarilar = 0
$BaskaKaynak = $null                                # iex oturumu değişkenleri korur: önceki çalıştırmadan kalmasın

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
Write-Host "Divit - yazim tezgahi / kurulum" -ForegroundColor White

# Kanal: DIVIT_DAL > klasörün kanal.txt'si > main.
$KanalDosyasi = Join-Path $Hedef '.divit\kanal.txt'
if ($env:DIVIT_DAL) { $Dal = $env:DIVIT_DAL }
elseif (Test-Path $KanalDosyasi) { $Dal = ([IO.File]::ReadAllLines($KanalDosyasi) | Select-Object -First 1).Trim() }
else { $Dal = 'main' }
if (-not ($Dal -ceq 'main' -or $Dal -ceq 'yeni' -or $Dal -cmatch '^deneme(-.+)?$')) {
  Uyari "'$Dal' bilinen bir kanal degil; main kullaniliyor."; $Dal = 'main'
}
$PazarUrl = "https://raw.githubusercontent.com/$Repo/$Dal/.claude-plugin/marketplace.json"

# Kullanıcı türü: DIVIT_TUR > kimlik.md satırı > akademisyen.
$Kimlik = Join-Path $Hedef '.divit\profil\kimlik.md'
$TurSatiri = [string][char]0x4B + 'ullan' + [char]0x131 + 'c' + [char]0x131 + ' t' + [char]0xFC + 'r' + [char]0xFC + ':'   # "Kullanıcı türü:" (betik ANSI okunsa da bozulmasın)
$Doldurulmadi = 'Hen' + [char]0xFC + 'z doldurulmad' + [char]0x131                                                  # "Henüz doldurulmadı"
$ProfilDolu = $false
$ProfilTur = 'akademisyen'                                          # satır yoksa akademisyen
if (Test-Path $Kimlik) {
  $kimlikMetni = [IO.File]::ReadAllText($Kimlik)
  $ProfilDolu = -not $kimlikMetni.Contains($Doldurulmadi)
  $satir = [IO.File]::ReadAllLines($Kimlik) | Where-Object { $_.StartsWith($TurSatiri) } | Select-Object -First 1
  if ($satir) { $v = ($satir.Substring($TurSatiri.Length).Trim() -split '\s')[0]; if ($v) { $ProfilTur = $v } }
}
$TurVerildi = $false
if ($env:DIVIT_TUR -in @('akademisyen', 'yazar')) { $Tur = $env:DIVIT_TUR; $TurVerildi = $true }
elseif ($env:DIVIT_TUR) { Uyari "DIVIT_TUR='$($env:DIVIT_TUR)' taninmadi (akademisyen ya da yazar olmali); yok sayildi." }
if (-not $TurVerildi) { $Tur = if ($ProfilTur -eq 'yazar') { 'yazar' } else { 'akademisyen' } }

# Dolu profil başka türdense hiçbir şeye dokunmadan dur: bu klasör
# başka bir kullanıma ait (ör. aynı hesapta önceden kurulmuş bir Divit).
if ($ProfilDolu -and $TurVerildi -and $Tur -ne $ProfilTur) {
  $yeniAd = if ($Tur -eq 'yazar') { 'Divit-Yazar' } else { 'Divit-Akademik' }
  $dalOnek = if ($Dal -ne 'main') { "`$env:DIVIT_DAL='$Dal'; " } else { '' }
  Write-Host ""
  Write-Host "Kurulum yapilmadi." -ForegroundColor Red
  Write-Host "Bu klasorde baska bir kullanim turuyle kurulmus bir Divit var:"
  Write-Host "  $Hedef"
  Write-Host "Klasore ve icindeki bilgilere dokunulmadi."
  Write-Host ""
  Write-Host "Ayni bilgisayarda ikinci bir kullanim icin yeni klasor (yeni PowerShell penceresinde):"
  Write-Host "  $dalOnek`$env:DIVIT_TUR='$Tur'; `$env:DIVIT_HEDEF=Join-Path ([Environment]::GetFolderPath('MyDocuments')) '$yeniAd'; irm https://raw.githubusercontent.com/$Repo/$Dal/kur.ps1 | iex"
  Write-Host ""
  Remove-Item $Gecici -Recurse -Force -ErrorAction SilentlyContinue
  return
}

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
$EnAzSurum = [version]'2.1.280'      # klasör ayarındaki model bu sürümü istiyor
$ArsivEnAz = [version]'2.1.224'      # eklentinin zip olarak inmesi (archive kaynağı) bu sürümle geldi
$YerelClaude = Join-Path $Ev '.local\bin\claude.exe'   # resmî (npm'siz) kurulumun yeri
$Claude = $null                                         # eklenti adımında kullanılacak claude
function ClaudeSurumu($exe) {
  $v = (& $exe --version 2>$null | Select-Object -First 1) -replace '^([0-9.]+).*$', '$1'
  try { return [version]$v } catch { return [version]'0.0' }
}
function ResmiKurulum {
  # Ayrı süreçte: resmî kurucu 'exit' derse bu betik kapanmasın.
  powershell -NoProfile -ExecutionPolicy Bypass -Command "irm https://claude.ai/install.ps1 | iex" | Out-Null
}
if (Test-Path $YerelClaude) { $Claude = $YerelClaude }
elseif (Get-Command claude -ErrorAction SilentlyContinue) { $Claude = (Get-Command claude).Source }
if ($Claude) {
  $sv = ClaudeSurumu $Claude
  if ($sv -lt $EnAzSurum -and $Test) {
    # Sınama geliştiricinin kendi Claude Code'unu değiştirmez.
    Bilgi "(sinama: surum $sv eski; guncelleme atlandi)"
  } elseif ($sv -lt $EnAzSurum) {
    Bilgi "Surum $sv eski; guncelleniyor..."
    & $Claude update *> $null
    $sv = ClaudeSurumu $Claude
    if ($sv -lt $EnAzSurum) {
      # Eski kopya çoğu zaman npm kurulumudur ve npm'e ulaşamayınca güncellenemez.
      Bilgi "Guncellenemedi; resmi kurulum yapiliyor..."
      ResmiKurulum
      if (Test-Path $YerelClaude) { $Claude = $YerelClaude; $sv = ClaudeSurumu $Claude }
    }
  }
  if ($sv -lt $EnAzSurum) {
    Uyari "Claude Code $sv eski (en az $EnAzSurum gerekli) ve guncellenemedi. Divit klasoru acilinca 'model desteklenmiyor' hatasi cikabilir."
    Bilgi "  Cozum: powershell -NoProfile -ExecutionPolicy Bypass -Command `"irm https://claude.ai/install.ps1 | iex`"   (sonra bu kurulumu yeniden calistirin)"
    if ($sv -lt $ArsivEnAz) { $Claude = $null }             # bu kopya eklentiyi hiç indiremez
  } else { Bilgi "Kurulu: $sv" }
}
elseif ($Test) { Bilgi "(sinama: atlandi)" }
else {
  ResmiKurulum
  $env:Path = "$Ev\.local\bin;$env:Path"
  if (Test-Path $YerelClaude) { $Claude = $YerelClaude; Bilgi "Kuruldu." }
  else { Uyari "Kurulamadi. Eklenti, uygulama ilk acildiginda kendiliginden inecek." }
}

# ---------------------------------------------------------------- 3
Adim "3/6 Word ve PDF araclari"
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

# PDF araci (pdfcpu): birlestirme, sayfa cikarma, isaretleme.
$Pdfcpu = Join-Path $Araclar 'pdfcpu.exe'
$pdfcpuTamam = (Test-Path $Pdfcpu) -and ((& $Pdfcpu version 2>$null | Out-String) -match [regex]::Escape($PdfcpuSurum))
if ($pdfcpuTamam) { Bilgi "PDF araci kurulu." }
else {
  $zip = Join-Path $Gecici 'pdfcpu.zip'
  $url = "https://github.com/pdfcpu/pdfcpu/releases/download/v$PdfcpuSurum/pdfcpu_${PdfcpuSurum}_Windows_x86_64.zip"
  if (Indir $url $zip) {
    Expand-Archive -Path $zip -DestinationPath (Join-Path $Gecici 'pdfcpu') -Force
    $bul = Get-ChildItem -Path (Join-Path $Gecici 'pdfcpu') -Recurse -Filter 'pdfcpu.exe' | Select-Object -First 1
    New-Item -ItemType Directory -Force -Path $Araclar | Out-Null
    Copy-Item $bul.FullName $Pdfcpu -Force
    Unblock-File $Pdfcpu -ErrorAction SilentlyContinue
    if (& $Pdfcpu version 2>$null) { Bilgi "PDF araci kuruldu." } else { Uyari "PDF araci calismadi. PDF birlestirme ve sayfa isleri yapilamaz." }
  } else { Uyari "PDF araci indirilemedi. PDF birlestirme ve sayfa isleri yapilamaz." }
}
# PDF okuyucu (Poppler): metin cikarma ve sayfa goruntusu. Claude'un PDF
# okumasi da sayfa goruntusu icin pdftoppm'i PATH'te arar.
$Poppler = Join-Path $Araclar 'poppler'
$Pdftotext = Join-Path $Poppler 'pdftotext.exe'
if ((Test-Path $Pdftotext) -and (Test-Path (Join-Path $Poppler "surum-$PopplerSurum.txt"))) { Bilgi "PDF okuyucu kurulu." }
else {
  $zip = Join-Path $Gecici 'poppler.zip'
  $url = "https://github.com/oschwartz10612/poppler-windows/releases/download/v$PopplerSurum/Release-$PopplerSurum.zip"
  if (Indir $url $zip) {
    Expand-Archive -Path $zip -DestinationPath (Join-Path $Gecici 'poppler') -Force
    $bin = Get-ChildItem -Path (Join-Path $Gecici 'poppler') -Recurse -Filter 'pdftotext.exe' | Select-Object -First 1
    New-Item -ItemType Directory -Force -Path $Poppler | Out-Null
    Copy-Item (Join-Path $bin.DirectoryName '*') $Poppler -Recurse -Force
    Get-ChildItem $Poppler -Recurse -File | Unblock-File -ErrorAction SilentlyContinue
    Set-Content -Path (Join-Path $Poppler "surum-$PopplerSurum.txt") -Value $PopplerSurum
    if (& $Pdftotext -v 2>&1 | Out-String) { Bilgi "PDF okuyucu kuruldu." } else { Uyari "PDF okuyucu calismadi. PDF yerine Word hali verilmeli." }
  } else { Uyari "PDF okuyucu indirilemedi. PDF yerine Word hali verilmeli." }
}
if (Test-Path $Pdftotext) {
  $yol = [Environment]::GetEnvironmentVariable('Path', 'User')
  if (-not $yol) { $yol = '' }
  if (($yol -split ';') -notcontains $Poppler) {
    [Environment]::SetEnvironmentVariable('Path', ($yol.TrimEnd(';') + ';' + $Poppler).TrimStart(';'), 'User')
  }
}

# Turkce harfler icin yazi tipi (bir kez).
if ((Test-Path $Pdfcpu) -and -not ((& $Pdfcpu fonts list 2>$null | Out-String) -match 'ArialMT')) {
  $arial = Join-Path $env:WINDIR 'Fonts\arial.ttf'
  if (Test-Path $arial) { & $Pdfcpu fonts install $arial 2>$null | Out-Null }
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

if ($Tur -eq 'yazar') { $TurKlasoru = 'kitaplar'; $Akademik = $false }
else { $TurKlasoru = 'tez-kontrol'; $Akademik = $true }
Bilgi "Kullanici turu: $Tur"
if ($Dal -ne 'main') { Bilgi "Kanal: $Dal" }

# Tür satırı yalnız doldurulmamış profile yazılır (ilk başlığın altına ya da
# var olan satırın yerine). Dolu profile hiç dokunulmaz.
function TurSatiriYaz {
  if (-not (Test-Path $Kimlik)) { return }
  if (-not [IO.File]::ReadAllText($Kimlik).Contains($Doldurulmadi)) { return }
  $yeni = New-Object System.Collections.Generic.List[string]
  $yazildi = $false
  foreach ($l in [IO.File]::ReadAllLines($Kimlik)) {
    if ($l.StartsWith($TurSatiri)) { continue }
    $yeni.Add($l)
    if (-not $yazildi -and $l.StartsWith('# ')) { $yeni.Add("$TurSatiri $Tur"); $yazildi = $true }
  }
  YazUtf8 $Kimlik (($yeni -join "`n") + "`n")
}
# Kılavuz tek dosyadır; açılış sekmesi kök etiketteki data-rol'dür.
function KilavuzYaz {
  $m = [IO.File]::ReadAllText((Join-Path $S 'KILAVUZ.html'))
  YazUtf8 (Join-Path $Hedef 'KILAVUZ.html') $m.Replace('<html lang="tr" data-rol="">', "<html lang=`"tr`" data-rol=`"$Tur`">")
}
# Klasörün CLAUDE.md'si: araç yolları kurulumda yazılır.
function ClaudeMdYaz {
  $pt = if (Test-Path $Pdftotext) { $Pdftotext } else { 'yok' }
  $m = [IO.File]::ReadAllText((Join-Path $S 'CLAUDE.md'))
  YazUtf8 (Join-Path $Hedef 'CLAUDE.md') $m.Replace('__PANDOC__', $Pandoc).Replace('__PDFCPU__', $Pdfcpu).Replace('__PDFTOTEXT__', $pt)
}

if (Test-Path $Hedef) {
  Bilgi "Klasor zaten var. Kisisel dosyalara dokunmadan Divit dosyalari guncelleniyor."
  ClaudeMdYaz
  if (Test-Path (Join-Path $Hedef 'tez-kontrol')) {
    Copy-Item (Join-Path $S 'tez-kontrol\CLAUDE.md') (Join-Path $Hedef 'tez-kontrol\CLAUDE.md') -Force
  }
  # Türün klasörü yoksa eklenir; hiçbir klasör silinmez.
  if (-not (Test-Path (Join-Path $Hedef $TurKlasoru))) {
    Copy-Item (Join-Path $S $TurKlasoru) $Hedef -Recurse -Force
    Bilgi "Eklendi: $TurKlasoru"
  }
  # Gizli bolme (Divit okumaz) akademisyende; eski klasorlere de eklenir.
  if ($Tur -eq 'akademisyen' -and -not (Test-Path (Join-Path $Hedef 'gizli'))) {
    Copy-Item (Join-Path $S 'gizli') $Hedef -Recurse -Force
    Bilgi "Eklendi: gizli"
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
  # Şablon türe göre: başka türün klasörü kopyalanmaz. Kılavuz ve CLAUDE.md
  # aşağıda yazılır; eski kart/kılavuz dosyaları kopyalanmaz.
  # -Force gizli sayılan öğeleri (.claude, .divit) de kapsar.
  Get-ChildItem $S -Force | ForEach-Object {
    if ($Tur -ne 'akademisyen' -and $_.Name -eq 'tez-kontrol') { return }
    if ($Tur -ne 'yazar' -and $_.Name -eq 'kitaplar') { return }
    if ($Tur -ne 'akademisyen' -and $_.Name -eq 'gizli') { return }
    if ($_.Name -like '*.html' -or $_.Name -eq 'CLAUDE.md') { return }
    Copy-Item $_.FullName $Hedef -Recurse -Force
  }
  ClaudeMdYaz
  Bilgi "Olusturuldu: $Hedef"
}
KilavuzYaz
if ($TurVerildi) { TurSatiriYaz }
YazUtf8 $KanalDosyasi "$Dal`n"
# Ayarlar Divit'e aittir, her kurulumda yenilenir. Kullanıcının "bir daha sorma"
# izinleri settings.local.json'da durur; orada yalnız iki eklenti anahtarı değişir.
$pandocYolu = $Pandoc -replace '\\', '/'
$ayar = [IO.File]::ReadAllText((Join-Path $S '.claude\settings.json')).Replace('__PANDOC__', $pandocYolu).Replace('__PDFCPU__', ($Pdfcpu -replace '\\', '/')).Replace('__PDFTOTEXT__', ($Pdftotext -replace '\\', '/'))
# Pazar yeri adresi kanala göre (klasör açılınca uygulama da aynı kanaldan alır).
$ayar = $ayar -replace 'https://raw\.githubusercontent\.com/[^"]*/\.claude-plugin/marketplace\.json', $PazarUrl
YazUtf8 (Join-Path $Hedef '.claude\settings.json') $ayar
$surumDosyasi = Join-Path (Split-Path (Split-Path $S)) 'plugins\divit\SURUM.md'
if (Test-Path $surumDosyasi) {
  $ilk = Select-String -Path $surumDosyasi -Pattern '^## ([0-9.]+) ' | Select-Object -First 1
  if ($ilk) { YazUtf8 (Join-Path $Hedef '.divit\kurulum-surumu.txt') ($ilk.Matches[0].Groups[1].Value + "`n") }
}
# Hangi eklenti bu klasörde açık: akademik eklenti yalnız akademisyende.
$yerel = Join-Path $Hedef '.claude\settings.local.json'
$akademikJson = if ($Akademik) { 'true' } else { 'false' }
if (-not (Test-Path $yerel)) {
  YazUtf8 $yerel "{`n  `"enabledPlugins`": { `"divit@divit`": true, `"divit-akademik@divit`": $akademikJson }`n}`n"
} else {
  try {
    $metin = [IO.File]::ReadAllText($yerel)
    if (-not $metin.Trim().StartsWith('{')) { throw 'nesne degil' }
    $j = $metin | ConvertFrom-Json -ErrorAction Stop
    if (-not ($j.PSObject.Properties.Name -contains 'enabledPlugins')) {
      $j | Add-Member -NotePropertyName 'enabledPlugins' -NotePropertyValue ([pscustomobject]@{})
    }
    $anahtarlar = [ordered]@{ 'divit@divit' = $true; 'divit-akademik@divit' = $Akademik }
    foreach ($k in $anahtarlar.Keys) {
      if ($j.enabledPlugins.PSObject.Properties.Name -contains $k) { $j.enabledPlugins.$k = $anahtarlar[$k] }
      else { $j.enabledPlugins | Add-Member -NotePropertyName $k -NotePropertyValue $anahtarlar[$k] }
    }
    YazUtf8 $yerel (($j | ConvertTo-Json -Depth 20) + "`n")   # varsayılan derinlik iç içe izinleri keser
  } catch { Uyari "Klasor ayar dosyasi okunamadi; dokunulmadi: .claude\settings.local.json" }
}
Get-ChildItem $Hedef -Recurse -File -ErrorAction SilentlyContinue | Unblock-File -ErrorAction SilentlyContinue
Get-ChildItem $Hedef -Recurse -Force -Filter '.gitkeep' -ErrorAction SilentlyContinue | Remove-Item -Force   # git kalintisi

# ---------------------------------------------------------------- 5
Adim "5/6 Divit eklentisi"
if ($Test -and -not $env:CLAUDE_CONFIG_DIR) { Bilgi "(sinama: atlandi)" }
elseif ($Claude) {
  # Ev klasöründen: bir klasörün kendi ayarı pazar yeri adresini karıştırmasın.
  Push-Location $Ev
  # Her çalıştırmada: ekle (yoksa), katalogu yenile, kur (yoksa), güncelle (varsa).
  # "Zaten kurulu" da başarı döndüğü için tek tek çıkış koduna bakılmaz;
  # sonuç kurulu eklentiler listesinden okunur.
  $cikti = @()
  $cikti += (& $Claude plugin marketplace add $PazarUrl 2>&1 | Out-String)
  $cikti += (& $Claude plugin marketplace update divit 2>&1 | Out-String)
  $cikti += (& $Claude plugin install divit@divit 2>&1 | Out-String)
  $cikti += (& $Claude plugin update divit@divit 2>&1 | Out-String)
  # Akademik eklenti her türde kurulur; klasörde yalnız akademisyende açıktır.
  $cikti += (& $Claude plugin install divit-akademik@divit 2>&1 | Out-String)
  $cikti += (& $Claude plugin update divit-akademik@divit 2>&1 | Out-String)
  $liste = (& $Claude plugin list 2>&1 | Out-String)
  $cekirdek = '(^|[^-\w])divit@divit'                  # divit-akademik@divit ile karışmasın
  # divit pazar yeri beklenen adreste mi? Başka kaynağa kayıtlıysa ekleme
  # "source differs" ile düşer, güncelleme eski kaynaktan yapılır: başarı sanılmasın.
  $BaskaKaynak = $null
  try {
    $pazarlar = (& $Claude plugin marketplace list --json 2>$null | Out-String) | ConvertFrom-Json -ErrorAction Stop
    $dp = @($pazarlar) | Where-Object { $_.name -eq 'divit' } | Select-Object -First 1
    if ($dp -and $dp.url -ne $PazarUrl) {
      $BaskaKaynak = @($dp.url, $dp.repo, $dp.path) | Where-Object { $_ } | Select-Object -First 1
      if (-not $BaskaKaynak) { $BaskaKaynak = '(bilinmiyor)' }
    }
  } catch { }                                             # --json yoksa yalnız eklenti listesine bakılır
  if (-not $BaskaKaynak -and (($cikti -join "`n") -match 'source differs')) { $BaskaKaynak = '(bilinmiyor)' }
  Pop-Location
  if ($BaskaKaynak) {
    Write-Host "  HATA: Divit bu bilgisayarda baska bir kaynaktan kurulu:" -ForegroundColor Red
    Write-Host "    $BaskaKaynak"
  }
  elseif ($liste -match $cekirdek) {
    $surum = if ($liste -match "$cekirdek[\s\S]*?Version:\s*(\S+)") { $Matches[2] } else { '?' }
    Bilgi "Kurulu ve guncel (surum $surum)."
  }
  else {
    Uyari "Simdi kurulamadi; uygulama ilk acildiginda kendiliginden inecek."
    Write-Host "  Ayrinti (gelistiriciye gonderin):" -ForegroundColor DarkGray
    ($cikti -join "`n").Trim() -split "`n" | Where-Object { $_.Trim() } |
      Select-Object -Last 12 | ForEach-Object { Write-Host "    $_" -ForegroundColor DarkGray }
  }
  if ($liste -notmatch 'divit-akademik@divit') {
    # Henüz yayında olmayabilir; kurulum durmaz. Yazarda bu eklenti zaten kapalı.
    if ($Tur -eq 'akademisyen') { Uyari "Universite isleri eklentisi (divit-akademik) simdi kurulamadi; kurulumu sonra yeniden calistirin." }
    else { Bilgi "Ek eklenti (divit-akademik) kurulamadi; sizin islerinizi etkilemez." }
  }
} else { Bilgi "Uygulama ilk acildiginda kendiliginden inecek." }

# Pazar yeri başka kaynaktaysa kurulum bitmiş sayılmaz.
if ($BaskaKaynak) {
  Remove-Item $Gecici -Recurse -Force -ErrorAction SilentlyContinue
  Write-Host ""
  Write-Host "Kurulum tamamlanmadi." -ForegroundColor Red
  Write-Host @"
Bu bilgisayarda Divit baska bir kaynaktan kurulu; yeni surum gelemedi.
Once sunu calistirin:

  claude plugin marketplace remove divit

sonra bu kurulumu yeniden calistirin. Klasordeki dosyalariniz silinmez.

"@
  $global:LASTEXITCODE = 1
  return
}

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

# Klasör seçerken gösterilecek yer: Belgeler altındaysa kısa ad, değilse tam yol.
$KlasorYeri = if ((Split-Path $Hedef -Parent).TrimEnd('\') -eq $Belgeler.TrimEnd('\')) { "Belgeler > $(Split-Path $Hedef -Leaf)" } else { $Hedef }

Remove-Item $Gecici -Recurse -Force -ErrorAction SilentlyContinue
Write-Host ""
if ($script:Uyarilar -gt 0) { Write-Host "Kurulum bitti ($($script:Uyarilar) uyari - yukariya bakin)." -ForegroundColor White }
else { Write-Host "Kurulum bitti." -ForegroundColor White }
Write-Host @"

Simdi:
  1. Claude aciksa tamamen kapatin. Sonra Claude uygulamasini acin (Baslat menusu > Claude). Divit'i kullanacak kisinin hesabiyla giris yapin.
  2. Ustteki "Code" sekmesine tiklayin.
  3. "Local" secin > "Select folder" > $KlasorYeri
  4. "merhaba" yazin. Divit gerisini kendisi sorar.

"@
if ($Dal -ne 'main') { Write-Host "Guncellemeler su dagitimdan gelir: $Dal"; Write-Host "" }
