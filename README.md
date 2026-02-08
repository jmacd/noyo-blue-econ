# Noyo Harbor

This is a static HTML site for the Noyo Harbor Blue Economy water quality monitoring project.

The site is generated using **DuckPond templates** (Tera) with D3.js and Observable Plot for visualizations.

## Local Development

To preview the site locally:

```bash
npm run dev
```

Then visit <http://localhost:5173> to preview your project.

## Production Deployment

The site runs on a cron job that:
1. Collects data from HydroVu sensors (`scripts/run.sh`)
2. Exports data and renders templates to static HTML (`scripts/export.sh`)
3. Deploys to web server (`scripts/cron.sh`)

Published at: <https://noyo-harbor-blue-economy.observablehq.cloud/feasibility-study/>

## Project structure

```
.
├─ src/
│  ├─ data.html.tmpl       # Template for data pages (by param/site)
│  ├─ index.html.tmpl      # Template for home page
│  ├─ page.html.tmpl       # Sidebar navigation template
│  ├─ lib.js               # Shared JavaScript (DuckDB, Plot)
│  ├─ style.css            # Shared styles
│  └─ template.yaml        # Template factory configuration
├─ scripts/
│  ├─ cron.sh              # Main cron entry point
│  ├─ run.sh               # Data collection
│  ├─ export.sh            # Export data + render templates
│  └─ pond.sh              # DuckPond container wrapper
├─ pond/                   # DuckPond data (local development)
└─ dist/                   # Generated static site
```

## Command reference

| Command           | Description                                              |
| ----------------- | -------------------------------------------------------- |
| `npm install`     | Install or reinstall dependencies                        |
| `npm run dev`     | Start local preview server (serves dist/)                |
| `npm run clean`   | Remove dist/ directory                                   |
