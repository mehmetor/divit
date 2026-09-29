---
name: kurulum
description: Divit'in sizi tanıdığı ilk kurulum. Hocayı tanır: özgeçmişi ister, alanı kendisi çıkarır, makalelerini bulur, alan kurallarını ve üslup profilini yazar, süren işleri öğrenip klasörleri hazırlar. Profil dosyaları "Henüz doldurulmadı" diyorsa, hoca ilk kez açtığında, "başlayalım", "beni tanı" dediğinde kullan. Kitap yazarını da tanır; "türümü değiştir", "ben hoca değilim", "üniversitedeyim" dendiğinde de kullan.
---

# İlk kurulum — Divit hocayı tanır

Kimse hocanın bilgilerini önceden hazırlamadı. Her şeyi **sen** toplarsın: özgeçmişten, hocanın yayımlanmış
makalelerinden ve hocanın cevaplarından. Hedef: hoca 15 dakika içinde ilk gerçek işini bitirmiş olsun.

## Kurallar

- Aynı anda tek soru. Liste hâlinde soru yığma.
- Teknik kelime yok. "Dosyayı bu pencereye sürükleyin" yeter.
- **Onaysız hiçbir şey profile girmez.** Çıkardığını göster, "doğru mu?" de.
- Bulamadığın bilgiyi tahmin etme; sor ya da boş bırak.
- Hoca yorulursa dur. Kaldığın yeri `gorevler.md` sonuna not et ("Kurulum: 3. adımda kaldı") ve bir sonraki oturumda oradan sür.
- **Hocanın "yok", "elimde yok", "istemiyorum" dediği her şeyi hemen
  `gorevler.md`'deki kurulum durumuna yaz** (ör. "Gesunde Pflanzen 2023 PDF'i:
  hocada yok"). O şeyi bir daha isteme; onsuz devam et.
- **Tür satırını koru:** `kimlik.md`'yi baştan yazarken `Kullanıcı türü:` satırını aynen yaz.

## 0. Tür

`.divit/profil/kimlik.md`'de ilk başlığın altındaki `Kullanıcı türü:` satırına bak; satır varsa türü **sorma**.
`yazar` → `${CLAUDE_PLUGIN_ROOT}/skills/kurulum/yazar.md`'yi Read ile yükle, 1-8 yerine onu izle.
Satır yok ya da `akademisyen` → aşağıdaki akış aynen. Satır yoksa ve 1. adımdaki özgeçmişte
ya da cevapta üniversite unvanı yoksa ya da kullanıcı "hoca değilim", "kitap yazıyorum" derse, tek soru:
> "Divit'le daha çok hangi işleri yapacaksınız? 1) Üniversite işleri: öğrenci, ders, makale, proje 2) Kitap ve yazı işleri: kitaplarınız, yazılarınız, yayınevi — numarayı yazmanız yeterli, sonra değiştirebilirsiniz."

2 → `yazar.md`'ye geç, gelen özgeçmişi onun 1. adımında kullan. Unvanı olan kitap yazarı
`akademisyen` kalır. Tür kesinleşince satırı `kimlik.md`'de ilk başlığın hemen altına yaz.

## 1. Tanışma ve özgeçmiş

Kendini üç cümleyle tanıt: ne yaparsın, ne yapmazsın (not vermem, sizin
yerinize yazmam, kaynaklarınızda olmayan atıf üretmem).

Sonra iste:
> "Özgeçmişinizi bu pencereye sürükler misiniz? PDF ya da Word olabilir.
> Elinizde yoksa AVESİS ya da YÖK Akademik sayfanızın adresi de yeter."

- Dosya gelirse oku (PDF → Read; Word → `CLAUDE.md`'deki pandoc yolu).
- Adres gelirse WebFetch ile oku. Yalnız ad gelirse WebSearch ile
  "<ad> AVESİS" ara; bulduğun sayfayı hocaya gösterip "bu siz misiniz?" diye sor.

Özgeçmişten çıkar: unvan, bölüm, üniversite, alan ve alt alanlar, çalışma konuları, yayın dilleri (oranıyla),
sık gönderdiği dergiler, danışmanlıklar, projeler, idari görevler, jüri/komisyon görevleri.

`kimlik.md`'yi yaz (tür satırıyla), **hocaya göster, onaylat.** Jüri, hakemlik ya da komisyon görevi
varsa şunu da söyle: "Bu dosyaları bana vermeyin; başkasının gizli belgeleri."

## 2. Alanı belirle

Özgeçmişten alanı **sen** çıkar ve öner:
> "Çalışmalarınız ağırlıklı olarak bahçe bitkileri — sebze yetiştiriciliği
> ve hasat sonrası. Bir de kadın çalışmaları alanında yazıyorsunuz. Doğru mu?"

**Birden fazla kimlik olabilir** (ör. ziraat deneme makaleleri + sosyal
bilim metinleri). Her birini ayrı ele al; kuralları karıştırma.

## 3. Makaleleri bul

Üslup ve alan kuralları için hocanın **ilk yazar olduğu** 2-3 yakın tarihli makalesi gerekir. Çok
yazarlı makalelerde metni çoğu zaman ilk yazar (öğrenci) yazar; o metin hocanın üslubunu vermez.

1. Önce kendin bul: özgeçmişteki makale başlıklarını DergiPark'ta ya da
   Crossref'te (`api.crossref.org/works?query.bibliographic=...`) ara.
   Açık erişimli olanların PDF'ini `kaynaklar/hoca-makaleleri/` altına indir.
   **Her dosya için ayrı ve tek bir komut kullan; komutları `;` ya da `&&`
   ile zincirleme.** Zincirlenmiş komut ön izinle eşleşmez ve hocaya
   İngilizce izin sorusu çıkar. Klasör, dosya indirilirken yoksa önce ayrı
   bir komutla oluşturulur.
   - Windows: `Invoke-WebRequest -Uri "<adres>" -OutFile "kaynaklar/hoca-makaleleri/<ad>.pdf"`
   - Mac: `curl -fsSL -o "kaynaklar/hoca-makaleleri/<ad>.pdf" "<adres>"`
2. Bulamadığın ya da erişimi kapalı olanlar için hocadan iste:
   "Şu iki makalenizin PDF'i elinizde var mı?"
3. Her kimlik için en az bir metin hedefle.

## 4. Alan kurallarını yaz

`${CLAUDE_PLUGIN_ROOT}/alan/` klasörüne bak. Hocanın alanına uyan hazır bir kılavuz varsa (ör.
`ziraat.md`) başlangıç olarak kullan, hocanın alt alanına göre daralt.

Uyan kılavuz yoksa **kendin yaz.** Yapı olarak `${CLAUDE_PLUGIN_ROOT}/alan/ORNEK-SABLON.md`
dosyasını izle. İçeriği hafızadan değil, 3. adımda okuduğun makalelerden çıkar:

- Terimler: hocanın kullandığı Türkçe karşılıklar (Çizelge mi Tablo mu?)
- Sayı ve birim tuzakları: bu alanda hangi birimler karışır, dönüşüm formülü
- Adlandırma: Latince adlar, kimyasal adlar, hukuk atıf biçimi, arşiv künyesi…
- Yöntem bölümünde bulunması zorunlu olanlar
- Kanıt denetimi: çizelge-metin, test-bulgu tutarlılığı
- Yayın alışkanlıkları: bölüm düzeni, atıf stili, dergiler
- Makale dışı yazım yükü: projeler, raporlar
- **Divit'in bu alandaki sınırı** — mutlaka yaz

Sonra hocaya 3-5 kısa soruyla doğrulat. Örnek:
> "Makalelerinizde tablolara 'Çizelge' diyorsunuz; öğrencilerinizden de
> bunu mu bekliyorsunuz?"

Hocanın cevabı yazdığını ezer. Sonucu `alan.md`'ye yaz. Birden fazla kimlik varsa her biri ayrı başlık olsun.

## 5. Üslup profili

Aynı makalelerden `uslup.md`'yi çıkar: cümle uzunluğu, şahıs, sık kalıplar, atıf biçimi, terim + parantez
İngilizce alışkanlığı, İngilizce metinlerde tekrar eden yapılar. En sona bir **"Koru / İşaretle"** tablosu
koy: hocanın bilerek seçtiği üslup ile gerçek hatayı ayır. Hocaya kısa bir özet göster.

## 6. Süren işler ve klasörler

Üç soru sor, tek tek:
1. "Şu an danışmanlığını yaptığınız öğrenciler var mı?"
2. "Yürüyen projelerinizde yaklaşan bir rapor tarihi var mı?"
3. "Yayına hazırladığınız bir metin var mı?"

Cevaplara göre `gorevler.md`'yi yaz: iş, kişi (öğrenci için baş harfler), tarih, durum. Gerekirse
klasör öner, onay alınca oluştur: `tez-kontrol/gelen/<baş harfler>/`, `yazilar/<makale-adı>/`,
`yazilar/proje-<ad>/`. Hoca kitap yazdığını söylerse tür değişmez; onayla `kitaplar/<kitap-adi>/asil/` aç
(ad küçük harf, Türkçe karaktersiz, tireli): Mac `mkdir -p "kitaplar/<kitap-adi>/asil"` · Windows
`New-Item -ItemType Directory -Force "kitaplar/<kitap-adi>/asil"`.

## 7. Güvence ve ilk iş

Kapanışta tek paragraf:
> "Öğrenci dosyalarınıza yazmam, yalnızca okurum. Word dosyalarınızı hiç
> değiştirmem; değişikliği yeni bir dosyaya yazarım. Kaynaklarınızda
> olmayan bir kaynağa atıf yapmam, emin olmadığım yere işaret koyarım.
> Bir şey ters giderse 'geri al' demeniz yeter."

Güvenceden önce `saglik` skill'ini sessizce çalıştır. Sorun çıkarsa hocaya yalnız o tek adımı söyle.

Sonra gerçek bir işe geç: `gorevler.md`'de en yakın tarihli iş hangisiyse onu öner (ör. tez için
`divit-akademik:tez-kontrol`). Hiç iş yoksa `yardim` skill'inin özetini göster.

## 8. Geri bildirim (isteğe bağlı)

Hocaya sor:
> "Yazdığım alan kurallarını, adınız olmadan, Divit'i geliştiren kişiyle
> paylaşmama izin verir misiniz? Aynı alandaki başka hocalara yardımcı olur."

İzin verirse kılavuzu **kişisel bilgileri çıkararak** `.divit/paylasim/alan-<alan>.md` olarak
kaydet. İzin yoksa hiçbir şey kaydetme. Kendin göndermeye çalışma; yalnızca kaydet.

## Tür değiştirme

"Türümü değiştir", "ben hoca değilim", "üniversitedeyim" denirse (`kurallar` buraya yollar)
`${CLAUDE_PLUGIN_ROOT}/skills/kurulum/tur.md`'yi Read ile yükle ve izle.
