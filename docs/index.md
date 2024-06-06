---
toc: false
sql:
  DIR:      ./data/pond/HydroVu/9e604298-c16f-4906-a2d6-3c0c358a01dd/dir.3.parquet
  TEMPORAL: ./data/pond/HydroVu/9e604298-c16f-4906-a2d6-3c0c358a01dd/temporal.3.parquet
  LOCATIONS: ./data/pond/HydroVu/9e604298-c16f-4906-a2d6-3c0c358a01dd/locations.1.parquet
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
	<!-- <h1>Noyo Harbor Blue Economy</h1> -->
	<!-- <h2>Feasibility Study Data Gathering</h2> -->
	<h1>Testing</h1>
	<h2>Feasibility</h2>
</div>

<!-- ```js -->
<!-- const lattitude = 39.425200984011916 -->
<!-- const longitude = -123.80366719309244 -->

<!-- const div = display(document.createElement("div")); -->
<!-- div.style = "height: 400px;"; -->

<!-- const map = L.map(div, { scrollWheelZoom: false }) -->
<!--   .setView([lattitude, longitude], 16); -->

<!-- L.tileLayer("https://tile.openstreetmap.org/{z}/{x}/{y}.png", { -->
<!--   attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a>' -->
<!-- }) -->
<!--   .addTo(map); -->

<!-- L.circle([39.42768783218275, -123.80584629151588], {radius: 20}).bindPopup("Princess").addTo(map); -->
<!-- L.circle([39.42630383307301, -123.80507914592623], {radius: 20}).bindPopup("Silvers").addTo(map); -->
<!-- L.circle([39.42359794726219, -123.80380240755608], {radius: 20}).bindPopup("Field Station").addTo(map); -->
<!-- L.circle([39.42398791346205, -123.80214663996874], {radius: 20}).bindPopup("B Dock").addTo(map); -->
<!-- ``` -->

<!-- ```js -->

<!-- const bdockSal = await sql`SELECT "Actual Conductivity.µS/cm"/1000 as Value, timestamp*1000 as Date, 'BDock Surface' as Name from BDock_AT500` -->

<!-- // Note was using "Offset" field, but it changed in the past couple of days. -->
<!-- const harborOffset = -6.46 -->

<!-- function c2f(x) { -->
<!--     return (x * 9 / 5) + 32 -->
<!-- }	 -->
<!-- ``` -->

```js
// https://observablehq.observablehq.cloud/framework-example-input-select-file/

const inputs = await sql`SELECT name, id FROM LOCATIONS order by name`;

const input = view(Inputs.select(inputs, {
    value: inputs[0], 
    label: "Instrument",
    format: (t) => t.name,
}));
```


```js
const prefix = "data-" + input.id;
```

```js
const dirs = await sql`SELECT number FROM DIR where prefix = ${prefix}`;

const dirnames = dirs.toArray().map(_=>_.number);

//const dir = view(Inputs.select(dirs, {value: dirs[0], label: "File:"}));
```

```js
const filenames = dirnames.map(_=> "./data/pond/HydroVu/9e604298-c16f-4906-a2d6-3c0c358a01dd/" + prefix + "." + _ + ".parquet")
display(filenames)
```

```js
const db = DuckDBClient.of(filenames.map(_ => FileAttachment(_)));

const params = await db.sql`DESCRIBE data;`
```


<!-- <div class="grid grid-cols-2"> -->
<!--   <div class="card">${ -->
<!--     resize((width) => Plot.plot({ -->
<!--       title: "Salinity", -->
<!--       width, -->
<!-- 	  x: {grid: true, type: "time"}, -->
<!--       y: {grid: true, label: "Salinity (g/kg)", domain: [0, 40]}, -->
<!-- 	  color: {legend: true}, -->
<!--       marks: [ -->
<!--         Plot.ruleY([0]), -->
<!--         Plot.ruleY([35]), -->
<!-- 		Plot.lineY(bdockSal, {x: "Date", y: "Value", stroke: "Name"}), -->
<!--       ] -->
<!--     })) -->
<!--   }</div> -->
<!--   <div class="card"> -->
<!--   </div> -->
<!-- </div> -->

<!-- <div class="grid grid-cols-2"> -->
<!--   <div class="card">${ -->
<!--     resize((width) => Plot.plot({ -->
<!--       title: "Salinity", -->
<!--       width, -->
<!-- 	  x: {grid: true, type: "time"}, -->
<!--       y: {grid: true, label: "Salinity (g/kg)", domain: [0, 40]}, -->
<!-- 	  color: {legend: true}, -->
<!--       marks: [ -->
<!--         Plot.ruleY([0]), -->
<!--         Plot.ruleY([35]), -->
<!-- 		Plot.lineY(bdockSal, {x: "Date", y: "Value", stroke: "Name"}), -->
<!--       ] -->
<!--     })) -->
<!--   }</div> -->
<!--   <div class="card"> -->
<!--   </div> -->
<!-- </div> -->
