---
toc: false
title: "Area Map"
---

<style>
html`<link type="text/css" href="${await FileAttachment('style.css').url()}" rel="stylesheet" />`
</style>

<div class="hero">
	<h1>Noyo Harbor Blue Economy</h1>
	<h2>Project page</h2>
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

L.circle([39.42768783218275, -123.80584629151588], {radius: 20}).bindPopup("Princess Seafood").addTo(map);
L.circle([39.42630383307301, -123.80507914592623], {radius: 20}).bindPopup("The Wharf").addTo(map);
L.circle([39.42359794726219, -123.80380240755608], {radius: 20}).bindPopup("Field Station").addTo(map);
L.circle([39.42398791346205, -123.80214663996874], {radius: 20}).bindPopup("B-Dock").addTo(map);
```
