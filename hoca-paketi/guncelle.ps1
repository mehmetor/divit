# Divit guncelleyici (Windows). Kurulum bunu %USERPROFILE%\.divit\guncelle.ps1
# olarak koyar ve klasor ayarina bu yolla tam eslesen tek bir izin kurali
# yazar; boylece Divit'in "guncelle"si kurulumu soru ve guvenlik denetimine
# takilmadan baslatabilir (DVT-67). Divit'in cagirdigi bicim:
#
#   powershell -NoProfile -ExecutionPolicy Bypass -File "C:\Users\<ad>\.divit\guncelle.ps1" <kanal> "<Divit klasorunun tam yolu>"
#
# En yeni kur.ps1'i kanaldan indirir, klasoru DIVIT_HEDEF olarak verir
# (DVT-66). Tur verilmez: kur.ps1 onu klasordeki kimlik.md'den okur.
# (Bu dosya ANSI okunsa da bozulmasin diye yalniz ASCII.)
param([string]$Kanal = 'main', [string]$Klasor = '')

try { [Console]::OutputEncoding = [Text.Encoding]::UTF8 } catch {}
try { [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 } catch {}
if (-not ($Kanal -ceq 'main' -or $Kanal -cmatch '^deneme(-.+)?$')) { $Kanal = 'main' }
if (-not $Klasor -or -not (Test-Path -LiteralPath (Join-Path $Klasor '.divit') -PathType Container)) {
  Write-Host "HATA: Divit klasoru bulunamadi: $Klasor" -ForegroundColor Red
  exit 1
}
try { $kod = Invoke-RestMethod -Uri "https://raw.githubusercontent.com/mehmetor/divit/$Kanal/kur.ps1" -UseBasicParsing }
catch {
  Write-Host "HATA: Divit indirilemedi. Internet baglantisini kontrol edin." -ForegroundColor Red
  exit 1
}
Remove-Item Env:DIVIT_TUR -ErrorAction SilentlyContinue
$env:DIVIT_DAL = $Kanal
$env:DIVIT_HEDEF = $Klasor
Invoke-Expression $kod
