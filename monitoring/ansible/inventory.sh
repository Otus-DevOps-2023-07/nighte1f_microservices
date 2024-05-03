#!/bin/bash

if [ "$1" == "--list" ] ; then
cat<<EOF
{
   "docker":
	{"hosts":["84.201.157.130"]}
}
EOF
elif [ "$1" == "--host" ]; then
  echo '{"_meta": {"hostvars": {}}}'
else
  echo "{ }"
fi
