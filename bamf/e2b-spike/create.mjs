import { Sandbox } from './env.mjs';
const sbx = await Sandbox.create({ timeoutMs: 30*60*1000, metadata: { purpose: 'cloudroom-spike' } });
console.log(sbx.sandboxId);
