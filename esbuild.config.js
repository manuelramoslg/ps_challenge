const path = require('path')
const reactPlugin = require('esbuild-react')

require("esbuild").build({
  entryPoints: ["application.js"],
  bundle: true,
  outdir: path.join(process.cwd(), "app/assets/builds"),
  absWorkingDir: path.join(process.cwd(), "app/javascript"),
  watch: process.argv.includes("--watch"),
  plugins: [reactPlugin()],
  loader: { 
    '.js': 'jsx',
    '.jsx': 'jsx'
  },
  resolve: {
    alias: {
      '@': path.resolve(__dirname, 'app/javascript')
    }
  }
}).catch(() => process.exit(1))