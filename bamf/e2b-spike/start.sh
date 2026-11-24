cat /sys/fs/cgroup/cgroup.subtree_control
setsid nohup /usr/local/lib/cloudroom/sandbox-start.sh >/var/log/cloudroom-start.out 2>&1 < /dev/null &
sleep 6; cat /var/log/cloudroom-start.out; tail -30 /var/log/cloudroom/core.log
. /root/api.sh; api /v1/ready; api /v1/health
