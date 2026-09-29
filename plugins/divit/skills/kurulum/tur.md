# Tür değiştirme

Kullanıcı "türümü değiştir", "ben hoca değilim", "üniversitedeyim" dediğinde
`kurulum` bu dosyayı yükler. `SKILL.md`'deki Kurallar burada da geçerlidir.

## Yasaklar

- **Hiçbir şey silinmez.** Klasörler, profil dosyaları, günlük yerinde kalır.
- Onaysız hiçbir şeyi değiştirme; her adımı önce söyle.
- `kimlik.md`'de yalnız `Kullanıcı türü:` satırını değiştir; başka satıra dokunma.
- Klasör ayarlarına (`.claude/` altı) yazma. Yeni işlerin menüsünü ve kılavuzu
  yalnız kurulumun yeniden çalışması getirir.
- Komutları zincirleme; her klasör için ayrı ve tek bir komut.

## Akış

1. `SKILL.md` 0. adımındaki tek soruyu aynen sor. Cevap bugünkü türle
   aynıysa "Zaten öyle ayarlı." de ve bitir.
2. Yeni türü göster, onay al. `.divit/profil/kimlik.md`'de ilk başlığın hemen
   altındaki satırı `Kullanıcı türü: akademisyen` ya da `Kullanıcı türü: yazar`
   yap (satır yoksa ekle).
3. Yeni türün klasörü yoksa öner, onayla aç:
   - akademisyen: `tez-kontrol/gelen/`, `tez-kontrol/rapor/`
   - yazar: `kitaplar/`
   - Mac: `mkdir -p "<klasör>"` · Windows: `New-Item -ItemType Directory -Force "<klasör>"`
4. Eski türün klasörü için sor: "Eski klasörü olduğu gibi bırakayım mı,
   arşive mi kaldırayım?" Yalnız "arşive" derse `arsiv/` altına taşı:
   Mac `mv "<klasör>" "arsiv/"` · Windows `Move-Item "<klasör>" "arsiv/"`.
   Varsayılan: olduğu gibi bırak.
5. Sade dille söyle:
   > "Size uygun işler ve kılavuz, kurulum bir kez daha çalışınca gelir.
   > İsterseniz şimdi birlikte yapalım."
   Evet derse `guncelleme` skill'inin kurulum adımına geç (kurulum türü
   `kimlik.md`'deki satırdan okur).
6. `.divit/gunluk.md` sonuna ekle:
   `YYYY-AA-GG SS:DD · tür değişti · kimlik.md · <eski> → <yeni>`.
7. Profil yeni türe uymuyorsa (ör. yazar oldu ama kimlik akademik bilgilerle
   dolu) tanışmayı yeni türün akışıyla tamamlamayı öner: yazar için
   `${CLAUDE_PLUGIN_ROOT}/skills/kurulum/yazar.md` 2-5. adımlar, akademisyen için
   `SKILL.md` 1-6. adımlar. Var olan bilgiyi silme; yeni bilgiyi ekle.
