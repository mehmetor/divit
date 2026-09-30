# Editörlük — ayrıntılı liste ve şablonlar

`kitap-duzenle` skill'inin yardımcı dosyası. Aşamalar sırayla uygulanır;
bir aşamanın bulguları gösterilmeden sonrakine geçilmez.

## 1. Yapı

- İçindekiler okura bir yol çiziyor mu? Bölüm sırası değişse kitap
  kazanır mı? (Önerirken hangi bölümün nereye gideceğini yaz.)
- Her bölümün ana fikrini tek cümleyle yazabiliyor musun? Yazamıyorsan
  bölüm iki fikri taşıyor ya da hiçbirini bitirmiyor.
- Giriş okura ne vaat ediyor? Son bölüm bu vaadi karşılıyor mu?
- Anekdot–ilke dengesi: hikâye anlatılıp ders çıkarılmayan, ya da ilke
  sayılıp hiç örneklenmeyen bölüm.
- Bölüm uzunlukları: diğerlerinin iki katı ya da yarısı olan bölüm.
- Yeni baskının amacına göre: kısaltmada çıkabilecek bölüm ve pasaj
  (kelime sayısıyla); yeni okurda açıklama gerektiren yer;
  genişletmede malzemesi olmayan boşluk.

## 2. Anlatım

- Dolgu: bir şey söylemeyen giriş paragrafı, aynı fikrin art arda üç
  kez başka sözlerle söylenmesi.
- Uzun pasaj: bir paragrafta birden çok fikir; okuru yoran cümle
  (üç yan cümleden uzun).
- Belirsiz kavram: ilk geçtiği yerde anlatılmayan terim, kısaltma.
- İngilizce iş jargonu: Türkçesi yerleşik olanları öner, okurun
  bilmeyeceği yerde açıklama öner; kullanıcı bilerek kullanıyorsa bırak.
- Kullanıcının sesi: konuşma tadı, kendine özgü deyimleri, mizahı
  **bulgu değildir**.

## 3. Tutarlılık

`plan.md` "Bölüm notları"ndan bütün kitap boyunca karşılaştır:
- Aynı olayın yılı, yaşı, süresi, tutarı iki yerde farklı mı? Hesapla
  (ör. "1985'te girdim, 12 yıl çalıştım, 1995'te ayrıldım" tutmaz).
- Kişi ve şirket adının, unvanın yazımı her yerde aynı mı?
- Aynı kavram için farklı terim (müşteri / alıcı / tüketici) — kasıtlı mı?
- İki bölümde anlatılan aynı anekdot ya da aynı ilke: hangisinde
  kalacağını kullanıcıya sor, öteki için kısa gönderme öner.
- Çizelge, liste ve metindeki sayılar birbirini tutuyor mu?

## 4. Son okuma

Yazım (TDK), noktalama, büyük harf, sayıların yazımı (rakam/yazı),
tırnak ve kesme işaretleri, bitişik/ayrı yazılan ekler ("de/da", "ki").
Tek tek listeleme; türüne göre öbekle, her öbekten iki örnek ver.

## Yeni baskı denetimi

| İşaret | Ne zaman |
|---|---|
| `[GÜNCELLE]` | Yılı belli rakam, "geçen yıl", "bugün", "şu an", "son on yılda"; kapanmış ya da adı değişmiş şirket; değişmiş olabilecek mevzuat, vergi oranı, teknoloji |
| `[DOĞRULA]` | Kaynağı gösterilmeyen sayı, tarih, olay; ünlü birine mal edilen söz |

Ünlü söz için kimin söylediğini hafızadan düzeltme; "bu söz başka
kişilere de mal ediliyor olabilir, kaynağını doğrulayın" yaz.

## Rapor şablonu

```markdown
# Editör raporu — <kitap adı>, <YYYY-AA-GG>
**Metin:** <dosya> · <bölüm sayısı> bölüm · yaklaşık <kelime> kelime
**Yeni baskının amacı:** <plan.md'den>  ·  **Bakılan aşamalar:** <...>

## Üç cümlelik özet
<kitabın durumu; en ağır tek sorun; en güçlü yanı>

## Bulgular
| # | Aşama | Yer | Alıntı | Bulgu | Önem |
|---|---|---|---|---|---|
| 1 | Yapı | 3. bölüm, "..." başlığı | "..." (en çok bir satır) | ... | 3 |

Önem: 3 = yeni baskıdan önce mutlaka · 2 = düzeltilmeli · 1 = iyileştirme
Sıra: önce yapı, sonra anlatım, tutarlılık, son okuma; her birinde önem.

## Yeni baskı için güncellenecekler
| # | Yer | Alıntı | İşaret | Neden |

## Yayınevi ya da hukukçuyla konuşun
<gerçek kişi ya da şirket hakkında olumsuz ya da özel bilgi, izin
gerektirebilecek alıntı, fotoğraf, çizelge — yer ve tek cümle; hüküm yok>

## Güçlü yanlar
<kitabın en iyi yaptığı iki üç şey; yeni baskı bunun üzerine kurulsun>

## Yeni baskıya önsöz (başlıklar)
<ne değişti, neden — madde başlıkları; metni kullanıcı yazar>

---
*Bu rapor yapay zekâ destekli bir ön okumadır. Karar ve metin yazarındır.*
```

Durum satırı rapora değil, yalnız `plan.md`'ye yazılır.

## Öneri dosyası — `duzenleme/oneriler-<bolum-no>.md`

```markdown
# Öneriler — <bölüm no>. bölüm, <YYYY-AA-GG>
| # | Yer | Önce | Sonra | Neden | Durum |
|---|---|---|---|---|---|
| 1 | "..." başlığı, 2. paragraf | <asıl cümle> | <en az değişmiş hâli> | <tek cümle> | bekliyor |
```

Durum: bekliyor · onaylandı · reddedildi · kullanıcı değiştirdi.
Yapı önerisinde "Önce/Sonra" sütunlarına paragraf değil, yer yaz
(ör. "Önce: 4. bölüm → Sonra: 2. bölümden sonra").

## plan.md iskeleti

```markdown
Durum: <aşama> · <sıradaki iş> · <YYYY-AA-GG>
# <kitap adı>
- Asıl dosya: <yol>
- Bakılacak: <seçilen aşamalar> · Yeni baskının amacı: <...>

## Bölümler
| No | Başlık | Kelime | Okundu | Aşama |

## Bölüm notları
### <no>. <başlık>
- Ana fikir: <tek cümle>
- Anekdotlar: <kısa adlar>
- Sayılar ve tarihler: <...>
- Kişi ve şirket adları: <yazıldığı gibi>
```
