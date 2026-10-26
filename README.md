# bwagner.dev

Personal site. Plain HTML and CSS, no build step, deployed to GitHub Pages.

```
site/                 everything that gets published
  index.html          the page
  404.html            GitHub Pages serves this for missing paths
  @InventorB/         redirect for the old LinkStack profile URL
  styles.css          all styles; colors are tokens at the top
  assets/fonts/       IBM Plex Sans + Mono (self-hosted, OFL)
  assets/img/         avatar, favicons, og.jpg
tools/og.html         template for the link-preview image (+ og-photo.webp)
tools/og.sh           regenerates site/assets/img/og.jpg from the template
lychee.toml           link-checker config used by CI
```

## Preview locally

```sh
python3 -m http.server 8000 --directory site
```

Then open http://localhost:8000. Paths are root-absolute (`/styles.css`), so opening
`index.html` straight from Finder won't load styles. Use the server.

## Common edits

- **Add a link:** copy one `<li>` in the `.links` list in `site/index.html`.
- **Add a sub-link:** put a `<ul class="sublinks">` inside the parent `<li>`, after
  its `<a>`, with one `<li>` per child. Nest another `<ul class="sublinks">` for a
  deeper level (see SJSU Robotics → repo → demo). Tree lines are drawn automatically.
- **"Now" line:** uncomment the block under the bio in `site/index.html`.
- **Preview image:** edit `tools/og.html`, then run `./tools/og.sh`.

## Deploys

`.github/workflows/deploy.yml`:

- Every push and PR validates the HTML (`html-validate`) and checks links (`lychee`).
- Pushes to `main` (or a manual run) deploy `site/` to Pages if the checks pass.
- A weekly scheduled run re-checks links so dead ones show up as a failed run.
