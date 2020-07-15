#! /bin/bash

# Parse FUSEKI_UPDATE if exists
function parse_endpoint() {
  pattern='^(([[:alnum:]]+)://)?(([[:alnum:]]+)(:([[:alnum:]]+))?@)?([^:^@]+)(:([[:digit:]]+))?/(.*)/.*$'
  if [[ "${FUSEKI[endpoint]}" =~ $pattern ]]; then
    FUSEKI[proto]=${BASH_REMATCH[2]}
    FUSEKI[user]=${BASH_REMATCH[4]}
    FUSEKI[password]=${BASH_REMATCH[6]}
    FUSEKI[hostname]=${BASH_REMATCH[7]}
    FUSEKI[port]=${BASH_REMATCH[9]}
    if [[ -n ${FUSEKI[port]} ]]; then
      FUSEKI[host]="${BASH_REMATCH[7]}:${BASH_REMATCH[9]}"
    else
      FUSEKI[host]=${FUSEKI[hostname]}
    fi
    FUSEKI[db]=${BASH_REMATCH[10]}
  else
    >&2 echo ${FUSEKI[url]} is url
    FUSEKI[error]=1;
  fi

}

# Defaults
declare -A FUSEKI=([host]="fuseki:80"
                   [proto]="http"
                   [db]="vivo"
                   [username]="admin"
                   [password]="vivo"
                  );

: ${VIVO_CONTENT_TRIPLE_SOURCE:=tdbContentTripleSource}
export VIVO_CONTENT_TRIPLE_SOURCE

# If we have an update url, then get everything from that.
if [[ -n ${FUSEKI_ENDPOINT} ]]; then
  VIVO_CONTENT_TRIPLE_SOURCE=sparqlContentTripleSource
  FUSEKI[endpoint]=${FUSEKI_ENDPOINT}
  parse_endpoint

  if [[ -n ${FUSEKI[error]} ]] ; then
    >&2 echo "WARNING: ${FUSEKI[endpoint]} is not a valid endpoint";
  fi
fi

#declare -p FUSEKI

# Fill these out even if not used.
export FUSEKI_UPDATE="${FUSEKI[proto]}://${FUSEKI[username]}:${FUSEKI[password]}@${FUSEKI[host]}/${FUSEKI[db]}/update"
export FUSEKI_QUERY="http://${FUSEKI[host]}/${FUSEKI[db]}/query"


# Create if not there
for f in runtime.properties applicationSetup.n3; do
  if [[ ! -f $f ]]; then
    content=$(cat $f.tpl)
    for var in $(compgen -e); do
      content=$(echo "$content" | sed "s|{{$var}}|${!var}|g")
    done
    echo "$content" > $f
  fi
done

if [ -f "/usr/local/vivo/home/tdbModels/tdb.lock" ] ; then
  echo "WARNING: tdbModels lock file found.  removing."
  rm /usr/local/vivo/home/tdbModels/tdb.lock
fi
if [ -f "/usr/local/vivo/home/tdbContentModels/tdb.lock" ] ; then
  echo "WARNING: tdbContentModels lock file found.  removing."
  rm /usr/local/vivo/home/tdbContentModels/tdb.lock
fi

/wait-for-it.sh -t 0 ${FUSEKI[host]}

catalina.sh run