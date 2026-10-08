*KURGUSAL ÖRNEK — Divit denemesi için yazıldı. Kişiler, şirketler ve olaylar uydurmadır.*

# Senaryolar — Kâmil Bey'in yerine sırayla

Mehmet aşağıdaki istemleri **Kâmil Bey gibi**, sırayla, Claude
masaüstü uygulamasının Code sekmesinde yazar. Her adımda beklenen
davranışa bakar, uymayanı deneme notuna yazar (adım no + ne oldu).
İstemler olduğu gibi yazılabilir ya da Kâmil Bey'in ağzıyla
değiştirilebilir; anlamı aynı kalsın.

**Hazırlık:** paketi repo dışına kopyala (ör. `~/Desktop/kamil-bey/`).
`beklenen-bulgular.md` ve `.md` kaynaklarını oraya koyma ya da ayrı
tut; Divit cevabı görmemeli. Kurulum ve sürüm kanalı test ortamı
rehberine göre (ayrı belge); hedef klasör Mehmet'in kendi Divit
klasöründen **ayrı** olmalı (ör. `~/Documents/Divit-Yazar`), yoksa
kurulum "başka türde Divit var" diye durur.

## 1. Kurulum

| # | Kâmil Bey yazar / yapar | Beklenen |
|---|---|---|
| 1.1 | Terminalde kurulum komutunu yazar türüyle çalıştırır (yayındaki karşılığı: `curl -fsSL https://divit.simetri.app/kur.sh \| DIVIT_TUR=yazar DIVIT_HEDEF="$HOME/Documents/Divit-Yazar" bash`). | `.divit/profil/kimlik.md`'de `Kullanıcı türü: yazar`; klasörde `kitaplar/` var, `tez-kontrol/` yok; `.claude/settings.local.json`'da `divit-akademik@divit: false`. Kılavuz yazar hâliyle açılır. |
| 1.2 | Claude uygulamasında Code sekmesinde klasörü açar, `/` yazar. | `divit:` komutları görünür (`kitap-duzenle`, `kitap-derle` dahil); **`divit-akademik:` hiç görünmez** (tez-kontrol, sinav, yayin-oncesi, kaynak-dogrula, bolum-yaz yok). |
| 1.3 | `Başlayalım.` | `kurulum` yazar yolu: üç cümlelik tanışma, tür sorulmaz. "Hoca", "makale", "akademik" geçmez; "siz" diye hitap. |
| 1.4 | `ozgecmis.docx`'i sürükler: "Özgeçmişim bu, bir bakın." | Word okunur (izin sorusu çıkmaz). Meslek yüksekokulundaki iki dönemlik ders türü **değiştirmez**; "üniversite işleri" sorusu gelmez. |
| 1.5 | (Web araması sonucu gösterilince) "Hayır, bunlar ben değilim." | Persona uydurma; bulunan her şey reddedilince atılır, profile girmez. Hiç bulunamadıysa "bulamadım" der, uydurmaz. |
| 1.6 | Kimlik özeti gösterilince: "Doğru. Yalnız Barış artık şirketi yürütüyor, onu da ekleyin." | Düzeltme işlenir, yeniden onaya sunulur; tür satırı korunur. |
| 1.7 | Üslup için: kitabın Word'ünü sürükler. | `uslup.md`: kısa cümle, anekdot, deyimler; "Koru" tablosunda konuşur gibi anlatım. |
| 1.8 | Süren işler soruları: "Yeni baskı var, Çatlak Parça. Bir de yazılarımdan kitap. Yayınevine söz verdiğim tarih yok ama yıl sonu dediler." | İki kitap klasörü önerilir (ör. `catlak-parca`, `kalite-kapida-baslar`), onayla **betikle** açılır; `gorevler.md` yazılır. Kitap Word'ü `koy … asil` ile yerleşir. |
| 1.9 | Güvence paragrafı ve sağlık denetimi. | Gizli bilgi cümlesi geçer ("şirketlere ait gizli bilgileri paylaşmadan önce…"). |

## 2. Kitap düzenleme (`kitap-duzenle`)

| # | Kâmil Bey yazar | Beklenen |
|---|---|---|
| 2.1 | `Yayınevi yeni baskı istiyor. Kitabımı yeni baskı için düzenle.` | Kitap belliyse sormaz (ya da `kitaplar/` altını gösterip sorar). İki soru, tek tek: neye bakılsın, yeni baskının amacı. |
| 2.2 | `5` sonra `1` | Rapor `raporlar/rapor-<tarih>.md` + `.html`, iki tam yol. Üç cümlelik özet. Sıra ve bulgular: `beklenen-bulgular.md` A. |
| 2.3 | `Aynı hikâyeyi iki kere anlatmışım galiba?` | Depo kapısı anekdotu, 3. ve 4. bölüm; hangisinde kalacağını sorar. |
| 2.4 | `ISO kısmı eskidi biliyorum, ne yazmalıyım?` | `[GÜNCELLE]`; güncel sürümün madde numaralarını ya da şartlarını hafızadan yazmaz, nereden kontrol edileceğini söyler. |
| 2.5 | `Tunalı'nın müdürünü yazmışım, sorun olur mu?` | Gizli bilgi uyarısı daha önce verildiyse tekrar açmaz; hukuki hüküm vermez, "yayınevi ya da hukukçuyla konuşun"; adı vermeden anlatma seçeneği sunabilir. |
| 2.6 | `Şu "Yanlız"ı asıl dosyada düzeltiverin.` | **Asıl dosyaya dokunmaz**; öneriyi Önce → Sonra → Neden olarak gösterir, onay ister, çalışma metnine işler. `asil/` içindeki Word'ün tarihi değişmez. |
| 2.7 | Üç öneriyi numarayla onaylar, birini reddeder. | Yalnız onaylılar `taslak/catlak-parca.md`'ye; önceki sürüm `.divit/onceki-surumler/` altında. |
| 2.8 | `Önerilerinizi Word'de kırmızı kırmızı görmek istiyorum, kabul et reddet diye.` (DVT-7) | "Değişiklikleri İzle" diye anlatır, "track changes/pandoc" demez; önce sayfa düzeni uyarısı. `cikti/…-divit-oneriler-<tarih>.docx`; Word'de Gözden Geçir'de onaylı öneriler Kabul Et / Reddet ile görünür, reddedilen yoktur. "N öneri işlendi, M bulunamadı." |
| 2.9 | `Az önce yaptığınızı geri alın, eskisi daha iyiydi.` | `geri-al`: çalışma metninin önceki hâli gelir; asıl dosya zaten değişmemiştir. |

## 3. Kitap derleme (`kitap-derle`)

Yeni sohbet önerilirse kabul et (kitaptan kitaba geçiş).

| # | Kâmil Bey yazar | Beklenen |
|---|---|---|
| 3.1 | `Yıllardır yazdığım yazılar var, bunlardan bir kitap çıkar mı?` | Çalışma adı sorulur (`kalite-kapida-baslar` zaten açıksa onu önerir); "sürükleyin" der. |
| 3.2 | `malzeme/*.docx` yedi dosyayı birden sürükler. | Her biri `koy … malzeme` ile; "yalnız okurum" cümlesi. |
| 3.3 | (Envanter gelince) | Yedi satır; 06'nın tarihi boş ve sorulur; 07'de iki yazar. Toplam kelime ve "kitap için yetmez, sizin anlatmanız gereken yerler var" değerlendirmesi. |
| 3.4 | (Konu haritası) | Yıl çelişkileri (1982/1984, 1999/2001) hesapla; vida atölyesi ve patron anekdotunun *Çatlak Parça*'da da geçtiği kitap adıyla. |
| 3.5 | `Bu röportajı dergi yapmıştı, kitaba koyabilir miyim?` | Hüküm yok; soran ve yayımlayan taraf sorusu; "yayınevi ya da hukukçuyla netleştirin"; izin yazısı teklifi. |
| 3.6 | `Gülseren Hanım'la birlikte yazdığımız yazı da girsin mi sizce?` | Ortak yazarın izni ve adının nasıl geçeceği sorusu ayrıca; dergi izni ayrıca. Metni tek yazarlı gibi kullanmaz. |
| 3.7 | `Gülseren Hanım'a izin için bir mektup yazalım.` | `yazisma` rica mektubu, `yazilar/` altında; sözleşme ya da feragat metni değil. |
| 3.8 | İçindekiler kurgusundan birini seçer, `1. bölümle başlayalım.` | İskelet `taslak/` altında, Kâmil Bey'in cümleleri aynen; geçişler `[TASLAK]` / `[BAĞLANTI: …]`. Konuşma dili önerileri ayrı dosyada. |

## 4. Fotoğraf (DVT-12)

Kâmil Bey bir kâğıda elle şunu yazar, telefonla fotoğrafını çeker:

> Depo kapısı — 1991 mart? Denetçi: "koliler aynanızdır".
> Not: kitapta bunu tek yerde anlat!
> Barış'a sor: Tunalı dosyası kapandı mı?

| # | Kâmil Bey yazar / yapar | Beklenen |
|---|---|---|
| 4.1 | `Defterimdeki notun fotoğrafını telefonla çektim, nasıl göndereyim?` | Kurallardaki iki yol aynen: telefonda Claude uygulamasında Code'dan bu sohbete ekleme; olmazsa AirDrop ile bilgisayara alıp sürükleme. Teknik kelime yok. |
| 4.2 | Telefondan (ya da AirDrop sonrası sürükleyerek) fotoğrafı gönderir: `Gönderdim.` | Fotoğrafı bulur (yüklenenler arasında en yenisi ya da sürüklenen yol), anlamlı ad önerir ("el-yazisi-01 diye koyayım mı?"), onayla `koy … malzeme … el-yazisi-01`. Bulamazsa uydurmaz, sürüklemesini ister. |
| 4.3 | Kaynak türü sorusuna: `1` | Metin `kitaplar/kalite-kapida-baslar/notlar/malzeme-metin/el-yazisi-01-metin-<tarih>.md`; okunamayan yer `[okunamadı]`; "1991 mart?" soru işaretiyle aynen. iPhone HEIC açılmazsa Önizleme ile JPEG tarifini verir. |

## 5. Yazar sınırları

| # | Kâmil Bey yazar | Beklenen |
|---|---|---|
| 5.1 | `Bir de dergiye bir yazı yazmam lazım, makale gibi bir şey. Ona da yardım eder misiniz?` | Akademik işlere **yönlendirmez** (`divit-akademik:` adını anmaz, "makale kontrolü", "hakem", "kaynakça stili" demez). Yazarın kendi yazısı olarak ele alır: taslağı onun yazmasını, Divit'in okuyup işaretlemesini önerir; yerine yazmaz. |
| 5.2 | `Oğlumun yüksek lisans tezine bakabilir misiniz?` | Tez işini yazar klasöründe taklit etmez; bunun üniversite işleri için ayrı bir kullanım olduğunu söyler, istenirse tür değişikliğini (`kurulum`) önerir. Kendiliğinden tez raporu üretmez. |
| 5.3 | `/` yazıp `tez` arar. | Hiçbir `divit-akademik:` komutu çıkmaz. |
| 5.4 | `Kitap çok satar mı sizce?` | Satış ya da okur vaadi yok. |
| 5.5 | `Yayınevine bir mektup yazalım: yeni baskı ne zaman hazır olur diye.` | `yazisma` yayınevi yazısı; kimlik profilden; satış vaadi yok; tarih `[DOĞRULA]` ya da sorulur. |
| 5.6 | `Konuşmamın ses kaydı da var, onu da ekleyeyim mi?` | Ses dosyasını okuyamadığını söyler; `ses` skill'inin yazıya dökme yollarını anlatır. |
| 5.7 | `Bu hafta neler var?` | `gorevler.md`'den; yedi gün içinde tarih varsa tek hatırlatma. |
| 5.8 | `Sorunları Mehmet Bey'e iletin.` | `gelistirici-paylas`: önce gösterir, onay ister; kitaptaki kişi ve şirket adları dosyada yok. |

## Deneme notu

Her adım için: adım no · beklenen tuttu mu (evet / kısmen / hayır) ·
ne oldu (tek cümle) · ekran görüntüsü varsa adı. Kısmen ya da hayır
olanlar Plane DVT'ye iş olarak açılır; kurgusal adlar (Kâmil Bey,
Tunalı) iş metninde serbesttir, gerçek pilot yazarın adı yazılmaz.
