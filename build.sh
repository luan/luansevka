#!/usr/bin/env bash

[ ! -f "Iosevka/package.json" ] && git submodule init && git submodule update

[ ! -f "Iosevka/private-build-plans.toml" ] && ln build-plans.tom "Iosevka/private-build-plans.toml"

(
cd Iosevka || exit 1
npm install
npm run build -- ttf::luansevka
npm run build -- ttf::luansevka-slab
npm run build -- ttf::luansevka-ui
)
