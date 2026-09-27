---
name: saglik
description: Divit'in bu bilgisayarda düzgün çalışıp çalışmadığını sessizce dener — Word okuma, dosya yazma, izinler, profil. Hoca "Divit çalışıyor mu", "bir sorun var", "Word'ü okuyamıyorsun", "kontrol et kendini" dediğinde, kurulumun sonunda ya da bir dosya işlemi beklenmedik biçimde başarısız olduğunda kullan.
---

# Sağlık denetimi

Amaç: bir sorun hocanın işinin ortasında değil, önceden görünsün.

## Yasaklar

- Hocanın dosyalarına dokunma. Denemeleri yalnızca `.divit/gecici/`
  içinde yap.
- Hiçbir şeyi silme. Deneme dosyaları `.divit/gecici/` altında kalır.
- Hocaya teknik ayrıntı gösterme. Sonuç tek paragraftır.
- İzin sorusu çıkaracak bir deneme yapma. Aşağıdaki komutlar klasörün
  izin listesindedir; başka komut ekleme.

## Denemeler — sırayla, sessizce

1. **Yazma:** `.divit/gecici/saglik.md` dosyasına bugünün tarihiyle
   `# deneme` yaz (Write), sonra oku (Read).
2. **Word:** pandoc ile bu dosyayı Word'e, sonra geri metne çevir:
   - Mac: `"$DIVIT_PANDOC" ".divit/gecici/saglik.md" -o ".divit/gecici/saglik.docx"`
     ve `"$DIVIT_PANDOC" ".divit/gecici/saglik.docx" -t gfm -o ".divit/gecici/saglik-geri.md"`
   - Windows: `& $env:DIVIT_PANDOC ".divit/gecici/saglik.md" -o ".divit/gecici/saglik.docx"`
     ve `& $env:DIVIT_PANDOC ".divit/gecici/saglik.docx" -t gfm -o ".divit/gecici/saglik-geri.md"`
   Geri gelen metinde "deneme" var mı, bak.
3. **PDF okuma:** `${CLAUDE_PLUGIN_ROOT}/scripts/deneme.pdf` dosyasını
   Read ile oku; içinde "Divit PDF deneme" yazmalı. PDF çıktısı Divit'te
   Word'ün "PDF olarak kaydet" özelliğiyle yapılır; onu deneme, yalnızca
   Word okuma-yazma denemesinin geçtiğini bil.
   **PDF aracı:** deneme PDF'ini iki kez birleştir ve sayfa sayısına bak:
   - Mac: `"$DIVIT_PDFCPU" merge ".divit/gecici/saglik.pdf" "${CLAUDE_PLUGIN_ROOT}/scripts/deneme.pdf" "${CLAUDE_PLUGIN_ROOT}/scripts/deneme.pdf"`
   - Windows: `& $env:DIVIT_PDFCPU merge ".divit/gecici/saglik.pdf" "$env:CLAUDE_PLUGIN_ROOT/scripts/deneme.pdf" "$env:CLAUDE_PLUGIN_ROOT/scripts/deneme.pdf"`
   `.divit/gecici/saglik.pdf` önceden varsa araç üstüne yazmaz; adına saat ekle.
   Sonra `info` ile bak: 2 sayfa olmalı.
4. **Profil:** `.divit/profil/` dosyaları var mı, `kimlik.md` doldurulmuş mu.
5. **Klasörler:** `tez-kontrol/`, `yazilar/`, `kaynaklar/`, `cikti/` var mı.
   Eksik olanı `gorevler.md`'ye bakmadan oluşturma; yalnızca not et.
6. **Kural yükü:** klasördeki `CLAUDE.md` "divit:kurallar" satırını
   içeriyor mu.
7. **Hatırlatma durumu:** `.divit/hatirlatma.md`'de `son-bakim` 60
   günden eski mi.

## Sonuç

Her şey yolundaysa:
> "Kontrol ettim; her şey çalışıyor. Word ve PDF dosyalarınızı
> okuyabiliyor, Word dosyası hazırlayabiliyorum. PDF birleştirme ve
> sayfa işleri de çalışıyor."

Sorun varsa yalnızca hocayı ilgilendiren sonucu ve tek adımı söyle:

| Bulgu | Hocaya |
|---|---|
| pandoc çalışmıyor | "Word dosyalarını şu an okuyamıyorum. Kurulum komutunu bir kez daha çalıştırmak düzeltir; yardım gerekirse Mehmet Bey'e yazın. O zamana kadar PDF verebilirsiniz." |
| PDF okunamıyor | "PDF dosyalarını şu an okuyamıyorum. Word hâlini verebilir misiniz?" |
| PDF aracı çalışmıyor | "PDF birleştirme ve sayfa işlerini şu an yapamıyorum. Kurulum komutunu bir kez daha çalıştırmak düzeltir." |
| profil boş | `kurulum` skill'ine geç. |
| CLAUDE.md'de kural satırı yok | "Klasör ayarlarımdan biri eksik. Kurulum komutunu yeniden çalıştırmak düzeltir." |
| klasör eksik | "Şu klasör yok: … Açayım mı?" Onayla oluştur. |
| bakım gecikmiş | `bakim` skill'inin bakım önerisini yap. |

Her sorunu `.divit/sorunlar.md`'ye iş türü "sağlık denetimi" ile kaydet.
`gunluk.md`'ye tek satır: `… · sağlık denetimi · — · <sonuç>`.
