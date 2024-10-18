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
const all_variables = [
   {
     name: "Battery Level",
	 unit: "%",
	 key: "Vulink.Battery Level.%",
	 domain: [0, 100], 
	 mark: Plot.line
   },
   {
     name: "Temperature",
	 unit: "C",
	 key: "Vulink.Temperature.C",
	 domain: [0, 30], 
	 mark: Plot.line
   },
   {
     name: "Atmospheric Pressure",
	 unit: "psi",
	 key: "Vulink.Baro.psi",
	 domain: [14, 15], 
	 mark: Plot.line
   },
];

const timelist = [
  ["1 Week", 7],
  ["2 Weeks", 14],
  ["1 Month", 30],
  ["2 Months", 60],
  ["3 Months", 90]
];

const instruments_list = [
   {
     name: "Silver",
	 short: "silver",
	 vars: ["Temperature", "Battery Level", "Atmospheric Pressure"]
   },
   {
     name: "B-Dock",
	 short: "bdock",
	 vars: ["Temperature", "Battery Level", "Atmospheric Pressure"]
   },
   {
     name: "Princess",
	 short: "princess",
	 vars: ["Temperature", "Battery Level", "Atmospheric Pressure"]
   },
   {
     name: "Field Station",
	 short: "fieldstation",
	 vars: ["Battery Level", "Atmospheric Pressure"]
   },
];

const instruments = view(
  Inputs.checkbox(
    instruments_list,
    {
      value: instruments_list, 
      label: "Instrument",
      format: (t) => t.name,
    }
  )
);

const timepick = view(
  Inputs.radio(
    new Map(timelist),
    {
		value: 7, 
		label: "Time range", 
   	}
  )
);

const variable = view(
  Inputs.radio(
    all_variables,
    {
      value: all_variables[0], 
      label: "Measurement",
      format: (t) => t.name,
    }
  )
);
```

```js
// This section loads after the controls render.
const duck = await DuckDBClient.of({
    silver: FileAttachment("./data/combined-Silver.parquet"),
    bdock: FileAttachment("./data/combined-BDock.parquet"),
    princess: FileAttachment("./data/combined-Princess.parquet"),
    fieldstation: FileAttachment("./data/combined-FieldStation.parquet"),
});

// Timestamps are in milliseconds
const now = new Date().getTime();

// 24 days, 3600 secs/hour, 1000 ms/sec
const begin = now - timepick * 24 * 3600 * 1000;

function c2q(short, cname) {
	return `SELECT "${cname}" as Value, timestamp*1000 as UTC from ${short} where UTC >= ${begin}`;
}

//const princess = duck.sql`select * from princess`;
//Inputs.table(princess)
```

hello

```js
duck.queryRow(`SELECT COUNT() FROM princess`)
```
there

```js
Inputs.table(duck.sql`select * from bdock`)
```
hi

```js
//const results = instruments.map((inst) => { 
//   console.log("VALUE");
//   console.log(inst.name);
//   return duck.sql`SELECT "${variable.key}" as Value, timestamp*1000 as UTC from ${inst.short} where UTC >= ${begin}`;
//});
Inputs.table(duck.sql`SELECT "Vulink.Battery Level.%" as Value, timestamp*1000 as UTC from princess where UTC >= 0`)
```
