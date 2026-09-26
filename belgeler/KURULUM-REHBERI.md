# Divit — Kurulum Rehberi

Bu rehber Divit'i bir hocanın bilgisayarına kurmayı anlatır.
Rehberi kurulumu yapan kişi okur. Hoca bu rehberi okumaz. Hoca
`KILAVUZ.html` dosyasını okur.

Rehber ASD-STE100 kurallarını Türkçeye uyarlayarak kullanır:

- Bir cümlede bir eylem vardır.
- Uyarı ilgili adımdan önce gelir.
- Bir terimin her yerde tek anlamı vardır.

| Terim | Anlamı |
|---|---|
| **kurulum makinesi** | Sizin bilgisayarınız. Divit reposu bu bilgisayardadır. |
| **hoca makinesi** | Hocanın bilgisayarı. Divit bu bilgisayara kurulur. |
| **Divit klasörü** | Hoca makinesindeki `~/Divit` klasörü. Hocanın çalışma alanıdır. |
| **paket** | `Divit-Kurulum-<ad>.zip` dosyası. Kurulum için gereken her şeyi içerir. |
| **Divit penceresi** | Hocanın çift tıklayınca açılan Terminal penceresi. |

---

## Bölüm A — Bir kez yapılacak işler (kurulum makinesi)

Bu bölümü yalnızca bir kez yapın. Sonraki hocalar için bu bölümü atlayın.

### A1. GitHub reposunu oluşturun

> **UYARI:** Repo **public** olmalıdır. Özel repoda hoca makinesi eklenti
> güncellemelerini alamaz. Repoda kişisel veri yoktur. `hocalar/` ve
> `dist/` klasörleri git dışındadır.

1. Terminal'i açın.
2. Divit klasörüne gidin:
   ```bash
   cd ~/Simetri/Develop/divit
   ```
3. Repoyu oluşturun ve gönderin:
   ```bash
   gh repo create mehmetor/divit --public --source . --push \
     --description "Divit — akademik yazım tezgâhı. Makale, tez, kitap."
   ```
4. Tarayıcıda `https://github.com/mehmetor/divit` adresini açın.
5. `hocalar/` klasörünün repoda **olmadığını** kontrol edin.

### A2. Repoyu doğrulayın

1. Şu komutu çalıştırın:
   ```bash
   claude plugin validate .
   ```
2. Sonuç "Validation passed" olmalıdır.
3. `version` uyarısını yok sayın. Bu uyarı bilinçli bir karardır.

---

## Bölüm B — Her hoca için hazırlık (kurulum makinesi)

### B1. Ön koşulları kontrol edin

Hoca makinesi için şu koşullar gereklidir:

| Koşul | Nasıl kontrol edilir |
|---|---|
| macOS | Hocaya sorun. |
| İnternet bağlantısı | — |
| Hocanın **Claude hesabı** (Pro ya da Max) | Hocaya sorun. |
| Hocanın **Mac yönetici parolası** | Hoca kurulum sırasında parolayı yazar. |

> **UYARI:** Divit şu an yalnızca macOS'ta çalışır. Hoca makinesi Windows
> ise kuruluma başlamayın. Windows kurulum betiği henüz yoktur.

> **UYARI:** Claude Code ücretsiz Claude hesabıyla çalışmaz. Hocanın Pro
> ya da Max aboneliği olmalıdır.

### B2. Hoca klasörünü hazırlayın

1. `hocalar/<ad>/` klasörünü oluşturun. Örnek: `hocalar/ad-soyad/`.
2. Hocanın CV'sini bu klasöre koyun.
3. Claude Code'dan `kimlik.md` ve `uslup.md` dosyalarını hazırlamasını
   isteyin.
4. Hocanın alanını belirleyin. Alan kılavuzları `plugins/divit/alan/`
   klasöründedir.

> **NOT:** Hocanın alanına uygun kılavuz yoksa alan adı olarak `ziraat`
> vermeyin. Kılavuzsuz kurulum güvenlidir. Yanlış kılavuz güvenli değildir.

### B3. Paketi oluşturun

1. Şu komutu çalıştırın:
   ```bash
   ./hoca-paketi/paketle.sh hocalar/ad-soyad ziraat
   ```
2. Paket `dist/` klasöründe oluşur.
3. Paketi USB belleğe kopyalayın. Ya da paketi AirDrop ile gönderin.

> **NOT:** Pakette CV, makale ve öğrenci dosyası yoktur. Bu dosyaları
> kurulumdan sonra ayrıca kopyalayın.

---

## Bölüm C — Kurulum (hoca makinesi)

Kurulum yaklaşık 20 dakika sürer. Hoca yanınızda olsun. Hoca kurulumu
izlesin.

### C1. Terminal'i açın

1. <kbd>Cmd</kbd> + <kbd>Space</kbd> tuşlarına basın.
2. `Terminal` yazın.
3. <kbd>Enter</kbd> tuşuna basın.

### C2. Homebrew'u kontrol edin

1. Şu komutu çalıştırın:
   ```bash
   brew --version
   ```
2. Sürüm numarası görürseniz C3'e geçin.
3. "command not found" görürseniz Homebrew'u kurun:
   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```
4. Hoca Mac parolasını yazsın. Parola ekranda görünmez. Bu normaldir.
5. Kurulumun sonunda Homebrew "Next steps" bölümünde iki komut verir.
   Bu iki komutu çalıştırın.

### C3. Paketi açın

1. Paketi `İndirilenler` klasörüne kopyalayın.
2. Pakete çift tıklayın. `Divit-Kurulum` klasörü oluşur.
3. Terminal'de klasöre gidin:
   ```bash
   cd ~/Downloads/Divit-Kurulum
   ```

### C4. Kurulum betiğini çalıştırın

1. Şu komutu çalıştırın:
   ```bash
   DIVIT_ALAN=ziraat DIVIT_PROFIL=./profil bash kur.sh
   ```
2. Betiğin bitmesini bekleyin.

Betik şu işleri yapar:

| İş | Sonuç |
|---|---|
| Divit klasörünü oluşturur | `~/Divit` |
| Hocanın profilini ve alan kılavuzunu koyar | `~/Divit/.claude/profil/` |
| pandoc, poppler ve git araçlarını kurar | Homebrew ile |
| Claude Code'u kurar | Kurulu değilse |
| Divit eklentisini kurar | GitHub'dan |
| İlk yedeği alır | `~/Divit` git deposu olur |
| Masaüstüne simge koyar | `Divit` |
| Kılavuzu tarayıcıda açar | `KILAVUZ.html` |

> **NOT:** Betik "UYARI: Divit eklentisi kurulamadı" derse kuruluma devam
> edin. Adım C8 eklentiyi kontrol eder.

### C5. Kılavuzu hocaya gösterin

1. Tarayıcıda Divit Kılavuzu açılır.
2. Hocayla birlikte **Bölüm 2** ve **Bölüm 5**'i okuyun.
3. Kılavuzu tarayıcıda açık bırakın.

### C6. Divit'i ilk kez açın

1. Masaüstünde **Divit** simgesine çift tıklayın.
2. Divit penceresi açılır.

> **UYARI:** Giriş adımında hoca **kendi** Claude hesabıyla giriş yapmalıdır.
> Kendi hesabınızla giriş yapmayın. Hocanın metinleri hangi hesaba
> girilirse o hesaptan işlenir.

3. Divit tema seçimini sorarsa <kbd>Enter</kbd> tuşuna basın.
4. Divit giriş yöntemini sorarsa **Claude account with subscription**
   seçeneğini seçin.
5. Tarayıcı açılır. Hoca kendi Claude hesabıyla giriş yapsın.
6. Tarayıcıda **Authorize** düğmesine tıklayın.
7. Divit penceresine dönün.

### C7. Klasöre güven verin

> **UYARI:** Bu adımı atlamayın. Güven verilmezse Divit'in ön izinleri
> çalışmaz. Hoca her işlem için onay vermek zorunda kalır.

1. Divit "Do you trust the files in this folder?" diye sorar.
2. **Yes, proceed** seçeneğini seçin.
3. <kbd>Enter</kbd> tuşuna basın.
4. Divit eklenti ya da marketplace kurulumunu sorarsa onay verin.

### C8. Eklentiyi kontrol edin

1. Divit penceresine şunu yazın:
   ```
   /plugin
   ```
2. **Installed** sekmesinde `divit` görünmelidir.
3. `divit` görünmezse Divit penceresini kapatın. Terminal'de şu komutları
   çalıştırın:
   ```bash
   cd ~/Divit
   claude plugin marketplace add mehmetor/divit
   claude plugin install divit@divit --scope project
   ```
4. Divit'i simgeden yeniden açın.

---

## Bölüm D — Kurulumu doğrulayın (hoca makinesi)

Her satırı sırayla yapın. Bir satır başarısız olursa Bölüm G'ye bakın.

| # | Yapın | Beklenen sonuç |
|---|---|---|
| D1 | Divit penceresine `yardım` yazın. | Kılavuz tarayıcıda açılır. Divit altı iş sayar. |
| D2 | Finder'da bir PDF'i `~/Divit/tez-kontrol/gelen` klasörüne sürükleyin. | Dosya klasörde görünür. |
| D3 | Divit penceresine `gelen klasöründeki dosyayı değerlendir` yazın. | Divit dosyayı okur. İzin sormaz. |
| D4 | Değerlendirmenin bitmesini bekleyin. | `tez-kontrol/rapor` klasöründe rapor oluşur. |
| D5 | Divit penceresine `geri al` yazın. | Divit son yedekleri tarih ve saatle listeler. |
| D6 | `hayır, vazgeç` yazın. | Divit hiçbir şeyi değiştirmez. |

> **NOT:** D3 adımında Divit okuma izni isterse klasöre güven verilmemiştir.
> Adım C7'yi tekrarlayın.

---

## Bölüm E — İlk oturum (hoca makinesi)

1. Divit penceresine şunu yazın:
   ```
   başlayalım
   ```
2. Divit hocanın profilini gösterir. Hoca her satırı onaylasın.
3. Divit alan kurallarını sorar. Hoca cevaplasın.
4. Hoca ilk gerçek işini seçsin.
5. Hocanın hangi çıktıyı okumadan geçtiğini not alın.
6. Hocanın hangi maddeyi sildiğini not alın.

> **NOT:** İlk oturumda müdahale etmeyin. Hoca takılırsa 10 saniye bekleyin.
> Hocanın takıldığı yer ürün için en değerli bilgidir.

Hocaya özel gündem `hocalar/<ad>/HAZIRLIK.md` dosyasındadır.

---

## Bölüm F — Güncelleme

Divit sürüm numarası kullanmaz. Her commit yeni bir sürümdür.

### F1. Güncelleme gönderin (kurulum makinesi)

1. Değişikliği commit edin.
2. Değişikliği gönderin:
   ```bash
   git push
   ```

> **UYARI:** Gönderdiğiniz her değişiklik bütün hocalara gider. Hatalı bir
> değişiklik bütün hocaları aynı anda etkiler. Göndermeden önce
> `claude plugin validate .` komutunu çalıştırın.

### F2. Güncellemeyi alın (hoca makinesi)

Güncelleme genellikle kendiliğinden gelir. Güncelleme gelmezse:

1. Terminal'i açın.
2. Şu komutları çalıştırın:
   ```bash
   claude plugin marketplace update divit
   claude plugin update divit@divit
   ```
3. Divit'i yeniden açın.

---

## Bölüm G — Sorun giderme

| Belirti | Neden | Çözüm |
|---|---|---|
| Simge "tanınmayan geliştirici" uyarısı veriyor | Karantina işareti | `xattr -dr com.apple.quarantine ~/Divit` |
| Simge açılıyor, pencere hemen kapanıyor | Claude Code kurulu değil | `curl -fsSL https://claude.ai/install.sh \| bash` |
| `claude: command not found` | Terminal yolu eski | Terminal'i kapatın ve yeniden açın |
| `yardım` yazınca kılavuz açılmıyor | Eklenti kurulu değil | Adım C8 |
| Divit her işlemde izin soruyor | Klasöre güven verilmedi | Adım C7 |
| "Word'e çevir" çalışmıyor | pandoc eksik | `brew install pandoc` |
| PDF okunamıyor | poppler eksik | `brew install poppler` |
| Giriş hatası | Hesap abonelik değil | Hocanın Pro/Max aboneliğini kontrol edin |
| Divit ortam uyarısı veriyor | Eksik araç | Divit hangi aracı söylüyorsa onu kurun |

---

## Bölüm H — Kaldırma (hoca makinesi)

> **UYARI:** `~/Divit` klasörü hocanın bütün çalışmasını ve yedeklerini
> içerir. Klasörü silmeden önce klasörün kopyasını alın.

1. Eklentiyi kaldırın:
   ```bash
   cd ~/Divit
   claude plugin uninstall divit@divit
   ```
2. Masaüstündeki Divit simgesini silin.
3. Hoca isterse `~/Divit` klasörünü başka bir yere taşıyın.
