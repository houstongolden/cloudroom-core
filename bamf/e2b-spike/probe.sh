kill "$(cat /run/cloudroom-supervisor.pid)"; pkill -x cloudroom; sleep 2
sed -i "/^CLOUDROOM_CODEX_/d" /etc/cloudroom/core.env
setsid nohup /usr/local/lib/cloudroom/sandbox-start.sh >/var/log/cloudroom-start.out 2>&1 < /dev/null &
sleep 6; tail -3 /var/log/cloudroom/core.log
. /root/api.sh
api /v1/ready; api /v1/capabilities; api /v1/accounts/claude
api /v1/sessions --json '{"request_id":"spike1","harness":"claude-code"}'
api /v1/accounts/claude/login --json '{"request_id":"spike-login1"}' > /root/login.json
python3 -c "
import json,re;t=open('/root/login.json').read().split('\n[http')[0]
d=json.loads(t)
def shape(x):
  if isinstance(x,dict): return {k:shape(v) for k,v in x.items()}
  if isinstance(x,list): return [shape(v) for v in x[:2]]
  return (type(x).__name__+(':url host='+re.sub(r'https?://([^/]+).*',r'\1',x) if isinstance(x,str) and x.startswith('http') else '')) if isinstance(x,str) else x
print(json.dumps(shape(d)))"; grep -o '\[http [0-9]*\]' /root/login.json
api /v1/accounts/claude/cancel --json '{"request_id":"spike-login1"}' | head -c 300
