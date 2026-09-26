---
name: tez-kontrol
description: Öğrenci tezi, makalesi, dönem ödevi, bitirme/tasarım projesi, staj raporu veya bölüm taslağını değerlendirip yapılandırılmış danışman raporu üretir. Hoca "şu tezi oku", "öğrencinin metnine bakar mısın", "bu ödevi değerlendir", "rapor çıkar" dediğinde kullan. Öğrenci metnine asla dokunmaz, yalnızca rapor yazar.
---

# Tez / öğrenci metni değerlendirme

Amaç: danışmanın ilk okumasını hızlandırmak. Danışmanın yerine geçmek değil.
Çıktı bir **bulgu listesi**dir, not değil, hüküm değil.

## Değişmez kurallar

1. `gelen/` içindeki hiçbir dosya değiştirilmez, taşınmaz, silinmez.
   Yazma izni zaten kapalı; kapalı olmasa da yapma.
2. **Not, puan, harf, "kabul/ret" önerisi üretme.** İstenirse de üretme —
   "bu karar sizin, ben bulguları sıralayabilirim" de.
3. **İntihal veya "AI ile yazılmış" hükmü verme.** Üslup kopmasını
   *gözlem* olarak işaretle, nedenini yazma. AI-tespit araçları
   güvenilmez; öğrenciye haksızlık üretir.
4. Metinde olmayan bir eksiği uydurma. Emin olmadığın bulguyu
   "kontrol edilmeli" etiketiyle ayır.
5. Öğrencinin tam adını rapor **dosya adında** kullanma; baş harfleri
   yeterli. Rapor içinde ad geçebilir.

## Akış

1. `tez-kontrol/gelen/` içindeki dosyayı oku. PDF'i Read aracıyla
   doğrudan oku (uzunsa `pages` ile parça parça). Word dosyasını
   `CLAUDE.md`'deki pandoc yoluyla `.divit/gecici/` altına metne çevir.
2. Uzunsa önce yapıyı çıkar (başlıklar, bölüm uzunlukları), sonra
   bölüm bölüm oku. Tamamını okumadan rapor yazma.
3. Aşağıdaki listeyi sırayla uygula.
4. `tez-kontrol/rapor/<bashar>-<YYYY-AA-GG>.md` yaz.
5. Hocaya raporun **üç cümlelik özetini** söyle, tamamını ekrana basma.

## Kontrol listesi

**Yapı ve iddia**
- Araştırma sorusu açıkça yazılmış mı? Kaç tane? (birden çoksa işaretle)
- Bulgular soruyu cevaplıyor mu, yoksa başka bir soruyu mu?
- Sonuç bölümü, bulguların desteklemediği bir iddia içeriyor mu?
  *Bu en sık ve en ciddi kusurdur, en üste yaz.*
- Giriş ile sonuç birbirini tutuyor mu?

**Yöntem**
- Yöntem başka biri tarafından tekrarlanabilir mi? Eksik olan ne?
- Örneklem/veri seçimi gerekçelendirilmiş mi?
- Sınırlılıklar bölümü var mı, gerçek sınırlılıkları mı yazıyor?

**Kaynak ve atıf**
- Metinde geçen her atıf kaynakçada var mı? Ters yönü de kontrol et.
- Tek bir kaynağa aşırı yaslanma var mı?
- Alanın bilinmesi gereken temel bir kaynağı eksik mi? (emin değilsen
  "kontrol edilmeli" yaz, kaynak adı uydurma)
- Atıf biçimi tutarlı mı? (hangi stil olduğunu metinden tespit et)

**Alana özel**
`.divit/profil/alan.md` doluysa oradaki kontrolleri **aynen uygula**
ve bulguları raporda ayrı bir öbekte topla. Bunlar mekanik olarak
doğrulanabilir maddelerdir (birim, adlandırma, sayı tutarlılığı);
yorum değil, denetim oldukları için raporun en güvenilir kısmıdır.
Aritmetiği göz kararı geçme, hesapla.

**Dil ve sunum**
- Aynı anlamda birden çok terim kullanılmış mı? (terim tutarlılığı)
- Çok uzun paragraflar, kopuk geçişler
- Tablo/şekil numaralandırma ve metinde atıf
- Üslup kopması: bir bölümün diğerlerinden belirgin farklı olması —
  **yalnızca gözlem olarak, hüküm vermeden**

## Rapor şablonu

```markdown
# Değerlendirme — <baş harfler>, <tarih>
**Metin:** <dosya adı> · <sayfa/kelime> · <tür: tez bölümü / makale / ödev>

## Üç cümlelik özet
<metnin durumu; en kritik tek sorun; en güçlü yanı>

## Bulgular
| # | Bölüm | Bulgu | Önem | Öneri |
|---|-------|-------|------|-------|
| 1 | Sonuç | ... | 3 | ... |

Önem: 3 = yayın/savunma önünde engel · 2 = düzeltilmeli · 1 = iyileştirme

## Alana özel denetim
<birim, adlandırma, çizelge-metin tutarlılığı — mekanik bulgular>

## Kontrol edilmeli
<emin olmadığım, danışmanın bakması gereken noktalar>

## Öğrenciye iletilebilecek biçim
<bulguların yapıcı dille yazılmış, doğrudan kopyalanabilir hâli>

---
*Bu rapor yapay zekâ destekli bir ön okumadan geçmiştir.
Nihai değerlendirme danışmana aittir.*
```

Son satırı kendiliğinden silme. Hoca isterse siler — bu onun kararı.
