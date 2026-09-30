# Editörlü kitap — başka yazarların bölümleri

Kullanıcı kitabın editörü; bölümleri başka yazarlar yazdı. Divit
editöre yardım eder, yazarların yerine yazmaz.

## Yasaklar

1. **Yazarın metni yeniden yazılmaz.** Bölüm iskeletine yazarın metni
   olduğu gibi girer. Her değişiklik öneridir ve yazara gider; editör ya
   da yazar onaylamadan işlenmez.
2. Üslup farkı **hata değildir.** Yalnız listelenir; editör karar verir.
3. Bir yazarın bölümünü başka bir yazarın bölümüne göre "düzeltme".
   Çelişkide iki yeri alıntıyla yaz; doğrusunu tahmin etme (`[DOĞRULA]`).
4. Yazar adı, unvanı, kurumu uydurulmaz; bilinmiyorsa boş bırak, sor.

## Başlangıç

Sor: "Bu kitapta bölümleri siz mi yazdınız, yoksa başka yazarların
bölümlerini siz mi bir araya getiriyorsunuz? 1) Hepsi benim 2) Başka
yazarlar da var — numarayı yazın." 2 ise bu dosyayla devam.

Bölümler tek tek ya da hep birlikte gelir; hepsi `malzeme/`'ye betikle
konur. Dosya adından yazar belli değilse her dosya için sor.

## yazarlar.md

`kitaplar/<kitap-adi>/yazarlar.md` — her bölüm bir satır:

| Bölüm dosyası | Bölüm başlığı | Yazar(lar) | Unvan / kurum | E-posta | Teslim tarihi | Durum |
|---|---|---|---|---|---|---|

Durum: `geldi` · `okundu` · `düzeltme istendi` · `düzeltilmiş hâli geldi` · `tamam`.
Bir bölümün düzeltilmiş hâli gelince eskisi silinmez; yeni dosya
`-2` ekiyle konur, satırdaki dosya adı güncellenir.

## Adımların farkı (yedi adım aynı sırayla)

**1. Envanter** — "Yazar" sütunu eklenir; yazar sayısı ve bölüm başına
kelime yazılır. Çok kısa ya da çok uzun bölüm varsa söyle.

**2. Konu haritası** — ayrıca **yazarlar arası**: aynı konuyu iki
yazarın anlatması (tekrar), birbirini tutmayan bilgi (çelişki), birinin
tanımladığı terimi ötekinin başka anlamda kullanması.

**4. İçindekiler** — her bölüm başlığının altında yazar adı:
`3. Suyun Hikâyesi — Ayşe Demir`. Bölüm sırası önerilir; bölüm
bölünmez, birleştirilmez (bu yazarın kararıdır, sor).

**5. İskelet** — yazarın bölümü değişmeden girer. Editörün giriş ve
bölümler arası bağlantı notları `[TASLAK]` ile ayrı başlıkta.

## Biçim birliği ve üslup listesi

`duzenleme/bicim-birligi.md` — bütün kitap için tek liste:
- Başlık düzeyleri, alt başlık kullanımı, bölüm başı özet var mı
- Sayı ve tarih yazımı (`1990'lı`, `%10` / `yüzde 10`), kısaltmalar
- Kaynak gösterme: dipnot mu, metin içi mi, kaynakça bölüm sonunda mı
  kitap sonunda mı; her yazar hangisini kullanmış. Tek biçim öner
  (çoğunluğunkini), karar editörün.
- Terim birliği: aynı şeye farklı ad (tablo: terim → hangi yazar → öneri)
- **Üslup farkları** (yalnız liste, düzeltme yok): hitap (siz/sen/biz),
  resmîlik, cümle uzunluğu, birinci tekil anlatım.

## Katkıcıya düzeltme isteği

Her yazar için ayrı dosya:
`duzenleme/yazar-istekleri/<yazar-kisa-ad>-<YYYY-AA-GG>.md`

İçerik: kısa selam ve bağlam (`[TASLAK]`), sonra numaralı liste — her
madde: yer (bölüm / başlık), en çok bir satır alıntı, istek, neden
(biçim birliği / çelişki / tekrar / eksik bilgi). Başka yazarın metnini
alıntılama; "başka bir bölümde farklı yıl geçiyor" yeter, kim olduğunu
editör söyler. Son satır teslim tarihi sorusu.

Gönderimi editör yapar. E-posta metni istenirse `yazisma`.
yazarlar.md'de durum, editör gönderdiğini söyleyince `düzeltme istendi` olur.
