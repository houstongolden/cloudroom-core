// usage: node copy-token.mjs [sandbox-id]
// Copies core's API token from the sandbox to the macOS clipboard and prints the core URL.
// The token is never printed. Paste it into the app: Settings > Account > "Or connect your own Core".
// (A script cannot do this step: the app's local server only accepts it from the desktop app itself.)
import fs from 'node:fs';
import { spawnSync } from 'node:child_process';
import { Sandbox } from './env.mjs';
const id = process.argv[2] ?? fs.readFileSync(new URL('./sandbox-id.txt', import.meta.url), 'utf8').trim();
const sbx = await Sandbox.connect(id, { timeoutMs: 3600000 });
const r = await sbx.commands.run("awk -F= '/^CLOUDROOM_TOKEN=/{printf \"%s\", $2}' /etc/cloudroom/core.env", { user: 'root' });
if (!r.stdout.trim()) throw new Error('no token in sandbox');
spawnSync('pbcopy', { input: r.stdout.trim() });
console.log(`Core URL: https://${sbx.getHost(9840)}\nToken copied to clipboard (not shown). Sandbox stays awake for 60 minutes.`);
