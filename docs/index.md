---
toc: false
sql:
  fieldstation: ./data/noyo-fieldstation.csv
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

<div class="grid grid-cols-2" style="grid-auto-rows: 504px;">
  <div class="card">${
    resize((width) => Plot.plot({
      title: "Surface salinity",
      subtitle: "Salt water sinks",
      width,
	  x: {type: "time", domain: [new Date(2024, 1, 1), new Date(2024, 3, 10)], grid: true},
      y: {grid: true, label: "Salinity (g/kg)"},
      marks: [
        Plot.ruleY([0]),
        Plot.lineY(topsal, {x: "Date", y: "Value", tip: true})
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
```

```sql
select strptime(Timestamp, '%Y-%m-%d %H:%M'), Value from fieldstation where \"Series Name\" = 'Surface Salinity';
```


```js
display(topsal);
```
