#!/bin/bash

./build-js.sh && rsync -av webapp/ swalladge.id.au:/usr/share/nginx/uni_root/hit381/functional_prototype2/
