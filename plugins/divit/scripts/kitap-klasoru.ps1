# Windows: kitap klasörünü açar ve kullanıcının dosyasını bir kez yerleştirir.
# Divit klasörünün içinde (alt klasörde de) çalışır; kökü .divit klasöründen bulur,
# yollar köke göredir. Var olan dosyaya dokunmaz.
# Kullanım: powershell -NoProfile -ExecutionPolicy Bypass -File kitap-klasoru.ps1 ac <kitap-adi>
#           powershell -NoProfile -ExecutionPolicy Bypass -File kitap-klasoru.ps1 koy <kitap-adi> asil|malzeme "<kaynak dosya>" [yeni-ad]
# yeni-ad isteğe bağlı: küçük harf, rakam, tire; uzantı kaynaktan korunur
# (ör. 327434a4-image.jpg + el-yazisi-01 → el-yazisi-01.jpg).
# Çıktı tek satır: ACILDI <yol> | KOPYALANDI <yol> | VAR <yol> | HATA <neden>
# Çıkış: 0 tamam, 3 aynı adlı dosya zaten var, 1 hata.
# Mac eşi: kitap-klasoru.sh (aynı arayüz). PowerShell 5.1 ile uyumlu.

try { [Console]::OutputEncoding = [System.Text.Encoding]::UTF8 } catch { }

function Hata([string]$neden) {
    Write-Output "HATA $neden"
    exit 1
}

$islem = if ($args.Count -ge 1) { [string]$args[0] } else { '' }
$ad = if ($args.Count -ge 2) { [string]$args[1] } else { '' }

if ($ad -cnotmatch '^[a-z0-9][a-z0-9-]*$') {
    Hata 'Kitap adı yalnız küçük harf, rakam ve tire olabilir (ör. yonetim-notlari).'
}

# Kabuk bir alt klasörde kalmış olabilir: kök, .divit içeren ilk üst klasör.
$calisma = (Get-Location).ProviderPath
$koku = $calisma
while ($koku -and -not (Test-Path -LiteralPath (Join-Path $koku '.divit') -PathType Container)) {
    $koku = Split-Path -Parent $koku
}
if (-not $koku) { Hata "Divit klasörü bulunamadı (.divit yok): $calisma" }

$kok = "kitaplar/$ad"                 # çıktıdaki yol (köke göre)
$kokTam = Join-Path (Join-Path $koku 'kitaplar') $ad

function Klasorleri-Ac {
    foreach ($alt in @('asil', 'malzeme')) {
        $yol = Join-Path $kokTam $alt
        if (-not (Test-Path -LiteralPath $yol -PathType Container)) {
            try { New-Item -ItemType Directory -Path $yol -Force -ErrorAction Stop | Out-Null }
            catch { Hata "Kitap klasörü açılamadı: $kok" }
        }
    }
}

switch ($islem) {
    'ac' {
        if ($args.Count -ne 2) { Hata 'Kullanım: ac <kitap-adi>' }
        Klasorleri-Ac
        Write-Output "ACILDI $kok"
        exit 0
    }
    'koy' {
        if ($args.Count -ne 4 -and $args.Count -ne 5) { Hata 'Kullanım: koy <kitap-adi> asil|malzeme "<dosya>" [yeni-ad]' }
        $bolum = [string]$args[2]
        $kaynak = [string]$args[3]
        $yeni = if ($args.Count -eq 5) { [string]$args[4] } else { '' }
        if ($args.Count -eq 5 -and $yeni -cnotmatch '^[a-z0-9][a-z0-9-]*$') {
            Hata 'Yeni ad yalnız küçük harf, rakam ve tire olabilir, uzantısız (ör. el-yazisi-01).'
        }
        if (-not [System.IO.Path]::IsPathRooted($kaynak)) { $kaynak = Join-Path $calisma $kaynak }
        if ($bolum -cne 'asil' -and $bolum -cne 'malzeme') { Hata 'Yer yalnız asil ya da malzeme olabilir.' }
        if (-not (Test-Path -LiteralPath $kaynak -PathType Leaf)) { Hata "Dosya bulunamadı: $kaynak" }
        Klasorleri-Ac
        $ad_ = [System.IO.Path]::GetFileName($kaynak)
        if ($yeni) {
            $uzanti = ''
            if ([System.IO.Path]::GetFileNameWithoutExtension($ad_)) { $uzanti = [System.IO.Path]::GetExtension($ad_) }
            $ad_ = "$yeni$uzanti"
        }
        $hedef = "$kok/$bolum/$ad_"
        $hedefTam = Join-Path (Join-Path $kokTam $bolum) $ad_
        if (Test-Path -LiteralPath $hedefTam) {
            Write-Output "VAR $hedef"
            exit 3
        }
        try { Copy-Item -LiteralPath $kaynak -Destination $hedefTam -ErrorAction Stop }
        catch { Hata "Dosya kopyalanamadı: $kaynak" }
        Write-Output "KOPYALANDI $hedef"
        exit 0
    }
    default { Hata "Bilinmeyen iş: '$islem' (ac ya da koy olmalı)." }
}
