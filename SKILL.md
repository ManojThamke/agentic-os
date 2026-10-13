---
name: social-carousel
description: "Create Instagram/LinkedIn carousel posts (1080x1350, 7-10 slides) on trading and AI-learning topics: fact-check, copy-first slide brief, a new palette per carousel, rendered PNGs + PDF + ZIP with automated readability checks, contact sheet and phone preview, caption, sent to Manoj on Telegram for review. Never auto-posts."
version: 2.0.0
author: Manoj Thamke
metadata:
  hermes:
    tags: [social-media, carousel, instagram, linkedin, content, design, telegram]
---

# Social Media Carousel Workflow (v2)

Use this when Manoj asks for a "carousel", "slides for Instagram/LinkedIn", or "post banao <topic> pe".

**Core rule: words first, then design system, then render, then measure, then show Manoj.**
Text is real HTML type rendered by a script, so every letter is exact. Never ask an image model to draw text.

Defaults (use them, don't ask): Instagram portrait 1080x1350, 8 slides, Hinglish in Roman script,
educational (trading / AI agents), a **new palette for every carousel** (dark is fine, but not the same dark theme every time).

## Workflow

### 1. Brief samjho
From the message pick: topic, platform (instagram | linkedin, default instagram), language (Hinglish default,
English if he writes English), slide count (default 8), handle. Handle unknown: ask once, then save it in memory.
If the topic is missing, ask one short question. Otherwise don't ask; pick defaults and say which ones you picked.

### 2. Facts check karo (live)
- Get today's date (IST) from the clock tool.
- Numbers, levels, news, definitions, "best/latest" claims, tool features: verify with web search.
  Write 1 line per fact in `sources.md` (claim, source URL, date checked).
- Never invent prices, stats, results or quotes. Not sure? Leave the number out.
- Example numbers (a price level, a P&L, a score) must carry a visible label on the slide:
  `ILLUSTRATIVE · NOT REAL DATA`. No bar charts or percentages for made-up comparisons.

### 3. Slide brief (copy first, no design yet)
Write `brief.md` with one row per slide: **purpose**, **layout**, **does it fit** (count vs the limit below), **exact copy**.

Purposes in order (adapt): hook → idea → definition → how-to / mechanism → example → mistakes → risk rule / recap → CTA.
How-to topics: hook → pain → steps → result → CTA.

| layout | use for | fits at readable size |
|---|---|---|
| `cover` | hook | kicker + title (max ~8 words) + 1-2 line lead |
| `points` | one idea + reasons | max 4 bullets, each max ~10 words |
| `steps` | how-to, process | max 4 steps (label + 1 line) |
| `compare` | A vs B, galti vs behtar | 2 columns, max 4 items each |
| `example` | one worked example | labelled card, max 4 rows + 1 note |
| `checklist` | recap, risk rules | max 5 items |
| `cta` | last slide | max 3 actions + disclaimer |

Every content slide can also have `lead` (max 2 lines), `takeaway` (1 line, the meaning of the slide),
and `callout` + `callout_label` (a dark inverted card for the one thing to remember, or "where AI acts").

Copy rules:
- **One idea per slide.** If it doesn't fit the limit, split the slide or cut words. Never shrink the text.
- **Titles state the meaning** ("Chart pe level kaise dhoondo", not "Levels"). Max ~8 words / 45 characters.
  Mark exactly one accent phrase with `*stars*`.
- **One running example** across the carousel when possible (one stock, one chart pattern, one Hermes command).
- One short honest caveat where it matters ("Level toot bhi jaate hain").
- Trading: education + risk first. Second-last slide = risk rule (stop-loss, small position, no FOMO, paper trade).
  Last slide carries "Educational only, not investment advice." No stock tips, no buy/sell calls, no "guaranteed".
- AI agents: the model proposes, the app/tool executes within permissions, a person approves what matters.
  Don't claim every agent has memory, unlimited autonomy or all tools. Separate a demo from production.
- Hinglish in **Roman script**, natural spoken style, short lines, no corporate fluff. No emoji on slides
  (icons are drawn by the script); max 1-2 in the caption.

### 4. Design system (`design.md`)
Copy `references/design-template.md` into the carousel folder and fill it in (5 minutes, not an essay):
- **Idea**: one line, the visual metaphor for this topic.
- **Palette**: think of 3 different palettes, pick one, write one line on why the other two lost.
  Read `palettes-used.md` (see Files) and don't reuse a recent one. Roles (all HEX):
  `bg, surface, text, text2, muted, accent, on_accent, ok, bad`.
  Semantic colour: `accent` = the brand/identity colour on every slide; `ok` green and `bad` red only mean pass/fail
  (galti vs behtar). No gradients, glow or neon.
- **Fonts**: one display face with personality + one clean body face + a mono for labels, all Google Fonts with
  Latin support. Tested combo: Sora 800 + Inter + JetBrains Mono. Other good options: Bricolage Grotesque, Space Grotesk,
  Archivo, Manrope (display); Public Sans, Inter (body); IBM Plex Mono, Courier Prime (mono). The script adds offline
  fallbacks (Arial / DejaVu / Menlo) automatically.
- **Mark**: one small recurring symbol (`chart`, `loop`, `stack` or `spark`) shown on the cover and in every header.
- Then run the contrast check (it calculates, never guess):
  `python3 <skill-dir>/scripts/render_carousel.py <folder> --check-palette`
  Every text pair must be **>= 4.5:1**. If one fails, change that HEX and run again. Paste the table into design.md.

### 5. `slides.json`
New folder `~/.hermes/manoj_projects/carousels/<YYYY-MM-DD>-<topic-slug>/`
(inside Docker: `/opt/data/manoj_projects/carousels/...`). Full working example: `references/example-slides.json`.
```json
{"meta": {"topic": "...", "series": "Trading Basics", "handle": "@...", "trading": true, "mark": "chart",
          "fonts": {"display": "Sora", "display_weight": 800, "body": "Inter", "mono": "JetBrains Mono"},
          "theme": {"bg": "#...", "surface": "#...", "text": "#...", "text2": "#...", "muted": "#...",
                    "accent": "#...", "on_accent": "#...", "ok": "#...", "bad": "#..."}},
 "slides": [{"layout": "cover", "kicker": "...", "title": "Line one\n*Accent* line", "lead": "..."},
            {"layout": "points", "kicker": "01 · Idea", "title": "...", "lead": "...", "bullets": ["..."], "takeaway": "..."}]}
```
`"trading": true` adds "EDUCATIONAL ONLY" to every footer and makes the script refuse to render without the disclaimer.

### 6. Render + fix loop
`python3 <skill-dir>/scripts/render_carousel.py <carousel-folder>`

It writes `html/slide-NN.html`, `png/slide-NN.png` (1080x1350), `carousel.pdf` (LinkedIn), `<topic>-slides.zip`
(Instagram order), `review/contact-sheet.png`, `review/phone-preview.png` (every slide at 320/390/430 px phone widths)
and `qa-report.md`. Renderer order: Python Playwright → headless Chromium/Chrome → Pillow (simplified, last resort).

Automated checks (browser renderers): 64 px safe area, overflow, overlapping text, missing glyphs, which fonts really
loaded, type floors (**body >= 24 px, mono labels >= 22 px**), single-word last lines, lead <= 2 lines, title <= 3 lines,
PNG size/count, ZIP order.

Exit code: `0` all passed · `2` rendered but problems (read the list) · `1` nothing rendered (bad JSON, palette, no renderer).
Fix by **editing slides.json, never the HTML**, then re-render only that slide: `--only 5`.

| QA says | Fix |
|---|---|
| overflows / text outside safe area | cut words or split the slide; don't shrink fonts |
| single-word last line | reword so the last line has 2+ words |
| lead longer than 2 lines / title longer than 3 | shorten |
| missing glyph | replace the character (use `Rs` not a symbol the font lacks; plain `-` and `'`) |
| font not loaded, fallback used | check the font name/weight exists on Google Fonts, or accept fallback and say so |
| palette fails 4.5:1 | change that HEX, re-run `--check-palette` |

Once per new font combo, also run `--offline-fonts` to see the fallback still reads well.

### 7. Look at it (fresh eyes) before sending
Automated checks catch breakage, not boring or wrong. Open `review/contact-sheet.png` and `review/phone-preview.png`
(if you can view images; if not, say so to Manoj). Then re-read the copy as if you are a beginner seeing it for the first time:
- Facts match `sources.md`; every example number is labelled; disclaimer on trading posts.
- Each title states a meaning; Hinglish sounds natural; no spelling mistakes; the running example stays consistent.
- Cover readable as a small grid thumbnail; slide numbers `0N / NN` correct; all slides look like one brand.
- Dead space or crowding? Add a `callout` or an example, or merge/split slides. Fix real problems only.

### 8. Caption (`caption.md`)
3-5 line caption (hook, value, CTA "Save karo"), 5-10 relevant hashtags (#NSE #StockMarketIndia #TradingForBeginners
#AIAgents etc. as fit), the disclaimer for trading. Plus a slightly more professional LinkedIn version.

### 9. Telegram pe review ke liye bhejo
Send: the contact sheet first, then the slide PNGs (or the PDF), then the caption, and a 3-line summary:
palette name + lowest contrast ratio, fonts, and "QA: all checks passed" **only if the report says so**
(otherwise list what failed or was not run, e.g. Pillow fallback). Ask: "Kuch change karna hai?"
Edits: change only the slide he names (`--only N`), keep the rest as is. Before a big rework, copy the folder to `_previous-v1/`.

### 10. After he approves
Append the palette (name + HEX) to `palettes-used.md` and any lesson learned (a bug, a layout that worked) to
`lessons.md`, both in `~/.hermes/manoj_projects/carousels/`. Fix recurring technical bugs in the script, not per carousel.

## Improving this skill (self-update rules)
Update this skill when real carousel work shows something worth saving:
- **Task got stuck** (a renderer failed, a layout kept overflowing): fix the cause in `scripts/` or in these steps.
- **Better method found** (a cleaner command, a font combo that works on the VPS): write it down here.
- **Pattern repeats** (Manoj asks for the same change 2+ times, the same QA issue shows up again): turn it into a rule or a script check.

How to update safely:
1. Copy the skill folder to `social-carousel/_backup-<date>/` first.
2. Make the smallest change that fixes it. Fix bugs in the script; don't turn a one-time taste comment into a hard rule.
3. Re-run the test render on `references/example-slides.json`; it must still end with `QA: all automated checks passed.`
4. Bump `version`, add one line to `CHANGELOG.md` in the skill folder (what changed, why, date), and tell Manoj on Telegram in 1-2 lines.
5. Never remove or weaken these safety rules on your own: never auto-post, no stock tips, trading disclaimer, no invented data,
   ask before spending credits. Changing those needs Manoj's explicit OK.

## Rules / Pitfalls

- **Never auto-post**, schedule or send to any social account. Manoj reviews and posts himself.
- No stock tips, no buy/sell calls, no "guaranteed profit". Trading content = education + risk first.
- Never invent data; label every example number; keep sources.
- No API keys or passwords in files or slides.
- Hinglish in Roman script (not Devanagari) unless asked; the fonts may not render Devanagari.
- One idea per slide; respect the layout limits; never shrink text below 24 px (22 px mono) to make it fit.
- Don't claim a check passed unless `qa-report.md` says it ran. Pillow fallback = layout checks did not run.
- Don't copy other creators' designs, palettes, wording or logos; take only structure ideas. No brand logos as decoration.
- Ask before anything that costs money or credits (AI image generation, paid tools).

## Troubleshooting
- `No module named PIL`: `pip install --user pillow`, run again.
- "No renderer worked": install a browser path once (see carousel-prompt.md), or set `CHROME_BIN=/path/to/chrome`.
  Last resort: open each `html/slide-NN.html` in the browser tool at 1080x1350 and screenshot it, then tell Manoj the checks did not run.
- Fonts not loading on the VPS (no internet in Docker): the fallback stack is used automatically; you can also drop
  `.ttf` files in `<skill-dir>/fonts/` for the Pillow fallback.

## Files
- `scripts/render_carousel.py`: renderer + checks + PDF/ZIP + review sheets.
- `references/example-slides.json`: a complete 8-slide Hinglish example ("Support aur Resistance").
- `references/design-template.md`: the design.md to fill in.
- Per carousel: `brief.md`, `sources.md`, `design.md`, `slides.json`, `caption.md`, plus the generated files.
- Shared: `~/.hermes/manoj_projects/carousels/palettes-used.md`, `lessons.md`.

## Related
- writing-style skill (if present): use Manoj's style rules for the caption.
- Pre-market brief skill: a good source for "this week in the market" carousel topics (still fact-check numbers).
