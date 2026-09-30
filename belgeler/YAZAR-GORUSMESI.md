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

### Demo hazırlığı

Karar: demo yayınsız, Mehmet'in Mac'inde terminalden `claude
--plugin-dir` ile. Code sekmesi ve yayın bu buluşmada yok. Aşağıdaki
komutlar 2026-09-29'da birleşik dalda (`orc/yonetici-kitap-yazarlari-i/entegrasyon`)
denendi; kanıtı `belgeler/demo-yazar/prova/`.

**Önkoşullar:** Mac'te `claude` girişli, `pandoc` yolda (`which pandoc`),
birleşik dal GitHub'da. **Süre:** hazırlık 15 dk (pandoc inerken 2-3 dk
bekleme), kitap düzenleme yaklaşık 2 dk (iki soru + rapor), kitap derleme
yaklaşık 1,5 dk. Maliyet: bir koşu yaklaşık 0,6 $.

**Bir gün önce — hazırlık (Mehmet'in kendi terminalinde):**

1. Eklentinin kalıcı kopyası, repo ve iş klasörleri dışında (worktree
   temizliği bunu silmez):
   ```bash
   git -C ~/Simetri/Develop/divit fetch origin
   git -C ~/Simetri/Develop/divit worktree add ~/divit-demo-eklenti origin/orc/yonetici-kitap-yazarlari-i/entegrasyon
   ```
   Yalnız `~/divit-demo-eklenti/plugins/divit` yüklenir; `divit-akademik`
   **yüklenmez.**
2. Demo klasörü repo dışında, kurulum betiğinin sınama kipiyle (ayrı bir
   ev klasörü: masaüstüne kısayol konmaz, pandoc oraya iner):
   ```bash
   EV=~/divit-demo-ev; DEMO=~/Divit-Demo; EK=~/divit-demo-eklenti
   mkdir -p "$EV"
   git -C "$EK" archive --format=zip --prefix=divit/ HEAD -o "$EV/divit.zip"
   HOME="$EV" DIVIT_TEST=1 DIVIT_TUR=yazar DIVIT_KAYNAK_ZIP="$EV/divit.zip" DIVIT_HEDEF="$DEMO" bash "$EK/kur.sh"
   ```
   (Değişkenler şart: zsh'de `HOME=…` önekinden sonraki `~` yeni ev
   klasörüne açılır.)
   Beklenen: `Kullanıcı türü: yazar`, klasörde `KILAVUZ.html`
   (`data-rol="yazar"`), `.divit/kanal.txt`, `kitaplar/`; `tez-kontrol/` yok.
3. Örnek dosyalar (`beklenen-bulgular.md` kopyalanmaz):
   ```bash
   cd ~/Divit-Demo
   mkdir -p kitaplar/sahada-yonetmek/asil kitaplar/dinlemek-uzerine/malzeme
   cp ~/divit-demo-eklenti/belgeler/demo-yazar/asil/ornek-bolum.docx kitaplar/sahada-yonetmek/asil/
   cp ~/divit-demo-eklenti/belgeler/demo-yazar/malzeme/*.md kitaplar/dinlemek-uzerine/malzeme/
   ```
4. Profil — gerçek ad yok, tür satırı ve kurgusuz tek genel satır:
   ```bash
   printf '# Kim\nKullanıcı türü: yazar\n\nUzun yıllar sanayide yönetici olarak çalışmış, deneyimlerini kitaplaştıran bir yazar.\n' > .divit/profil/kimlik.md
   ```
5. Klasör ayarı: yayındaki kopyalar kapalı, eklenti kopyasını okuma izni
   (yoksa yazarın ekranında izin sorusu çıkar), demoda görülen iki kabuk
   sorusu önceden izinli:
   ```bash
   printf '{"enabledPlugins":{"divit@divit":false,"divit-akademik@divit":false},"permissions":{"allow":["Read(/%s/divit-demo-eklenti/plugins/**)","Bash(awk *)","Bash(wc *)"]}}\n' "$HOME" > .claude/settings.local.json
   ```
6. Başlatma komutu (her seferinde aynı; `--setting-sources project,local`
   Mehmet'in kendi eklentilerini — `engineering:`,
   `cowork-plugin-management:` — kişisel skill'lerini ve kullanıcı
   ayarlarındaki hook'ları bu oturumdan çıkarır; denendi):
   ```bash
   cd ~/Divit-Demo && claude --setting-sources project,local --plugin-dir ~/divit-demo-eklenti/plugins/divit
   ```
   İlk açılışta **klasör güven sorusu** çıkar → kabul et (etmezsen
   `.claude/settings.json` izinleri yok sayılır, Word okuma izin sorar).
   Sonra `/` yaz: `divit:kitap-duzenle` ve `divit:kitap-derle` görünmeli,
   `divit-akademik:` hiç görünmemeli. Kalan `/model`, `/config`,
   `dataviz`, `code-review` gibi satırlar Claude'un kendi komutlarıdır;
   Mehmet'e ait değildir. `/exit`.
7. Prova: 6'daki komutla aç, B ve A'daki iki isteği yaz, sonucu
   `beklenen-bulgular.md` ile karşılaştır. Sonra klasörü sıfırla:
   `rm -rf ~/Divit-Demo` ve 2-5'i yeniden çalıştır (güven sorusu bir
   kez daha çıkar; 6'yı da yinele).

**Demo günü:**

- Önce ekranı temizle: yalnız bir Terminal penceresi, tam ekran; öteki
  uygulamalar, tarayıcı sekmeleri ve masaüstü kapalı ya da gizli;
  bildirimler kapalı (Rahatsız Etme). Terminal'i **doğrudan demo
  klasöründe** aç (6. adımdaki komut `cd` ile başlar); ev klasöründe ya
  da repoda açma — repodaki geliştirici `CLAUDE.md`'si yüklenir.
- Karşılama ekranında hesap adı/e-postası görünür; sorun değilse geç,
  değilse komutu yazmadan önce ekranı çevirme.
- Divit raporu `.html` olarak da yazar ve iki dosyanın tam yolunu düz
  metin verir; yola tıklayınca Mac tarayıcıda açar. Tarayıcıda kişisel
  sekmeler açıksa önceden kapat.
- Yazarın kendi yazacağı iki istek:
  1. `kitabımı yeni baskı için düzenle` → Divit iki soru sorar: neye
     bakılsın (`5` hepsi) ve yeni baskının amacı (`1` güncellemek).
  2. `yazılarımdan kitap yapalım` → envanter ve içindekiler seçenekleri.
- Divit Word'ü `~/.divit/araclar/pandoc` ile okur (Mehmet'in Mac'inde
  var); izin sorusu beklenmez. Çıkarsa "Yes" de ve not al.
- İş bitince Divit "birkaç yazınızı paylaşır mısınız" diye üslup
  isteyebilir (profil boş olduğu için); geçmek yeterli.
- Demo sonrası: `rm -rf ~/Divit-Demo ~/divit-demo-ev`; eklenti kopyası
  için `git -C ~/Simetri/Develop/divit worktree remove ~/divit-demo-eklenti`.

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
