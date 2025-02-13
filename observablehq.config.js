// See https://observablehq.com/framework/config for documentation.
export default {
  // The project’s title; used in the sidebar and webpage titles.
  title: "Noyo Harbor",

  pages: [
    {
      name: "Overview",
      pages: [
//        {name: "Parameter", path: "/parameter"},
//        {name: "Vulink", path: "/vulink"}
      ]
    },
    {
      name: "Detail",
      open: true,
      pages: [
          {name: "Field Station", path: "/data/FieldStation"},
          {name: "BDock", path: "/data/BDock"},
          {name: "Silver", path: "/data/Silver"},
          {name: "Princess", path: "/data/Princess"},
      ]
    }
  ],

  // Some additional configuration options and their defaults:
  theme: "slate", // try "light", "dark", "slate", etc.
  // header: "", // what to show in the header (HTML)
  // footer: "Built with Observable.", // what to show in the footer (HTML)
  // toc: true, // whether to show the table of contents
  // pager: true, // whether to show previous & next links in the footer
  root: "src", // path to the source root for preview
  // output: "dist", // path to the output root for build
  // search: true, // activate search
};
