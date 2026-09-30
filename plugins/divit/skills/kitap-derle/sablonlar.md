# Kitap derleme — tablo ve iskelet biçimleri

`kitap-derle` skill'inin yardımcı dosyası.

## envanter.md

```markdown
# Envanter — <çalışma adı>, <YYYY-AA-GG>
Toplam: <n> parça · yaklaşık <kelime> kelime

| # | Dosya | Başlık | Tarih | Tür | Kelime | Ana fikir | Nerede yayımlandı | İzin |
|---|---|---|---|---|---|---|---|---|
| 1 | malzeme/... | ... | 2014-03 | köşe yazısı | 650 | <tek cümle> | <yayın yeri ya da "yayımlanmadı"> | [İZİN] soru bekliyor |
```

- Tür: köşe yazısı · konuşma · röportaj · sunum · not.
- İzin sütunu: boş (sorun yok) · `[İZİN] soru bekliyor` ·
  `[İZİN] <kullanıcının cevabı, tek cümle>`.
- Tarih ya da yayın yeri bilinmiyorsa "?" yaz; tahmin etme.

## Konu haritası (plan.md'de)

```markdown
## Konu haritası
### <küme adı> — <parça no'ları>
<kümenin ortak fikri, tek cümle>

### Tekrarlar
- <anekdot ya da fikir, kısa ad>: <parça no'ları> — hangisi kalsın? (soru bekliyor)

### Birbirini tutmayanlar
- <ne>: <parça no> "<alıntı>" ↔ <parça no> "<alıntı>"
- <parça no>: "<zaman ifadesi>" [DOĞRULA] — <parça tarihi> ↔ <parça no> "<alıntı>": <hesap, ör. 2008 − 1987 = 21 yıl>

### Eskimiş olabilecekler
- <parça no>: "<alıntı>" [GÜNCELLE] — <neden>

### Kümeye girmeyenler
- <parça no'ları>
```

## İçindekiler kurgusu

```markdown
### Kurgu <A/B/C>: <kronolojik / konuya göre / ders-ilke>
Güçlü yanı: <tek cümle> · Zayıf yanı: <tek cümle>
| Bölüm | Başlık (çalışma) | Parçalar | Eksik |
|---|---|---|---|
| 1 | ... | 3, 7 | — |
| 2 | ... | 1 | Bu bölüm için sizin anlatmanız gerekir: <ne> |
```

## Bölüm iskeleti — taslak/<bolum-no>-<kisa-ad>.md

```markdown
# <bölüm no>. <çalışma başlığı>
Bölümün fikri: <tek cümle, plan.md'den>

## <parça başlığı>
*Kaynak: malzeme/<dosya> · <tarih> · <tür>*

<kullanıcının metni, değiştirilmeden>

[BAĞLANTI: <önceki parçadan buna geçiş için ne gerekiyor>]

## <sonraki parça başlığı>
...
```

- Parçanın bir kısmı alınırsa atlanan yere `(…)` koy; cümle ekleme.
- Divit'in önerdiği geçiş cümlesi iskelette değil öneri dosyasında durur;
  onaylanırsa `[TASLAK]` işaretiyle iskelete girer, kullanıcı kendi
  cümlesiyle değiştirince işaret kalkar.

## Konuşma dilinden yazı diline — duzenleme/oneriler-<bolum-no>.md

```markdown
# Öneriler — <bölüm no>. bölüm, <YYYY-AA-GG>
| # | Yer | Önce | Sonra | Neden | Durum |
|---|---|---|---|---|---|
| 1 | <parça>, 2. paragraf | "yani şimdi bakın, biz o zaman..." | "O zaman biz..." | konuşma dolgusu | bekliyor |
```

Yalnız dolgu, yarım cümle, tekrar ve konuşmaya özgü gönderme
("burada gördüğünüz slaytta") önerilir. Kullanıcının deyimleri, mizahı
ve anlatım tadı korunur.

## plan.md

```markdown
Durum: <adım> · <sıradaki iş> · <YYYY-AA-GG>
# <çalışma adı>
- İddia: <tek cümle> · Okur: <...>
- Seçilen kurgu: <A/B/C>
## Konu haritası
## İçindekiler
## Açık sorular
- <tekrar eden anekdot, [İZİN] cevabı, eksik bölüm>
```
