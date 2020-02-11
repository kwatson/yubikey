#! /bin/bash

set -e

echo QUIT | \
openssl s_client -servername api.yubico.com -showcerts -connect api.yubico.com:443 | \
awk '/-----BEGIN CERTIFICATE-----/ {p=1}; p; /-----END CERTIFICATE-----/ {p=0}' > lib/cert/chain.pem

