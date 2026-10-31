# Windows: eski Office dosyasının (.doc, .xls, .ppt) bir kopyasını kullanıcının kendi
# Word / Excel / PowerPoint'üyle yeni biçime (.docx, .xlsx, .pptx) çevirir.
# Asıl dosya salt okunur açılır, değişmez. Program görünmez (PowerPoint pencere açmaz);
# makrolar zorla kapalı, uyarı penceresi yok. Şifreli dosyada şifre sorulmaz, hata döner.
# Program 90 saniyede bitirmezse yalnız bu betiğin başlattığı program kapatılır;
# kullanıcının açık belgelerine dokunulmaz. Çıktı yalnız .divit\gecici\ altına yazılır;
# gizli\ ve hakemlik\ klasörlerindeki dosyalar açılmaz.
# Kullanım: powershell -NoProfile -ExecutionPolicy Bypass -File eski-cevir.ps1 "<girdi.doc|xls|ppt>" "<.divit/gecici/ad.docx|xlsx|pptx>"
# Çıktı tek satır: TAMAM <çıktı> | HATA PROGRAM-YOK | HATA SIFRELI | HATA ZAMAN-ASIMI | HATA <neden>
# Çıkış: 0 tamam, 1 hata. Mac eşi: textutil (.doc), eski-cevir.js (.xls, .ppt). PowerShell 5.1 ile uyumlu.

try { [Console]::OutputEncoding = [System.Text.Encoding]::UTF8 } catch { }

$SURE = 90
$SAHTE_SIFRE = 'divit-sifre-yok'   # şifresiz dosyada yok sayılır, şifreli dosyada soru yerine hata verir

function Bitir([string]$satir) {
    Write-Output $satir
    if ($satir -like 'TAMAM *') { exit 0 } else { exit 1 }
}

if ($args.Count -lt 2) { Bitir 'HATA Kullanım: eski-cevir.ps1 "<girdi.doc|xls|ppt>" "<.divit/gecici/ad.docx|xlsx|pptx>"' }

$calisma = (Get-Location).ProviderPath
function Tam([string]$yol) {
    if (-not [IO.Path]::IsPathRooted($yol)) { $yol = Join-Path $calisma $yol }
    return [IO.Path]::GetFullPath($yol)
}
$girdi = Tam ([string]$args[0])
$cikti = Tam ([string]$args[1])
$ciktiGoster = [string]$args[1]

$turler = @{
    '.doc' = @{ Yeni = '.docx'; ProgId = 'Word.Application';       Surec = 'WINWORD' }
    '.xls' = @{ Yeni = '.xlsx'; ProgId = 'Excel.Application';      Surec = 'EXCEL' }
    '.ppt' = @{ Yeni = '.pptx'; ProgId = 'PowerPoint.Application'; Surec = 'POWERPNT' }
}
$uzanti = [IO.Path]::GetExtension($girdi).ToLowerInvariant()
$tur = $turler[$uzanti]

if (-not (Test-Path -LiteralPath $girdi -PathType Leaf)) { Bitir "HATA Dosya bulunamadı: $($args[0])" }
if (-not $tur) { Bitir 'HATA Yalnız .doc, .xls ve .ppt çevrilir.' }
if ($girdi -match '[\\/](gizli|hakemlik)[\\/]') { Bitir 'HATA Bu klasördeki dosyalar okunmaz.' }
if ([IO.Path]::GetExtension($cikti).ToLowerInvariant() -ne $tur.Yeni) { Bitir "HATA Çıktı $($tur.Yeni) olmalı." }
if ($cikti -notmatch '[\\/]\.divit[\\/]gecici[\\/]') { Bitir 'HATA Çıktı yalnız .divit/gecici/ altına yazılır.' }
$klasor = Split-Path -Parent $cikti
if (-not (Test-Path -LiteralPath $klasor -PathType Container)) {
    New-Item -ItemType Directory -Path $klasor -Force | Out-Null
}

# PowerPoint şifre sorusunu kapatmanın yolu yok: şifreli .ppt'yi açmadan tanı
# (şifreli dosyada "EncryptedSummary" bölümü bulunur).
if ($uzanti -eq '.ppt') {
    $baytlar = [IO.File]::ReadAllBytes($girdi)
    if ([Text.Encoding]::Unicode.GetString($baytlar).Contains('EncryptedSummary')) { Bitir 'HATA SIFRELI' }
    $baytlar = $null
}

# Bu betiğin başlattığı süreç: öncesi ve sonrası karşılaştırılır.
$oncekiler = @(Get-Process -Name $tur.Surec -ErrorAction SilentlyContinue | ForEach-Object { $_.Id })
try {
    $app = New-Object -ComObject $tur.ProgId
} catch {
    Bitir 'HATA PROGRAM-YOK'
}
$yeniler = @(Get-Process -Name $tur.Surec -ErrorAction SilentlyContinue |
    Where-Object { $oncekiler -notcontains $_.Id } | ForEach-Object { $_.Id })
# Yeni süreç yoksa kullanıcının açık programına bağlanılmıştır (PowerPoint tek
# pencerelidir): yalnız kendi açtığımız dosyayı kapat, programı kapatma.
$kendiProgram = $yeniler.Count -ge 1
$bizimId = if ($yeniler.Count -eq 1) { $yeniler[0] } else { $null }

# Bekçi: süre dolarsa yalnız bizim programı kapatır; takılan çağrı hatayla döner.
$bekci = $null
if ($bizimId) {
    $bekci = Start-Job -ArgumentList $bizimId, $SURE -ScriptBlock {
        param($id, $sn)
        Start-Sleep -Seconds $sn
        Stop-Process -Id $id -Force -ErrorAction SilentlyContinue
    }
}

# Office yöntemlerini IDispatch üzerinden, seçenekleri ADIYLA geçirerek çağırır.
# Word'ün seçenekleri "başvuru" (ByRef) türündedir; PowerShell oraya $true/$false
# veremez ("Cannot convert the True value of type bool to type Object", pilotta
# görüldü). Adlı çağrıda başvuru da eksik değer de gerekmez.
function Cagir($nesne, [string]$yontem, $secenekler) {
    $adlar = [string[]]@()
    $degerler = [object[]]@()
    if ($secenekler) {
        foreach ($k in $secenekler.Keys) {
            $adlar += [string]$k
            $degerler += , $secenekler[$k]
        }
    }
    return [System.__ComObject].InvokeMember($yontem, [Reflection.BindingFlags]::InvokeMethod,
        $null, $nesne, $degerler, $null, $null, $adlar)
}

$belge = $null
$sonuc = $null
try {
    switch ($uzanti) {
        '.doc' {
            $app.Visible = $false
            $app.DisplayAlerts = 0          # wdAlertsNone
            $app.AutomationSecurity = 3     # msoAutomationSecurityForceDisable: makro çalışmaz
            $belge = Cagir $app.Documents 'Open' ([ordered]@{
                FileName = $girdi; ConfirmConversions = $false; ReadOnly = $true
                AddToRecentFiles = $false; PasswordDocument = $SAHTE_SIFRE
                Revert = $false; Format = 0; Visible = $false; NoEncodingDialog = $true })
            # wdFormatXMLDocument = 16; SaveAs2 Word 2010 ve sonrası, öncesi SaveAs
            $kaydet = if ($belge.PSObject.Methods['SaveAs2']) { 'SaveAs2' } else { 'SaveAs' }
            [void](Cagir $belge $kaydet ([ordered]@{ FileName = $cikti; FileFormat = 16; AddToRecentFiles = $false }))
        }
        '.xls' {
            $app.Visible = $false
            $app.DisplayAlerts = $false
            $app.AutomationSecurity = 3
            $belge = Cagir $app.Workbooks 'Open' ([ordered]@{
                Filename = $girdi; UpdateLinks = 0; ReadOnly = $true; Password = $SAHTE_SIFRE
                IgnoreReadOnlyRecommended = $true; Editable = $false; Notify = $false; AddToMru = $false })
            [void](Cagir $belge 'SaveAs' ([ordered]@{ Filename = $cikti; FileFormat = 51 }))   # xlOpenXMLWorkbook
        }
        '.ppt' {
            # PowerPoint'te uygulama gizlenemez; dosya penceresiz açılır.
            $app.DisplayAlerts = 1          # ppAlertsNone
            $app.AutomationSecurity = 3
            # msoTrue = -1, msoFalse = 0
            $belge = Cagir $app.Presentations 'Open' ([ordered]@{
                FileName = $girdi; ReadOnly = -1; Untitled = 0; WithWindow = 0 })
            [void](Cagir $belge 'SaveAs' ([ordered]@{ FileName = $cikti; FileFormat = 24 }))   # ppSaveAsOpenXMLPresentation
        }
    }
    if (Test-Path -LiteralPath $cikti -PathType Leaf) { $sonuc = "TAMAM $ciktiGoster" }
    else { $sonuc = 'HATA Program dosyayı kaydetmedi.' }
} catch {
    $e = $_.Exception
    while ($e.InnerException) { $e = $e.InnerException }
    $ileti = ([string]$e.Message) -replace '\s+', ' '
    if ($bizimId -and -not (Get-Process -Id $bizimId -ErrorAction SilentlyContinue)) {
        $sonuc = 'HATA ZAMAN-ASIMI'
    } elseif ($e.HResult -eq -2146822880 -or $ileti -match 'password|parola|şifre') {
        $sonuc = 'HATA SIFRELI'      # Word hata 5408 ya da Excel/PowerPoint şifre iletisi
    } else {
        $sonuc = "HATA $ileti"
    }
} finally {
    if ($null -ne $belge) {
        try {
            switch ($uzanti) {
                '.doc' { [void](Cagir $belge 'Close' ([ordered]@{ SaveChanges = 0 })) }   # wdDoNotSaveChanges
                '.xls' { [void](Cagir $belge 'Close' ([ordered]@{ SaveChanges = $false })) }
                '.ppt' { [void](Cagir $belge 'Close' $null) }
            }
        } catch { }
    }
    if ($kendiProgram) {
        try {
            if ($uzanti -eq '.doc') { [void](Cagir $app 'Quit' ([ordered]@{ SaveChanges = 0 })) }
            else { [void](Cagir $app 'Quit' $null) }
        } catch { }
    }
    foreach ($o in @($belge, $app)) {
        if ($null -ne $o) { try { [void][Runtime.InteropServices.Marshal]::ReleaseComObject($o) } catch { } }
    }
    [GC]::Collect()
    [GC]::WaitForPendingFinalizers()
    if ($bekci) {
        Stop-Job -Job $bekci -ErrorAction SilentlyContinue
        Remove-Job -Job $bekci -Force -ErrorAction SilentlyContinue
    }
    # Kapanmadıysa bizim başlattığımız süreci kapat: görünmez program arkada kalmasın
    # (kalırsa kullanıcının sonra açtığı dosyalar görünmez pencereye düşebilir).
    if ($bizimId) {
        $surec = Get-Process -Id $bizimId -ErrorAction SilentlyContinue
        if ($surec -and -not $surec.WaitForExit(5000)) {
            Stop-Process -Id $bizimId -Force -ErrorAction SilentlyContinue
        }
    }
}
Bitir $sonuc
