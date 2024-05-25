---
toc: false
sql:
  BDock_AT500:     ./data/data-BDock_AT500_1115690.1.parquet
  BDock_VuLink:    ./data/data-BDock_VuLink_1114049.1.parquet
  Princess_AT500:  ./data/data-Princess_AT500_1115670.1.parquet
  Princess_VuLink: ./data/data-Princess_VuLink_1114447.1.parquet
  Silver_AT500:    ./data/data-Silver_AT500_1115675.1.parquet
  Silver_VuLink:   ./data/data-Silver_VuLink_1114440.1.parquet
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

<div class="hero">
	<h1>Noyo Harbor Blue Economy</h1>
	<h2>Feasibility Study Data Gathering</h2>
</div>

```js
const lattitude = 39.425200984011916
const longitude = -123.80366719309244

const div = display(document.createElement("div"));
div.style = "height: 400px;";

const map = L.map(div, { scrollWheelZoom: false })
  .setView([lattitude, longitude], 16);

L.tileLayer("https://tile.openstreetmap.org/{z}/{x}/{y}.png", {
  attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a>'
})
  .addTo(map);

L.circle([39.42768783218275, -123.80584629151588], {radius: 20}).bindPopup("Princess").addTo(map);
L.circle([39.42630383307301, -123.80507914592623], {radius: 20}).bindPopup("Silvers").addTo(map);
L.circle([39.42359794726219, -123.80380240755608], {radius: 20}).bindPopup("Field Station").addTo(map);
L.circle([39.42398791346205, -123.80214663996874], {radius: 20}).bindPopup("B Dock").addTo(map);
```

```js

const bdockSal = await sql`SELECT "Actual Conductivity.µS/cm" as Value, timestamp*1000 as Date, 'BDock Surface' as Name from BDock_AT500`

// Note was using "Offset" field, but it changed in the past couple of days.
const harborOffset = -6.46

function c2f(x) {
    return (x * 9 / 5) + 32
}	
```

<div class="grid grid-cols-2">
  <div class="card">${
    resize((width) => Plot.plot({
      title: "Salinity",
      width,
	  x: {grid: true, type: "time"},
      y: {grid: true, label: "Salinity (g/kg)", domain: [0, 40]},
	  color: {legend: true},
      marks: [
        Plot.ruleY([0]),
        Plot.ruleY([35]),
		Plot.lineY(bdockSal, {x: "Date", y: "Value", stroke: "Name"}),
      ]
    }))
  }</div>
  <div class="card">
    Inputs.table(bdockSal)
  </div>
</div>
