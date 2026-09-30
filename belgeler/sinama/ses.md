# Ses kaydı — sınama

Tarih: 2026-10-01. Dal: `orc/yonetici-kitap-yazarlari-i/ses`. Skill: `divit:ses`.

## Yöntem

`hoca-paketi/Divit` → `/tmp/divit-ses/aka` (tür satırı yok = akademisyen).
`.claude/settings.json` → `settings.local.json` (`extraKnownMarketplaces`
çıkarıldı, `Read(<worktree>/plugins/**)` eklendi). Komut:

```
ENABLE_CLAUDEAI_MCP_SERVERS=false claude -p "<istem>" \
  --setting-sources project,local --permission-mode acceptEdits \
  --plugin-dir <worktree>/plugins/divit --model claude-sonnet-5-5 \
  --strict-mcp-config --mcp-config '{"mcpServers":{}}'
```

İstem: kurgusal, Word Transkribe biçiminde dağınık döküm ("Speaker 1
00:00:03", bölünmüş satırlar, "ıı/şey", anlamsız "xqzr mbrelda", 00:26'dan
05:31'e atlama), "adı ak-gorusme, iki sürüm".

## Sonuç — geçti

- İki dosya: `notlar/ses-metin/ak-gorusme-2026-10-01.md` ve
  `ak-gorusme-duzeltilmis-2026-10-01.md`; başlık satırları skill biçiminde.
- Etiketler `**Konuşmacı 1/2:**`; bölünmüş satırlar birleşti; zaman damgası
  yerine tek `[dk 05]`.
- Anlamsız parça `[anlaşılmadı: "xqzr mbrelda"]`; tahmin edilmedi.
- Ağızdan sürümde dolgu kaldı; düzeltilmişte çıktı, "domates de" → "domateste",
  anlam değişmedi, yeni cümle yok.
- 5 dakikalık atlamayı kendiliğinden bildirdi. Günlüğe satır yazıldı.

## Bulgu ve düzeltme

- Cevapta "Konuşmacı 1 büyük ihtimalle Ayşe Kaya" dedi (yanlış; 1 hocaydı).
  Dosyaya yazmadı. Skill'e "kim olduğunu cevapta da tahmin etme; sor" eklendi;
  yeniden koşulmadı.
- Tarif bölümü (1. adım, Word/Sesli Notlar) bu koşuda sınanmadı; menü adları
  canlı doğrulanmadı (bkz. `belgeler/arastirma/ses-yaziya.md`).
