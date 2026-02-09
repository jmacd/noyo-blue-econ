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
  build: {
    outDir: resolve(__dirname, 'dist'),
    emptyOutDir: true,
    ...(inputs.length > 0 && {
      rollupOptions: {
        input: inputs,
      },
    }),
  },
})
