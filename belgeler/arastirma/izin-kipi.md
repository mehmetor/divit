# İzin kipi — Otomatik (auto) araştırması

Tarih: 2026-10-01 · Bu Mac'te Claude Code 2.1.286.
Bugünkü durum: `hoca-paketi/Divit/.claude/settings.json` →
`"defaultMode": "acceptEdits"`; kılavuz Otomatik'i öneriyor.

## Otomatik kip nedir?

Claude rutin izin sorularını sormadan çalışır; her kabuk komutu, ağ isteği
gibi eylemden önce **ayrı bir denetleyici model** eylemin isteğe uyup
uymadığına bakar. İstek dışına taşan, tanımadığı bir yere giden ya da
okunan bir metnin kışkırttığı görünen eylemi durdurur. Varsayılan olarak
durdurduklarından Divit'i ilgilendirenler: indirip kod çalıştırma, hassas
veriyi dışarı gönderme, oturumdan önce var olan dosyaları geri dönüşsüz
silme. `deny` kuralları **her kipte** geçerli (ör. `gelen/`, `hakemlik/`,
`asil/`, `malzeme/` koruması Otomatik'te de sürer); `ask` kuralları yine
sorar. Korumalı yollara (`.claude/` vb.) yazım hiçbir kipte kendiliğinden
onaylanmaz.

Belge ayrıca şunu söylüyor: Otomatik kip Claude'u **açıklama sorusu
sormadan devam etmeye** iter; ancak istem ya da skill açıkça soruya
dayanıyorsa yine sorar. Divit'in "Anladığım: … Doğru mu?" kuralı bu yüzden
`kurallar`'da açık ve zorunlu yazılı kalmalı.

## Kimde açık?

- **Plan:** tüm planlar. Team/Enterprise'da varsayılan açık; yönetici
  `disableAutoMode: "disable"` ile kapatabilir.
- **Model:** Anthropic hesabında Opus 4.6+, Sonnet 4.6+ ya da Fable.
  Divit'in klasör ayarı `claude-opus-5-5` → uygun. Haiku ve eski modeller
  desteklenmez.
- Anthropic sunucu tarafında geçici olarak kapatabilir; o oturum sonuna
  kadar kapalı kalır.
- Uygun değilse Otomatik seçilen oturum **Manuel**'de başlar (sessizce,
  hatasız).
- Masaüstü: Code sekmesinde gönder düğmesinin yanındaki kip seçicide
  **Auto** yalnız kullanılabilirse görünür; ayrı bir Ayarlar anahtarı yok.
- Telefondan Uzaktan Kontrol'de Otomatik **seçilemez**.

## Klasör `settings.json`'da `defaultMode: "auto"` olur mu?

**Hayır.** Belge açık: `.claude/settings.json` ve
`.claude/settings.local.json` içindeki `"auto"` yok sayılır; oturum o
zaman yerleşik varsayılana döner (kullanıcının `~/.claude/settings.json`'ı
da atlanır). `auto` yalnız kullanıcı ayarında (`~/.claude/settings.json`)
ya da kurum yönetimli ayarda geçerli. `bypassPermissions` de klasörde yok
sayılır. Bu, bir klasörün kendini gizlice "sormadan çalış"a almasını
engelleyen bilinçli bir kural.

Yerleşik varsayılan: terminal ve VS Code'da 2.1.283'ten beri `auto`;
`claude -p`'de `default`. **Masaüstü Code sekmesinin yerleşik varsayılanı
belgede yazmıyor.** Masaüstü aynı ayar dosyalarını okur ve **kip
seçicide seçilen kip klasör başına hatırlanır, `defaultMode`'un önüne
geçer** (Plan hariç).

## Karşılaştırma

| | `acceptEdits` (bugün) | `auto` |
|---|---|---|
| Dosya yazma/düzenleme (klasör içi) | Sormaz | Sormaz |
| `mkdir`, `mv`, `cp` vb. | Sormaz | Sormaz |
| pandoc, pdfcpu, dosya açma | Allow kuralı varsa sormaz; yoksa sorar | Denetleyici onaylarsa sormaz |
| Beklenmedik komut (ör. Claude'un bir şey kurmaya kalkması) | **Sorar** — hoca anlamadığı bir soru görür | Denetleyici çoğunu durdurur; indirip çalıştırmayı varsayılan olarak engeller |
| `deny` kuralları | Geçerli | Geçerli |
| Klasörde varsayılan yapılabilir mi | Evet (bugünkü hâl) | **Hayır** |
| Ek maliyet | Yok | Her denetlenen eylemde ek model çağrısı |
| Açıklama sorusu eğilimi | Normal | Daha az soru sorar |

## Öneri

1. **Klasör ayarında `acceptEdits` kalsın.** `auto` yazılırsa yok sayılır
   ve masaüstünün bilinmeyen yerleşik varsayılanına düşer — daha kötü.
2. **Kullanıcı Otomatik'i bir kez kendisi seçsin:** Code sekmesinde
   gönder düğmesinin yanındaki kip seçiciden **Auto**. Seçim o klasör için
   hatırlanır; her oturumda yeniden gerekmez. `kurulum` sonunda ve kılavuzda
   tek satır: "İzin sorularını azaltmak için yazı kutusunun yanındaki
   seçiciden Auto'yu seçin; bir kez yeter." Seçicide Auto yoksa (plan/kurum)
   `acceptEdits` ile devam edilir, bir şey kaybolmaz.
3. **`kur.sh`/`kur.ps1` kullanıcının `~/.claude/settings.json`'ına
   `defaultMode: auto` yazmasın.** Bu hocanın bütün Claude Code
   oturumlarını etkiler; "kurulum hocanın profiline dokunmaz" kararıyla
   çelişir. Ayrıca klasördeki `acceptEdits` zaten önce gelir (klasör ayarı
   kullanıcı ayarından üstündür), yani etkisi de olmaz.
4. `kurallar`'da "Anladığım: … Doğru mu?" ve "onaysız dosya silme/taşıma
   yok" satırları **açık** kalsın; Otomatik kipte soru azaltma eğilimine
   karşı skill'in açık talimatı esas.
5. `saglik` skill'ine bir satır (öneri): oturumun kipi Otomatik değilse ve
   kullanıcı sık izin sorusundan yakınırsa seçiciyi hatırlatsın.

Kılavuza önerilen satır:

> **İzin soruları çok mu?** Yazı kutusunun yanındaki seçiciden **Auto**'yu
> seçin. Divit yine sizin dosyalarınızı korur; bir kez seçmeniz yeter.

## Kalan riskler

- Masaüstü Code sekmesinin yerleşik başlangıç kipi belgede yok; seçici
  hatırlama davranışı pilot makinede bir kez görülmeli.
- Otomatik kipte daha az soru sorulması, belirsiz istekte "Anladığım: …"
  adımını atlatabilir.
- Denetleyici ara sıra zararsız pandoc/PowerShell komutunu durdurabilir;
  hoca bunu hata sanar.

## Kaynaklar

- İzin kipleri — Otomatik kip, gereksinimler, hangi kipte başlanır,
  klasörde `auto` yok sayılır, masaüstü seçicisi:
  https://code.claude.com/docs/en/permission-modes
- Masaüstü — "Choose a permission mode", Auto'nun seçicide görünmesi,
  klasör başına hatırlama: https://code.claude.com/docs/en/desktop
- Mobil — Uzaktan Kontrol'de seçilebilen kipler:
  https://code.claude.com/docs/en/mobile
- İzin kuralları (deny her kipte): https://code.claude.com/docs/en/permissions
- Ayar önceliği: https://code.claude.com/docs/en/settings
- Duyuru: https://claude.com/blog/claude-code-auto-mode
