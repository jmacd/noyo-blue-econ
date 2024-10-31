// See https://observablehq.com/framework/config for documentation.
export default {
  // The project’s title; used in the sidebar and webpage titles.
  title: "Noyo Harbor",

  pages: [
    {
      name: "Overview",
      pages: [
        {name: "Parameter", path: "/parameter"},
        {name: "Vulink", path: "/vulink"}
      ]
    },
    {
      name: "Detail",
      open: false,
      pages: [
        {name: "B-Dock", path: "/quality-bdock.md"},
        {name: "Princess Seafood", path: "/quality-princess.md"},
        {name: "The Wharf", path: "/quality-wharf.md"},
        {name: "Field Station Surface", path: "/quality-fieldstationsurface.md"},
        {name: "Field Station Bottom", path: "/quality-fieldstationbottom.md"},
      ]
    }
  ],

    dynamicPaths: [
    "/quality-bdock.md",
    "/quality-princess.md",
    "/quality-wharf.md",
    "/quality-fieldstationsurface.md",
    "/quality-fieldstationbottom.md"
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
