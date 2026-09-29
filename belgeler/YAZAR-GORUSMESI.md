# Yazar görüşmesi — ilk buluşma

Akademisyen olmayan bir kitap yazarıyla ilk buluşma için. Konu: var olan
kitapların yeni baskı için düzenlenmesi ve elindeki yazı ve
konuşmalardan yeni kitap derlenmesi. Kişisel notlar bu dosyaya değil,
git dışı `hocalar/` klasörüne yazılır.

## 1. Açılış — üç cümle

> Divit kitabınızı bir editör gibi okur; yapıdaki, anlatımdaki ve
> bilgilerdeki sorunları yeriyle gösterir, her değişikliği önce size
> sorar. Kitabı sizin yerinize yazmaz, cümlelerinize ve sesinize
> dokunmaz, bilmediği bir bilgiyi uydurmaz; emin olmadığı yere işaret
> koyar. Asıl dosyanız hiç değişmez; yayın hakkı gibi hukuki konularda
> hüküm vermez, yalnız sorulacak soruyu gösterir.

## 2. Görüşme soruları

Yöntem (`IHTIYAC-ANALIZI.md` §0): "Yapay zekâdan ne beklersiniz" diye
sorma. Son kitabı ve geçen haftayı sor. Cevabı dinle, yorumlama, not al.
Sıra önemli değil; ilk üçü mutlaka sorulsun.

| # | Soru | Cevap şuysa | Divit'te |
|---|---|---|---|
| 1 | Son kitabınız nasıl yazıldı? Kendiniz mi, bir editörle mi, birinin yardımıyla mı? | Kendisi yazdı | `kitap-duzenle`: editör okuması; ses korunur, bu vurgulanır |
| | | Biri yazıya geçirdi (konuşarak) | `kitap-derle` daha yakın; ses kayıtları yazıya dökülmüş mü, sor |
| 2 | Yeni baskıda neyi değiştirmek istiyorsunuz, neden? | Rakamlar eskidi | `kitap-duzenle`, yeni baskı denetimi: `[GÜNCELLE]` |
| | | Kitap uzun geldi | `kitap-duzenle`, amaç "kısaltmak": çıkabilecek bölüm ve pasaj |
| | | Yeni bir okura seslenmek | `kitap-duzenle`, amaç "yeni okur": açıklama gereken yerler |
| | | Emin değil | Önce yapı raporu; karar rapordan sonra |
| 3 | Elinizde başka ne var? Köşe yazısı, konuşma kaydı ya da dökümü, sunum, röportaj? | Yazılar, dökümler | `kitap-derle`: envanter, konu haritası, kurgular |
| | | Yalnız ses ya da video kaydı | Divit bunu yapmaz; önce yazıya dökülmeli |
| | | Sunum dosyaları | PDF hâli istenir |
| 4 | Hangi programda yazıyorsunuz? Kitabın son hâli hangi dosyada? | Word | Divit okur; yeni Word ayrı dosya (`disa-aktar`) |
| | | Yalnız basılı kitap ya da PDF | PDF okunur; taranmışsa yavaş. Yayınevinden Word istensin |
| 5 | Yayınevindeki editörle süreç nasıldı? Kaç tur düzeltme oldu, en çok neye takıldınız? | Çok tur, hep aynı tür düzeltme | `kitap-duzenle` o aşamayı öne alır; yayınevine öneri listesi verilebilir |
| | | Editör sayfa düzeninde de çalıştı | Divit dizgi yapmaz; temiz metin ya da öneri listesi verir |
| 6 | Bu yazılar nerede yayımlandı? O sırada oranın maaşlı çalışanı mıydınız? Sözleşmede yazıların hakları geçiyor mu? | Maaşlı köşe yazarıydı | `kitap-derle` `[İZİN]` işaretler; "yayınevi ya da hukukçuyla netleştirin" |
| | | İzin yazısı gerekecek | `yazisma` taslağı hazırlar |
| 7 | Kitap işinde size en çok zaman yiyen adım hangisiydi? | Toparlamak, sıraya koymak | `kitap-derle` 1–4. adımlar |
| | | Tekrarları, çelişkileri bulmak | `kitap-duzenle` tutarlılık aşaması |
| | | Yazmak | Divit yerine yazmaz; boşlukları gösterir, yazan kendisi |
| 8 | Metin yayına gitmeden kimin onayından geçiyor? (yayınevi, şirket, aile, avukat) | Şirket ya da avukat | Hukuk notları raporda ayrı başlık; hüküm Divit'te değil |
| 9 | Kitaplarda şirketlerin iç bilgisi, gerçek kişiler, rakamlar var mı? Bunların bilgisayar dışına çıkması sorun olur mu? | Evet, gizli bilgi var | Bölüm 4'teki gizlilik notu açıkça söylenir; o bölümler denemede kullanılmaz |
| 10 | Hangi bilgisayarı kullanıyorsunuz, Windows mu Mac mi? Claude hesabınız var mı? | Hesap yok ya da ücretsiz | Kurulumdan önce Claude Pro gerekir (`KURULUM-REHBERI.md` Bölüm A) |
| | | Windows | Yazar kurulumu Windows'ta henüz denenmedi; ilk kurulum birlikte yapılır |

**Dinlenecek işaretler** (`IHTIYAC-ANALIZI.md` §3): itibar ("yanlış bir
rakam kitabımda çıkarsa…"), sahiplik ("benim cümlem gibi durmuyor"),
kayıp korkusu ("dosyam bozulur mu"). Hangisi önce gelirse onu not et.

## 3. Demo akışı (10 dakika)

Bilgisayarı yazara ver; isteği yazar kendisi yazsın, sonucu kendisi
okusun. Sen yalnız izle. Önce `belgeler/demo-yazar/` örnekleriyle
göster. Yazarın kendi metniyle deneme ancak **açıkça izin verirse**:
demoda metin senin Claude hesabından işlenir, bunu söyle.

**a) Kitap düzenleme (6 dk).** Yazar yazar: `kitabımı yeni baskı için
düzenle`. Divit iki soru sorar (neye bakılsın, yeni baskının amacı);
"5) hepsi" ve "1) güncellemek" seçilsin. Göster:
- Raporun sırası: önce yapı (söz verilen üç dersten biri yok), sonra
  anlatım, tutarlılık (1987/1989, 1996 hesabı), en son yazım.
- `[GÜNCELLE]` ("geçen yıl emekli olduğumda") ve `[DOĞRULA]` (Einstein
  sözü); rakip şirket sahibi hakkındaki ima için hukuk notu.
- Bir öneriyi önce → sonra → neden olarak açsın, onaylasın; asıl
  dosyanın değişmediğini, önceki sürümün saklandığını göster.

**b) Kitap derleme (4 dk).** Yazar yazar: `yazılarımdan kitap yapalım`.
Göster: altı satırlık envanter ve `[İZİN]` sütunu (iki gazete yazısı,
röportaj, konuşma kaydı), iki yazıda aynı anekdot, 2-3 içindekiler
kurgusu ve "bu bölüm için sizin anlatmanız gerekir" boşlukları.

Karşılaştırma: `belgeler/demo-yazar/beklenen-bulgular.md` (yazara
gösterme; yanında kâğıt olarak dursun).

### Demo hazırlığı (taslak)

Karar: demo yayınlamadan, Mehmet'in Mac'inde terminalden `claude
--plugin-dir` ile. Code sekmesi ve yayın bu buluşmada yok. Aşağıdaki
adımlar taslaktır; son hâlini entegrasyon parçası denenmiş komutlarla
yazar.

1. Eklenti kopyası repo dışında, bu işi içeren daldan (ör.
   `~/divit-demo-eklenti`). Yalnız `plugins/divit` yüklenir;
   `divit-akademik` **yüklenmez**.
2. Demo klasörü repo dışında (ör. `~/divit-demo-yazar`): klasör ayarı
   (`CLAUDE.md`, `.claude/settings.json` izinleri) yazar kurulumunun
   ürettiği gibi olmalı; en kısası kurulum betiğini sınama kipinde
   `DIVIT_TUR=yazar` ile bu klasöre çalıştırmak.
3. `.claude/settings.local.json` — yayındaki kopyalar kapalı:
   `{"enabledPlugins": {"divit@divit": false, "divit-akademik@divit": false}}`
4. `.divit/profil/kimlik.md`: ilk başlığın altında
   `Kullanıcı türü: yazar`, kurgusal bir ad. Profilin geri kalanı
   "Henüz doldurulmadı" kalırsa Divit kurulumla açılır; demodan önce
   bir kez dene.
5. Örnekler: `asil/ornek-bolum.docx` →
   `kitaplar/sahada-yonetmek/asil/`; `malzeme/*.md` →
   `kitaplar/dinlemek-uzerine/malzeme/`. `beklenen-bulgular.md`
   kopyalanmaz.
6. Word okuma için `DIVIT_PANDOC` tanımlı olmalı (kurulum yapar; elle:
   `export DIVIT_PANDOC="$(command -v pandoc)"`).
7. Başlat: demo klasöründe `claude --plugin-dir
   ~/divit-demo-eklenti/plugins/divit`. `/` yaz: akademik komut
   görünmemeli; `kitap-duzenle` ve `kitap-derle` görünmeli.
8. Menüde Mehmet'in kendi başka eklentilerinin komutları görünebilir;
   önlemi entegrasyon parçası buraya yazar.
9. Bir gün önce iki demoyu baştan sona bir kez çalıştır, sonucu
   `beklenen-bulgular.md` ile karşılaştır. Demo sonrası klasörü sıfırla.

## 4. Vaat edilmeyecekler ve riskler

**Söyleme:** "kitabınızı yazar", "daha çok satar", "yayınevi kabul
eder". **Yapmaz:** yerine yazmak; yayın hakkı hakkında hukuki görüş
(yalnız soru); ses ya da video kaydını yazıya dökmek; dizgi, sayfa
düzeni, kapak; Word'de değişiklik izleme (öneri listesi ya da yeni
dosya verir). Yeni Word dosyasında resim, dipnot ve sayfa düzeni asıl
dosyadaki gibi olmayabilir.

**Gizlilik.** Divit'in okuduğu metin işlenmek üzere Claude'a gider.
Şirketlerin gizli bilgisi, yayımlanmamış rakamlar, kişiler hakkındaki
özel bilgiler için yazar karar verir; bunu ilk denemeden önce söyle.

**Hesap.** Claude Pro (ya da üstü) hesabı gerekir; ücretsiz hesap
çalışmaz. Uzun kitapta kullanım sınırı dolabilir; Divit sınırı
göremez, iş bölüm bölüm ilerler ve kaldığı yerden devam eder.

**Menü.** Yazar klasöründe `/` menüsünde akademik komutlar görünmez:
akademik işler ayrı bir eklentidedir ve yazar klasöründe kapalıdır.
Demoda Mehmet'in Mac'inde başka eklentilerin komutları görünebilir
(bkz. Demo hazırlığı, 8).

## 5. Buluşma sonrası

1. Yazar isterse kurulum, **yayından sonra**, kendi bilgisayarında:
   - Mac: `curl -fsSL https://divit.simetri.app/kur.sh | DIVIT_TUR=yazar bash`
   - Windows: `$env:DIVIT_TUR='yazar'; irm https://divit.simetri.app/kur.ps1 | iex`
   Windows'ta yazar kurulumu henüz denenmedi; birlikte yapılsın.
2. Takip `PILOT.md` düzeninde: 3 gün sonra telefon, 1 hafta sonra kısa
   görüşme. Ölçü beğeni değil davranış: kendiliğinden açtı mı, rapordan
   neyi sildi, Word'e geri döndü mü.
3. Görüşme notları, yazarın adı, kitap adları, ücret ve konuşulanlar
   **repoya girmez**: git dışı `hocalar/` klasörüne.
4. Çıkan istekler `YAPILACAKLAR.md` "Kapsam"a, kişisel bilgi olmadan.
