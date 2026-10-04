# Yapılacaklar

Pilotta ve geliştirmede biriken konular. Bitince satırı sil, gerekiyorsa
`SURUM.md`'ye yaz. Hocaya ait kişisel bilgi buraya yazılmaz (repo açık).

## Geliştirme

- [ ] Değişken ya da betik içinden yapılan arama izin kalıplarıyla kapatılamaz;
      `gizli/` için son koruma kuraldaki yazılı yasak. Gerekirse işletim
      sistemi izniyle (klasör kilidi) araştırılır.

## Kapsam

- [ ] Yazar kurulumu Windows'ta (ilk yazarla buluşmada): `belgeler/YENI-KURULUM.md`.

## Masaüstü uygulaması

Divit hocanın bilgisayarında çalışan bir uygulama olacak: açılışta hocanın
Claude üyeliğini kullanmak için izin ister, arka planda yerel Claude Code
oturumlarını çalıştırır; aynı oturumlar Claude Desktop'tan da izlenir.
Üyelik buluta taşınmaz. Sohbet arayüzü ORC'ta geliştirilecek ortak
kütüphaneden gelir (çalışma adı `@simetri/agent-ui`, temeli assistant-ui,
React, MIT). 2–4 bu kütüphane hazır olunca devralınır; Divit'e özgü
olanlar 1 ve 5–8.

- [ ] 1. Masaüstü kabuğu (Tauri ya da Electron): açılışta Claude üyeliği izni,
      yerel Claude Code oturumlarını başlatma ve sürdürme, Claude Desktop ile
      aynı oturumu paylaşma.
- [ ] 2. Gelişmiş sohbet alanı: sürükle-bırak ek, `/komut` ve `@dosya`
      önerileri, mesajı düzenleme, yanıtı durdurma, izin isteği ve plan kartları.
      *(ortak kütüphane)*
- [ ] 3. Uygulama içi dosya görüntüleyiciler: PDF (pdf.js), DOCX
      (docx-preview), XLSX/CSV (SheetJS), Markdown + LaTeX (KaTeX), görsel,
      kod ve diff. *(ortak kütüphane)*
- [ ] 4. Sohbette zengin içerik: grafik, tablo, pano, form. Araçlar arayüzü
      MCP Apps standardıyla döndürsün; `tez-kontrol` raporu Divit'te ve Claude
      Desktop'ta aynı açılsın. *(ortak kütüphane)*
- [ ] 5. Atıf ve kaynakça paneli: Zotero ya da BibTeX listesi, atıfa tıklayınca
      kaynak açılır (`kaynak-dogrula` ile bağlantılı).
- [ ] 6. PDF üzerinde vurgu ve not; asistanın yorumu sayfadaki ilgili yere
      iliştirilir.
- [ ] 7. İki belgeyi yan yana karşılaştırma (taslak ile düzeltilmiş hâli).
- [ ] 8. Word'deki değişiklik izleme benzeri öneri ve kabul/ret akışı.
- [ ] 9. Dosya ve sürüm paneli: değişen dosyalar, önceki sürüme dönme
      (`geri-al` ile uyumlu, arka planda git).
- [ ] 10. Oturum geçmişinde arama.

## Mehmet'e kalan

Bu Mac'ten yapılamayanlar; her satır ne beklendiğini söyler.

- [ ] Ses: Word 365'te Transkribe'ın Türkçe dil listesinde olduğunu doğrula (Apple'da Türkçe yok).
- [ ] Kitap: izlenen değişiklikli docx'i Word'de açıp Kabul Et/Reddet dene.
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
