---
toc: false
sql:
  fieldstationSurface: ./data/noyo-fieldstation-surface.csv
  fieldstationBottom: ./data/noyo-fieldstation-bottom.csv
  princessData: ./data/noyo-princess.csv
  bDockData: ./data/noyo-bdock.csv
  silversData: ./data/noyo-silvers.csv
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

L.marker([39.42768783218275, -123.80584629151588]).bindPopup("Princess").addTo(map);
L.marker([39.42630383307301, -123.80507914592623]).bindPopup("Silvers").addTo(map);
L.marker([39.42359794726219, -123.80380240755608]).bindPopup("Field Station").addTo(map);
L.marker([39.42398791346205, -123.80214663996874]).bindPopup("B Dock").addTo(map);
```

```js
// From FS-Top: LakeTech style data
const topsal = await sql`SELECT Value, "Offset", strptime(Timestamp, '%Y-%m-%d %H:%M') as Date, 'FS Surface' as Name from fieldstationSurface where \"Series Name\" = 'Surface Salinity' AND date_sub('day', Date, current_date) < 14`
const topDO = await sql`SELECT Value, "Offset", strptime(Timestamp, '%Y-%m-%d %H:%M') as Date, 'FS Surface' as Name from fieldstationSurface where \"Series Name\" = 'Surface DO' AND date_sub('day', Date, current_date) < 14`
const topTEMP = await sql`SELECT Value, "Offset", strptime(Timestamp, '%Y-%m-%d %H:%M') as Date, 'FS Surface' as Name from fieldstationSurface where \"Series Name\" = 'Surface Temp' AND date_sub('day', Date, current_date) < 14`
const topCHLA = await sql`SELECT Value, "Offset", strptime(Timestamp, '%Y-%m-%d %H:%M') as Date, 'FS Surface' as Name from fieldstationSurface where \"Series Name\" = 'Surface Chl-a' AND date_sub('day', Date, current_date) < 14`
const topPH = await sql`SELECT Value, "Offset", strptime(Timestamp, '%Y-%m-%d %H:%M') as Date, 'FS Surface' as Name from fieldstationSurface where \"Series Name\" = 'Surface pH' AND date_sub('day', Date, current_date) < 14`

// From FS-Bottom: LakeTech style is localtime
const botsal = await sql`SELECT Value, "Offset", strptime(Timestamp, '%Y-%m-%d %H:%M') as Date, 'FS Bottom' as Name from fieldstationBottom where \"Series Name\" = 'Bottom Salinity' AND date_sub('day', Date, current_date) < 14`
const botDO = await sql`SELECT Value, "Offset", strptime(Timestamp, '%Y-%m-%d %H:%M') as Date, 'FS Bottom' as Name from fieldstationBottom where \"Series Name\" = 'Bottom DO' AND date_sub('day', Date, current_date) < 14`
const botTEMP = await sql`SELECT Value, "Offset", strptime(Timestamp, '%Y-%m-%d %H:%M') as Date, 'FS Bottom' as Name from fieldstationBottom where \"Series Name\" = 'Bottom Temp' AND date_sub('day', Date, current_date) < 14`
const botdep = await sql`SELECT Value, "Offset", strptime(Timestamp, '%Y-%m-%d %H:%M') as Date, 'FS Bottom' as Name from fieldstationBottom where \"Series Name\" = 'Depth' AND date_sub('day', Date, current_date) < 14`

// Princess, Silvers, B Dock: In-Situ stye data is UTC, subtract 7 hours
const bdockSal = await sql`SELECT "Salinity (psu)" as Value, "Date Time" - INTERVAL 7 hour as Date, 'B Dock Bottom' as Name from bDockData where date_sub('day', Date, current_date) < 14`
const princessSal = await sql`SELECT "Salinity (psu)" as Value, "Date Time" - INTERVAL 7 hour as Date, 'Princess Bottom' as Name from princessData where date_sub('day', Date, current_date) < 14`
const silversSal = await sql`SELECT "Salinity (psu)" as Value, "Date Time" - INTERVAL 7 hour as Date, 'Silvers Bottom' as Name from silversData where date_sub('day', Date, current_date) < 14`

const bdockDO = await sql`SELECT "DO (mg/L)" as Value, "Date Time" - INTERVAL 7 hour as Date, 'B Dock Bottom' as Name from bDockData where date_sub('day', Date, current_date) < 14`
const princessDO = await sql`SELECT "DO (mg/L)" as Value, "Date Time" - INTERVAL 7 hour as Date, 'Princess Bottom' as Name from princessData where date_sub('day', Date, current_date) < 14`
const silversDO = await sql`SELECT "DO (mg/L)" as Value, "Date Time" - INTERVAL 7 hour as Date, 'Silvers Bottom' as Name from silversData where date_sub('day', Date, current_date) < 14`

// Note: the Princess data set has a missing value for temperature, added Value != 0 clause.
const bdockTEMP = await sql`SELECT "Temperature (C)" as Value, "Date Time" - INTERVAL 7 hour as Date, 'B Dock Bottom' as Name from bDockData where date_sub('day', Date, current_date) < 14 AND Value != 0`
const princessTEMP = await sql`SELECT "Temperature (C)" as Value, "Date Time" - INTERVAL 7 hour as Date, 'Princess Bottom' as Name from princessData where date_sub('day', Date, current_date) < 14 AND Value != 0`
const silversTEMP = await sql`SELECT "Temperature (C)" as Value, "Date Time" - INTERVAL 7 hour as Date, 'Silvers Bottom' as Name from silversData where date_sub('day', Date, current_date) < 14 AND Value != 0`

const princessTDS = await sql`SELECT "Total Dissolved Solids (mg/L)" as Value, "Date Time" - INTERVAL 7 hour as Date, 'Princess Bottom' as Name from princessData where date_sub('day', Date, current_date) < 14`

// Note was using "Offset" field, but it changed in the past couple of days.
const harborOffset = -6.46

function c2f(x) {
    return (x * 9 / 5) + 32
}	
```

<div class="grid grid-cols-2">
  <div class="card">${
    resize((width) => Plot.plot({
      title: "Harbor Depth",
      width,
	  x: {grid: true, type: "time"},
      y: {grid: true, label: "Depth (ft)"},
	  color: {legend: true},
      marks: [
	    Plot.ruleY([0]),
		Plot.lineY(botdep, {x: "Date", y: (d) => d.Value - harborOffset, stroke: "Name"})
      ]
    }))
  }</div>
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
		Plot.lineY(botsal, {x: "Date", y: "Value", stroke: "Name"}),
		Plot.lineY(topsal, {x: "Date", y: "Value", stroke: "Name"}),
		Plot.lineY(bdockSal, {x: "Date", y: "Value", stroke: "Name"}),
		Plot.lineY(princessSal, {x: "Date", y: "Value", stroke: "Name"}),
		Plot.lineY(silversSal, {x: "Date", y: "Value", stroke: "Name"})
      ]
    }))
  }</div>
  <div class="card">${
    resize((width) => Plot.plot({
      title: "Disolved Oxygen",
      width,
	  x: {type: "time", grid: true},
      y: {grid: true, label: "Disolved Oxygen (mg/L)", domain: [7, 12.5]},
	  color: {legend: true},
      marks: [
		Plot.lineY(topDO, {x: "Date", y: "Value", stroke: "Name"}),
		Plot.lineY(botDO, {x: "Date", y: "Value", stroke: "Name"}),
		Plot.lineY(bdockDO, {x: "Date", y: "Value", stroke: "Name"}),
		Plot.lineY(princessDO, {x: "Date", y: "Value", stroke: "Name"}),
		Plot.lineY(silversDO, {x: "Date", y: "Value", stroke: "Name"})
      ]
    }))
  }</div>
  <div class="card">${
    resize((width) => Plot.plot({
      title: "Water Temperature",
      width,
	  x: {type: "time", grid: true},
      y: {grid: true, label: "℉", domain: [45, 60]},
	  color: {legend: true},
      marks: [
		Plot.lineY(topTEMP, {x: "Date", y: (d) => c2f(d.Value), stroke: "Name"}),
		Plot.lineY(botTEMP, {x: "Date", y: (d) => c2f(d.Value), stroke: "Name"}),
		Plot.lineY(bdockTEMP, {x: "Date", y: (d) => c2f(d.Value), stroke: "Name"}),
		Plot.lineY(princessTEMP, {x: "Date", y: (d) => c2f(d.Value), stroke: "Name"}),
		Plot.lineY(silversTEMP, {x: "Date", y: (d) => c2f(d.Value), stroke: "Name"})
      ]
    }))
  }</div>
  <div class="card">${
    resize((width) => Plot.plot({
      title: "pH",
      width,
	  x: {type: "time", grid: true},
      y: {grid: true, label: "pH", domain: [7.5, 8.5]},
	  color: {legend: true},
      marks: [
		Plot.lineY(topPH, {x: "Date", y: "Value", stroke: "Name"})
      ]
    }))
  }</div>
  <div class="card">${
    resize((width) => Plot.plot({
      title: "Chlorophyl-A",
      width,
	  x: {type: "time", grid: true},
      y: {grid: true, label: "RFU"},
	  color: {legend: true},
      marks: [
	    Plot.ruleY([0]),
		Plot.lineY(topCHLA, {x: "Date", y: "Value", stroke: "Name"})
      ]
    }))
  }</div>
  <div class="card">${
    resize((width) => Plot.plot({
      title: "Total Dissolved Solids (mg/L)",
      width,
	  x: {grid: true, type: "time"},
      y: {grid: true, label: "mg/L"},
	  color: {legend: true},
      marks: [
	    Plot.ruleY([0]),
		Plot.lineY(princessTDS, {x: "Date", y: "Value", stroke: "Name"})
      ]
    }))
  }</div>
</div>
