# Kitap ekleri — editörlü derleme ve Word'de değişiklik izleme

Tarih: 2026-10-01. Dal: `orc/yonetici-kitap-yazarlari-i/kitap-ek`.
Skill: `kitap-derle` (+ yeni `editorlu.md`), `kitap-duzenle` (+ yeni `izleme.md`).

## Pandoc ölçümü (izlenen değişiklik)

`/opt/homebrew/bin/pandoc` 3.10.2. Pandoc markdown'da
`[eski]{.deletion author="Divit" date="…"}[yeni]{.insertion …}` span'ları
docx yazıcısında Word'ün izlenen değişikliklerine dönüşür.
Deneme: 2 silme + 2 ekleme → `word/document.xml` içinde `<w:del ` 2, `<w:ins ` 2.
Geri okuma `--track-changes=all` ile aynı span'ları verir.

Not: `document.xml` tek satırdır; `grep -c w:ins` 1 döner. Sayım için
`grep -o '<w:ins ' | wc -l`. Girdi `-t markdown` olmalı; gfm span taşımaz.

## Yöntem

`/tmp/divit-kitap-ek/{derle,duzenle}` — `hoca-paketi/Divit` kopyası; CLAUDE.md'de
araç yolları dolduruldu, `settings.json` → `settings.local.json`
(`extraKnownMarketplaces` çıkarılmış) + allow `Read(//<worktree>/plugins/**)`.
İlk koşuda allow tek `/` ile yazılmıştı; eklenti ek dosyaları reddedildi
(`permission_denials` 4). `//` ile yeniden koşuldu: reddedilen 0.
Profil `Kullanıcı türü: yazar`. Komut:

```
ENABLE_CLAUDEAI_MCP_SERVERS=false claude -p "<istem>" \
  --setting-sources project,local --permission-mode acceptEdits \
  --plugin-dir <worktree>/plugins/divit --plugin-dir <worktree>/plugins/divit-akademik \
  --model sonnet --strict-mcp-config --mcp-config '{"mcpServers":{}}' \
  --output-format stream-json --verbose
```

## 1. Editörlü derleme (üç kurgusal yazar)

Malzeme: Ayşe Demir (kanal 1987, "siz", metin içi atıf), Mert Yılmaz
(kanal 1992, "sen", dipnot, dosyada ad yok), Selin Ak (kaynaksız sav).

Sonuç: `yazarlar.md` (yazar, başlık, dosya; unvan/e-posta/teslim boş,
uydurulmadı), `envanter.md`, `plan.md` (iki içindekiler kurgusu, başlıklar
"— Yazar Adı" ile), `duzenleme/bicim-birligi.md`,
`duzenleme/yazar-istekleri/<yazar>-2026-10-01.md` × 3. 1987↔1992 ve
yüzde 40'ın iki ayrı kaynağı `[DOĞRULA]` ile iki alıntı yan yana; hitap
farkı yalnız listelendi. `malzeme/` değişmedi.

İlk koşuda (SKILL.md yönlendirmesi yolları anmıyorken) dosyalar kök
klasöre, istekler tek dosyaya yazıldı; yönlendirmeye yollar eklendi.
Kalan küçük sapma: yazarlar.md durumu "düzeltme istendi (gönderilmedi)"
yazıldı → `editorlu.md`'de "editör gönderdiğini söyleyince" diye netleşti
(yeniden koşulmadı).

## 2. Word'de değişiklik izleme (3 öneri)

Asıl: `asil/yonetim-notlari.docx`; `duzenleme/oneriler-01.md`'de 3 onaylı
öneri (yazım düzeltme, cümle silme, "geçen yıl" → "2025 yılında").
İstem: "Word'de değişiklik izleme ile görmek istiyorum … Şablonum yok."

Sonuç: `cikti/yonetim-notlari-divit-oneriler-2026-10-01.docx` —
`<w:ins ` **2**, `<w:del ` **3** (silme önerisi yalnız w:del üretir; beklenen).
`izleme.md` okundu, reddedilen izin 0, asıl docx değişmedi (tarih aynı),
öneri dosyasında Durum → `Word'e işlendi`. Kullanıcıya: "Gözden Geçir
sekmesinden Kabul Et ya da Reddet", biçim uyarısı tek cümle, "asıl
dosyanıza dokunmadım".

Word'de elle açılıp Kabul Et/Reddet denenmedi (yalnız XML sayımı).
Windows koşusu yapılmadı.
