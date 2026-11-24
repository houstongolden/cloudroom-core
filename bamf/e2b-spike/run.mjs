// usage: node run.mjs <id> <timeoutSec> <script-file-or-cmd>
import fs from 'node:fs';
import { Sandbox } from './env.mjs';
const [id, to, arg] = process.argv.slice(2);
const cmd = fs.existsSync(arg) ? fs.readFileSync(arg,'utf8') : arg;
const sbx = await Sandbox.connect(id);
try {
  const r = await sbx.commands.run(cmd, { user: 'root', timeoutMs: Number(to)*1000 });
  process.stdout.write(r.stdout); process.stderr.write(r.stderr); console.log('[exit]', r.exitCode);
} catch (e) { process.stdout.write(e.stdout||''); process.stderr.write(e.stderr||String(e)); console.log('[exit]', e.exitCode ?? 'err'); }
