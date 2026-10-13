# Hermes carousel: setup guide (v2)

Do tarike hain. **B recommended hai** (tested script ke saath poora skill folder copy karo).
**A** tab use karo jab folder copy karna possible na ho; tab Hermes khud skill likhega, par tested script nahi milega.

## B. Ready skill folder copy karo (VPS pe) — recommended

Folder: `social-carousel/`
```
social-carousel/
  SKILL.md
  scripts/render_carousel.py        renderer + checks + PDF/ZIP + contact sheet + phone preview
  references/example-slides.json    full 8-slide Hinglish example
  references/design-template.md     design.md template
```

1. Laptop (PowerShell) se VPS pe bhejo:
   ```powershell
   scp -r social-carousel manoj@YOUR_VPS_IP:~/
   ```
2. VPS pe skill folder me rakho:
   ```bash
   mkdir -p ~/.hermes/skills/social-media
   mv ~/social-carousel ~/.hermes/skills/social-media/
   ```
3. Renderer check karo (jahan Hermes chalta hai, yaani Docker container ke andar agar Docker use karte ho):
   ```bash
   python3 -c "import PIL; print('pillow ok')"   || pip install --user pillow
   python3 -c "import playwright; print('playwright ok')"
   which chromium chromium-browser google-chrome
   ```
   Pillow zaroori hai. Kam se kam ek browser bhi chahiye taaki saare checks chalein:
   - Option 1: `pip install --user playwright && python3 -m playwright install --with-deps chromium`
   - Option 2: system Chromium (Debian/Ubuntu image: `apt-get install -y chromium`)
   Docker me install kiya hua package container rebuild pe chala jata hai. Permanent chahiye to Dockerfile / compose
   setup me add karo. Browser na ho to script Pillow se simple slides banayega aur saaf bolega ki checks nahi chale.
4. Test render (pehle palette check, phir full render):
   ```bash
   mkdir -p /tmp/carousel-test && cp ~/.hermes/skills/social-media/social-carousel/references/example-slides.json /tmp/carousel-test/slides.json
   python3 ~/.hermes/skills/social-media/social-carousel/scripts/render_carousel.py /tmp/carousel-test --check-palette
   python3 ~/.hermes/skills/social-media/social-carousel/scripts/render_carousel.py /tmp/carousel-test
   cat /tmp/carousel-test/qa-report.md
   ```
   Achha result: `renderer: playwright` ya `renderer: chrome`, aur `QA: all automated checks passed.`
5. Hermes restart:
   ```bash
   docker compose restart hermes     # docker-compose.yml waale folder me
   ```
   Telegram pe `/skills` chalao, `social-carousel` dikhna chahiye. Phir `/new` karke bolo:
   **"carousel banao: Stop-loss kyun zaroori hai"**.

Check: `ls ~/.hermes/manoj_projects/carousels/` me naya folder ho, jisme `png/`, `carousel.pdf`, ZIP,
`review/contact-sheet.png`, `review/phone-preview.png`, `qa-report.md`, `caption.md`.

## A. Telegram pe ye prompt paste karo (agar folder copy nahi ho sakta)

```
Create a skill called "social-carousel" (category: social-media) for making
Instagram and LinkedIn carousel posts for me. Never post anything yourself.

Defaults: Instagram portrait 1080x1350, 8 slides, Hinglish in Roman script,
topics on trading (NSE/BSE learning) and AI agents. A NEW colour palette for
every carousel (keep a palettes-used.md list and don't repeat).

Workflow for every carousel:
1. Facts: use the live clock (IST). Verify numbers, news, definitions with web
   search, keep sources.md. Never invent data. Any example number on a slide
   gets the label "ILLUSTRATIVE · NOT REAL DATA".
2. Copy first (brief.md): for each slide write purpose, layout, and exact copy.
   Slide 1 hook (title max 8 words). Middle slides one idea each: kicker,
   title that states the meaning, max 4 bullets or steps, 1-line takeaway.
   Second-last = risk rule / recap (stop-loss, small position, no FOMO).
   Last = CTA "Save karo / Follow karo" + "Educational only, not investment
   advice." for trading. If it doesn't fit, split the slide; never shrink text.
3. Design (design.md): pick 1 of 3 palettes with roles bg, surface, text,
   text2, muted, accent, on_accent, ok, bad. Calculate WCAG contrast with a
   small Python function; every text/background pair must be >= 4.5:1.
   Fonts: Google Fonts display + body + mono, each with a fallback
   (Arial / DejaVu Sans / Menlo). Red/green only for wrong/right.
4. Render: one HTML per slide (1080x1350, 64 px safe margin, same header with
   "0N / NN" and same footer with my handle on every slide). Body text >= 24
   px, small mono labels >= 22 px. Screenshot with Playwright or headless
   Chromium; Pillow only as last resort. Then check in the browser: text inside
   the 64 px margin, no overflow, no overlapping text, fonts actually loaded,
   no single-word last line. Save png/, carousel.pdf, a ZIP in order, a
   contact sheet and a phone preview (each slide at 320/390/430 px wide), and
   qa-report.md saying which checks ran.
5. Look at the contact sheet and phone preview with fresh eyes: facts,
   labels, Hinglish, cover readable as a thumbnail. Fix real problems.
6. caption.md: 3-5 line caption + 5-10 hashtags, plus a LinkedIn version.
7. Send me on Telegram: contact sheet, PNGs (or PDF), caption, and a short
   summary (palette, lowest contrast, checks passed or not run). Ask what to
   change; edit only the slides I name.

No stock tips or buy/sell calls. No API keys in any file.
Save in ~/.hermes/manoj_projects/carousels/<date>-<topic-slug>/.

Now test it: make a carousel on "Support aur Resistance kya hota hai".
```

## Roz ka use

- **"carousel banao: RSI kya hai"** ya **"LinkedIn carousel: Hermes Agent skills kya hain"**.
- Change: **"slide 4 ka title chhota karo"** (wo sirf slide 4 dobara banayega).
- Pehli baar handle pucchega (jaise @manoj.learns), bata do, wo yaad rakhega.

## Tips

- `qa-report.md` me "Pillow fallback" likha ho to browser checks nahi chale: browser install karo (step 3).
- Font na load ho (Docker me internet band) to fallback font use hota hai; report me dikhega.
- Hamesha khud review karke hi post karna. Canva me finish karna ho to Canva me wahi fonts available hain ya nahi, check kar lena.
