# Yapılacaklar

Pilotta ve geliştirmede biriken konular. Bitince satırı sil, gerekiyorsa
`SURUM.md`'ye yaz. Hocaya ait kişisel bilgi buraya yazılmaz (repo açık).

## Yeni işler — hocalardan gelen istekler

- [ ] **Sınav sorusu — ilk hocayla dene** (`sinav` skill'i 1.8'de). Bak:
      sorular nottan mı çıktı, doğru şıklar dengeli mi, Word düzeni.
- [ ] **Takvim ve iş takibi.** Bugün yalnızca `gorevler.md`'de 7 gün içindeki
      tarih hatırlatılıyor. Seçenekler:
  - "bu hafta neler var" özeti
  - e-posta ya da yazıdan son tarihi yakalayıp onayla göreve ekleme
  - `.ics` takvim dosyası (kurulumsuz; Outlook, Google, Apple)
  - Claude'da takvim bağlayıcısı varsa izinle etkinlik oluşturma
- [ ] **Akademik takvim + ders programı.** Dönem, sınav haftaları, not giriş
      son günü ve haftalık ders programı bir kez alınır; öneriler buna göre
      planlanır (sınavdan önce soru hazırlığı, not girişinden önce
      değerlendirme hatırlatması). Hocaya sor: bu dosyalar elinizde var mı?

- [ ] **Dosya düzeni — uzun vadede çöplük olmasın.**
  - Hocanın çalışma dosyalarına tarih ve sürüm: `<ad>-YYYY-AA-GG-s2.docx`
    gibi tek bir adlandırma kuralı; aynı işin yeni hâli sürüm artırır.
  - Alt klasörle gruplama: iş türü → kişi/konu → dönem. Örnek:
    `tez-kontrol/<öğrenci baş harfi>/<tarih>/` (gelen, rapor, ara dosyalar
    bir arada).
  - Ara dosyalar (metne çevrilmiş PDF, geçici md) `.divit/gecici/` dışına
    çıkmasın; biten işin ara dosyaları arşive ya da silinmeye aday.
  - `bakim` skill'i aylık düzen denetiminde dağınıklığı bulup önersin.

- [ ] **Bağlayıcılar (Gmail, Google Takvim, Google Drive).** İlk pilot
      hocada Gmail kapalıydı. Divit kendisi açamaz (hesap ayarı, Google
      girişi hocada); açık olup olmadığını anlar, kapalıysa adım adım tarif
      eder. Takvim: son tarihleri izinle etkinlik yapmak. Drive bağlayıcısı
      büyük ihtimalle yalnız okur; yedek için Drive/OneDrive masaüstü
      eşitlemesi daha sağlam (Windows'ta Belgeler zaten OneDrive'da olabilir).
- [ ] **PowerPoint ve Excel.** İlk pilot hoca kendi başına denedi, başarılı.
      Claude ek araç kurmuş olabilir: günlükte ne kurulduğuna bak; kalıcı
      bir `sunum`/`tablo` yolu gerekebilir (Python varsayılmaz).

- [ ] **Belirsiz istekler — yük hocada değil Divit'te.** İlk pilotta istekler
      dağınık, sorular yarım cevaplandı. Hocaya "daha iyi yazın" denmez.
  - İşe başlamadan tek cümle "Anladığım: … Doğru mu?"
  - Tek soru; evet/hayır ya da numaralı seçenek ("1) Word 2) PDF")
  - Parça mesajları tek istek olarak okuma
  - Yerinde ipucu (Shift + Enter ile alt satır; ne + dosya + çıktı),
    oturumda en fazla bir, her biri en fazla üç kez, "bir daha gösterme"
  - Kılavuz ve kartta "İyi istek" kutusu; isteğe bağlı alıştırma
    yalnız kılavuzda, Divit kendiliğinden önermez
  - Ölçü: `sorunlar.md`'de "onu demedim" türü kayıtların sayısı
  - İlk madde küçük bir kurallar değişikliği; dosya düzeniyle aynı yayına girebilir

- [ ] **LaTeX / Overleaf dışa aktarma.** Taslak → pandoc ile `\cite{}`
      komutlu `.tex` + `kaynaklar.bib` (+ dergi şablonu) tek zip; hoca
      Overleaf'te "Upload Project" ile açar. Tek tıkla Overleaf'e gönderme
      denenmeli. Aktarımdan önce `kaynak-dogrula` zorunlu. Fen/mühendislik
      hocalarını açar. (Benzer özellik: thesisai.io.)

## Kaynak doğrulama — "sessiz hata sıfır"

- [ ] 7. madde önce: bilerek hata konmuş **sınama seti**; her yayından önce
      zorunlu, tek kaçırma yayını durdurur.
- [ ] Crossref'e ek OpenAlex ve DergiPark
- [ ] Geri çekilmiş/düzeltilmiş makale denetimi (Crossref)
- [ ] Alan alan kesin karşılaştırma (soyadı, yıl, cilt, sayfa, başlık)
- [ ] Metin ↔ kaynakça mekanik eşleştirme, tek tek listeleyerek
- [ ] Kanıt dosyası `.divit/dogrulama/`
- [ ] "Doğrulandı" denenlere ikinci bağımsız okuma
- [ ] **Web of Science** — API anahtar/kurum aboneliği ister; üniversite
      erişimiyle olur mu, bak.

## Kapsam

- [ ] **Öğretmenler / okul rehberliği (PDR).** Aday: lise PDR bölüm başkanı,
      uzman psikolojik danışman; CV'si gelecek.
  - kurulum: yayını olmayanlar için örnek metin isteme yolu
  - alan kılavuzu: okul rehberliği / öğretmenlik
  - gizlilik: vaka dosyaları reşit olmayanların özel nitelikli verisi
    (KVKK) → okunamayan `gizli/` klasörü, deny kuralıyla
- [ ] **Sosyal bilimler kılavuzu** (`alan/sosyal-bilimler.md`) ilk sosyal
      bilimler hocasıyla doğrulanacak.
- [ ] İsteğe bağlı **git geçmişi** (ayrıntılı dosya geçmişi isteyen hocalar
      için; önceki sürüm kuralı kalır).

## Doğrulanmayı bekleyenler (Windows'ta dene)

- [ ] İlk PDF okumadaki Türkçe karakter bozulması: `sorunlar.md` kaydına bak,
      sebep komut mu PowerShell çıktısı mı.
- [ ] `/effort high` ve `/model` Claude uygulamasının Code sekmesinde
      yazılarak çalışıyor mu (kılavuz bunu varsayıyor).
- [ ] E-posta taslağı: bağlayıcı yolu ve e-posta programı yolu.
- [ ] Kontrol listesi işaretleme: tik yerleri kutuya denk geliyor mu;
      doldurulabilir form yolu.
- [ ] `guncelleme` akışı: yenilikleri söyleme, onayla kurulumu çalıştırma.
- [ ] Mac kısa adres + Windows kısa adres (Windows'ta kullanıldı, çalışıyor).

## Kararlar

- [ ] Varsayılan izin kipi: şimdi `acceptEdits` + Auto önerisi. Auto
      varsayılan yapılabilir mi, her hesapta açık mı?
- [ ] Ücretlendirme — uygulama tamamen hazır olunca ücretli sürüm.
      O zaman lisans değişir (şimdi PolyForm Noncommercial); avukata danışılır.

## Pilot

- [ ] İlk hoca: kimlik bilgilerini onaylatma (kurulumda yarım kaldıysa).
- [ ] Buluşmadan 3 gün sonra telefon, 1 hafta sonra kısa görüşme.
- [ ] Gelen geri bildirimleri `araclar/pano.py` ile topla.
- [ ] KVKK: 30 kişiye çıkmadan üniversite BT/etik birimiyle netleştir.
