# `yeni` kanalı — yayın ve yalıtılmış gerçek kurulum sınaması

Tarih: 2026-09-30. Kaynak: `son` dalı (cfc2e05) + `yayinla.sh --kanal`.
Eklenti sürümleri: `divit` c7b56e733a47, `divit-akademik` fb29c366bf04.

## Sonuç

| # | Denetim | Sonuç |
|---|---|---|
| 1 | `bash -n yayinla.sh`; argümansız kuru çalıştırma eskisiyle aynı çıktı (diff boş) | **GEÇTİ** |
| 2 | `--kanal main`, `--deneme develop`, `--kanal foo` reddedilir | **GEÇTİ** |
| 3 | `./yayinla.sh --kanal yeni` → `yeni` dalı oluştu | **GEÇTİ** |
| 4 | GitHub `yeni`: marketplace.json iki url'si `/yeni/dagitim/…`, indirilen zip'lerin sha256'sı marketplace'tekiyle aynı | **GEÇTİ** |
| 5 | GitHub `yeni`: `hoca-paketi/Divit/.claude/settings.json` pazar yeri `…/divit/yeni/.claude-plugin/marketplace.json` | **GEÇTİ** |
| 6 | Yazar kurulumu (ayrı geçici HOME): iki eklenti `yeni` zip'lerinden, pazar yeri `yeni`, `kanal.txt` = yeni, `data-rol="yazar"`, klasörde `divit-akademik` kapalı | **GEÇTİ** |
| 7 | Akademisyen kurulumu (ayrı geçici HOME, `DIVIT_TUR`'suz): aynı, `data-rol="akademisyen"`, iki eklenti açık | **GEÇTİ** |
| 8 | Menü (`claude -p` init, klasörün içinden): yazarda `divit-akademik:` yok, 14 `divit:`; akademisyende beş `divit-akademik:` | **GEÇTİ** |
| 9 | `DIVIT_DAL`'sız yeniden kurulum: iki klasör `yeni`de kaldı (kanal.txt, settings.json, known_marketplaces) | **GEÇTİ** |
| 10 | main değişmedi: `origin/main` ve main marketplace.json sha'sı önce/sonra aynı | **GEÇTİ** (aşağıda) |
| 11 | `/opt/homebrew/bin/claude --version` önce/sonra aynı | **KALDI** — resmî kurulum npm genel kopyayı kaldırdı (aşağıda) |

## Yöntem

Her tür için ayrı geçici HOME (`$T`). Önce resmî Claude Code:

```bash
curl -fsSL https://claude.ai/install.sh | HOME=$T bash
$T/.local/bin/claude --version     # 2.1.285 (≥ 2.1.280)
```

Sonra GitHub'daki `yeni` dalından kurulum:

```bash
curl -fsSL https://raw.githubusercontent.com/mehmetor/divit/yeni/kur.sh | \
  env HOME=$T CLAUDE_CONFIG_DIR=$T/.claude DIVIT_HEDEF=$T/Documents/Divit \
      DIVIT_TEST=1 DIVIT_DAL=yeni [DIVIT_TUR=yazar] bash
```

`DIVIT_TEST=1` burada yalnız kılavuzun tarayıcıda açılmasını atlatır:
Claude uygulaması `/Applications`'da kurulu olduğu için 1. adım zaten
"Kurulu." dedi; `$T/.local/bin/claude` 2.1.285 olduğundan 2. adımın
sınama dalı devreye girmedi; `CLAUDE_CONFIG_DIR` verildiği için 5. adım
eklentileri gerçekten kurdu. Pandoc ve pdfcpu `$T/.divit/araclar`'a indi.
kur.sh'de uygulama indirmesini ayrıca atlatan bir değişken yok; gerek
olmadı.

Menü: klasörün içinden `claude -p merhaba --output-format stream-json
--verbose --max-turns 1` (aynı geçici HOME), ilk satırdaki `system init`
olayının `plugins` ve `slash_commands` alanları.

## Çıktılar

```
yazar  kur.sh çıkış 0
  Kullanıcı türü: yazar · Kanal: yeni · Kurulu ve güncel (sürüm c7b56e733a47).
  kanal.txt: yeni · data-rol="yazar"
  settings.local.json enabledPlugins: divit@divit true, divit-akademik@divit false
  pazar yeri url: https://raw.githubusercontent.com/mehmetor/divit/yeni/.claude-plugin/marketplace.json
  plugin list: divit c7b56e733a47, divit-akademik fb29c366bf04 (kullanıcı düzeyinde kurulu)
  pazar yeri önbelleği zip'leri: …/yeni/dagitim/divit-c7b56e733a47.zip, …/yeni/dagitim/divit-akademik-fb29c366bf04.zip
  init eklentiler: divit (cache/divit/divit/c7b56e733a47)
  divit-akademik: []
  divit: bakim disa-aktar eposta gelistirici-ihtiyac-gorusmesi gelistirici-paylas geri-al
         guncelleme kitap-derle kitap-duzenle kurulum pdf saglik yardim yazisma
akademisyen  kur.sh çıkış 0
  Kullanıcı türü: akademisyen · Kanal: yeni · Kurulu ve güncel (sürüm c7b56e733a47).
  kanal.txt: yeni · data-rol="akademisyen"
  settings.local.json enabledPlugins: ikisi de true
  init eklentiler: divit (…/c7b56e733a47), divit-akademik (…/fb29c366bf04)
  divit-akademik: bolum-yaz kaynak-dogrula sinav tez-kontrol yayin-oncesi
yeniden kurulum (DIVIT_DAL yok), iki klasör:
  Kanal: yeni · kanal.txt yeni · settings.json ve known_marketplaces → /divit/yeni/
```

`guncelleme` skill'i (kurulu `yeni` zip'inde) kanalı `.divit/kanal.txt`'den
okur ve `…/divit/<kanal>/kur.sh | DIVIT_DAL=<kanal> bash` komutunu kurar.
Uygulamada "güncelle" denemesi Mehmet'e kaldı.

## main değişmedi

```
önce  origin/main caebb153ad2ec4017e91d18733e564ea0bf4446b
      main marketplace.json shasum 0cbe952d325a648cb11a6a57fb00235a75fdb67f
sonra origin/main caebb153ad2ec4017e91d18733e564ea0bf4446b
      main marketplace.json shasum 0cbe952d325a648cb11a6a57fb00235a75fdb67f
```

## Bulgular

- **Resmî Claude Code kurulumu npm genel kopyasını kaldırıyor.**
  `curl … install.sh | HOME=$T bash` HOME geçici olsa da
  `npm uninstall --global @anthropic-ai/claude-code` çalıştırıyor
  (`$T/.npm/_logs`'da iki kayıt, 14:47:15Z ve 14:47:21Z). npm öneki
  `/opt/homebrew` olduğundan `/opt/homebrew/bin/claude` (2.1.278) gitti.
  Geri kurmak için izin verilmedi; Mehmet elle kurar:
  `npm install -g @anthropic-ai/claude-code@2.1.278`. Hocanın makinesinde
  aynı davranış istenen şeydir (eski npm kopyası yerine yenisi); sınamada
  ise geçici HOME yetmez, npm öneki de geçici yapılmalı
  (`NPM_CONFIG_PREFIX=$T/npm`).
- Klasör güvenilmediği için `claude -p` "Ignoring 33 permissions.allow
  entries … not trusted" yazıyor. Uygulamada ilk klasör seçiminde güven
  sorusu çıkmalı; çıkmazsa allow kuralları uygulanmıyor olabilir (skill
  `allowed-tools` yedeği devrede).
- Kurulumun son satırı `yeni` için de `Deneme kanalı: yeni` diyor (kur.sh
  ve kur.ps1'de etiket). Kanal doğru; etiket ayrı bir düzeltme.
