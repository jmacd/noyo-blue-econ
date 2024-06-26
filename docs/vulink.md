---
toc: false
title: Vulink Instruments
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
	<h2>Vulink Instruments</h2>
</div>

```js
function c2q(cname) {
	return `SELECT "${cname}" as Value, timestamp*1000 as UTC from data where UTC >= ${begin}`;
}

const all_variables = [
   {
     name: "Temperature",
	 unit: "C",
	 key: "Temperature.C",
	 domain: [0, 30], 
	 mark: Plot.line
   },
   {
     name: "Atmospheric Pressure",
	 unit: "psi",
	 key: "Baro.psi",
	 domain: [14, 15], 
	 mark: Plot.line
   },
   {
     name: "Battery Level",
	 unit: "%",
	 key: "Battery Level.%",
	 domain: [0, 100], 
	 mark: Plot.line
   },
   {
	 name: "Total Dissolved Solids",
	 unit: "mg/L",
	 key: "Total Dissolved Solids.mg/L",
	 domain: [0, 50000],
	 mark: Plot.line
   },
   {
	 name: "DO",
	 unit: "mg/L",
	 key: "DO.mg/L",
	 domain: [0, 20],
	 mark: Plot.line
   },
   {
	 name: "Depth",
	 unit: "m",
	 key: "Depth.m",
	 domain: [0, 4],
	 mark: Plot.line
   },
   {
	 name: "Specific Conductivity",
	 unit: "µS/cm",
	 key: "Specific Conductivity.µS/cm",
	 domain: [0, 10000],
	 mark: Plot.line
   },
   {
	 name: "Salinity",
	 unit: "psu",
	 key: "Salinity.psu",
	 domain: [0, 35],
	 mark: Plot.line
   }
];
```

```js

const timepicks = [
  {
    name: "3 Months",
	days: 90
  },
  {
    name: "1 Month",
	days: 30
  },
  {
    name: "2 Weeks",
		days: 14
  },
  {
    name: "1 Week",
	days: 7
  }
];

const timepick = view(Inputs.select(timepicks, {
    value: timepicks[0], 
    label: "Time Range",
    format: (t) => t.name
}));
```

```js
// Timestamps are in milliseconds
const now = new Date().getTime()

// 24 days, 3600 secs/hour, 1000 ms/sec
const begin = now - timepick.days * 24 * 3600 * 1000
```

```js
const instruments = [
   {
     name: "Silver Vulink",
     duck: await DuckDBClient.of({data: FileAttachment("./data/loc.Silver_VuLink_1114440.parquet")}),
	 vars: ["Temperature", "Battery Level", "Atmospheric Pressure"]
   },
   {
     name: "B Dock Vulink",
     duck: await DuckDBClient.of({data: FileAttachment("./data/loc.BDock_VuLink_1114049.parquet")}),
	 vars: ["Temperature", "Battery Level", "Atmospheric Pressure"]
   },
   {
     name: "Princess Vulink",
     duck: await DuckDBClient.of({data: FileAttachment("./data/loc.Princess_VuLink_1114447.parquet")}),
	 vars: ["Temperature", "Battery Level", "Atmospheric Pressure"]
   },
   {
     name: "Silver AT500",
     duck: await DuckDBClient.of({data: FileAttachment("./data/loc.Silver_AT500_1115675.parquet")}),
	 vars: ["Temperature", "Specific Conductivity", "DO", "Depth", "Salinity"]
   },
   {
     name: "B Dock AT500",
     duck: await DuckDBClient.of({data: FileAttachment("./data/loc.BDock_AT500_1115690.parquet")}),
	 vars: ["Temperature", "Specific Conductivity", "DO", "Depth", "Salinity"]
   },
   {
     name: "Princess AT500",
     duck: await DuckDBClient.of({data: FileAttachment("./data/loc.Princess_AT500_1115670.parquet")}),
	 vars: ["Temperature", "Total Dissolved Solids", "DO", "Depth", "Salinity"]
   }
];

const instrument = view(Inputs.select(instruments, {
    value: instruments[0], 
    label: "Instrument",
    format: (t) => t.name,
}));
```

```js
const variables = all_variables.filter((x) => instrument.vars.includes(x.name));

const variable = view(Inputs.select(variables, {
    value: variables[0], 
    label: "Variable",
    format: (t) => t.name + " (" + t.unit + ")",
}));
```

```js
const result = instrument.duck.query(c2q(variable.key));
```

<div class="grid grid-cols-1">
  <div class="card">${
    resize((width) => Plot.plot({
      title: variable.name,
      width,
	  x: {grid: true, type: "utc", label: "Date", domain: [begin, now]},
      y: {grid: true, label: variable.unit, domain: variable.domain},
      marks: [
	    Plot.ruleY([0]),
		variable.mark(result, {x: "UTC", y: "Value"}),
      ]
    }))
  }</div>
</div>
