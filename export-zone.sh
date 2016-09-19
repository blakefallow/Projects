#!/bin/bash
# exports DNS records from Rackspace Cloud DNS to text files
# Depends on https://github.com/wichert/clouddns/blob/master/src/clouddns.py

set -e

me=export-zone
base_domain=flexint.net
rackspace_region=ORD
rackspace_rate_limit_delay=3
script_root=$(cd `dirname "${BASH_SOURCE[0]}"` && pwd)

function usage() {
  cat << EOF
Usage: `basename "${BASH_SOURCE[0]}"` [domain]
  exports a Racksapce Cloud DNS domain and subdomains to zone files"
  domain - an optional filter for the domain to export, defaults to all
EOF
  exit 1
}
[ "$1" == "-?" ] && usage
[ "$1" == "--help" ] && usage
echo "[$me] verifying Rackspace API credentials ..."
if [ -z "$OS_USERNAME" ] || [ -z "$OS_PASSWORD" ]; then
  echo "[$me] error - missing rackspace credentials - you may need a openrc file" >&2
  echo "[$me] see http://docs.rackspace.com/servers/api/v2/cs-gettingstarted/content/section_gs_install_nova.html#d6e1129" >&2
  exit 1
fi
if echo "$OS_REGION_NAME" | grep -i "LON" >/dev/null 2>&1; then
  rackspace_region=uk
else
  rackspace_region=us
fi
echo "[$me] verifying python dependencies ..."
if ! python --version >/dev/null 2>&1; then
  echo "[$me] error - python runtime not found" >&2
  echo "[$me] see https://www.python.org/downloads/" >&2
  exit 2
fi
if ! pip --version >/dev/null 2>&1; then
  echo "[$me] error - missing python dependency - pip" >&2
  echo "[$me] see https://pip.pypa.io/en/latest/installing.html" >&2
  exit 2
fi
if ! pip install --user isodate >/dev/null; then
  echo "[$me] error - pip install isodate failed" >&2
  exit 3
fi
if ! pip install --user requests >/dev/null; then
  echo "[$me] error - pip install requets failed" >&2
  exit 3
fi
echo "[$me] downloading wichert/clouddns from GitHub ..."
curl -L -o "$script_root/clouddns.py" 'https://raw.githubusercontent.com/wichert/clouddns/master/src/clouddns.py'
if [ -z "$1" ]; then
  base_domain="."
else
 base_domain="$1"
fi
clouddns_command="python ""$script_root/clouddns.py"" --region ""$rackspace_region"" \
                                                      --username ""$OS_USERNAME"" \
                                                      --api ""$OS_PASSWORD"""
echo "[$me] exporting zone files for $base_domain ..."
domain_list=`$clouddns_command list | \
             awk '{print $1}' | \
             grep "$base_domain" | \
             sort`
for domain in $domain_list;
do
  echo "[$me] exporting $domain ..."
  # ignore errors in exporting a subdomain, which can happen due to rate limiting
  # assume the next run will export the subdomain
  set +e
  $clouddns_command export-zone "$domain" > "$domain.txt"
  set -e
  # avoid Rackspace API rate limiting errors
  echo "[$me] sleeping $rackspace_rate_limit_delay seconds ..."
  sleep $rackspace_rate_limit_delay
done
exit 0
