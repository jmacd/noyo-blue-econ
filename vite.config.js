import { defineConfig } from 'vite'
import { resolve, join } from 'node:path'
import { existsSync, readdirSync, statSync } from 'node:fs'

// Recursively find all HTML files under a directory
function findHtml(dir, files = []) {
  if (!existsSync(dir)) return files
  for (const entry of readdirSync(dir)) {
    const full = join(dir, entry)
    if (statSync(full).isDirectory()) findHtml(full, files)
    else if (entry.endsWith('.html')) files.push(full)
  }
  return files
}

const buildRoot = resolve(__dirname, 'build')
const inputs = findHtml(buildRoot)

export default defineConfig({
  base: '/noyo-harbor/',
  root: 'build',
  // publicDir copies build/public/ → dist/ as-is (no hashing/processing).
  // Sitegen exports parquet data into build/data/; we symlink it so Vite
  // includes it in the output without any post-build copy step.
  publicDir: false,
  build: {
    outDir: resolve(__dirname, 'dist'),
    emptyOutDir: true,
    // Copy the data directory into dist/ after bundling
    copyPublicDir: false,
    ...(inputs.length > 0 && {
      rollupOptions: {
        input: inputs,
      },
    }),
  },
  plugins: [
    // Copy build/data/ → dist/data/ so parquet files are served alongside HTML
    {
      name: 'copy-data-dir',
      closeBundle: async () => {
        const { cpSync } = await import('node:fs')
        const src = resolve(__dirname, 'build', 'data')
        const dst = resolve(__dirname, 'dist', 'data')
        if (existsSync(src)) {
          cpSync(src, dst, { recursive: true })
          console.log('  Copied build/data/ → dist/data/')
        }
      },
    },
  ],
})
