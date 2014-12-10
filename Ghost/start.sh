#!/bin/bash -e

if [ -d '/external' ]; then
  for src in `find /external/ -mindepth 1 -maxdepth 1 -type d`; do
    dest="/app/content/`echo $src | sed 's/\/external\///'`"
    echo Linking $src to $dest
    rm -rf $dest
    ln -s $src $dest
  done
  if [ -f '/external/config.js' ]; then
    echo Copying /app/config.js to /app/config.js
    rm -f /app/config.js
    cp /external/config.js /app/config.js
  fi
fi

echo "IP: `facter ipaddress`"
chown -R app. /app /external
su app << EOF
  cd /app
  npm start
EOF

