---
toc: false
sql:
  fieldstation: ./data/noyo-fieldstation.csv
  fieldstationSurface: ./data/noyo-fieldstation-surface.csv
  fieldstationBottom: ./data/noyo-fieldstation-bottom.csv
theme: "cotton"
---

<style>

.hero {
  display: flex;
  flex-direction: column;
  align-items: center;
  font-family: var(--sans-serif);
  margin: 4rem 0 8rem;
  text-wrap: balance;
  text-align: center;
}

.hero h1 {
  margin: 2rem 0;
  max-width: none;
  font-size: 14vw;
  font-weight: 900;
  line-height: 1;
  background: linear-gradient(30deg, var(--theme-foreground-focus), currentColor);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.hero h2 {
  margin: 0;
  max-width: 34em;
  font-size: 20px;
  font-style: initial;
  font-weight: 500;
  line-height: 1.5;
  color: var(--theme-foreground-muted);
}

@media (min-width: 640px) {
  .hero h1 {
    font-size: 90px;
  }
}

</style>

```js
const longitude = -123.80366406257751
const lattitude = 39.42604167897769
```

<div class="hero">
  <h1>Hello, Noyo Harbor</h1>
</div>

//Plot.lineY(topsal, {x: "Date", y: "Value", tip: true})

<div class="grid grid-cols-2" style="grid-auto-rows: 504px;">
  <div class="card">${
    resize((width) => Plot.plot({
      title: "Surface salinity",
      subtitle: "Salt water sinks",
      width,
	  x: {type: "time", domain: [new Date(2024, 1, 1), new Date(2024, 3, 10)], grid: true},
      y: {grid: true, label: "Salinity (g/kg)"},
      marks: [
        () => htl.svg`<defs>
          <linearGradient id="gradient" gradientTransform="rotate(90)">
          <stop offset="15%" stop-color="purple" />
          <stop offset="75%" stop-color="red" />
          <stop offset="100%" stop-color="gold" />
          </linearGradient>
        </defs>`,
        Plot.ruleY([0]),
		Plot.areaY(topsal, {x: "Date", y: "Value", fillOpacity: 1.0, fill: "url(#gradient)"})
      ]
    }))
  }</div>
</div>

```js
//const forecast = FileAttachment("./data/weather.json").json();
```

```js
//display(forecast);
```

```js
const div = display(document.createElement("div"));
div.style = "height: 400px;";

const map = L.map(div)
  .setView([lattitude, longitude], 16);

L.tileLayer("https://tile.openstreetmap.org/{z}/{x}/{y}.png", {
  attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a>'
})
  .addTo(map);
  
//L.geoJSON(forecast.geometry).addTo(map);
```

```js
const topsal = await sql`SELECT Value, strptime(Timestamp, '%Y-%m-%d %H:%M') as Date from fieldstation where \"Series Name\" = 'Surface Salinity'`

const botdep = await sql`SELECT Value, strptime(Timestamp, '%Y-%m-%d %H:%M') as Date from fieldstationBottom where \"Series Name\" = 'Depth' AND date_sub('day', Date, current_date) < 7`
```

```sql
select strptime(Timestamp, '%Y-%m-%d %H:%M'), Value from fieldstation where \"Series Name\" = 'Surface Salinity';
```


```js
display(topsal);

const harborOffset = 5
```

<div class="grid grid-cols-2" style="grid-auto-rows: 504px;">
  <div class="card">${
    resize((width) => Plot.plot({
      title: "Tide Depth",
      subtitle: "Don't know the offset",
      width,
	  x: {type: "time", grid: true},
      y: {grid: true, label: "Depth (m)"},
      marks: [
        Plot.ruleY([0]),
		Plot.areaY(botdep, {x: "Date", y: (d) => d.Value + harborOffset, fillOpacity: 1.0})
      ]
    }))
  }</div>
</div>

<div class="grid grid-cols-2" style="grid-auto-rows: 504px;">
  <div class="card">${
    resize((width) => Plot.plot({
      title: "Tide Depth 2",
      subtitle: "Don't know the offset 2",
      width,
	  x: {type: "time", domain: [new Date(2024, 3, 7), new Date(2024, 3, 14)], grid: true},
      y: {grid: true, label: "Depth (m)"},
      marks: [
        Plot.ruleY([0]),
		Plot.areaY(botdep, {x: "Date", y: "Value", fill: (d) => svg`
          <linearGradient id="water${d.Date}" gradientTransform="rotate(90)">
          <stop offset="15%" stop-color="blue" />
          <stop offset="${d.i}" stop-color="aqua" />
          <stop offset="100%" stop-color="green" />
          </linearGradient>`})
      ]
    }))
  }</div>
</div>
