#!/usr/bin/env bash

if [ ! -f "Iosevka/package.json" ] || [ ! -f "nerd-fonts/package.json" ]; then
   git submodule init && git submodule update
fi

[ ! -f "Iosevka/private-build-plans.toml" ] && ln build-plans.tom "Iosevka/private-build-plans.toml"

main() {
   (
   cd Iosevka || exit 1
   npm install
   npm run build -- ttf::luansevka
   npm run build -- ttf::luansevka-slab
   npm run build -- ttf::luansevka-ui
   )

   mkdir -p ./fonts/regular/luansevka{,-slab,-ui}
   cp ./Iosevka/fonts/luansevka/ttf/*.ttf ./fonts/regular/luansevka/
   cp ./Iosevka/fonts/luansevka-slab/ttf/*.ttf ./fonts/regular/luansevka-slab/
   cp ./Iosevka/fonts/luansevka-ui/ttf/*.ttf ./fonts/regular/luansevka-ui/

   (
   cd nerd-fonts || exit 1
   mkdir -p ../fonts/nerd-font/luansevka{,-slab,-ui}
   find ../fonts/regular/luansevka/*.ttf -print0 | \
      xargs -n 1 -I{} \
      fontforge -script font-patcher "{}" -cls --outputdir=../fonts/nerd-font/luansevka/
   find ../fonts/regular/luansevka-slab/*.ttf -print0 | \
      xargs -n 1 -I{} \
      fontforge -script font-patcher "{}" -cls --outputdir=../fonts/nerd-font/luansevka-slab/
   find ../fonts/regular/luansevka-ui/*.ttf -print0 | \
      xargs -n 1 -I{} \
      fontforge -script font-patcher "{}" -cls --outputdir=../fonts/nerd-font/luansevka-ui/
   )
}

main
