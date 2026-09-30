---
name: takvim
description: Yaklaşan işleri ve son tarihleri takip eder — bu haftanın özeti, bir e-postadaki ya da yazıdaki son tarihi işler listesine ekleme, tarihi Outlook, Google ya da Apple takvimine aktarma. Kullanıcı "bu hafta neler var", "yaklaşan işlerim", "ne zaman teslim", "şu tarihi not al", "takvime ekle", "hatırlat" dediğinde ya da bir e-posta yapıştırıp içinde son tarih geçtiğinde kullan.
---

# Takvim ve iş takibi

**Önce:** `divit:kurallar` bu oturumda yüklenmediyse şimdi Skill aracıyla yükle;
her komut oradaki kabuk kuralına ve araç yollarına uyar (`cat`, zincir, `cd` yok).

İş listesi tektir: `.divit/profil/gorevler.md`. Yeni liste dosyası açma.
Kullanıcı türü `kurallar`'daki rol dosyasından bellidir; hitap ona göre.

## Yasaklar

- **Tarih uydurma.** Metinde açıkça yazmayan günü tahmin etme. "Ay sonu",
  "önümüzdeki hafta" gibi belirsiz ifadede günü kullanıcıya sor.
  Yıl yazmıyorsa en yakın gelecek yılı öner ve sor.
- **Onaysız ekleme yok.** `gorevler.md`'ye, takvime ya da bağlı hesaba
  eklemeden önce ne ekleyeceğini gösterip "Ekleyeyim mi?" diye sor.
- Bağlı takvim hesabında **yalnız etkinlik oluştur**; var olanı silme,
  değiştirme, davet gönderme, başkasını ekleme.
- Yazar türünde akademik kelime kullanma (öğrenci, tez, makale, dergi,
  sınav, ders, jüri, hakem). Örnekler: yayınevine teslim, editör dönüşü,
  dizgi provası, baskı, söyleşi.
- Bitmiş işi silme; `bitti` diye işaretle (taşımayı `bakim` yapar).

## gorevler.md biçimi

Dosyada zaten satır varsa **aynı biçimle** yaz. Dosya yalnız "Henüz
doldurulmadı" diyorsa o paragrafı bırak, altına şu biçimle başla:

```
- <iş> · <kişi ya da kitap> · <YYYY-AA-GG> · <durum>
```

Sıra her zaman: iş, kişi (akademisyende öğrenci için baş harf) ya da kitap,
tarih, durum (`bekliyor`, `sürüyor`, `bitti`). Kişi yoksa `—` yaz. Kaynağı
e-postaysa iş sütununun sonuna, tarihten önce ekle: `… (e-posta, 28 Eylül) · — · …`.

## 1. "Bu hafta neler var"

1. `gorevler.md`'yi Read ile oku. Bugünün tarihini oturum bilgisinden al;
   pencere **bugün ve sonraki 6 gün**dür.
2. Akademisyense `.divit/profil/takvim.md`'yi de oku (aşağıda 4. bölüm).
3. Şu biçimde, kısa ver:

   > **Bu hafta (1–7 Ekim)**
   > - **Bugün, Perşembe 1 Ekim** — <iş> (<kişi ya da kitap>)
   > - **Pazartesi 5 Ekim** — <iş>
   >
   > **Tarihi geçmiş, bitti mi?** <iş> — 28 Eylül
   >
   > **Sonraki hafta:** <en yakın bir-iki iş> 

   Gün adını tarihten hesapla, Türkçe yaz. Yalnız işi olan günleri yaz; bugün
   iş yoksa "Bugün" satırı olmaz. Bitmiş (`bitti`) işleri gösterme.
   Tarihsiz işleri en sonda tek satırda say ("Tarihi olmayan 2 iş var.").
   Hiç iş yoksa: "Bu hafta listenizde tarihli bir iş yok." de.
4. Geçmiş tarihli iş için bir kez "bitti mi?" sor; "evet" derse
   `durum`u `bitti` yap.
5. Sonunda bir kez öner: "İsterseniz bu tarihleri takviminize de eklerim."
   Bu özeti verdiysen `kurallar`'daki "Hatırlatma: …" cümlesini ayrıca ekleme.

## 2. E-postadan ya da yazıdan tarih yakalama

Kullanıcı bir e-posta, duyuru ya da yazı yapıştırır (ya da dosyasını verir;
Word ve PDF'i `kurallar`'daki yolla oku).

1. Metindeki **her** son tarihi, toplantıyı, teslimi bul. Her biri için: ne,
   kim için, hangi gün (saat varsa saat), metindeki yeri (kısa alıntı).
2. Göster ve sor — tek mesajda:

   > Bu yazıda şu tarihi buldum:
   > - **15 Ekim 2026, Perşembe** — <iş> ("…en geç 15 Ekim'e kadar…")
   >
   > İşler listenize ekleyeyim mi?

3. "Evet" derse `gorevler.md`'ye Edit ile ekle (biçim yukarıda). Aynı iş
   zaten varsa ekleme; tarihi farklıysa hangisinin doğru olduğunu sor.
4. Sonra bir kez: "Takviminize de ekleyeyim mi?" → 3. bölüm.

## 3. Takvime aktarma

Önce araç listene bak: adında `calendar`, `takvim` ya da `outlook` geçen ve
etkinlik oluşturan bir araç varsa (ör. Google Calendar `create_event`) **a**,
yoksa **b**.

**a. Bağlı takvim.** İzin iste:

> "Takviminiz Claude'a bağlı görünüyor. Bu tarihi takviminize tüm gün
> etkinlik olarak ekleyeyim mi? Başka hiçbir şeye dokunmam."

İzin gelirse tüm gün etkinlik oluştur (saat varsa o saatte, bir saatlik);
başlık işin kendisi, açıklama kişi ya da kitap ve kaynağı. Katılımcı ekleme.
Bitince: "Takviminize ekledim: <gün> — <iş>." Hata olursa ya da kullanıcı
"hayır" derse **b**'ye geç. Bir oturumda izin bir kez sorulur.

**b. Takvim dosyası (.ics).** Outlook, Google ve Apple takviminin
tanıdığı dosya. Nasıl yazılacağı:
`${CLAUDE_PLUGIN_ROOT}/skills/takvim/ics.md` — Read ile yükle, aynen uygula.
Birden çok tarih varsa hepsi tek dosyaya. Dosyayı açtıktan sonra söyle:

> "Takvim dosyasını açtım. Takvim programınız 'ekle' diye sorarsa onaylayın.
> Google Takvim kullanıyorsanız: Google Takvim'de sağ üstteki dişli →
> **Ayarlar** → **İçe ve dışa aktar** → bu dosyayı seçin."

Dosyanın tam yolunu ters tırnak içinde ver.

## 4. Akademisyen: dönem takvimi

Yalnız akademisyen türünde; yazarda bu bölümü tümüyle atla.

`.divit/profil/takvim.md` **varsa** oku. Özetin gün listesinin altına tek satır
ders programı koy (gün listesine karıştırma): "Bu haftanın dersleri: Pzt 10.00
<ders>, Çar 14.00 <ders>." Özetin sonuna, "takviminize eklerim" önerisinden
önce, uyan her durum için **ayrı bir soru** — cümleler aynen:
- Sınav haftasına **14 gün ya da daha az** kaldıysa ve `gorevler.md`'de
  soru hazırlığı yoksa: "<Sınav> haftası <gün>'de başlıyor. Soruları
  hazırlamaya başlayalım mı?" → evetse `divit-akademik:sinav`.
- Not giriş son gününe **7 gün ya da daha az** kaldıysa: "Not girişi
  <gün>'e kadar. Değerlendirmeniz gereken kâğıt ya da ödev kaldı mı?"
- Önerilen işi kullanıcı isterse `gorevler.md`'ye ekle (onayla).
Dosyadaki en son tarih geçmişse dönem bitmiştir: bir kez "Yeni dönemin
takvimini verir misiniz?" diye sor.

`takvim.md` **yoksa** ve bu oturumda sorulmadıysa, özetin sonunda bir kez:

> "Dönem takviminiz ve haftalık ders programınız elinizde var mı? Bir kez
> verirseniz sınavdan önce soru hazırlığını, not girişinden önce
> değerlendirmeyi hatırlatırım."

- Evet → `divit-akademik:ders-takvimi` skill'ini yükle.
- Hayır ya da "sonra" → `.divit/profil/takvim.md`'ye yalnız şunu yaz ve bir
  daha sorma: `Durum: istenmedi (YYYY-AA-GG). Kullanıcı isterse "dönem takvimimi ekle" der.`
- Dosyada `Durum: istenmedi` satırı varsa hiç sorma.

`divit-akademik:ders-takvimi` yüklenemezse `kurallar`'daki "kurulumu bir kez
yenilemek" yoluna uy.

## Bitiş

`.divit/gunluk.md` sonuna tek satır: `… · takvim · gorevler.md · <ne yapıldı>`.
