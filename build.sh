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
   cp ./Iosevka/dist/luansevka/ttf/*.ttf ./fonts/regular/luansevka/
   cp ./Iosevka/dist/luansevka-slab/ttf/*.ttf ./fonts/regular/luansevka-slab/
   cp ./Iosevka/dist/luansevka-ui/ttf/*.ttf ./fonts/regular/luansevka-ui/

   echo
   echo

   (
   cd nerd-fonts || exit 1
   mkdir -p ../fonts/nerd-font/luansevka{,-slab,-ui}
   find ../fonts/regular/luansevka/*.ttf -print0 | \
      xargs -0 -I{} -P64 \
      fontforge -script font-patcher "{}" -cls --outputdir=../fonts/nerd-font/luansevka/
   find ../fonts/regular/luansevka-slab/*.ttf -print0 | \
      xargs -0 -I{} -P64 \
      fontforge -script font-patcher "{}" -cls --outputdir=../fonts/nerd-font/luansevka-slab/
   find ../fonts/regular/luansevka-ui/*.ttf -print0 | \
      xargs -0 -I{} -P64 \
      fontforge -script font-patcher "{}" -cl --outputdir=../fonts/nerd-font/luansevka-ui/
   )
}

main
