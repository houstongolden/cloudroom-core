import fs from 'node:fs';
const t = fs.readFileSync('/Users/houstongolden/Desktop/CODE_2025/bamfaiapp/.env.local','utf8');
const m = t.match(/^E2B_API_KEY=["']?([^"'\n]+)/m);
if (!m) throw new Error('E2B_API_KEY missing');
process.env.E2B_API_KEY = m[1];
export const { Sandbox } = await import('/Users/houstongolden/Desktop/CODE_2025/bamfaiapp/node_modules/e2b/dist/index.mjs');
