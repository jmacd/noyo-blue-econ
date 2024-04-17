---
toc: false
sql:
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

<div class="hero">
  <h1>Hello, Noyo Harbor</h1>
</div>

```js
const topsal = await sql`SELECT Value, "Offset", strptime(Timestamp, '%Y-%m-%d %H:%M') as Date from fieldstationSurface where \"Series Name\" = 'Surface Salinity' AND date_sub('day', Date, current_date) < 14`
const topDO = await sql`SELECT Value, "Offset", strptime(Timestamp, '%Y-%m-%d %H:%M') as Date from fieldstationSurface where \"Series Name\" = 'Surface DO' AND date_sub('day', Date, current_date) < 14`
const topTEMP = await sql`SELECT Value, "Offset", strptime(Timestamp, '%Y-%m-%d %H:%M') as Date from fieldstationSurface where \"Series Name\" = 'Surface Temp' AND date_sub('day', Date, current_date) < 14`
const topCHLA = await sql`SELECT Value, "Offset", strptime(Timestamp, '%Y-%m-%d %H:%M') as Date from fieldstationSurface where \"Series Name\" = 'Surface Chl-a' AND date_sub('day', Date, current_date) < 14`
const topPH = await sql`SELECT Value, "Offset", strptime(Timestamp, '%Y-%m-%d %H:%M') as Date from fieldstationSurface where \"Series Name\" = 'Surface pH' AND date_sub('day', Date, current_date) < 14`

const botsal = await sql`SELECT Value, "Offset", strptime(Timestamp, '%Y-%m-%d %H:%M') as Date from fieldstationBottom where \"Series Name\" = 'Bottom Salinity' AND date_sub('day', Date, current_date) < 14`
const botDO = await sql`SELECT Value, "Offset", strptime(Timestamp, '%Y-%m-%d %H:%M') as Date from fieldstationBottom where \"Series Name\" = 'Bottom DO' AND date_sub('day', Date, current_date) < 14`
const botTEMP = await sql`SELECT Value, "Offset", strptime(Timestamp, '%Y-%m-%d %H:%M') as Date from fieldstationBottom where \"Series Name\" = 'Bottom Temp' AND date_sub('day', Date, current_date) < 14`

const botdep = await sql`SELECT Value, "Offset", strptime(Timestamp, '%Y-%m-%d %H:%M') as Date from fieldstationBottom where \"Series Name\" = 'Depth' AND date_sub('day', Date, current_date) < 14`
```

<div class="grid grid-cols-2" style="grid-auto-rows: 504px;">
  <div class="card">${
    resize((width) => Plot.plot({
      title: "Harbor Depth",
      subtitle: "Measured at Field Station",
      width,
	  x: {type: "time", grid: true},
      y: {grid: true, label: "Depth (f)"},
      marks: [
	    Plot.ruleY([0]),
		Plot.lineY(botdep, {x: "Date", y: (d) => d.Value - d.Offset, stroke: "steelblue"})
      ]
    }))
  }</div>
  <div class="card">${
    resize((width) => Plot.plot({
      title: "Salinity",
      subtitle: "Measured at Field Station Surface/Bottom",
      width,
	  x: {type: "time", grid: true},
      y: {grid: true, label: "Salinity (g/kg)"},
      marks: [
        Plot.ruleY([0]),
        Plot.ruleY([35], {stroke: "LightSeaGreen", strokeWidth: 2}),
		Plot.lineY(botsal, {x: "Date", y: "Value", stroke: "mediumblue"}),
		Plot.lineY(topsal, {x: "Date", y: "Value", stroke: "darkturquoise"})
      ]
    }))
  }</div>
</div>

<div class="grid grid-cols-2" style="grid-auto-rows: 504px;">
  <div class="card">${
    resize((width) => Plot.plot({
      title: "Disolved Oxygen",
      subtitle: "Measured at Field Station Top Surface/Bottom",
      width,
	  x: {type: "time", grid: true},
      y: {grid: true, label: "Disolved Oxygen (mg/L)", domain: [7, 12.5]},
      marks: [
		Plot.lineY(topDO, {x: "Date", y: "Value", stroke: "darkturquoise"}),
		Plot.lineY(botDO, {x: "Date", y: "Value", stroke: "mediumblue"})
      ]
    }))
  }</div>
  <div class="card">${
    resize((width) => Plot.plot({
      title: "Water Temperature",
      subtitle: "Measured at Field Station Surface/Bottom",
      width,
	  x: {type: "time", grid: true},
      y: {grid: true, label: "℉", domain: [45, 60]},
      marks: [
		Plot.lineY(topTEMP, {x: "Date", y: (d) => (d.Value * 9 / 5)+32, stroke: "skyblue"}),
		Plot.lineY(botTEMP, {x: "Date", y: (d) => (d.Value * 9 / 5)+32, stroke: "mediumblue"})
      ]
    }))
  }</div>
  <div class="card">${
    resize((width) => Plot.plot({
      title: "pH",
      subtitle: "Measured at Field Station Surface",
      width,
	  x: {type: "time", grid: true},
      y: {grid: true, label: "pH", domain: [7.5, 8.5]},
      marks: [
		Plot.lineY(topPH, {x: "Date", y: (d) => d.Value, stroke: "steelblue"})
      ]
    }))
  }</div>
  <div class="card">${
    resize((width) => Plot.plot({
      title: "Chlorophyl-A",
      subtitle: "Measured at Field Station Surface",
      width,
	  x: {type: "time", grid: true},
      y: {grid: true, label: "RFU"},
      marks: [
	    Plot.ruleY([0]),
		Plot.lineY(topCHLA, {x: "Date", y: (d) => d.Value, stroke: "steelblue"})
      ]
    }))
  }</div>
</div>
