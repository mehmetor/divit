# Windows: eski Word dosyasını (.doc) kullanıcının kendi Word'üyle .docx'e çevirir.
# Asıl dosya salt okunur açılır, değişmez. Word görünmez; makrolar zorla kapalı,
# uyarı penceresi ve dönüştürme sorusu yok. Şifreli dosyada şifre sorulmaz, hata döner.
# Word 90 saniyede bitirmezse yalnız bu betiğin başlattığı Word kapatılır;
# kullanıcının açık Word'üne dokunulmaz. Çıktı yalnız .divit\gecici\ altına yazılır;
# gizli\ ve hakemlik\ klasörlerindeki dosyalar açılmaz.
# Kullanım: powershell -NoProfile -ExecutionPolicy Bypass -File doc-cevir.ps1 "<girdi.doc>" "<.divit/gecici/ad.docx>"
# Çıktı tek satır: TAMAM <çıktı> | HATA WORD-YOK | HATA SIFRELI | HATA ZAMAN-ASIMI | HATA <neden>
# Çıkış: 0 tamam, 1 hata. Mac eşi: textutil (macOS'ta yerleşik). PowerShell 5.1 ile uyumlu.

try { [Console]::OutputEncoding = [System.Text.Encoding]::UTF8 } catch { }

$SURE = 90

function Bitir([string]$satir) {
    Write-Output $satir
    if ($satir -like 'TAMAM *') { exit 0 } else { exit 1 }
}

if ($args.Count -lt 2) { Bitir 'HATA Kullanım: doc-cevir.ps1 "<girdi.doc>" "<.divit/gecici/ad.docx>"' }

$calisma = (Get-Location).ProviderPath
function Tam([string]$yol) {
    if (-not [IO.Path]::IsPathRooted($yol)) { $yol = Join-Path $calisma $yol }
    return [IO.Path]::GetFullPath($yol)
}
$girdi = Tam ([string]$args[0])
$cikti = Tam ([string]$args[1])
$ciktiGoster = [string]$args[1]

if (-not (Test-Path -LiteralPath $girdi -PathType Leaf)) { Bitir "HATA Dosya bulunamadı: $($args[0])" }
if ($girdi -match '[\\/](gizli|hakemlik)[\\/]') { Bitir 'HATA Bu klasördeki dosyalar okunmaz.' }
if ($cikti -notmatch '\.docx$') { Bitir 'HATA Çıktı .docx olmalı.' }
if ($cikti -notmatch '[\\/]\.divit[\\/]gecici[\\/]') { Bitir 'HATA Çıktı yalnız .divit/gecici/ altına yazılır.' }
$klasor = Split-Path -Parent $cikti
if (-not (Test-Path -LiteralPath $klasor -PathType Container)) {
    New-Item -ItemType Directory -Path $klasor -Force | Out-Null
}

# Bu betiğin başlattığı Word süreci: öncesi ve sonrası karşılaştırılır.
$oncekiler = @(Get-Process -Name WINWORD -ErrorAction SilentlyContinue | ForEach-Object { $_.Id })
try {
    $word = New-Object -ComObject Word.Application
} catch {
    Bitir 'HATA WORD-YOK'
}
$yeniler = @(Get-Process -Name WINWORD -ErrorAction SilentlyContinue |
    Where-Object { $oncekiler -notcontains $_.Id } | ForEach-Object { $_.Id })
# Yeni süreç yoksa var olan bir Word'e bağlanılmıştır: onu kapatma.
$kendiWord = $yeniler.Count -ge 1
$bizimId = if ($yeniler.Count -eq 1) { $yeniler[0] } else { $null }

# Bekçi: süre dolarsa yalnız bizim Word'ü kapatır; takılan çağrı hatayla döner.
$bekci = $null
if ($bizimId) {
    $bekci = Start-Job -ArgumentList $bizimId, $SURE -ScriptBlock {
        param($id, $sn)
        Start-Sleep -Seconds $sn
        Stop-Process -Id $id -Force -ErrorAction SilentlyContinue
    }
}

$eksik = [System.Reflection.Missing]::Value
$doc = $null
$sonuc = $null
try {
    $word.Visible = $false
    $word.DisplayAlerts = 0          # wdAlertsNone
    $word.AutomationSecurity = 3     # msoAutomationSecurityForceDisable: makro çalışmaz
    # Open(FileName, ConfirmConversions, ReadOnly, AddToRecentFiles, PasswordDocument,
    #      PasswordTemplate, Revert, WritePasswordDocument, WritePasswordTemplate, Format,
    #      Encoding, Visible, OpenAndRepair, DocumentDirection, NoEncodingDialog)
    # Uydurma şifre: şifresiz dosyada yok sayılır, şifreli dosyada soru yerine hata verir.
    $doc = $word.Documents.Open($girdi, $false, $true, $false, 'divit-sifre-yok',
        $eksik, $false, $eksik, $eksik, 0, $eksik, $false, $false, $eksik, $true)
    if ($doc.PSObject.Methods['SaveAs2']) {
        # SaveAs2(FileName, FileFormat=wdFormatXMLDocument, LockComments, Password, AddToRecentFiles)
        $doc.SaveAs2($cikti, 16, $false, '', $false)
    } else {
        $ad = $cikti; $bicim = 16
        $doc.SaveAs([ref]$ad, [ref]$bicim)
    }
    if (Test-Path -LiteralPath $cikti -PathType Leaf) { $sonuc = "TAMAM $ciktiGoster" }
    else { $sonuc = 'HATA Word dosyayı kaydetmedi.' }
} catch {
    $e = $_.Exception
    while ($e.InnerException) { $e = $e.InnerException }
    $ileti = ([string]$e.Message) -replace '\s+', ' '
    if ($bizimId -and -not (Get-Process -Id $bizimId -ErrorAction SilentlyContinue)) {
        $sonuc = 'HATA ZAMAN-ASIMI'
    } elseif ($e.HResult -eq -2146822880 -or $ileti -match 'password|parola|şifre') {
        $sonuc = 'HATA SIFRELI'      # Word hata 5408: şifre yanlış
    } else {
        $sonuc = "HATA $ileti"
    }
} finally {
    if ($null -ne $doc) { try { $doc.Close(0) } catch { } }        # wdDoNotSaveChanges
    if ($kendiWord) { try { $word.Quit(0) } catch { } }
    foreach ($o in @($doc, $word)) {
        if ($null -ne $o) { try { [void][Runtime.InteropServices.Marshal]::ReleaseComObject($o) } catch { } }
    }
    [GC]::Collect()
    [GC]::WaitForPendingFinalizers()
    if ($bekci) {
        Stop-Job -Job $bekci -ErrorAction SilentlyContinue
        Remove-Job -Job $bekci -Force -ErrorAction SilentlyContinue
    }
}
Bitir $sonuc
