# Yapılacaklar

Pilotta ve geliştirmede biriken konular. Bitince satırı sil, gerekiyorsa
`SURUM.md`'ye yaz. Hocaya ait kişisel bilgi buraya yazılmaz (repo açık).

## Geliştirme

- [ ] **Kaynak sınaması yayına bağlanmadı.** `araclar/kaynak-sinama/calistir.sh`
      elle koşuluyor; her yayından önce zorunlu olsun, tek kaçırma yayını
      durdursun (`yayinla.sh` ya da CI; internet ve kota ister).
- [ ] **Ara dosya adları.** `pdf` skill'indeki `.divit/gecici/form.json` ve
      `saglik`'ın deneme dosyaları tarihsiz; `bakim` eskiyenleri tarihten
      bulduğu için tarihli ada (`<ad>-YYYY-AA-GG`) çevrilsin.
- [ ] **`gizli/` araması.** `Bash(*gizli*)` adı "gizli" geçmeyen genel
      aramayı (`grep -r … .`) durdurmaz; kullanıcı onaylarsa ya da Auto kipi
      geçirirse gizli klasör de taranır. Kural yazıyla da var; izinle kapatma
      yolu aranacak.

## Kapsam

- [ ] **Kitap yazarları (akademik olmayan)** — ilk görüşme:
      `belgeler/YAZAR-GORUSMESI.md`; demo örnekleri `belgeler/demo-yazar/`.
  - yazar için tanıtım sayfası (`apps/web`)
  - editörlü (çok yazarlı) kitap derleme — bugün `kitap-derle` yalnız
    kullanıcının kendi yazılarıyla çalışır
  - Word'de değişiklik izleme ile öneri (bugün öneri listesi ya da yeni dosya)
  - ses kaydını yazıya dökme (bugün yazıya dökülmüş hâli gerekir)

## Kararlar

- [ ] Varsayılan izin kipi: şimdi `acceptEdits` + Auto önerisi. Auto
      varsayılan yapılabilir mi, her hesapta açık mı?

## Mehmet'e kalan

Bu Mac'ten yapılamayanlar; her satır ne beklendiğini söyler.

- [ ] Sınav sorusu — ilk hocayla dene: sorular nottan mı, şıklar dengeli mi, Word düzeni.
- [ ] Dönem takvimi — hocaya sor: akademik takvim ve ders programı dosyası elinde var mı.
- [ ] Bağlayıcılar — pilot makinede Gmail bağlıyken "bu taslağı gönder" de; izin reddetmeli; menü adları (+ → Connectors) ekranla aynı mı.
- [ ] PowerPoint/Excel — Türkçe Windows Excel'de `.csv` çift tıkla doğru açılıyor mu; gerçek kurum şablonuyla sunum.
- [ ] Telefondan fotoğraf — Uzaktan Kontrol ile gelen fotoğraf `~/.claude/uploads/` altında bulunuyor mu (Mac ve Windows).
- [ ] Ayrıntılı geçmiş — Windows'ta git komutlarının tırnakları (PowerShell 5.1) ve `kitap-klasoru.ps1 koy … [yeni-ad]`.
- [ ] Windows: ilk PDF okumadaki Türkçe karakter bozulması — `sorunlar.md` kaydına bak, sebep komut mu PowerShell çıktısı mı.
- [ ] Windows: `/effort high` ve `/model` Code sekmesinde yazılarak çalışıyor mu.
- [ ] Windows: e-posta taslağı — bağlayıcı yolu ve e-posta programı yolu.
- [ ] Windows: kontrol listesi işaretleme — tik yerleri kutuya denk geliyor mu; doldurulabilir form yolu.
- [ ] Windows: `guncelleme` akışı — yenilikleri söyleme, onayla kurulumu çalıştırma.
- [ ] Windows: yazar kurulumu `kur.ps1` — `DIVIT_TUR`, yeniden kurulumda izinler kalıyor mu, `gizli/` yalnız akademisyende.
- [ ] Code sekmesinde '/' menüsü — yazar klasöründe `divit-akademik:` yok, akademisyen klasöründe var mı.
- [ ] Kurulu hocada iki eklentiye geçiş (`belgeler/GECIS-IKI-EKLENTI.md`) — yayın günü.
- [ ] İlk hoca — kimlik bilgilerini onaylatma (kurulumda yarım kaldıysa).
- [ ] Pilot görüşmeleri — buluşmadan 3 gün sonra telefon, 1 hafta sonra kısa görüşme; geri bildirimleri `araclar/pano.py` ile topla.
- [ ] KVKK — 30 kişiye çıkmadan üniversite BT/etik birimiyle netleştir.
- [ ] Lisans — ücretli sürüme geçerken PolyForm Noncommercial yerine ne; avukata danış.
- [ ] Web of Science — araştırıldı, şimdilik yok (`belgeler/arastirma/web-of-science.md`); üniversite kurum erişimiyle API anahtarı alınabiliyor mu.
- [ ] Sosyal bilimler kılavuzu (`alan/sosyal-bilimler.md`) — ilk sosyal bilimler hocasıyla doğrula.
- [ ] Okul rehberliği — PDR adayının CV'si gelince kurulumu onunla dene.
