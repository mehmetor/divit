# LaTeX / Overleaf paketi

`disa-aktar` bu dosyayı hoca LaTeX ya da Overleaf istediğinde Read ile yükler.
Yalnız akademisyen türü için önerilir. Tür yazarsa bu yolu kendiliğinden
önerme; kullanıcı açıkça isterse aynı adımları izle, 1. adımı atla ve
akademik kelime kullanma.

Çıktı tek bir zip dosyasıdır: içinde `.tex`, `kaynaklar.bib`, metindeki
resimler ve (verildiyse) derginin şablon dosyaları, hepsi en üst düzeyde.
Hoca bu zip'i Overleaf'e yükler. Hocaya "LaTeX", "derleme", "natbib" gibi
kelimeler söyleme; "Overleaf dosyası" de.

## Yasaklar

- Atıflar yalnız `[@anahtar]` biçiminde olabilir; `kaynaklar.bib`'de olmayan
  anahtar uydurma, `.tex` içine elle `\cite` yazma. Pandoc üretir.
- Hocanın taslağına dokunma; değişiklik gerekiyorsa `.divit/gecici/`
  altındaki kopyada yap.
- Zip'i ya da paketi var olan bir dosyanın üstüne yazma; ad çakışırsa
  sonuna `-2` ekle.
- "Tek tıkla Overleaf'te aç" vaat etme: bu bilgisayardaki dosyayla olmuyor.

## Akış

1. **Kaynak doğrulama.** Taslaktaki her `[@anahtar]`'ı Grep ile bul;
   `kaynaklar/dogrulama.md`'de aynı `[@anahtar]` ✅ ile yoksa ya da dosya
   yoksa hocaya söyle: "Bu metindeki <n> atıf henüz doğrulanmadı. Overleaf'e
   göndermeden önce kontrol edeyim mi?" Evet → `divit-akademik:kaynak-dogrula`,
   sonra devam. Hayır → "Doğrulanmadan göndermek istediğinizden emin misiniz?"
   diye bir kez daha sor; açık "evet" gelmeden paketi hazırlama. Kararı
   günlüğe yaz. Her soruda cevabı bekle; 2. adımın sorusunu bununla
   birlikte sorma.
2. **Şablon.** 1. adım bittikten sonra tek soru sor: "Derginin Overleaf
   şablonu var mı? (evet/hayır)" Hayır → standart biçimle devam. Evet →
   "Şablon dosyalarını klasöre koyun, hazır olunca söyleyin." de ve bekle.
   Şablon zip içinde geldiyse hocadan zip'i açıp içindeki dosyaları
   sohbete sürüklemesini iste (zip açmak Divit'in işi değil). Kullanılacak
   dosyalar `.cls`, `.sty`, `.bst` uzantılılardır.
3. **Paket klasörü:** `cikti/<ad>-overleaf-<YYYY-AA-GG>/` (aşağıda `<paket>`).
   `kaynaklar.bib`'i (kökte ya da `kaynaklar/` altında; Glob ile bul) Read
   ile oku, aynen `<paket>/kaynaklar.bib` olarak Write ile yaz. Şablon
   dosyalarını da aynı yolla `<paket>/` içine kopyala. Klasörü Write açar.
4. **`.tex` üretimi** — tek satır; `<filtre>` SKILL.md'de yazan tam yoldur,
   `<taslak-klasörü>` taslağın bulunduğu klasör (resimler oradan okunur),
   `<dil>` metnin dili (`tr`, `en`):
   - Mac: `~/.divit/araclar/pandoc "<taslak>.md" -t latex -s --natbib --bibliography kaynaklar.bib -M lang=<dil> --resource-path="<taslak-klasörü>" --lua-filter="<filtre>" -o "<paket>/<ad>.tex"`
   - Windows: `& "<pandoc>" "<taslak>.md" -t latex -s --natbib --bibliography kaynaklar.bib -M lang=<dil> --resource-path="<taslak-klasörü>" --lua-filter="<filtre>" -o "<paket>/<ad>.tex"`

   `--bibliography kaynaklar.bib` burada dosya okumaz, `.tex`'e paketteki
   dosyanın adını yazar; kaynakça Overleaf'te oluşur. Filtre resimleri
   pakete kopyalar ve sondaki boş "Kaynakça" başlığını atar (LaTeX kendi
   başlığını basar). Şablon varsa satıra ekle: `.cls` için
   `-V documentclass=<cls adı, uzantısız>`; `.bst` için
   `-V biblio-style=<bst adı, uzantısız>`. Şablon `biblatex` istiyorsa
   (şablonun `.tex` örneğinde `\usepackage{biblatex}` geçer) `--natbib`
   yerine `--biblatex`.
5. **Denetim.** `<paket>/<ad>.tex`'te Grep ile `\\cite` ara. Taslakta atıf
   varken hiç çıkmadıysa paketi verme; atıf biçimini hocaya göster.
   pandoc "Could not fetch resource" uyarısı verdiyse o resmin adını söyle.
6. **Zip** — tek satır:
   - Mac: `zip -j -r "<paket>.zip" "<paket>"`
   - Windows: `Compress-Archive -Path "<paket>/*" -DestinationPath "<paket>.zip"`
7. **Hocaya:**

   > Overleaf dosyanız hazır: `<paket>.zip` (tam yol). Overleaf'te
   > **New Project → Upload Project** ile bu zip'i seçin; metin, kaynakça ve
   > resimler birlikte açılır. Kaynakçayı dergi biçimine göre Overleaf'te
   > değiştirmek isterseniz söyleyin, birlikte bakalım.

   Şablon verildiyse ekle: "Derginin başlık bölümü farklı alanlar
   isteyebilir (yazar adresi, özet vb.); Overleaf'te ilk sayfaya bir bakın."
   Ardından klasörü `open` / `Invoke-Item` ile aç.

## Bilinen sınırlar

- Bu bilgisayarda deneme derlemesi yapılmaz; ilk derleme Overleaf'tedir.
  Hata çıkarsa hoca ekranda gördüğünü söyler, düzeltme taslakta yapılır.
- Word'deki değişiklik izleri ve yorumlar LaTeX'e taşınmaz.
- Metin Overleaf'te düzenlenirse Divit'teki taslakla ayrışır; hangisinin
  asıl olduğunu hocaya bir kez sor ve `gorevler.md`'ye yaz.
