#!/usr/bin/env node
// Apply unbscholar-specific edits to /app/angular.json with structural asserts.

const fs = require("fs");
const FILE = "/app/angular.json";
const PROJECT = "dspace-angular";

const data = JSON.parse(fs.readFileSync(FILE, "utf8"));

const project = data.projects && data.projects[PROJECT];
if (!project) throw new Error(`expected projects['${PROJECT}'] in ${FILE}`);

const buildOpts = project.architect && project.architect.build && project.architect.build.options;
const serveOpts = project.architect && project.architect.serve && project.architect.serve.options;
if (!buildOpts) throw new Error("expected architect.build.options");
if (!serveOpts) throw new Error("expected architect.serve.options");

// Insert unbscholar-theme bundle into styles, immediately after custom-theme.
const styles = buildOpts.styles;
if (!Array.isArray(styles)) throw new Error("architect.build.options.styles is not an array");
const customThemeIdx = styles.findIndex(
  s => s && typeof s === "object" && s.bundleName === "custom-theme"
);
if (customThemeIdx === -1) throw new Error("custom-theme entry not found in styles");
styles.splice(customThemeIdx + 1, 0, {
  input: "src/themes/unbscholar/styles/theme.scss",
  inject: false,
  bundleName: "unbscholar-theme",
});

// Insert favicon + apple-touch-icon globs before the "src/assets" entry so
// browsers/iOS auto-fetch them at URL root regardless of <link rel=>.
const assets = buildOpts.assets;
if (!Array.isArray(assets)) throw new Error("architect.build.options.assets is not an array");
const srcAssetsIdx = assets.indexOf("src/assets");
if (srcAssetsIdx === -1) throw new Error("'src/assets' string entry not found in assets");
assets.splice(
  srcAssetsIdx, 0,
  { glob: "favicon.ico", input: "src/", output: "/" },
  { glob: "apple-touch-icon*.png", input: "src/assets/unbscholar/images/favicons/", output: "/" },
);

// Let dev server accept any host; replaces the runtime sed against package.json.
serveOpts.allowedHosts = ["all"];

fs.writeFileSync(FILE, JSON.stringify(data, null, 2) + "\n");
