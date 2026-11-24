# E2B cloudroom-core spike (2026-11-24)

Sandbox id: see the untracked `sandbox-id.txt` beside this file (E2B default base template, Debian 12, x86_64, 2 vCPU, ~512 MB RAM, 22 GB disk).
State when this was written: **PAUSED**. Metadata `purpose=cloudroom-spike`.

Installed: cloudroom-core 0.1.122 (prebuilt release, checksum verified), accounts `cloudroom` + `cloudroom-agent`,
`/etc/cloudroom/core.env` (token generated in-sandbox, mode 600, never read out), `storage.json` with
`cgroup_root=/sys/fs/cgroup/cloudroom/agents` (real cgroup v2 mode, not container mode),
Claude Code 2.1.331 at `/home/cloudroom-agent/.local/bin/claude` (+ `~/.claude`), Codex 0.154.0 at `/usr/local/bin/codex`
(not configured in core.env: Codex config requires a model). Core listens on 127.0.0.1:9840 only.

All commands run from this folder with Node 22 (`source ~/.nvm/nvm.sh && nvm use 22.20.0`).
`env.mjs` loads `E2B_API_KEY` from bamfaiapp/.env.local without printing it.

```sh
# resume (connect auto-resumes a paused sandbox) and give it 30 min
node -e "import('./env.mjs').then(({Sandbox})=>Sandbox.connect('<sandbox-id>',{timeoutMs:1800000}))"
# exec as root (arg = inline command or a local script file)
node run.mjs <sandbox-id> 60 '. /root/api.sh; api /v1/ready; api /v1/accounts/claude'
# if core is not running after a cold boot
node run.mjs <sandbox-id> 60 'setsid nohup /usr/local/lib/cloudroom/sandbox-start.sh >/var/log/cloudroom-start.out 2>&1 </dev/null & sleep 5; tail -3 /var/log/cloudroom/core.log'
# pause again
node -e "import('./env.mjs').then(async({Sandbox})=>console.log(await (await Sandbox.connect('<sandbox-id>')).pause()))"
# kill when done
node -e "import('./env.mjs').then(async({Sandbox})=>console.log(await Sandbox.kill('<sandbox-id>')))"
```

Sign in to Claude later: `node run.mjs <id> 300 "sudo -iu cloudroom-agent claude auth login"` is interactive, so prefer the
API flow (`POST /v1/accounts/claude/login` then `/complete` with `code` + `state`) or an E2B PTY.

Files: `install-core.sh` (install), `start.sh`/`probe.sh` (start + API probes), `harness.sh` (CLI installs).
