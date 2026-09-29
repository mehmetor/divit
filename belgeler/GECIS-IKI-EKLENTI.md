# Kurulu hocada iki eklentiye geçiş

Akademik işler (tez-kontrol, sinav, yayin-oncesi, kaynak-dogrula,
bolum-yaz) ayrı `divit-akademik` eklentisine taşındı. Bugün kurulu olan
hocanın makinesinde yalnız `divit` var. Bu belge Mehmet'in o makinede
yapacağı geçişi yazar.

## Ne zaman

**Yayından sonra, aynı gün.** Şablonda `autoUpdate: true` olduğu için
çekirdek eklenti (`divit`) hocanın bir sonraki açılışında kendiliğinden
güncellenir; akademik eklenti ise kurulum yenilenene kadar **yoktur**.
Arada hoca tez, sınav ya da atıf işi isterse Divit işe girişmez,
kurulumu yenilemeyi önerir (provada denendi: yalnız çekirdek yüklü
akademisyen klasöründe "şu tezi oku" → "Tezi okuyamadım: bu iş için
Divit'in kurulumunu bir kez yenilemek gerekiyor… Yenilemeye başlayayım
mı?"). Bu bir güvenlik ağıdır; boşluğu uzatma.

## Adımlar — Mac

1. Claude uygulamasını kapat.
2. Terminal'i aç, kurulum komutunu **değişkensiz** çalıştır (tür
   satırı yok → akademisyen; hocanın dosyalarına dokunulmaz):

   ```bash
   curl -fsSL https://divit.simetri.app/kur.sh | bash
   ```

3. Çıktıda iki eklentinin de kurulduğunu gör (`divit` ve
   `divit-akademik`). "Üniversite işleri eklentisi şimdi kurulamadı"
   uyarısı çıkarsa yayın henüz tamamlanmamıştır; birkaç dakika sonra
   komutu yeniden çalıştır.
4. Claude uygulamasını aç → Code sekmesi → Divit klasörü.

## Adımlar — Windows

1. Claude uygulamasını kapat.
2. PowerShell'i aç (yönetici gerekmez), kurulum komutunu **değişkensiz**
   çalıştır:

   ```powershell
   irm https://divit.simetri.app/kur.ps1 | iex
   ```

3. Çıktıda iki eklentinin de kurulduğunu gör. Uyarı çıkarsa Mac'teki
   3. adım gibi.
4. Claude uygulamasını aç → Code sekmesi → Divit klasörü.

## Kontrol (iki sistemde aynı)

- Kutuya `/` yaz, `divit-akademik` yaz: `tez-kontrol`, `sinav`,
  `yayin-oncesi`, `kaynak-dogrula`, `bolum-yaz` görünmeli.
  Komut adları artık `/divit-akademik:<ad>` (ör.
  `/divit-akademik:tez-kontrol`); kılavuz ve kart bu adlarla yenilendi.
- `/divit:` altında kitap-duzenle ve kitap-derle de görünür; hoca kitap
  yazıyorsa kullanabilir, türü değişmez.
- Klasörde yeni dosya belirmemeli; kılavuz yine `KILAVUZ.html`.
  (Mac'te sınandı: eski kurulumun üzerine yeni betik → yeni dosya ya da
  klasör yok, `KILAVUZ.html`/`KART.html` yerinde,
  `.claude/settings.local.json`'da iki eklenti de `true`.)
- "merhaba" yaz: Divit her zamanki gibi açılmalı.

Windows'ta `kur.ps1` bu işte sınanmadı (`belgeler/YAPILACAKLAR.md` →
"Doğrulanmayı bekleyenler"); geçişi o makinede ilk kez yaparken çıktıyı
dikkatle oku.
