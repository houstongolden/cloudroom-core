set -euo pipefail
v=0.1.122
node --version; systemctl is-system-running 2>&1 || true
apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get install -y -qq curl git ca-certificates python3 openssl util-linux >/dev/null
stage=/root/core-$v; mkdir -p $stage; cd /root
curl -fsSL -o core.tgz https://github.com/davidondrej/cloudroom/releases/download/core-v$v/cloudroom-core-$v-linux-x86_64.tar.gz
tar -xzf core.tgz -C $stage --no-same-owner
sum=$(python3 -c 'import json,sys;print(json.load(open(sys.argv[1]))["sha256"])' $stage/update-manifest.json)
echo "$sum  $stage/cloudroom" | sha256sum --check
id cloudroom >/dev/null 2>&1 || useradd --system --user-group --create-home --home-dir /var/lib/cloudroom --shell /usr/sbin/nologin cloudroom
id cloudroom-agent >/dev/null 2>&1 || useradd --create-home --user-group --shell /bin/bash cloudroom-agent
chmod 700 /var/lib/cloudroom /home/cloudroom-agent
install -d -m 700 -o cloudroom -g cloudroom /var/lib/cloudroom/history
install -d -m 750 -o root -g cloudroom /etc/cloudroom
install -d -m 755 /usr/local/lib/cloudroom
install -d -m 700 -o cloudroom-agent -g cloudroom-agent /code
install -m 755 $stage/cloudroom /usr/local/lib/cloudroom/cloudroom
install -m 755 $stage/install/configure.py /usr/local/lib/cloudroom/configure.py
install -m 755 $stage/install/sandbox-start.sh /usr/local/lib/cloudroom/sandbox-start.sh
install -m 755 $stage/install/previews.py /usr/local/lib/cloudroom/previews.py
( umask 077; set -C; printf 'CLOUDROOM_TOKEN=%s\n' "$(openssl rand -hex 32)" > /etc/cloudroom/core.env )
cat >> /etc/cloudroom/core.env <<E2
CLOUDROOM_LISTEN=127.0.0.1:9840
CLOUDROOM_STORE=self-hosted
CLOUDROOM_LOCAL_HISTORY=1
CLOUDROOM_STATE_DIR=/var/lib/cloudroom/history
CLOUDROOM_ACCOUNT_HOME=/home/cloudroom-agent
E2
chown cloudroom:cloudroom /etc/cloudroom/core.env; chmod 600 /etc/cloudroom/core.env
python3 /usr/local/lib/cloudroom/configure.py --storage-only /etc/cloudroom
# no systemd unit here: point the policy at sandbox-start.sh's delegated cgroup
python3 - <<'PY'
import json;p='/etc/cloudroom/storage.json';d=json.load(open(p));d['cgroup_root']='/sys/fs/cgroup/cloudroom/agents'
open(p,'w').write(json.dumps(d,separators=(',',':')))
PY
chown cloudroom:cloudroom /etc/cloudroom/storage.json; chmod 600 /etc/cloudroom/storage.json
/usr/local/lib/cloudroom/cloudroom --version
