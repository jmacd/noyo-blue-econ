---
toc: false
title: Vulink Instruments
---

```js
html`<link type="text/css" href="${await FileAttachment('style.css').url()}" rel="stylesheet" />`
```

<div class="hero">
	<h1>Noyo Harbor Blue Economy</h1>
	<h2>Vulink Instruments</h2>
</div>


<details>
  <summary>Controls</summary>

```js
// TODO: Note that Air temperature measurements are available but one site is not reporting,
// and so they are not represented here.

const timelist = [
  ["1 Week", 7],
  ["2 Weeks", 14],
  ["1 Month", 30],
  ["2 Months", 60],
  ["3 Months", 90],
  ["6 Months", 180]
];

const instruments_list = [
   {
     name: "The Wharf",
	 short: "silver",
   },
   {
     name: "B-Dock",
	 short: "bdock",
   },
   {
     name: "Princess Seafood",
	 short: "princess",
   },
   {
     name: "Field Station",
	 short: "fieldstation",
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

const instruments = view(
  Inputs.checkbox(
    instruments_list,
    {
      value: instruments_list, 
      label: "Instrument",
      format: (t) => {
	    return html`<span style="
          font-size: 1.5vw;
          font-weight: 300;
          line-height: 1;
        ">${t.name}</span>`
	  }
    }
  )
);

```

</details>

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

function c2q(name, short) {
	return `SELECT '${name}' as SITE, "Vulink.Battery Level.%" as BATT, "Vulink.Baro.psi" as BARO, Timestamp*1000 as UTC from ${short} where UTC >= ${begin}`;
}
```

```js
const byinst = instruments.map(inst => { 
  const qs = c2q(inst.name, inst.short);
  return duck.query(qs);
});
const results = await Promise.all(byinst);
```

```js
const battery = results.map(result => {
	return Plot.lineY(result, {x: "UTC", y: "BATT", stroke: "SITE"});
});
const baro = results.map(result => {
	return Plot.lineY(result, {x: "UTC", y: "BARO", stroke: "SITE"});
});
```

<div class="grid grid-cols-1">
  <div class="card">${
    resize((width) => Plot.plot({
	  grid: true,
      color: {legend: true},
      title: "Battery Level",
      width,
	  x: {grid: true, type: "time", label: "Date", domain: [begin, now]},
      y: {grid: true, label: "%", domain: [0, 100], clamp: true},
      marks: battery
    }))
  }</div>
  <div class="card">${
    resize((width) => Plot.plot({
	  grid: true,
      color: {legend: true},
      title: "Barometric Pressure",
      width,
	  x: {grid: true, type: "time", label: "Date", domain: [begin, now]},
      y: {grid: true, label: "psi", domain: [13, 15], clamp: true},
      marks: baro
    }))
  }</div>
</div>

```js
console.log(results[0]);
Inputs.table(results[0].toArray());
```
