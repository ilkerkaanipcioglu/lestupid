// See the Tailwind configuration guide for advanced usage
// https://tailwindcss.com/docs/configuration

const plugin = require("tailwindcss/plugin");
const fs = require("fs");
const path = require("path");

module.exports = {
  content: [
    "./js/**/*.js",
    "../lib/*_web.ex",
    "../lib/*_web/**/*.*ex",
    "../lib/*_web/**/*.heex"
  ],
  theme: {
    extend: {
      colors: {
        // Dukkadee brand colors
        "brand": {
          yellow: "#fddb24",
          "light-purple": "#b7acd4",
          DEFAULT: "#fddb24",
        },
        // Dark variations
        "brand-dark": {
          1: "#272727",
          2: "#282828",
          3: "#292929",
          4: "#2a2a2a",
          5: "#2b2b2b",
          6: "#2c2c2c",
          7: "#2d2d2d",
          8: "#2e2e2e",
          9: "#2f2f2f",
          10: "#303030",
          11: "#313131",
          12: "#323232",
          13: "#333333",
          14: "#343434",
          15: "#353535",
          16: "#363636",
          17: "#373737",
          DEFAULT: "#2f2f2f",
        }
      },
      backgroundImage: {
        'gradient-brand': 'linear-gradient(to right, #fddb24, #b7acd4)',
      },
    },
  },
  plugins: [
    require("@tailwindcss/forms"),
    // Allows prefixing tailwind classes with LiveView classes to add rules
    // only when LiveView classes are applied, for example:
    //
    //     <div class="phx-click-loading:animate-ping">
    //
    plugin(({addVariant}) => addVariant("phx-no-feedback", [".phx-no-feedback&", ".phx-no-feedback &"])),
    plugin(({addVariant}) => addVariant("phx-click-loading", [".phx-click-loading&", ".phx-click-loading &"])),
    plugin(({addVariant}) => addVariant("phx-submit-loading", [".phx-submit-loading&", ".phx-submit-loading &"])),
    plugin(({addVariant}) => addVariant("phx-change-loading", [".phx-change-loading&", ".phx-change-loading &"])),

    // Embeds Heroicons (https://heroicons.com) into your app.css bundle
    // See your `CoreComponents.icon/1` for more information.
    //
    plugin(function({matchComponents, theme}) {
      let iconsDir = path.join(__dirname, "../priv/hero_icons/optimized");
      let values = {};
      try {
        fs.readdirSync(iconsDir).forEach(file => {
          let name = path.basename(file, ".svg");
          values[name] = {name, fullPath: path.join(iconsDir, file)};
        });
      } catch (error) {
        console.log(`Warning: ${error}`);
      }
      matchComponents({
        "hero": ({name, fullPath}) => {
          let content = fs.readFileSync(fullPath).toString().replace(/\r?\n|\r/g, "");
          return {
            [`--hero-${name}`]: `url('data:image/svg+xml;utf8,${content}')`,
            "-webkit-mask": `var(--hero-${name})`,
            "mask": `var(--hero-${name})`,
            "mask-repeat": "no-repeat",
            "background-color": "currentColor",
            "vertical-align": "middle",
            "display": "inline-block",
            "width": theme("spacing.5"),
            "height": theme("spacing.5")
          };
        }
      }, {values});
    })
  ]
}
