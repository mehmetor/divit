---
name: bakim
description: Divit'in ayda bir yaptığı iç düzen bakımı — profil dosyalarını, klasördeki CLAUDE.md'yi, Claude'un hafıza notlarını ve günlüğü sadeleştirir, eskiyen ara dosyaları listeler, yanlış yerde ya da sürümsüz kalmış Divit dosyalarını bulup onayla yerine taşır; ayrıca haftalık geri bildirim önerisinin ve aylık bakımın zamanını denetler. Kullanıcı "bakım yap", "düzenini gözden geçir", "kendini toparla", "klasör karıştı" dediğinde ya da kurallar skill'i hatırlatma denetimi istediğinde kullan.
---

# Bakım ve hatırlatmalar

## Yasaklar

- **İzin almadan bakıma başlama.** Hoca "hayır" ya da "sonra" derse dur.
- Hiçbir şeyi silme. Değiştireceğin her dosyanın kopyasını önce
  `.divit/onceki-surumler/<YYYY-AA-GG_SSDD>/` altına al.
- Hocanın metinlerine, öğrenci dosyalarına, `gelen/` klasörlerine dokunma.
  Bakım yalnızca Divit'in kendi düzenidir. Kullanıcının kendi dosyalarını
  yeniden adlandırma, taşıma; düzen listesine de alma.
- `kimlik.md`'deki `Kullanıcı türü:` satırına **dokunma**; sadeleştirirken
  de yerinde (ilk başlığın hemen altında) aynen kalır.
- Klasördeki `CLAUDE.md`'nin "Her oturumun ilk mesajında" ve "Çekirdek
  kurallar" bölümlerini **değiştirme, kısaltma.**
- Hocaya teknik ayrıntı anlatma. Sonucu üç satırda söyle.

## Hatırlatma denetimi

`kurallar` bunu hocanın ilk işi bittikten sonra ister. Tarihleri
`.divit/hatirlatma.md` dosyasında tut (yoksa oluştur):

```
son-oneri-geri-bildirim: YYYY-AA-GG
geri-bildirim-sorma: hayir
son-bakim: YYYY-AA-GG
son-oneri-bakim: YYYY-AA-GG
son-gorulen-surum: 1.6
son-oneri-guncelleme: YYYY-AA-GG
son-uzak-denetim: YYYY-AA-GG
```

Oturumda **en fazla bir** hatırlatma yap. Sıra: yenilik/güncelleme
(`guncelleme` skill'i, 1. ve 2. adımlar), geri bildirim, bakım.

**Geri bildirim** — şu üçü birden doğruysa öner:
1. `geri-bildirim-sorma` "evet" değil;
2. son gönderimden (`.divit/paylasim/son-paylasim.txt`; yoksa
   `gunluk.md`'deki ilk kayıttan) bu yana 7 günden fazla geçmiş;
3. son öneriden (`son-oneri-geri-bildirim`) bu yana 7 günden fazla geçmiş.

> "Bir haftadır geri bildirim göndermediniz. Notlarımı size göstereyim mi?
> Onaylamazsanız hiçbir şey gitmez. (İsterseniz bunu bir daha sormam.)"

- "evet" → `gelistirici-paylas` skill'ine geç.
- "sonra", "hayır" → yalnızca `son-oneri-geri-bildirim`'i bugüne yaz.
  Bir hafta sonra yeniden sorulur.
- "bir daha sorma" → `geri-bildirim-sorma: evet` yaz. Bir daha önerme.
  Hoca kendisi "geri bildirim gönder" derse `gelistirici-paylas` her zaman çalışır.

**Bakım** — `son-bakim` (yoksa `gunluk.md`'deki ilk kayıt) 30 günden eski
ve `son-oneri-bakim` 7 günden eskiyse sor:

> "Ayda bir kendi notlarımı toparlarım; beni hızlı ve doğru tutar. İki
> üç dakika sürer, dosyalarınıza dokunmam. Şimdi yapayım mı?"

- "evet" → aşağıdaki bakıma geç.
- başka cevap → `son-oneri-bakim`'i bugüne yaz; bir hafta sonra tekrar sor.

## Bakım adımları

Her adımda bulduğunu not et; değişiklikleri **sonda tek seferde** göster.

**1. Profil dosyaları** (`.divit/profil/`). Her oturumda okunurlar;
uzadıkça Divit yavaşlar ve kuralları karıştırır.
- Tekrarlanan ya da birbiriyle çelişen satırları bul. Çelişkide hocaya
  hangisinin doğru olduğunu sor; tahmin etme.
- `gorevler.md`: tarihi geçmiş ve bitmiş işleri "Biten işler" başlığı
  altına taşı. Kurulumda hocanın "yok" dediği şeyleri koru.
- Her dosya 150 satırın altında kalsın. Fazlası özetlenir; özet hocanın
  onayından geçer.

**2. Klasördeki `CLAUDE.md`.** Zamanla hoca ya da Divit altına satır
eklemiş olabilir.
- `@.divit/profil/...` satırları ve iki çekirdek bölüm yerinde mi, denetle.
  Eksikse hocaya söyle; kendin yeniden yazma.
- Sonradan eklenmiş satırlar profilde zaten varsa çıkar. Hocaya ait bir
  tercihse `uslup.md` ya da `gorevler.md`'ye taşı.

**3. Claude'un hafıza notları.** Claude bu klasör için kendi hafıza
dosyalarını tutabilir (bilgisayarın kullanıcı klasöründe
`.claude/projects/<bu klasör>/memory/MEMORY.md`). Varsa oku.
- Hoca hakkında kalıcı bilgi (tercih, alışkanlık) → ilgili profil
  dosyasına taşı, hafızadaki satırı çıkar.
- Eskimiş ya da profil ile çelişen notları çıkar.
- Dosya yoksa ya da okunamıyorsa bu adımı sessizce atla.

**4. Günlük ve sorunlar.**
- `gunluk.md` 300 satırı geçtiyse bir önceki aylardan olan satırları
  `.divit/arsiv/gunluk-<YYYY>.md` sonuna ekle, `gunluk.md`'de bu ayı bırak.
- `sorunlar.md`'de aynı sorun üç kez geçiyorsa bakım özetinde söyle ve
  geri bildirim göndermeyi öner (sorma kaydı "evet" değilse).

**Kota:** `saglik` skill'indeki "Kota ve model" kuralına göre ayın
"kota" kayıtlarını say; gerekirse öneriyi yap.

**5. Yer ve dosya düzeni.** Önce `${CLAUDE_PLUGIN_ROOT}/skills/kurallar/dosya-duzeni.md`'yi
Read ile yükle (yerler tablosu ve "Divit dosyasını taşımak"). Bu adımda yalnız **listele**.
- `.divit/onceki-surumler/` ve `.divit/gecici/` klasörlerinin kaba büyüklüğünü
  söyle (Glob ile dosya sayısı). 90 günden eski önceki sürümler varsa söyle.
- `.divit/gecici/`: adındaki tarih **30 günden eski** dosyalar ve adında
  tarih olmayanlar (ikincisi "tarihi belli değil" diye ayrı).
- **Dağınıklık** — yalnız Divit'in ürettikleri (adında `-divit-` olan ya da
  `gunluk.md`'de Divit'in yazdığı geçen); emin değilsen listeye alma:
  a) Yanlış yer: kökte ya da tablodakinden başka klasörde duran çıktı → tablodaki yer.
  b) Ara dosya `.divit/gecici/` dışında (metne çevrilmiş kopya, deneme) → `.divit/gecici/`.
  c) Sürümsüz aynı ad: aynı klasörde tarihsiz ya da `-2`, `-yeni`, `(1)` ekli
     çıktılar → `<ad>-YYYY-AA-GG`, sonra `-s2`; tarih günlükteki kayıttan,
     bulamazsan yeniden adlandırma önerme.
  Tarih almayan yaşayan dosyalar (`plan.md`, `oneriler-…`) dağınık değildir.

Taşıma ve yeniden adlandırma **yalnız onayla**, `dosya-duzeni.md`'deki komutla,
her dosya ayrı komutla. Divit dosya silemez: silmek isteyene klasörü açarsın (Windows:
`Invoke-Item`, Mac: `open`); siler ya da `arsiv/`'e taşır, kendisi karar verir.
Kullanıcının dosyası için "Bundan sonrakiler yeni düzende adlanacak" de.

## Göster, onay al, kaydet

Özet, en çok beş madde:

> "Bakımı yaptım. Önerdiğim değişiklikler:
> - Görevlerde biten 4 işi 'Biten işler'e taşıyorum.
> - Üslup notlarında iki kez yazılmış bir kural var; birini çıkarıyorum.
> - Bir aydan eski 12 ara dosya var; isterseniz klasörü açarım, siz silersiniz.
> - Benim yazdığım 3 rapor ana klasörde duruyor; öğrencinin klasörüne taşıyayım mı?
> Onaylıyor musunuz?"
Dağınıklık maddeleri türe göre birleşir ("3 rapor"); özet yine en çok beş madde.

Onaydan sonra uygula. `son-bakim`'i bugüne yaz. `gunluk.md`'ye tek satır:
`YYYY-AA-GG SS:DD · bakım · .divit · <ne değişti, tek cümle>`.
Değişiklik gerekmiyorsa: "Her şey düzenli." de, yalnızca tarihi yaz.
