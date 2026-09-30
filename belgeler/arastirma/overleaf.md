# Overleaf'e tek tıkla gönderme — araştırma

Tarih: 2026-10-01 · Kaynak: https://www.overleaf.com/devs ("Open in Overleaf" API)

**Karar:** Skill'e konmadı. `disa-aktar` zip üretir, hoca Overleaf'te
**New Project → Upload Project** ile yükler. Aşağıdaki yol ileride
denenebilir; pilotta bir hoca "zip yüklemek zor" derse açılır.

## API ne sunuyor

`https://www.overleaf.com/docs` adresi yeni proje açar. Parametreler:

| Parametre | Yöntem | Not |
|---|---|---|
| `snip_uri` | GET/POST | `.tex` ya da zip adresi; birden çok dosya `snip_uri[]` |
| `snip` | POST | ham `.tex` metni, kodlamasız |
| `encoded_snip` | POST | `encodeURIComponent` ile kodlanmış metin |
| `snip_name[]` | POST | yüklenen dosyaların adı |
| `engine` | GET/POST | `pdflatex`, `xelatex`, `lualatex`, `latex_dvipdf` |
| `main_document` | GET/POST | ana `.tex` dosyası |
| `visual_editor` | GET/POST | `true` → görsel düzenleyiciyle açılır |

## Neden görevdeki biçim (`?snip_uri=<url>`) olmuyor

`snip_uri` bir **herkese açık adres** ister; Overleaf sunucusu dosyayı o
adresten çeker. Hocanın bilgisayarındaki `cikti/...zip` bir adres değildir.
Dosyayı bir yere yüklemek (GitHub, Drive paylaşım linki) yayınlanmamış
makaleyi herkese açmak demektir — Divit bunu yapmaz.

## Denenebilecek yol: yerel HTML formu + `data:` adresi

Belgeye göre `snip_uri` base64 kodlu `data:` adresi de kabul ediyor, zip
dahil (`data:application/zip;base64,...`). Böylece dosya bir sunucuya
konmadan gönderilebilir:

1. Divit zip'i üretir (bugünkü akış).
2. Zip base64'e çevrilir ve `cikti/<ad>-overleaf.html` içine
   `<form method="POST" action="https://www.overleaf.com/docs">` altında
   gizli `snip_uri` alanı olarak yazılır; tek "Overleaf'te aç" düğmesi.
3. Hoca HTML'e tıklar, düğmeye basar; Overleaf (giriş yapılmışsa) projeyi açar.

Açık sorular (denenmedi):

- **Base64 çevirimi.** Python yok. Mac'te `base64` yerleşik, Windows'ta
  `[Convert]::ToBase64String(...)`; ikisi de izin listesine yeni satır ve
  kurallar'daki kabuk listesine istisna demek. Alternatif: HTML içinde
  tarayıcıya zip'i seçtirip JavaScript ile kodlamak — o zaman hoca yine
  dosya seçer, "tek tık" kazancı küçülür.
- **Boyut sınırı.** Resimli makalede base64 zip birkaç MB olur; Overleaf'in
  POST boyut sınırı belgede yok.
- **Gizlilik.** İçerik yalnız Overleaf'e gider (hoca zaten oraya yükleyecek);
  üçüncü tarafa açılmaz. KVKK açısından zip yüklemeyle aynı.
- **Tek `.tex` yolu.** Resim yoksa `snip` ile yalnız `.tex` gönderilebilir;
  kaynakça `filecontents` ortamıyla `.tex` içine gömülür. Daha basit ama
  resimli metinde işe yaramaz.

Deneme ölçütü: bir Mac ve bir Windows'ta, giriş yapılmış ve yapılmamış
Overleaf hesabıyla, 5 MB'lık resimli zip'in projeye eksiksiz açılması.
