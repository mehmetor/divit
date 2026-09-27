# Yapılacaklar

Pilotta ve geliştirmede biriken konular. Bitince satırı sil, gerekiyorsa
`SURUM.md`'ye yaz. Hocaya ait kişisel bilgi buraya yazılmaz (repo açık).

## Yeni işler — hocalardan gelen istekler

- [ ] **Sınav sorusu hazırlama.** İlk pilot hocanın kendi isteği. Netleştir:
      hangi ders, soru türü (çoktan seçmeli / klasik), kaynak (ders notu,
      kitap), cevap anahtarı, zorluk düzeyi, Word çıktısı.
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
- [ ] Ücretlendirme — pilot sonrası.

## Pilot

- [ ] İlk hoca: kimlik bilgilerini onaylatma (kurulumda yarım kaldıysa).
- [ ] Buluşmadan 3 gün sonra telefon, 1 hafta sonra kısa görüşme.
- [ ] Gelen geri bildirimleri `araclar/pano.py` ile topla.
- [ ] KVKK: 30 kişiye çıkmadan üniversite BT/etik birimiyle netleştir.
