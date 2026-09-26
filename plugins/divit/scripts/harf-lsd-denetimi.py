#!/usr/bin/env python3
"""Divit — çizelgelerdeki harflendirmenin LSD değeriyle tutarlılığını denetler.

Kural (LSD testi): iki ortalama arasındaki fark LSD'den büyükse ortak harf
taşıyamazlar; küçükse en az bir ortak harf taşımaları gerekir.

Yorum yapmaz, istatistik yeniden hesaplamaz; yalnızca metnin kendi içindeki
tutarlılığa bakar. Sınırdaki farklar (yuvarlama payı) ayrıca işaretlenir.

Kullanım:
    harf-lsd-denetimi.py makale.docx|makale.md|makale.txt [--pay 0.05]
Çıktı: markdown tablo (stdout). Çıkış kodu: 0 sorun yok, 1 sorun var, 2 okunamadı.
"""
import re
import subprocess
import sys
from pathlib import Path

SAYI = r"-?\d+(?:[.,]\d+)?"
HUCRE = re.compile(rf"^({SAYI})\s*([a-zA-Z]*)\*?$")


def metni_oku(yol: Path) -> str:
    if yol.suffix.lower() == ".docx":
        try:
            return subprocess.run(
                ["pandoc", str(yol), "-t", "plain", "--wrap=none"],
                capture_output=True, text=True, check=True).stdout
        except (FileNotFoundError, subprocess.CalledProcessError) as e:
            sys.exit(f"docx okunamadı (pandoc gerekli): {e}")
    return yol.read_text(encoding="utf-8")


def sayi(s: str) -> float:
    return float(s.replace(",", "."))


def satirlari_bul(metin: str):
    """Grid/pipe tablolarında 'değer harf' hücreleri + son hücrede LSD olan satırlar."""
    cizelge, baglam, basliklar = "?", "", []
    for satir in metin.splitlines():
        m = re.match(r"^\s*(Table|Çizelge|Tablo)\s*(\d+)", satir, re.I)
        if m:
            cizelge, baglam, basliklar = f"Çizelge {m.group(2)}", "", []
        if not satir.lstrip().startswith("|"):
            continue
        hucreler = [h.strip() for h in satir.strip().strip("|").split("|")]
        if len(hucreler) < 3:
            continue
        lsd, govde = hucreler[-1], hucreler[:-1]
        degerler = [h for h in govde if HUCRE.match(h)]
        etiketler = [h for h in govde if h and not HUCRE.match(h)]
        if not re.fullmatch(SAYI, lsd) or len(degerler) < 2:
            # başlık satırı olabilir: grup adlarını yakala
            if "LSD" in lsd.upper() or any("LSD" in h.upper() for h in hucreler):
                basliklar = [h for h in govde[1:] if h]
            continue
        if len(etiketler) >= 2:
            baglam = etiketler[0]
            ad = " ".join(etiketler)
        elif etiketler:
            ad = f"{baglam} {etiketler[0]}".strip() if baglam and len(etiketler[0]) < 8 else etiketler[0]
        else:
            ad = baglam
        cift = []
        for h in degerler:
            m = HUCRE.match(h)
            cift.append((sayi(m.group(1)), m.group(2).lower()))
        gruplar = basliklar[-len(cift):] if len(basliklar) >= len(cift) else [f"G{i+1}" for i in range(len(cift))]
        yield cizelge, ad, gruplar, cift, sayi(lsd)


def denetle(metin: str, pay: float):
    bulgular, incelenen = [], 0
    for cizelge, ad, gruplar, cift, lsd in satirlari_bul(metin):
        incelenen += 1
        if not any(h for _, h in cift):
            continue  # harfsiz satır (ns) — denetlenecek bir şey yok
        for i in range(len(cift)):
            for j in range(i + 1, len(cift)):
                (a, ha), (b, hb) = cift[i], cift[j]
                if not ha or not hb:
                    continue
                fark, ortak = round(abs(a - b), 6), bool(set(ha) & set(hb))
                if abs(fark - lsd) < 1e-9:
                    continue  # tam eşitlik: her iki yorum da mümkün
                sinirda = abs(fark - lsd) <= pay * lsd
                if fark > lsd and ortak:
                    tur = "fark > LSD ama ortak harf var"
                elif fark < lsd and not ortak:
                    tur = "fark < LSD ama ortak harf yok"
                else:
                    continue
                bulgular.append((cizelge, ad, f"{gruplar[i]} {a:g} {ha} — {gruplar[j]} {b:g} {hb}",
                                 f"{fark:.2f}", f"{lsd:g}", tur + (" (sınırda, yuvarlama olabilir)" if sinirda else "")))
        # satırda kullanılan harfler ardışık mı? (a,b,f gibi atlama → yazım hatası)
        harfler = sorted({c for _, h in cift for c in h})
        if harfler:
            beklenen = [chr(ord("a") + k) for k in range(ord(harfler[-1]) - ord("a") + 1)]
            eksik = [c for c in beklenen if c not in harfler]
            if eksik and len(eksik) >= 2:
                bulgular.append((cizelge, ad, "harfler: " + ",".join(harfler), "-", f"{lsd:g}",
                                 f"harf dizisinde atlama ({','.join(eksik)} yok) — yazım hatası olabilir"))
    return incelenen, bulgular


def main():
    if len(sys.argv) < 2:
        sys.exit(__doc__)
    pay = 0.05
    if "--pay" in sys.argv:
        pay = float(sys.argv[sys.argv.index("--pay") + 1])
    yol = Path(sys.argv[1])
    if not yol.exists():
        print(f"Dosya yok: {yol}", file=sys.stderr)
        sys.exit(2)
    incelenen, bulgular = denetle(metni_oku(yol), pay)
    print(f"İncelenen çizelge satırı: {incelenen} · Tutarsızlık: {len(bulgular)}\n")
    if bulgular:
        print("| Çizelge | Satır | Karşılaştırma | Fark | LSD | Sorun |")
        print("|---|---|---|---|---|---|")
        for b in bulgular:
            print("| " + " | ".join(b) + " |")
    sys.exit(1 if bulgular else 0)


if __name__ == "__main__":
    main()
