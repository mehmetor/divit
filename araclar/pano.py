#!/usr/bin/env python3
"""Pilot panosu — hocalardan gelen geri bildirim dosyalarını tek tabloda toplar.

Kullanım:
    python3 araclar/pano.py <klasör> [-o pano.md]

<klasör> içine e-postalardan indirilen `geri-bildirim-*.md` dosyalarını
koyun (alt klasörler de taranır; her hoca için bir alt klasör önerilir).
Çıktı: hoca başına iş sayıları, sorun sayısı, son tarih ve en sık iş türü;
ardından tüm sorun kayıtları. Yalnız standart kütüphane kullanır.
"""
import argparse, collections, pathlib, re, sys

SATIR = re.compile(r"^(\d{4}-\d{2}-\d{2})[ T]\d{2}:\d{2} · ([^·]+?) ·")
SORUN = re.compile(r"^## (\d{4}-\d{2}-\d{2})[ T]?\d{0,2}:?\d{0,2} · (.+)$")
BASLIK = re.compile(r"^Alan: (.+?) · Sistem: (.+?) ·")

def oku(yol):
    d = {"alan": "?", "sistem": "?", "isler": collections.Counter(),
         "tarihler": set(), "sorunlar": [], "not": ""}
    bolum = None
    for s in yol.read_text(encoding="utf-8").splitlines():
        if m := BASLIK.match(s):
            d["alan"], d["sistem"] = m.group(1).strip(), m.group(2).strip()
        if s.startswith("## ") and not SORUN.match(s):
            bolum = s[3:].strip().lower()
        if m := SATIR.match(s.lstrip("- ")):
            d["isler"][m.group(2).strip()] += 1
            d["tarihler"].add(m.group(1))
        if bolum == "sorunlar":
            if m := SORUN.match(s):
                d["sorunlar"].append([m.group(1), m.group(2).strip(), ""])
                d["tarihler"].add(m.group(1))
            elif d["sorunlar"] and s.startswith("- "):
                d["sorunlar"][-1][2] += s[2:].strip() + " "
        if bolum == "hocanın notu" and s.strip() and not s.startswith("#") and s.strip() != "—":
            d["not"] += s.strip() + " "
    return d

def main():
    a = argparse.ArgumentParser()
    a.add_argument("klasor"); a.add_argument("-o", "--cikti")
    ar = a.parse_args()
    kok = pathlib.Path(ar.klasor)
    dosyalar = sorted(kok.rglob("geri-bildirim-*.md"))
    if not dosyalar:
        sys.exit(f"{kok} altında geri-bildirim-*.md bulunamadı.")
    hocalar = collections.defaultdict(list)
    for f in dosyalar:
        ad = f.parent.name if f.parent != kok else f.stem
        hocalar[ad].append(oku(f))
    c = ["# Divit pilot panosu", "",
         "| Hoca | Alan | Sistem | Dosya | İş | Sorun | Etkin gün | Son kayıt | En sık iş |",
         "|---|---|---|---|---|---|---|---|---|"]
    for ad, ds in sorted(hocalar.items()):
        isler = sum((d["isler"] for d in ds), collections.Counter())
        tarih = set().union(*(d["tarihler"] for d in ds))
        sorun = sum(len(d["sorunlar"]) for d in ds)
        enc = ", ".join(f"{k} {v}" for k, v in isler.most_common(3)) or "—"
        c.append(f"| {ad} | {ds[-1]['alan']} | {ds[-1]['sistem']} | {len(ds)} | "
                 f"{sum(isler.values())} | {sorun} | {len(tarih)} | {max(tarih) if tarih else '—'} | {enc} |")
    c += ["", "## Sorunlar", ""]
    for ad, ds in sorted(hocalar.items()):
        for d in ds:
            for t, tur, ic in d["sorunlar"]:
                c.append(f"- **{ad}** · {t} · {tur} — {ic.strip()}")
    c += ["", "## Hocaların notları", ""]
    for ad, ds in sorted(hocalar.items()):
        for d in ds:
            if d["not"].strip():
                c.append(f"- **{ad}**: {d['not'].strip()}")
    metin = "\n".join(c) + "\n"
    if ar.cikti:
        pathlib.Path(ar.cikti).write_text(metin, encoding="utf-8"); print(ar.cikti)
    else:
        print(metin)

if __name__ == "__main__":
    main()
