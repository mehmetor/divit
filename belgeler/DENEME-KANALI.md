# Deneme kanalı — main'e yayın yapmadan gerçek kurulum

Yeni bir işi hocalara göndermeden önce, hocanın yapacağı kurulumun
aynısını denemek için. Fark tek: her şey GitHub'daki `deneme` dalından
iner (kurulum betiği, klasör şablonu, pazar yeri, eklenti zip'leri).
main'e, develop'a ve hocalara hiçbir şey gitmez.

`[Mehmet elle]` işaretli adımlar ekran ya da hesap işidir; geri kalan
her Terminal komutu yalıtılmış bir ortamda denendi.

## 0. Deneme dalını yayımla (geliştirme makinesinde)

1. Denenecek dalda, temiz çalışma ağacıyla:

   ```bash
   ./yayinla.sh --kanal deneme
   ```

   **Beklenen:** `Gönderildi: deneme → <commit> …`, iki eklentinin
   sürümü (zip özetinin ilk 12 hanesi) ve Mac/Windows kurulum komutları.
   Değişiklik yoksa `Kanal dalı 'deneme' zaten güncel`. Bulunduğunuz dal
   ve `SURUM.md` değişmez.
2. GitHub ham adresleri ~5 dakika önbellekte kalır. Şu komut az önce
   basılan sürümü gösterene kadar bekleyin:

   ```bash
   curl -fsSL https://raw.githubusercontent.com/mehmetor/divit/deneme/.claude-plugin/marketplace.json | grep '"url"'
   ```

   **Beklenen:** iki satır, ikisi de `/deneme/dagitim/…-<sürüm>.zip`.

`main` ve `develop` reddedilir; izinli kanallar `deneme`, `deneme-*` ve
`yeni` (gerçek kullanıcıya giden ayrı kanal: `belgeler/YENI-KURULUM.md`).
Eski yazım `--deneme deneme` aynı işi yapar.
Farklı denemeler yan yana gerekirse `deneme-yazar` gibi bir ad
verin; komutlarda `deneme` yerine o ad yazılır.

### Kanal klasörde kalır

Kurulum betiği kanalı (dal adını) klasörde `.divit/kanal.txt`'ye yazar.
Öncelik: `DIVIT_DAL` > var olan `.divit/kanal.txt` > `main`. İzinli adlar
`main`, `yeni`, `deneme`, `deneme-*`; başka bir ad uyarıyla `main` olur.
Bu yüzden:

- `DIVIT_DAL` yalnız ilk kurulumda gerekir; aynı klasörde yeniden kurulum
  (ve kanalı okuyan `guncelleme` skill'i) aynı kanalda kalır. Çıktıda
  `Kanal: deneme` ve en sonda `Deneme kanalı: deneme` satırı görünür.
- Klasörü main'e geri almak için `DIVIT_DAL=main` **açıkça** verilir.
- Klasör ayarındaki pazar yeri adresi de kanalın adresidir.
- main'deki hocanın klasöründe `kanal.txt` = `main`; hiçbir şey değişmez.

## 1. Neden ayrı macOS kullanıcısı

Deneme kurulumu `divit` pazar yerini deneme dalına bağlar. Kendi
hesabınızda `divit` pazar yeri başka adresle (ör. main) kayıtlıysa
kurulum betiği bunu görür, "Kurulum bitti" **demez**, "Divit bu
bilgisayarda başka bir kaynaktan kurulu" der ve 0 dışı kodla biter.
Kendi hesabınızda denemek isterseniz önce
`claude plugin marketplace remove divit` çalıştırın (kurulu Divit
eklentileri de kalkar; klasörlere dokunmaz), sonra kurulumu yapın. Bu
sizin Divit'inizi de deneme kanalına taşır.

Ayrıca `Belgeler/Divit` başka bir türle kurulmuş dolu bir profil
taşıyorsa (ör. eski bir hoca kopyası) `DIVIT_TUR` ile kurulum durur ve
yeni klasör için tam komutu verir (`DIVIT_HEDEF=...`); o klasöre ve
profile dokunmaz.

Ayrı bir macOS kullanıcısının kendi `~/.claude`'u, kendi anahtar zinciri
ve boş Belgeler'i vardır: hocanın yeni bilgisayarı gibidir. Temiz deneme
için bu yol önerilir.

1. `[Mehmet elle]` Sistem Ayarları → Kullanıcılar ve Gruplar → Kullanıcı
   Ekle. Ad: **Divit Deneme**, tür: Standart. Yönetici parolası bir kez
   sorulur.
   **Beklenen:** Yeni kullanıcı listede.
2. `[Mehmet elle]` Elma menüsü → Oturumu Kapat ya da hızlı kullanıcı
   geçişiyle "Divit Deneme"ye geçin, ilk açılış sorularını geçin.
   **Beklenen:** Boş bir masaüstü.

## 2. Yazar kurulumu (Divit Deneme hesabında)

1. Terminal'i açın, yapıştırın (DIVIT_TEST **yok**: Claude uygulaması ve
   komut satırı gerçekten kurulur):

   ```bash
   curl -fsSL https://raw.githubusercontent.com/mehmetor/divit/deneme/kur.sh | DIVIT_DAL=deneme DIVIT_TUR=yazar bash
   ```

   **Beklenen:** 6 adım, `Kullanıcı türü: yazar`, `Kanal: deneme`,
   `Oluşturuldu: …/Documents/Divit`, `Kurulu ve güncel (sürüm <deneme
   sürümü>)`, "Kurulum bitti.", 3. adımda `Belgeler → Divit`, en sonda
   `Deneme kanalı: deneme`. Kılavuz (`KILAVUZ.html`, yazar sekmesinde)
   tarayıcıda açılır, masaüstünde `Divit` kısayolu olur. Claude Code
   2.1.280'den eskiyse önce güncellenir; olmazsa açık bir uyarı çıkar.
2. `[Mehmet elle]` Claude uygulamasını açın, **kendi** Claude
   hesabınızla giriş yapın (aynı hesap iki macOS oturumunda açık
   kalabilir).
3. `[Mehmet elle]` Üstte **Code** → **Local** → **Select folder** →
   Belgeler → Divit. Klasöre güvenin.
   **Beklenen:** Oturum açılır, izin sorusu yok.
4. `[Mehmet elle]` `merhaba` yazın.
   **Beklenen:** Divit kurulum konuşmasını yazar olarak başlatır ("Kitabınızı
   editör gözüyle okurum…"); hoca, tez, makale, özgeçmiş gibi kelimeler
   geçmez.
5. `[Mehmet elle]` `/` yazın, `divit` diye süzün.
   **Beklenen:** `divit:kitap-duzenle`, `divit:kitap-derle`,
   `divit:yazisma`, `divit:disa-aktar`, `divit:pdf`, `divit:yardim` …
   **Görünmemeli:** `divit-akademik:` ile başlayan hiçbir şey.
6. `[Mehmet elle]` İki örnek istek:
   - `kitabımı yeni baskı için düzenle` → hangi kitap olduğunu sorar;
     `kitaplar/<kitap>/asil/` altındaki dosyaya dokunmadan öneri çıkarır.
   - `yayınevine kapak mektubu yaz` → yazışma taslağı `yazilar/` altına
     kaydedilir.
7. Uygulamayı kapatıp Terminal'de sürümün hâlâ deneme sürümü olduğunu
   denetleyin:

   ```bash
   cd ~ && claude plugin list
   ```

   (`command not found` derse: `~/.local/bin/claude plugin list`)
   **Beklenen:** `divit@divit` altında `Version: <deneme sürümü>`, ayrıca
   `divit-akademik@divit`. Sürüm main'deki eski özete döndüyse pazar yeri
   main'e kaymıştır; bulguyu not edin.

## 3. Akademisyen kurulumu (aynı hesapta, ayrı klasör)

1. ```bash
   curl -fsSL https://raw.githubusercontent.com/mehmetor/divit/deneme/kur.sh | DIVIT_DAL=deneme DIVIT_TUR=akademisyen DIVIT_HEDEF=~/Documents/Divit-Akademik bash
   ```

   **Beklenen:** `Kullanıcı türü: akademisyen`,
   `Oluşturuldu: …/Documents/Divit-Akademik`, yine `Kurulu ve güncel`,
   3. adımda `Belgeler → Divit-Akademik`. Yazar klasörü değişmez.
2. `[Mehmet elle]` Claude → Code → Local → Belgeler → Divit-Akademik,
   klasöre güvenin, `/` yazıp `divit` diye süzün.
   **Beklenen:** `divit-akademik:tez-kontrol`, `divit-akademik:sinav`,
   `divit-akademik:yayin-oncesi`, `divit-akademik:kaynak-dogrula`,
   `divit-akademik:bolum-yaz` ve çekirdek `divit:` komutları.
3. `[Mehmet elle]` `merhaba` → kurulum konuşması akademisyen olarak
   (özgeçmiş ister).

## 4. Tazeleme (yeni bir düzeltmeyi denemek)

1. Geliştirme makinesinde, entegrasyon dalının güncel hâlinden:
   `./yayinla.sh --kanal deneme`, sonra 0.2'deki gibi önbelleği bekleyin.
   **Beklenen:** Yeni sürüm numaraları.
2. Divit Deneme hesabında 2.1'deki kurulum komutunu (akademisyen için
   3.1'i) yeniden çalıştırın. Klasördeki dosyalara dokunmaz. `DIVIT_DAL`
   vermeseniz de klasörün `kanal.txt`'si kanalı korur; `DIVIT_TUR`
   klasörün türüyle aynı olmalı (farklıysa kurulum durur).
   **Beklenen:** `Kurulu ve güncel (sürüm <yeni sürüm>)`.
3. `[Mehmet elle]` Claude uygulamasını kapatıp açın (ya da açık oturumda
   `/reload-plugins`).

`guncelleme` skill'i klasörün `kanal.txt`'sini okur; yayındaki sürümü ve
kurulum komutunu o kanaldan kurar (`DIVIT_DAL=<kanal>`). Bu davranış
skill parçası birleşmeden önceki eklentide yoktu: o sürümlerde deneme
hesabında "güncelle" demeyin, kurulumu main'den çalıştırır.

## 5. Temizlik

1. Divit Deneme hesabında:

   ```bash
   cd ~ && claude plugin marketplace remove divit
   ```

   **Beklenen:** `Successfully removed marketplace: divit`; ardından
   `claude plugin list` → `No plugins installed`.
2. `[Mehmet elle]` Finder'da `Belgeler/Divit`, `Belgeler/Divit-Akademik`,
   masaüstündeki `Divit` kısayolunu ve gizli `~/.divit` klasörünü
   (Finder'da ⇧⌘. ile görünür) Çöp Sepeti'ne atın.
3. `[Mehmet elle]` İsterseniz hesabın tamamını silin: kendi hesabınızdan
   Sistem Ayarları → Kullanıcılar ve Gruplar → Divit Deneme → Kullanıcıyı
   Sil → "Ana klasörü sil".

## 6. Windows (denenmedi)

Aynı sıra, PowerShell'de. Ayrı Windows kullanıcısı: Ayarlar → Hesaplar →
Diğer kullanıcılar → Hesap ekle (yerel hesap).

```powershell
# 2.1 yazar
$env:DIVIT_DAL='deneme'; $env:DIVIT_TUR='yazar'; irm https://raw.githubusercontent.com/mehmetor/divit/deneme/kur.ps1 | iex
# 3.1 akademisyen (yeni PowerShell penceresinde)
$env:DIVIT_DAL='deneme'; $env:DIVIT_TUR='akademisyen'; $env:DIVIT_HEDEF=Join-Path ([Environment]::GetFolderPath('MyDocuments')) 'Divit-Akademik'; irm https://raw.githubusercontent.com/mehmetor/divit/deneme/kur.ps1 | iex
# 2.7 sürüm denetimi
cd ~; claude plugin list
# 5.1 temizlik
cd ~; claude plugin marketplace remove divit
```

`$env:` değişkenleri pencere kapanana kadar kalır; türü değiştirirken yeni
pencere açın. Kanal Windows'ta da `.divit\kanal.txt`'ye yazılır.

## 7. Kural

`deneme` ve `deneme-*` dalları **asla** main'e ya da develop'a
birleştirilmez, PR açılmaz. Her `--kanal` çalışması dala yalnızca hızlı
ileri bir commit ekler (zip'ler ve deneme adresleri); iş develop'a normal
yoldan gider.
