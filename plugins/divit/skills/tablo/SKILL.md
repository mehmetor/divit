---
name: tablo
description: Bir tabloyu Excel'de çift tıkla açılan dosyaya (.csv) aktarır; Türkçe harfler ve virgüllü sayılar bozulmaz; gelen Excel dosyasını okuyup tablo olarak gösterir. Kullanıcı "Excel'e aktar", "Excel'de açılır yap", "tablo yap", "bunu Excel'e koy", "listeyi Excel'e çevir", "bu Excel dosyasını oku", "şu tabloya bak" dediğinde kullan.
---

# Tablo — Excel'de açılan dosya

**Önce:** `divit:kurallar` bu oturumda yüklenmediyse şimdi Skill aracıyla yükle; her komut oradaki kabuk kuralına ve araç yollarına uyar (`cat`, zincir, `cd` yok).

Tür satırını `.divit/profil/kimlik.md`'den Read ile oku; hitap ve kelimeler rol
dosyasına göre (yazara akademik kelime yok). Dosyayı Write yazar; ek program kurulmaz.

## Yasaklar

1. **Python, Node ya da başka program isteyen yerleşik Excel becerisini
   kullanma**, bir şey kurma. Bu skill yeter.
2. **Sayı uydurma.** Her değer kullanıcıdan ya da onun dosyasından gelir. Eksik
   hücre boş kalır ya da sorulur; tahmin edilmez. Toplama, ortalama, yüzde yalnız
   kullanıcı isterse; yaptıysan söyle. İstatistik hesabı ve yorum yok.
3. **Formül, renk, birden çok sayfa yok.** İsterse: "Bunları Excel'de kendiniz
   ekleyebilirsiniz; ben düz tabloyu hazırlarım."
4. Kullanıcının Excel dosyasını yerinde değiştirme; her sonuç `cikti/` altında yeni dosya.
5. `gelen/`, `asil/`, `malzeme/` içine yazma. Not ya da puan verme; kullanıcının
   verdiği notu aktarmak serbest.

## Ad ve yer

`cikti/<ad>-YYYY-AA-GG.csv`; `<ad>` kısa, küçük harf, Türkçe karaktersiz, tireli
(`verim-karsilastirma`). Önce Glob'la bak (boş sonuç "yok" demektir; başka komutla bakma, klasörü Write kendisi açar); aynı gün varsa `-s2`, `-s3`. Üstüne yazma.

## Akış

1. **Veri.** Yapıştırılmış satırlar, Word tablosu, metindeki sayılar ya da Excel
   dosyası. Word'ü kurallardaki çeviriyle, Excel'i aşağıdaki "Gelen Excel" ile oku.
2. **Ekranda göster.** Tabloyu önce sohbette markdown tablosu olarak göster,
   sütun başlıklarıyla. "Böyle mi aktarayım?" Onay gelmeden yazma.
3. **Yaz.** Onaydan sonra Write ile `.csv`, aşağıdaki biçimle.
4. **Denetim (atlama).** Dosyayı Read ile oku: ilk satır başlık mı, her satırda
   sütun sayısı aynı mı (tırnak içindeki `;` sayılmaz), sayılar ekrandakiyle aynı mı.
5. **Aç:** Mac `open "cikti/<ad>-<tarih>.csv"`, Windows `Invoke-Item "cikti/<ad>-<tarih>.csv"`.

## Biçim — Türkçe Excel için

- **Dosyanın ilk karakteri görünmez U+FEFF işaretidir** (Excel Türkçe harfleri
  ancak onunla doğru okur). Write içeriği bu karakterle başlar, hemen ardından
  başlık satırı gelir. Boşluk ya da boş satır koyma.
- Ayırıcı `;` (Türkçe Excel'in liste ayırıcısı). Virgül ayırıcı kullanma.
- İlk satıra `sep=;` **yazma**; U+FEFF işaretini etkisiz bırakır, harfler bozulur.
- Ondalık virgül: `8100,5`. Noktalı gelen ondalığı (`650.0`, `8100.5`) virgüle
  çevir; `.0` ile biten tam sayıyı tam yaz (`650`). Binlik ayırıcı koyma (`12500`).
- Tarih `GG.AA.YYYY`. Yüzde işaretsiz sayı ve başlıkta `(%)`.
- **Tırnaklama:** hücrede `;`, `"`, virgül ya da satır sonu varsa hücre çift
  tırnak içine alınır; içindeki `"` ikilenir (`""`). Ondalık virgüllü sayı tırnaksız
  kalır (tırnak içindeki sayı Excel'de metin olur). Diğer hücreler tırnaksız.
- Başında sıfır olan numara (`0123`) Excel'de sıfırını kaybeder; varsa kullanıcıya söyle.

Örnek (U+FEFF görünmez, ilk satırın başında):

```
Yöntem;Su (m³/da);Verim (kg/da);Not
Karık;650;7200;"Çiğdem, Şule"
Damla;450;8100,5;"İğdır; ölçüm"
```

## Açılınca tek sütun görünürse

Bilgisayarın bölge ayarı Türkçe değilse Excel her şeyi tek sütuna koyar. Tek cümle:
"Excel'de boş bir sayfa açın, **Veri → Metinden/CSV'den** ile bu dosyayı seçin;
Dosya kökeni **65001: Unicode (UTF-8)**, Sınırlayıcı **Noktalı virgül** olsun."
Harfler bozuksa aynı yol. Sonra `.divit/sorunlar.md`'ye not düş.

Kullanıcı "Excel değil, Google E-Tablolar kullanıyorum" derse: aynı dosyayı
**Dosya → İçe aktar** ile açabilir; ayırıcıyı "Noktalı virgül" seçer.

## Gelen Excel

Kullanıcı `.xlsx` verip "oku", "bak", "şu tabloyu kullan" derse:
- Mac: `~/.divit/araclar/pandoc "<dosya>.xlsx" -t gfm -o ".divit/gecici/<ad>-YYYY-AA-GG.md"`
- Windows: `& "<pandoc>" "<dosya>.xlsx" -t gfm -o ".divit/gecici/<ad>-YYYY-AA-GG.md"`

Sonra Read ile oku. Her sayfa `##` başlığıyla gelir. Sayılar `650.0` biçiminde
gelebilir: kullanıcıya gösterirken ve yazarken yukarıdaki kurala göre düzelt.
Formüller gelmez, yalnız son hesaplanmış değerler gelir; gerekirse söyle.
Eski `.xls` okunmaz: "Excel'de açıp Farklı Kaydet → .xlsx yapar mısınız?" ya da
"İlgili satırları seçip buraya yapıştırır mısınız?"

Klasör dışındaki dosya için kurallardaki "Klasör dışındaki dosya" adımı.

## Kapanış

Kullanıcıya `.csv` dosyasının tam yolu, ters tırnakta ("çift tıklayınca Excel'de
açılır"). Tek cümle: "Divit Excel dosyası yapar ama süslemez; renk ve formülü
Excel'de eklersiniz. Kaydederken Excel sorarsa **Excel Çalışma Kitabı** seçin."

Günlüğe: `YYYY-AA-GG SS:DD · tablo · <dosya> · <kaç satır, kaç sütun>`.
