---
toc: false
title: Water Quality
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
	<h2>Quality detail</h2>
</div>

The current product is ${observable.params.site}.

<details>
  <summary>Controls</summary>

```js
const timelist = [
  ["1 Week", 7],
  ["2 Weeks", 14],
  ["1 Month", 30],
  ["2 Months", 60],
  ["3 Months", 90],
  ["6 Months", 180]
];

const sites_list = [
   {
     name: "B-Dock",
	 short: "bdock",
	 where: "Surface",
	 variables: ["AT500_Surface.Specific Conductivity.µS/cm", "AT500_Surface.DO.mg/L", "AT500_Surface.Temperature.C", "AT500_Surface.Density.g/cm³", "AT500_Surface.Salinity.psu", "AT500_Surface.Pressure.psi"]
   },
   {
     name: "The Wharf",
	 short: "silver",
	 where: "Surface",
	 variables: ["AT500_Surface.Temperature.C"]
   },
   {
     name: "Princess Seafood",
	 short: "princess",
	 where: "Surface",
	 variables: ["AT500_Surface.Temperature.C"]
   },
   {
     name: "Field Station Surface",
	 short: "fieldstation",
	 where: "Surface",
	 variables: ["AT500_Surface.Temperature.C"]
   },
   {
     name: "Field Station Bottom",
	 short: "fieldstation",
	 where: "Bottom",
	 variables: ["AT500_Bottom.Temperature.C"]
   },
];

const timepick = view(
  Inputs.radio(
    new Map(timelist),
    {
		value: 7, 
		label: "Time range", 
		format: (t) => {
	    return html`<span style="
          font-size: 1.5vw;
          font-weight: 300;
          line-height: 1;
        ">${t[0]}</span>`
	  }
   	}
  )
);

```

</details>

```js
// Timestamps are in milliseconds
const now = new Date().getTime();

// 24 days, 3600 secs/hour, 1000 ms/sec
const begin = now - timepick * 24 * 3600 * 1000;
```

```js
// This section loads after the controls render.
var duck = await DuckDBClient.of({
    silver: FileAttachment("./data/combined-Silver.parquet").parquet(),
    bdock: FileAttachment("./data/combined-BDock.parquet").parquet(),
    princess: FileAttachment("./data/combined-Princess.parquet").parquet(),
    fieldstation: FileAttachment("./data/combined-FieldStation.parquet").parquet(),
});

```

```js

function s2q(site) {
  const where = site.where;
  const short = site.short;
  const sitename = site.name;
  var varsas = "";
  var vnum = 0;
  for (const v of site.variables) {
	if (varsas.length != 0) {
		varsas = varsas.concat(", ");
	}
	vnum += 1;
	varsas = varsas.concat(`"${v}" as VAR${vnum}`)
  }
  return `SELECT '${sitename}' as SITE, ${varsas}, Timestamp*1000 as UTC from ${short} where UTC >= ${begin}`;
}

const bysite = sites_list.map(site => {
   const q = s2q(site);
   console.log("query is", q);
   return duck.query(q);
});

const results = await Promise.all(bysite);
```

```js
function sitePlot(width, sitedata, num) {
	return Plot.plot({
      title: "Yoyo",
      width,
	  x: {grid: true, type: "time", label: "Date", domain: [begin, now]},
      y: {grid: true, label: "hello", domain: [0, 10]},
      color: {legend: true},
  	  marks: [Plot.lineY(sitedata, {x: "UTC", y: `VAR${num}`, stroke: "SITE"})],
    });
}
```

<div class="grid grid-cols-1">
  <div class="card">${
    resize((width) => sitePlot(width, results[0], 1))
  }</div>
  <div class="card">${
    resize((width) => sitePlot(width, results[0], 2))
  }</div>
  <div class="card">${
    resize((width) => sitePlot(width, results[0], 3))
  }</div>
  <div class="card">${
    resize((width) => sitePlot(width, results[0], 4))
  }</div>
  <div class="card">${
    resize((width) => sitePlot(width, results[0], 5))
  }</div>
  <div class="card">${
    resize((width) => sitePlot(width, results[0], 6))
  }</div>
  <div class="card">${
    resize((width) => sitePlot(width, results[0], 7))
  }</div>
</div>

