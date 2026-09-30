# Takvim dosyası (.ics) yazımı

`takvim` skill'i bu dosyayı Read ile yükler. Kullanıcıya buradaki
hiçbir terimi söyleme; ona yalnız "takvim dosyası" de.

## Yer ve ad

`cikti/takvim/<YYYY-AA-GG>-<kisa-ad>.ics` — tarih ilk etkinliğin tarihi, ad
küçük harf, Türkçe karaktersiz, tireli (ör. `cikti/takvim/2026-10-15-rapor-teslimi.ics`).
Aynı adlı dosya varsa sonuna `-2` ekle; üzerine yazma. Write ile yaz
(klasör yoksa Write açar).

## Şablon

Aynen bu sırayla; her etkinlik için bir `BEGIN:VEVENT … END:VEVENT` bloğu.
Tüm gün etkinlik (saat yoksa):

```
BEGIN:VCALENDAR
VERSION:2.0
PRODID:-//Divit//Takvim//TR
CALSCALE:GREGORIAN
METHOD:PUBLISH
BEGIN:VEVENT
UID:20261015-rapor-teslimi-1@divit
DTSTAMP:20261001T090000Z
DTSTART;VALUE=DATE:20261015
DTEND;VALUE=DATE:20261016
SUMMARY:Proje ara raporu teslimi
DESCRIPTION:Kaynak: e-posta\, 28 Eylül. Divit ekledi.
BEGIN:VALARM
ACTION:DISPLAY
DESCRIPTION:Proje ara raporu teslimi
TRIGGER:-P1D
END:VALARM
END:VEVENT
END:VCALENDAR
```

Saatli etkinlikte (toplantı, sunum) tüm gün satırları yerine yerel saatle
(sonunda `Z` yok, `TZID` yok; takvim programı kullanıcının saatini alır):

```
DTSTART:20261015T140000
DTEND:20261015T150000
```

Bitiş saati yazmıyorsa bir saat sonrası. Uyarı (`VALARM`) saatlide
`TRIGGER:-PT1H`.

## Kurallar

- **DTEND tüm gün etkinlikte ertesi gündür** (15 Ekim etkinliği →
  `DTEND;VALUE=DATE:20261016`). Ay ve yıl sonunu doğru çevir
  (31 Ekim → 20261101, 31 Aralık → yeni yılın 0101'i).
- **UID** her etkinlikte farklı ve kalıcı: `<YYYYAAGG>-<kisa-ad>-<sıra>@divit`.
  Aynı işi yeniden aktarırken aynı UID'yi kullan; takvim programı onu
  güncelleme sayar, ikinci kopya açmaz.
- **DTSTAMP** dosyanın yazıldığı an, `YYYYAAGGTSSDDSSZ` biçiminde (saati
  bilmiyorsan `T090000Z`).
- Metinde (SUMMARY, DESCRIPTION) virgül `\,`, noktalı virgül `\;`, ters
  bölü `\\`, satır sonu `\n` yazılır. Tırnak, uzun tire, emoji koyma.
- Türkçe harf serbesttir; dosya UTF-8 yazılır.
- **Satır uzunluğu.** Her fiziksel satır 75 baytı geçemez. Ölçü:
  en fazla 60 karakter, Türkçe harfler (ç ğ ı İ ö ş ü ve büyükleri) iki
  sayılır. Uzun satırı böl; devam satırı **tek boşlukla** başlar:

  ```
  DESCRIPTION:Kaynak: e-posta\, 28 Eylül. Ara raporun iki nüshas
   ı enstitüye verilecek.
  ```

  SUMMARY'yi kısa tut (işin adı yeter); ayrıntı DESCRIPTION'a.
- Boş satır bırakma; dosya `END:VCALENDAR` ile biter.

Satır sonu kuralı CRLF'tir; Write düz satır sonu yazar. Outlook, Google
ve Apple takvimi bunu okur; ayrıca bir şey yapma.

## Denetle, sonra aç

**Atlama:** yazdıktan sonra Read ile bak: her `BEGIN` için bir `END`, her
etkinlikte UID, DTSTAMP, DTSTART, SUMMARY var; tüm gün etkinlikte DTEND
ertesi gün; 60'ı aşan satır yok. Yanlışı düzelt. Bu denetimi kullanıcıya
anlatma. Sonra dosyayı aç:
- Mac: `open "cikti/takvim/<ad>.ics"`
- Windows: `Invoke-Item "cikti/takvim/<ad>.ics"`

Açılmazsa klasörü aç (`open "cikti/takvim"` / `Invoke-Item "cikti/takvim"`)
ve "Dosyaya iki kez tıklayın" de.
