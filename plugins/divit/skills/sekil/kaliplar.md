# Şekil kalıpları

`sekil` skill'i bu dosyayı Read ile yükler. Kalıplar elle yazılan SVG'dir;
hesabı sen yaparsın, sonuçları yuvarlayıp (bir ondalık yeter) yazarsın.

## Ortak kurallar

- Tuval: `width="640" height="400" viewBox="0 0 640 400"`. Kenar boşluğu:
  sol 70, sağ 20, üst 50, alt 60. Çizim alanı: x 70–620, y 50–340 (yükseklik 290).
- Yazı: `font-family="Arial, Helvetica, sans-serif"`, eksen 12, değer 12,
  başlık 16 kalın. Metin rengi `#222`, ızgara `#ddd`.
- Renkler, sırayla: `#2b6cb0`, `#dd6b20`, `#2f855a`, `#b83280`, `#6b46c1`,
  `#718096`. Tek dizili grafikte yalnız ilki.
- Türkçe sayı: ondalık virgül, binlik nokta (2,5; 12.400). Birim eksen
  başlığında: "Satış (bin adet)".
- Her değer, sütunun ya da noktanın üstünde yazılı olur; okur tahmin etmez.
- Başlık SVG'nin içinde de yazar (y=28, ortada); Word'deki alt yazı ayrıca.
- `<` ve `&` metinde `&lt;` `&amp;` olarak yazılır.

**Eksen ölçeği.** En büyük değerden büyük ya da eşit, 1–2–5×10ⁿ ile biten ilk
"yuvarlak" sayı üst sınırdır (ör. en büyük 437 → 500; 83 → 100; 1.240 → 2.000).
Alt sınır 0. Beş ızgara çizgisi: 0, ¼, ½, ¾, üst. Değerin y'si:
`y = 340 − değer / üst × 290`. Negatif değer varsa sütun yerine çizgi öner
ve kullanıcıya sor.

## Sütun grafik

n değer için: aralık `a = 550 / n`, sütun genişliği `g = a × 0,6`,
i. sütun (0'dan) `x = 70 + i × a + a × 0,2`, yükseklik `h = değer / üst × 290`,
`y = 340 − h`.

```svg
<svg xmlns="http://www.w3.org/2000/svg" width="640" height="400" viewBox="0 0 640 400" font-family="Arial, Helvetica, sans-serif">
  <rect width="640" height="400" fill="#fff"/>
  <text x="320" y="28" text-anchor="middle" font-size="16" font-weight="bold" fill="#222">BAŞLIK</text>
  <!-- ızgara: her çizgi için bir line + solda değer -->
  <line x1="70" y1="340" x2="620" y2="340" stroke="#222"/>
  <line x1="70" y1="267.5" x2="620" y2="267.5" stroke="#ddd"/>
  <text x="62" y="271.5" text-anchor="end" font-size="12" fill="#222">125</text>
  <!-- sütun: rect + üstünde değer + altında etiket -->
  <rect x="X" y="Y" width="G" height="H" fill="#2b6cb0"/>
  <text x="X+G/2" y="Y-6" text-anchor="middle" font-size="12" fill="#222">DEĞER</text>
  <text x="X+G/2" y="358" text-anchor="middle" font-size="12" fill="#222">ETİKET</text>
  <!-- eksen başlığı -->
  <text x="18" y="195" text-anchor="middle" font-size="12" fill="#222" transform="rotate(-90 18 195)">BİRİM</text>
</svg>
```

Etiket uzunsa (10 harften çok) sütun sayısı 6'yı geçiyorsa yatay sütun
öner: aynı hesap, x ve y yer değiştirir.

## Çizgi grafik

Nokta i: `x = 70 + i × 550 / (n − 1)`, `y` ölçekten. Ölçek sıfırdan başlar;
kullanıcı değişimi büyütmek isterse alt sınırı birlikte seç ve eksende yaz.

```svg
<polyline points="X0,Y0 X1,Y1 …" fill="none" stroke="#2b6cb0" stroke-width="2.5"/>
<circle cx="X0" cy="Y0" r="4" fill="#2b6cb0"/>
<text x="X0" y="Y0-10" text-anchor="middle" font-size="12" fill="#222">DEĞER</text>
```

Birden çok dizi: her dizi kendi rengiyle; sağ üstte açıklama (küçük kare +
ad), `x=480`'den başlayarak alt alta 18 aralıkla.

## Pasta grafik

Açı hesabı yok: çevresi 100 olan halka kullanılır. Pay `p_i = değer_i / toplam × 100`
(bir ondalık); önceki payların toplamı `T_i`. Yuvarlama yüzünden toplam
100'den biraz saparsa farkı yalnız çizimde en büyük dilime ver; açıklamada
yazan yüzdeler hesaplandığı gibi kalır. Kullanıcı yüzde verdiyse ve toplam
100 değilse çizme, sor.

```svg
<g transform="translate(220 215) rotate(-90)">
  <circle r="15.9155" fill="none" stroke="#2b6cb0" stroke-width="31.831"
          stroke-dasharray="P0 100" stroke-dashoffset="0" transform="scale(4.5)"/>
  <circle r="15.9155" fill="none" stroke="#dd6b20" stroke-width="31.831"
          stroke-dasharray="P1 100" stroke-dashoffset="-T1" transform="scale(4.5)"/>
</g>
<!-- açıklama sağda: kare + "Ad — %P" -->
<rect x="420" y="Y" width="14" height="14" fill="#2b6cb0"/>
<text x="442" y="Y+12" font-size="12" fill="#222">AD — %P</text>
```

Açıklama satırları `Y = 120 + i × 24`.

## Akış şeması

Kutu: `rect` 180×48, köşe `rx="8"`, dolgu `#ebf4ff`, çizgi `#2b6cb0`; yazı
ortada, 14 harften uzunsa iki satır (`tspan`, dy="16"). Karar: eşkenar
dörtgen (`polygon`), yazı içinde, "Evet/Hayır" okların yanında. Başla/Bitir:
`rx="24"`. Adımlar yukarıdan aşağı, aralık 80. Adım 5'ten çoksa tuval yüksekliğini
artır (`height` ve `viewBox` birlikte).

```svg
<defs><marker id="ok" viewBox="0 0 10 10" refX="10" refY="5" markerWidth="8" markerHeight="8" orient="auto"><path d="M0,0 L10,5 L0,10 z" fill="#2b6cb0"/></marker></defs>
<line x1="320" y1="98" x2="320" y2="130" stroke="#2b6cb0" stroke-width="2" marker-end="url(#ok)"/>
```

## Zaman çizelgesi

Yatay çizgi y=200, x 60–600. Olay i: `x = 60 + (yıl − ilk) / (son − ilk) × 540`
(tarih eşit aralıklı değilse); çizgi üstünde daire, olayları sırayla bir üste
bir alta yaz (y=170 ve y=240), yılı kalın. Tarih kullanıcıdan gelir;
belirsiz tarih `[DOĞRULA]` ile yazılır, çizelgeye konmaz.

## HTML iskeleti

```html
<!doctype html>
<html lang="tr"><head><meta charset="utf-8"><title>BAŞLIK</title>
<style>body{font-family:Arial,Helvetica,sans-serif;max-width:720px;margin:32px auto;padding:0 16px;color:#222}
svg{max-width:100%;height:auto}table{border-collapse:collapse;margin-top:16px}
td,th{border:1px solid #ccc;padding:4px 10px;text-align:right}th:first-child,td:first-child{text-align:left}
.kaynak{font-size:14px;color:#555}</style></head>
<body>
<h1 style="font-size:20px">Şekil NO. BAŞLIK</h1>
<!-- SVG buraya, aynen -->
<p class="kaynak">Kaynak: KAYNAK</p>
<table><tr><th>Kalem</th><th>Değer</th></tr><!-- her değer bir satır --></table>
</body></html>
```

Akış şeması ve zaman çizelgesinde tablo yerine adım/olay listesi (`ol`).
