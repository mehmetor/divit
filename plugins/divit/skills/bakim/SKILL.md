---
name: bakim
description: Divit'in ayda bir yaptığı iç düzen bakımı — profil dosyalarını, klasördeki CLAUDE.md'yi, Claude'un hafıza notlarını ve günlüğü sadeleştirir; ayrıca haftalık geri bildirim önerisinin ve aylık bakımın zamanını denetler. Hoca "bakım yap", "düzenini gözden geçir", "kendini toparla" dediğinde ya da kurallar skill'i hatırlatma denetimi istediğinde kullan.
---

# Bakım ve hatırlatmalar

## Yasaklar

- **İzin almadan bakıma başlama.** Hoca "hayır" ya da "sonra" derse dur.
- Hiçbir şeyi silme. Değiştireceğin her dosyanın kopyasını önce
  `.divit/onceki-surumler/<YYYY-AA-GG_SSDD>/` altına al.
- Hocanın metinlerine, öğrenci dosyalarına, `gelen/` klasörlerine dokunma.
  Bakım yalnızca Divit'in kendi düzenidir.
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
```

Oturumda **en fazla bir** hatırlatma yap. Önce geri bildirim, o yoksa bakım.

**Geri bildirim** — şu üçü birden doğruysa öner:
1. `geri-bildirim-sorma` "evet" değil;
2. son gönderimden (`.divit/paylasim/son-paylasim.txt`; yoksa
   `gunluk.md`'deki ilk kayıttan) bu yana 7 günden fazla geçmiş;
3. son öneriden (`son-oneri-geri-bildirim`) bu yana 7 günden fazla geçmiş.

> "Bir haftadır geri bildirim göndermediniz. Notlarımı size göstereyim mi?
> Onaylamazsanız hiçbir şey gitmez. (İsterseniz bunu bir daha sormam.)"

- "evet" → `paylas` skill'ine geç.
- "sonra", "hayır" → yalnızca `son-oneri-geri-bildirim`'i bugüne yaz.
  Bir hafta sonra yeniden sorulur.
- "bir daha sorma" → `geri-bildirim-sorma: evet` yaz. Bir daha önerme.
  Hoca kendisi "geri bildirim gönder" derse `paylas` her zaman çalışır.

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

**5. Yer.** `.divit/onceki-surumler/` ve `.divit/gecici/` klasörlerinin
kaba büyüklüğünü söyle. 90 günden eski önceki sürümler varsa hocaya
söyle; **silme.** İsterse klasörü açarsın (Windows: `Invoke-Item`,
Mac: `open`), kendisi karar verir.

## Göster, onay al, kaydet

Özet, en çok beş madde:

> "Bakımı yaptım. Önerdiğim değişiklikler:
> - Görevlerde biten 4 işi 'Biten işler'e taşıyorum.
> - Üslup notlarında iki kez yazılmış bir kural var; birini çıkarıyorum.
> Onaylıyor musunuz?"

Onaydan sonra uygula. `son-bakim`'i bugüne yaz. `gunluk.md`'ye tek satır:
`YYYY-AA-GG SS:DD · bakım · .divit · <ne değişti, tek cümle>`.
Değişiklik gerekmiyorsa: "Her şey düzenli." de, yalnızca tarihi yaz.
