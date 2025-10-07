// See https://observablehq.com/framework/config for documentation.
export default {
  // The project’s title; used in the sidebar and webpage titles.
  title: "Noyo Harbor",

  pages: [
    {
      name: "Overview",
      pages: [
          {name: "Disolved Oxygen", path: "/data/DO.html"},
          {name: "Salinity", path: "/data/Salinity.html"},
          {name: "Water Temperature", path: "/data/Temperature.html"},
      ]
    },
    {
      name: "Detail",
      open: true,
      pages: [
          {name: "BDock", path: "/data/BDock.html"},
          {name: "Silver", path: "/data/Silver.html"},
          {name: "Princess", path: "/data/Princess.html"},
      ]
    }
  ],

  // Some additional configuration options and their defaults:
  theme: "light", // try "light", "dark", "slate", etc.
  // header: "", // what to show in the header (HTML)
  // footer: "Built with Observable.", // what to show in the footer (HTML)
  // toc: true, // whether to show the table of contents
  // pager: true, // whether to show previous & next links in the footer
  root: "src", // path to the source root for preview
  // output: "dist", // path to the output root for build
  // search: true, // activate search
};
