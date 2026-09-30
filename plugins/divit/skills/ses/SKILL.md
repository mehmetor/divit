---
name: ses
description: Ses kaydını yazıya döker — kaydı Word, Mac ya da telefonla metne çevirmenin yolunu adım adım anlatır, çıkan dağınık metni konuşmacılarıyla temiz bir nota çevirir. Kullanıcı "ses kaydını yazıya dök", "röportajı yazıya geçir", "ders kaydım var", "görüşmeyi deşifre et", "sesli notumu metne çevir", "anılarımı kaydettim" dediğinde ya da yazıya dökülmüş bir konuşma metni yapıştırdığında kullan.
---

# Ses — kayıttan temiz metne

**Önce:** `divit:kurallar` bu oturumda yüklenmediyse şimdi Skill aracıyla yükle;
her komut oradaki kabuk kuralına uyar. Hitap rol dosyasına göre.

## Yasaklar

- **Ses dosyasını okumaya çalışma.** Read sesi okuyamaz. Python, Whisper, ffmpeg
  ya da başka program kurdurma, önerme.
- **Uydurma yok.** Duyulmayan, kesik ya da belirsiz yeri tahminle doldurma:
  `[anlaşılmadı]` yaz. Emin olmadığın ad, sayı, yer için `[DOĞRULA]`.
- Söylenmeyen cümle ekleme, söyleneni özetleyip yerine koyma, sırasını değiştirme.
- Konuşmacının adını metin söylemiyorsa uydurma: `Konuşmacı 1`, `Konuşmacı 2`. Kim olduğunu cevapta da tahmin etme; sor.
- Akademisyende öğrenci ya da görüşülen kişi adını dosya adına yazma; baş harf.
- Yazar türünde akademik kelime kullanma (öğrenci, tez, ders, makale).

## 1. Kayıt henüz yazıya dökülmediyse

Tek soru sor: "Bilgisayarınızda Word var mı, Microsoft 365 aboneliğiyle mi?
1) Evet, Word 365 var 2) Word yok ya da eski 3) Bilmiyorum". Mac mi Windows mu
biliniyorsa sorma; bilinmiyorsa aynı soruya ekle.

Cevaptan önce bir kez söyle: "Kayıtta konuşan herkesin yazıya dökülmesine onay
vermiş olması gerekir. Word yolu kaydı Microsoft'un sunucusuna gönderir."

**Word 365 (Windows ya da Mac, en kolay yol):**
1. Tarayıcıda office.com'a girin, hesabınızla oturum açın, yeni boş Word belgesi açın.
2. Üstte **Giriş** sekmesinde mikrofon düğmesinin (**Dikte**) yanındaki oka basın,
   **Transkribe et**'i seçin.
3. Sağda açılan bölmede dili **Türkçe** yapın, **Ses yükle**'ye basıp kaydı seçin
   (mp3, m4a, wav ya da mp4).
4. Bitince **Belgeye ekle → Konuşmacılarla** seçin.
5. Metnin tamamını seçip kopyalayın (Ctrl+A, Ctrl+C; Mac'te Cmd+A, Cmd+C) ve buraya
   yapıştırın. Ya da belgeyi kaydedip bu klasöre koyun.
Menüde bu adları bulamazsanız ne gördüğünüzü yazın, birlikte bakalım.

**Word yok, kayıt iPhone'da ya da Mac'te:**
1. Kaydı **Sesli Notlar** uygulamasında açın; kaydın altındaki ya da üç nokta
   menüsündeki **Transkript**'i (konuşma balonu simgesi) açın.
2. Metni kopyalayıp buraya yapıştırın.
Transkript Türkçe çıkmıyorsa ya da düğme yoksa cihazınızda bu dil henüz
açılmamış olabilir; söyleyin.

**Word yok, Android telefon:** telefonun kendi ses kaydedicisinde "metne çevir" ya
da "transkript" düğmesi varsa onu kullanın, metni kendinize e-postayla gönderip buraya
yapıştırın. Yoksa söyleyin.

Hiçbir yol yoksa açıkça söyle: "Bu bilgisayarda kaydı yazıya dökecek hazır bir
araç yok. Word 365 olan bir bilgisayardan ya da telefondan dökülmüş metni
getirirseniz gerisini ben yaparım." Günlüğe yarım iş olarak yaz.

## 2. Dökülmüş metin gelince

1. Metin yapıştırıldıysa doğrudan kullan; dosyaysa (docx, txt) `kurallar`'daki
   tabloyla oku. Kaydın ne olduğunu bilmiyorsan tek soru: "Bu kayıt ne? Kısa bir
   ad verir misiniz (ör. `ali-bey-roportaj`, `3-hafta-ders`)?" Kitap klasörü
   birden çoksa hangi kitap olduğunu da aynı soruya ekle.
2. Yer:
   - Yazar: `kitaplar/<kitap>/notlar/ses-metin/<ad>-YYYY-AA-GG.md`
   - Akademisyen: `notlar/ses-metin/<ad>-YYYY-AA-GG.md` (görüşmede ad yerine baş harf)
   Klasör yoksa `mkdir` ile aç. Aynı ad varsa `-s2`.
3. Temizle (**"ağızdan çıktığı gibi" sürümü**):
   - Konuşmacı etiketlerini birleştir: araç "Konuşmacı 1", "Speaker 2", "K1" gibi
     karışık verdiyse tek biçime getir: `**Konuşmacı 1:**`. Metinde ad açıkça
     geçiyorsa ("Ben Ali, …") kullanıcıya sorup adı yaz.
   - Aynı konuşmacının art arda bölünmüş satırlarını tek paragrafta topla.
   - Zaman damgalarını kaldır; yalnız her 5 dakikada bir `[dk 05]` gibi bırak.
   - Aracın yazdığı anlamsız tekrar, bozuk harf ya da yabancı kelimeye dönmüş yeri
     `[anlaşılmadı]` yap; tahmin edebiliyorsan `[anlaşılmadı: "…" olabilir]`.
   - Dolgu sözcükleri (ıı, şey, yani) ve devrik cümleler **olduğu gibi kalır.**
4. Dosyanın başına şunu yaz:

   ```
   # <ad>
   Kayıt: <tarih biliniyorsa, yoksa —> · Konuşanlar: <etiketler> · Kaynak: <Word Transkribe / Sesli Notlar / …>
   Sürüm: ağızdan çıktığı gibi. [anlaşılmadı] yerleri kayda dönülerek doldurulmalı.
   ```

5. Sonra sor: "Okunması kolay, düzeltilmiş bir sürüm de ister misiniz? Dolgu
   sözcüklerini çıkarır, noktalamayı düzeltirim; anlamı ve sözcük seçimini
   değiştirmem." Evet derse aynı klasöre `<ad>-duzeltilmis-YYYY-AA-GG.md`:
   - Dolgu, kekeleme, yarım kalıp yeniden başlanan cümleyi çıkar; noktalama ve
     büyük harf düzelt; yazım hatasını düzelt.
   - Yerel ağız, deyim, konuşanın kendi sözcüğü kalır (anı ve röportajda ses budur).
   - `[anlaşılmadı]` ve `[DOĞRULA]` işaretleri aynen kalır.
   - Başlıkta `Sürüm: düzeltilmiş (asıl: <dosya adı>)`.
6. Kullanıcıya kısa bildir: dosya yolu (tam), kaç konuşmacı, kaç `[anlaşılmadı]`
   yeri. Hoca Word isterse `kurallar`'daki Word çıktısı komutu.

## 3. Sonrası

- Yazar: "Bu metinden bölüme malzeme çıkarmak isterseniz söyleyin" de; kendiliğinden
  bölüm yazma.
- Akademisyen: ders kaydıysa "ders notuna ya da sınav sorusuna çevirmek" önerilebilir;
  görüşmeyse yalnız metin kalır, değerlendirme yazma.
- Günlüğe tek satır: `YYYY-AA-GG SS:DD · ses · <dosya> · <kaç konuşmacı, kaç [anlaşılmadı]>`.
