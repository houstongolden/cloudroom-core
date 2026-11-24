# usage inside sandbox: api URL-path [curl args]
api() { p=$1; shift; awk -F= '/^CLOUDROOM_TOKEN=/{print "header = \"Authorization: Bearer " $2 "\""}' /etc/cloudroom/core.env | curl --config - --silent --show-error -w '\n[http %{http_code}]\n' "$@" "http://127.0.0.1:9840$p"; echo; }
