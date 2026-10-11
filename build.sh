#!/bin/bash
# Compila doomgeneric -> WASM usando Docker (sin instalar emsdk local).
# Uso: ./build.sh   (preloadea 5 WADs + parches GUS + cfgs timidity)
set -e
cd "$(dirname "$0")"

mkdir -p build
for w in doom.wad doom2.wad plutonia.wad tnt.wad doom1.wad; do
  if [ ! -f "wads/$w" ]; then
    echo "Falta wads/$w"
    exit 1
  fi
done
[ -f timidity/gus/timidity.cfg ] || { echo "Faltan parches GUS en timidity/gus/"; exit 1; }

echo "==> Compilando con emscripten/emsdk (5 WADs + MIDI)..."
docker run --rm -v "$PWD:/src" -w /src emscripten/emsdk:latest bash -c '
  set -e
  cd upstream/doomgeneric
  mkdir -p /tmp/obj
  SRCS="dummy.c am_map.c doomdef.c doomstat.c dstrings.c d_event.c d_items.c
    d_iwad.c d_loop.c d_main.c d_mode.c d_net.c f_finale.c f_wipe.c g_game.c
    hu_lib.c hu_stuff.c info.c i_cdmus.c i_endoom.c i_joystick.c i_scale.c
    i_sound.c i_system.c i_timer.c memio.c m_argv.c m_bbox.c m_cheat.c
    m_config.c m_controls.c m_fixed.c m_menu.c m_misc.c m_random.c p_ceilng.c
    p_doors.c p_enemy.c p_floor.c p_inter.c p_lights.c p_map.c p_maputl.c
    p_mobj.c p_plats.c p_pspr.c p_saveg.c p_setup.c p_sight.c p_spec.c
    p_switch.c p_telept.c p_tick.c p_user.c r_bsp.c r_data.c r_draw.c
    r_main.c r_plane.c r_segs.c r_sky.c r_things.c sha1.c sounds.c statdump.c
    st_lib.c st_stuff.c s_sound.c tables.c v_video.c wi_stuff.c w_checksum.c
    w_file.c w_main.c w_wad.c z_zone.c w_file_stdc.c i_input.c i_video.c
    doomgeneric.c doomgeneric_emscripten.c mus2mid.c i_sdlmusic.c i_sdlsound.c"
  for f in $SRCS; do
    emcc -O2 -DFEATURE_SOUND -s USE_SDL=2 -s USE_SDL_MIXER=2 \
      -c "$f" -o "/tmp/obj/${f%.c}.o"
  done
  echo "==> Linkeando..."
  emcc -O2 /tmp/obj/*.o -o /src/build/doom.html \
    -s USE_SDL=2 \
    -s USE_SDL_MIXER=2 \
    -s SDL2_MIXER_FORMATS='"'"'["mid"]'"'"' \
    -s ALLOW_MEMORY_GROWTH=1 \
    -s INITIAL_MEMORY=64MB \
    -lidbfs.js \
    --preload-file /src/wads/doom.wad@/doom.wad \
    --preload-file /src/wads/doom2.wad@/doom2.wad \
    --preload-file /src/wads/plutonia.wad@/plutonia.wad \
    --preload-file /src/wads/tnt.wad@/tnt.wad \
    --preload-file /src/wads/doom1.wad@/doom1.wad \
    --preload-file /src/timidity/gus@/gus \
    --preload-file /src/timidity/gus/timidity.cfg@/etc/timidity.cfg \
    --preload-file /src/timidity/gus/timidity.cfg@/etc/timidity/freepats.cfg \
    --shell-file /src/shell.html \
    -lm
'
echo "==> OK. Salida en build/:"
ls -lh build/
echo "==> Servir con: ./serve.py 8090  (http://localhost:8090/doom.html)"
