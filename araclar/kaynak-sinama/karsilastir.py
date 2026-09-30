"""Kaynak sınaması: skill'in kanıt dosyasını beklenen.md ile karşılaştırır.

  python3 karsilastir.py <beklenen.md> <kanıt.md> <akış.jsonl>

Çıkış: 0 GEÇTİ, 1 KALDI, 3 AĞ (KALDI satırı var, hiçbiri kaçırma değil ve
koşuda 429/5xx ya da bağlantı hatası görüldü; sonuç sayılmaz, yeniden koşulur).
Standart çıktıya markdown özet basar.
"""
import json
import re
import sys
import unicodedata


ALANLAR = ["yazar", "yıl", "cilt", "sayfa", "başlık", "dergi"]


def sade(s):
    s = unicodedata.normalize("NFC", s.strip().strip("`*").strip())
    return s.replace("İ", "i").replace("I", "ı").lower()


def tablo(yol, gerekli):
    """Başlığında `gerekli` sütunları olan ilk markdown tablosunu okur."""
    satirlar = open(yol, encoding="utf-8").read().splitlines()
    for i, l in enumerate(satirlar):
        if not l.lstrip().startswith("|"):
            continue
        bas = [sade(h) for h in l.strip().strip("|").split("|")]
        if not all(sade(g) in bas for g in gerekli):
            continue
        sonuc = []
        for m in satirlar[i + 2:]:
            if not m.lstrip().startswith("|"):
                break
            hucre = [h.strip() for h in m.strip().strip("|").split("|")]
            sonuc.append(dict(zip(bas, hucre)))
        return sonuc
    return None


def ag_hatalari(akis):
    """WebFetch'in ağ kaynaklı hata sonuçlarını sayar."""
    kimlik, hata = set(), []
    for l in open(akis, encoding="utf-8"):
        try:
            d = json.loads(l)
        except Exception:
            continue
        tur = d.get("tool_use_result")
        if isinstance(tur, dict) and isinstance(tur.get("code"), int) and (tur["code"] == 429 or tur["code"] >= 500):
            hata.append(f"HTTP {tur['code']} {tur.get('codeText', '')}")
        m = d.get("message")
        for p in (m.get("content") if isinstance(m, dict) else None) or []:
            if not isinstance(p, dict):
                continue
            if p.get("type") == "tool_use" and p.get("name") == "WebFetch":
                kimlik.add(p.get("id"))
            if p.get("type") == "tool_result" and p.get("tool_use_id") in kimlik and p.get("is_error"):
                metin = json.dumps(p.get("content"), ensure_ascii=False)
                if re.search(r"ECONN|ETIMEDOUT|ENOTFOUND|timeout|timed out|status code 5\d\d|429|network|socket", metin, re.I):
                    hata.append(metin[:160])
    return hata


def main():
    bek_yol, kanit_yol, akis_yol = sys.argv[1:4]
    bek = tablo(bek_yol, ["Anahtar", "Tür", "Kabul", "Şart"])
    kanit = tablo(kanit_yol, ["Anahtar", "Sonuç"]) if kanit_yol != "-" else None
    ag = ag_hatalari(akis_yol)
    print("| Anahtar | Tür | Beklenen | Bulunan | Şart | Durum |")
    print("|---|---|---|---|---|---|")
    if kanit is None:
        print("| — | — | — | kanıt dosyası ya da özet tablo yok | — | KALDI |")
        print(f"\nAğ hatası: {len(ag)}")
        sys.exit(3 if ag else 1)
    bulunan = {sade(r.get(sade("Anahtar"), "")).lstrip("@"): r for r in kanit}
    kaldi, uyari = [], []
    for b in bek:
        ak = sade(b["anahtar"])
        kabul = [sade(k) for k in b["kabul"].split(",")]
        sart = b.get("şart", "—").strip()
        r = bulunan.get(ak)
        durum = "GEÇTİ"
        if r is None:
            durum, s = "KALDI (tabloda yok)", "—"
        else:
            s = sade(r.get(sade("Sonuç"), ""))
            if b["tür"] == "hata" and s.startswith("doğrulandı"):
                durum = "KALDI (kaçırma)"
            elif not any(s.startswith(k) for k in kabul):
                durum = "KALDI (yanlış alarm)" if b["tür"] == "tuzak" else "KALDI (yanlış teşhis)"
            else:
                sartlar = [x.split("=", 1) for x in sart.split(";") if "=" in x]
                for sutun, deger in sartlar:
                    if not sade(r.get(sade(sutun), "")).startswith(sade(deger)):
                        durum = f"KALDI (şart: {sutun.strip()}={deger.strip()}, bulunan: {r.get(sade(sutun), 'yok')})"
                        break
                beklenen_farkli = {sade(x) for x, d in sartlar if sade(d) == "farklı"}
                fazla = [a for a in ALANLAR if a not in beklenen_farkli and sade(r.get(a, "")).startswith("farklı")]
                if durum == "GEÇTİ" and fazla:
                    durum = "UYARI (beklenmeyen farklı alan: " + ", ".join(fazla) + ")"
            if durum == "GEÇTİ" and b["tür"] == "tuzak" and s.startswith("elle bak"):
                durum = "UYARI (elle bak)"
        if durum.startswith("KALDI"):
            kaldi.append(ak)
        elif durum.startswith("UYARI"):
            uyari.append(ak)
        print(f"| {b['anahtar']} | {b['tür']} | {b['kabul']} | {s.upper() if s != '—' else s} | {sart} | {durum} |")
    fazla = sorted(set(bulunan) - {sade(b["anahtar"]) for b in bek})
    print(f"\nBeklenen {len(bek)} satır · KALDI {len(kaldi)} · UYARI {len(uyari)} · tabloda fazladan: {', '.join(fazla) or 'yok'} · ağ hatası: {len(ag)}")
    for h in ag:
        print(f"- ağ: {h}")
    if not kaldi:
        sys.exit(0)
    # Ağ hatası kaçırmayı asla örtmez: hatalı giriş DOĞRULANDI dendiyse KALDI.
    kacirma = any(bulunan.get(sade(b["anahtar"])) is None or sade(bulunan[sade(b["anahtar"])].get("sonuç", "")).startswith("doğrulandı")
                  for b in bek if b["tür"] == "hata" and sade(b["anahtar"]) in kaldi)
    sys.exit(3 if ag and not kacirma else 1)


main()
