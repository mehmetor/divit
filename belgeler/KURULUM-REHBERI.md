# Divit — Kurulum Rehberi

Bu rehberi kurulumu yapan kişi okur. Hoca bu rehberi okumaz. Hoca
kurulumun sonunda açılan `KILAVUZ.html` dosyasını okur.

Kurulum Windows'ta ve Mac'te aynıdır: **bir komut, sonra üç tıklama.**
Git, Homebrew ya da yönetici parolası gerekmez.

---

## Bölüm A — Ön koşul (hoca)

Hocanın **Claude Pro** (ya da Max) hesabı olmalıdır.

> **UYARI:** Ücretsiz Claude hesabı Divit'i çalıştırmaz. Hesabı kurulumdan
> önce açtırın. Adres: https://claude.ai

---

## Bölüm B — Kurulum (hoca makinesi, yaklaşık 10 dakika)

### B1. Kurulum komutunu çalıştırın

**Windows**

1. Başlat menüsünü açın.
2. `PowerShell` yazın. <kbd>Enter</kbd> tuşuna basın.
3. Şu satırı yapıştırın. <kbd>Enter</kbd> tuşuna basın:
   ```powershell
   irm divit.simetri.app/kur.ps1 | iex
   ```

**Mac**

1. <kbd>Cmd</kbd> + <kbd>Space</kbd> tuşlarına basın.
2. `Terminal` yazın. <kbd>Enter</kbd> tuşuna basın.
3. Şu satırı yapıştırın. <kbd>Enter</kbd> tuşuna basın:
   ```bash
   curl -fsSL https://raw.githubusercontent.com/mehmetor/divit/main/kur.sh | bash
   ```

Komut altı adımı kendisi yapar:

| Adım | Ne yapar |
|---|---|
| 1 | Claude uygulamasını kurar (kurulu değilse) |
| 2 | Claude Code'u kurar (eklentiyi kurmak için) |
| 3 | Word ve PDF araçlarını kurar: pandoc, pdfcpu; Windows'ta ayrıca Poppler (`pdftotext`, `pdftoppm` kullanıcı PATH'ine eklenir). Mac'te PDF okuma sistemin PDFKit'iyle olur |
| 4 | `Belgeler/Divit` klasörünü oluşturur, `.divit/kurulum-surumu.txt` yazar |
| 5 | Divit eklentisini kurar ve otomatik güncellemeyi açar |
| 6 | Masaüstüne Divit kısayolu koyar, kılavuzu açar |

> **NOT:** Windows'ta Claude uygulaması kurulurken ayrı bir kurulum
> penceresi açılabilir. Pencere kapanana kadar bekleyin.

> **UYARI:** Windows'ta kurulum bitince Claude açıksa tamamen kapatın
> ve yeniden açın. Yoksa Claude yeni PDF araçlarını görmez.

> **NOT:** Komut "UYARI" yazdıysa kuruluma devam edin. Uyarının ne
> olduğunu not alın. Çoğu uyarı ilk açılışta kendiliğinden çözülür.

### B2. Claude uygulamasını açın

1. Claude uygulamasını açın.
2. Hoca **kendi** hesabıyla giriş yapsın.
3. Üstteki **Code** sekmesine tıklayın.
4. **Local** → **Select folder** → **Belgeler** → **Divit**.

> **UYARI:** Kendi hesabınızla giriş yapmayın. Hocanın metinleri hangi
> hesapla işlenirse o hesaba gider.

### B3. Divit'i başlatın

1. Mesaj kutusuna `merhaba` yazın.
2. Divit hocadan özgeçmişini ister. Hoca özgeçmişini mesaj kutusuna
   sürüklesin.
3. Gerisini Divit sorar. Hoca cevaplasın.

Kurulum bu kadar. Divit hocanın alanını, makalelerini ve süren işlerini
kendisi öğrenir. Önceden hiçbir şey hazırlamanız gerekmez.

---

## Bölüm C — İlk oturumda gözlem

> **NOT:** Hoca takılırsa hemen müdahale etmeyin. 10 saniye bekleyin.
> Hocanın takıldığı yer ürün için en değerli bilgidir.

Şunları not alın:

- Hoca nerede durakladı?
- Divit'in hangi sorusunu anlamadı?
- Hangi izin sorusuna ne cevap verdi?
- Divit'in özgeçmişten çıkardığı bilgilerde hata var mıydı?

---

## Bölüm D — Güncelleme (sizin makineniz)

Eklenti hocalara kendiliğinden güncellenir.

1. `develop` dalında çalışın. Hocaya gidecek notu `plugins/divit/SURUM.md`
   içinde en üstteki `## Sıradaki` başlığına yazın.
2. Denemek için: `./yayinla.sh` (hiçbir şeyi değiştirmez; zip özetini ve
   hocaya gidecek notu gösterir).
3. `develop`'u GitHub'a gönderin. release-please "divit X yayını" adlı bir
   PR açar; her yeni commit'te PR güncellenir.
4. Yayına hazırsanız PR'ı birleştirin. CI zip'i üretir ve `main`'i
   günceller. Hocalar güncellemeyi birkaç saat içinde alır.

> **UYARI:** Her yayın bütün hocalara gider. Hatalı bir değişiklik bütün
> hocaları aynı anda etkiler. PR'ı yalnızca kendiniz denedikten sonra
> birleştirin. CI eklentiyi doğrular; doğrulama başarısız olursa `main`
> değişmez.

Divit klasörünün kendisini (`CLAUDE.md`, kılavuz, ayarlar) ve araçları
güncellemek için kurulum komutu yeniden çalışmalıdır. Komut hocanın
dosyalarına ve profiline dokunmaz. Bunu elle yapmanız gerekmez:
`plugins/divit/SURUM.md`'ye yeni sürüm başlığı yazın; başlığın sonuna
` · kurulum gerekir` ekleyin. `guncelleme` skill'i yenilikleri hocaya
anlatır ve kurulumu hocanın onayıyla yeniden çalıştırır.

---

## Bölüm E — Sorun giderme

| Belirti | Çözüm |
|---|---|
| PowerShell "irm tanınmıyor" diyor | CMD açmışsınız. PowerShell'i açın. |
| **Code** sekmesi "upgrade" istiyor | Hesap ücretsiz. Pro hesaba geçin. |
| Divit özgeçmiş istemiyor, sıradan cevap veriyor | Yanlış klasör seçildi. **Select folder** → Belgeler → Divit. |
| Divit çok izin soruyor | Mesaj kutusunun altındaki kip seçiciden **Auto**'yu seçin. |
| Word ya da PDF okuyamıyor | Divit'e `çalışıyor musun` yazın. Araç eksikse kurulum komutunu yeniden çalıştırın; Windows'ta sonra Claude'u tamamen kapatıp açın. |
| Eklenti yok (`yardım` kılavuzu açmıyor) | Kurulum komutunu yeniden çalıştırın. |

Hâlâ çözülmediyse hoca makinesinde şu komutu çalıştırın ve çıktıyı
geliştiriciye gönderin:
```
claude doctor
```

---

## Bölüm F — Kaldırma

1. Masaüstündeki Divit kısayolunu silin.
2. `Belgeler/Divit` klasörünü **silmeyin**; hocanın bütün çalışması
   oradadır. Hoca isterse başka bir yere taşısın.
3. Eklentiyi kaldırmak için: `claude plugin uninstall divit@divit`
