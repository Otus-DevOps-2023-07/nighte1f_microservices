#!/bin/bash

if [ "$1" == "--list" ] ; then
cat<<EOF
{
   "docker":
	{"hosts":["158.160.114.137"]}
}
EOF
elif [ "$1" == "--host" ]; then
  echo '{"_meta": {"hostvars": {}}}'
else
  echo "{ }"
fi
