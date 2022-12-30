const path = require('path')
const rails = require('esbuild-rails')

require("esbuild").build({
  entryPoints: ["application.js"],
  bundle: true,
  outdir: path.join(process.cwd(), "app/assets/builds"),
  absWorkingDir: path.join(process.cwd(), "app/javascript"),
  watch: process.argv.includes("--watch"),
  plugins: [rails()],
  minify: process.env.RAILS_ENV === "production",
  sourcemap: process.env.RAILS_ENV !== "production"
}).catch(() => process.exit(1))