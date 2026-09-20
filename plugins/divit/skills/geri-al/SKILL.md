---
name: geri-al
description: Bozulan veya istenmeyen bir değişikliği geri alır, çalışmanın önceki hâlini getirir. Hoca "geri al", "bozuldu", "eski hâline döndür", "az önce ne değişti", "kaybettim" dediğinde kullan.
---

# Geri alma

Hocanın en büyük korkusu uydurma atıf değil, **çalışmasını
kaybetmek**. Bu skill o korkuyu karşılar. Hoca git'i hiç görmez;
"git", "commit", "repo" kelimelerini kullanma.

## Akış

1. **Önce göster, sonra dokun.** Ne değiştiğini sade dille anlat:

```bash
git -C "$CLAUDE_PROJECT_DIR" log --format='%h  %ad  %s' --date=format:'%d %b %H:%M' -10
git -C "$CLAUDE_PROJECT_DIR" diff --stat HEAD~1
```

   "Bugün 14:20'de üçüncü bölüme 40 satır eklendi, kaynakça dosyası
   değişti." gibi tercüme et.

2. Hangi noktaya dönüleceğini sor. Tarih ve saatle seçtir.

3. **Geri almadan önce şu anki hâlin yedeğini al** — geri almanın
   kendisi de bir kayıp olabilir:

```bash
git -C "$CLAUDE_PROJECT_DIR" add -A
git -C "$CLAUDE_PROJECT_DIR" commit -q -m "geri almadan önce" || true
git -C "$CLAUDE_PROJECT_DIR" revert --no-edit <hash>   # veya:
git -C "$CLAUDE_PROJECT_DIR" checkout <hash> -- <dosya>
```

4. Tek dosya geri alınacaksa `checkout <hash> -- <dosya>` kullan;
   tüm klasörü geri sarma. Hocanın *istediği* diğer değişiklikleri
   de silersin.

5. **`reset --hard` kullanma.** Hiçbir durumda. Geçmişi yok eder.

6. Sonunda tek cümle: "Üçüncü bölüm dün akşamki hâline döndü,
   diğer dosyalarınız olduğu gibi duruyor."

## Kaza kurtarma

Hoca bir dosyayı kendi sildiyse ve yedek varsa aynı yoldan gelir.
Yedek yoksa (`.divit-vault` dosyası yoksa yedekleme çalışmaz) bunu
dürüstçe söyle ve yedeklemeyi o an kur.
