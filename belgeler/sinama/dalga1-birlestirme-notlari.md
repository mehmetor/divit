# Dalga 1 — birleştirme notları (yönetici)

Parça raporlarından çıkan, sahibi olmayan dosyalara işlenecekler.
`entegrasyon` parçası bunları uygular.

## Klasör izinleri (`hoca-paketi/Divit/.claude/settings.json`) · kurulum gerekir
- allow: `Bash(zip *)`, `PowerShell(Compress-Archive *)` (disa-aktar Overleaf paketi)
- allow: `Edit(./sekiller/**)`, `Edit(./notlar/**)` (akademisyen; yazar zaten `kitaplar/**`)
- allow: `Read(~/.claude/uploads/**)` (telefondan gelen fotoğraf)
- deny: Gmail gönderme araçları (`mcp__claude_ai_Gmail__send_message`, `__reply`, `__forward`) — bkz. `belgeler/arastirma/baglayicilar.md`
- kaynak-sinama parçasının istediği WebFetch alan adları (raporuna bak)

## kurallar (`plugins/divit/skills/kurallar/**`)
- Yönlendirme tablosu: "bu hafta neler var", "takvime ekle", e-postada son tarih → takvim; "Overleaf'e yükleyeceğim" → disa-aktar; "şunu Türkçeye çevir" → ceviri; "grafik çiz", "akış şeması", "zaman çizelgesi" → sekil; "fotoğraftaki yazıyı metne çevir", "el yazımı oku" → malzeme.
- akademisyen.md: "dönem takvimim", "ders programım" → divit-akademik:ders-takvimi; "Yaklaşan tarihler" `.divit/profil/takvim.md`'yi de okusun.
- yazar.md "Yardım özeti": çeviri, grafik, fotoğraftan metin satırları.
- Kabuk listesinde zip / Compress-Archive (yalnız disa-aktar).
- Oturum saati uydurulmaz: saat bilinmiyorsa günlükte yalnız tarih.

## Yol birliği (dosya düzeni kuralına uyum)
- kitap-duzenle SKILL.md: `duzenleme/rapor-` → `raporlar/rapor-`.
- tez-kontrol SKILL.md ve `hoca-paketi/Divit/tez-kontrol/CLAUDE.md`: `rapor/<bashar>/<bashar>-<tarih>.md`.
- `.divit/gecici/<ad>.md` geçen skill'lerde tarihli ad.
- kitap-duzenle / kitap-derle: malzeme okurken `notlar/malzeme-metin/*.md`'deki "Kaynak türü:" satırına uy; alıntı kitaba kopyalanmaz (kısa alıntı + künye + [İZİN]); esinlenme cümlesi aktarılmaz.

## İzin kipi
- Klasörde `acceptEdits` kalır. Kılavuza ve kurulum sonuna: "İzin soruları çok mu? Yazı kutusunun yanındaki seçiciden Auto'yu seçin; bir kez yeter."
- saglik: sık izin sorusu yakınmasında seçiciyi hatırlat.

## Kılavuz satırları
- İyi istek: ne yapılsın + hangi dosya + ne çıksın; Shift + Enter alt satır.
- Takvim: "bu hafta neler var"; e-postadaki son tarih. Akademisyen: dönem takvimi / ders programı fotoğrafı.
- Overleaf (akademisyen): "Overleaf'e yükleyeceğim" → zip; New Project → Upload Project.
- Çeviri, grafik, fotoğraftan metin.
- Telefondan fotoğraf (Uzaktan Kontrol; olmazsa AirDrop / OneDrive).

## SURUM (Sıradaki) — parça raporlarındaki satırlar
- Herkes: İsteğiniz birden çok anlama geliyorsa Divit işe başlamadan "Anladığım: … Doğru mu?" diye tek soru sorar; açık istekte sormadan başlar.
- Herkes: Divit'in hazırladığı dosyaların adında artık tarih var; aynı gün yenisi "-s2" diye ayrılır. Sizin dosyalarınızın adına ve yerine dokunulmaz.
- Akademisyen: Raporlar her öğrenci için baş harfleriyle ayrı klasörde toplanır.
- Yazar: Kitap raporları kitabın "raporlar" klasöründe toplanır.
- Herkes: Aylık bakımda eskiyen ara dosyalar gösterilir; silmeye siz karar verirsiniz.
- Herkes: "Bu hafta neler var" deyin, yaklaşan işlerinizi gün gün özetlerim. E-postadaki son tarihi bulur, onayınızla işler listenize ve isterseniz takviminize eklerim.
- Akademisyen: Dönem takviminizi ve ders programınızı bir kez verin; sınavdan önce soru hazırlığını, not girişinden önce değerlendirmeyi hatırlatırım.
- Akademisyen: Makalenizi Overleaf'e yüklenecek tek dosya olarak hazırlarım; kaynakça ve resimler içinde gelir. Atıflar kontrol edilmemişse önce onu öneririm.
- Herkes: Yabancı dildeki bir metni üslubunuzla Türkçeye çeviririm; seçtiğim karşılıklar bir listede durur, kitap boyunca aynı kalır.
- Herkes: Rakamlarınızdan grafik, akış şeması ya da zaman çizelgesi çizer, Word dosyasına da koyarım.
- Herkes: Fotoğrafını çektiğiniz el yazısı notları ve kitap sayfalarını metne çeviririm; kendi yazınız mı, alıntı mı, esin mi olduğunu not ederim, başka kitaptan geleni kitabınıza kopyalamam.
