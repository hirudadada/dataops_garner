#!/bin/bash -eu
set -o pipefail

ipvar=0.0.0.0

get_host_ip() {
  os=$(uname -s)
  if [ "${os}" == "Linux" ]; then
    ipvar=$(hostname -I | awk '{ print $1}')
  elif [ "${os}" == "Darwin" ]; then
    ipvar=$(ifconfig en0 | awk '$1 == "inet" {print $2}')
  fi
}

headers=(
  -H "kbn-version: ${DEV_STACK_VERSION}"
  -H "kbn-xsrf: kibana"
  -H 'Content-Type: application/json'
)

LOCAL_KBN_URL="${DEV_LOCAL_URL}:${DEV_KBN_PORT}"

configure_kbn() {
  MAXTRIES=15
  i=${MAXTRIES}

  while [ $i -gt 0 ]; do
    response=$(curl -I -k --silent "${LOCAL_KBN_URL}" || true)
    status=$(echo "$response" | head -n 1 | cut -d ' ' -f2)

    if [ -n "$status" ] && [ "$status" = "302" ]; then
      echo
      echo "Kibana is up. Proceeding."
      echo
      break
    else
      echo
      echo "Kibana still loading. Trying again in 40 seconds"
    fi
    sleep 10
    i=$((i - 1))
  done
  [ $i -eq 0 ] && echo "Exceeded MAXTRIES (${MAXTRIES}) to setup detection engine." && exit 1
  return 0
}

set_fleet_values() {
  fingerprint=$(${CONTAINER_CLI} compose exec -w /usr/share/elasticsearch/config/certs/ca ${DEV_ES_SERVICE} cat ca.crt | \
    openssl x509 -noout -fingerprint -sha256 | \
    cut -d "=" -f 2 | \
    tr -d :)

  if [ -z "$fingerprint" ]; then
    echo "Error obtaining fingerprint"
    return 1
  fi

  update_request() {
    local json_data=$1
    local api_endpoint=$2

    printf '%s' "$json_data" | \
      curl -k --silent --user "${DEV_ES_USERNAME}:${DEV_ES_PASSWORD}" -XPUT "${headers[@]}" "${LOCAL_KBN_URL}${api_endpoint}" -d @- |\
      jq
  }

  post_request() {
    local json_data=$1
    local api_endpoint=$2
    local jq_filter=$3

    printf '%s' "$json_data" | \
      curl -k --silent --user "${DEV_ES_USERNAME}:${DEV_ES_PASSWORD}" -XPOST "${headers[@]}" "${LOCAL_KBN_URL}${api_endpoint}" -d @- | \
      jq -r "${jq_filter}"
  }

  fleet_json=$(printf '{"fleet_server_hosts": ["https://%s:%s"]}' "${ipvar}" "${DEV_FLEET_PORT}")
  update_request "$fleet_json" "/api/fleet/settings"

  hosts_json=$(printf '{"hosts": ["https://%s:9200"]}' "${ipvar}")
  update_request "$hosts_json" "/api/fleet/outputs/fleet-default-output"

  ca_json=$(printf '{"ca_trusted_fingerprint": "%s"}' "${fingerprint}")
  update_request "$ca_json" "/api/fleet/outputs/fleet-default-output"

  config_yaml_json=$(printf '{"config_yaml": "ssl.verification_mode: certificate"}')
  update_request "$config_yaml_json" "/api/fleet/outputs/fleet-default-output"
}

start() {
  exec 3<>/dev/stderr
  get_host_ip

  configure_kbn 1>&2 2>&3
  echo "Waiting 40 seconds for Fleet Server setup."
  echo

  sleep 40

  echo "Populating Fleet Settings."
  set_fleet_values
  set_fleet_values > /dev/null 2>&1
  echo
}

start
exec 3>&-
