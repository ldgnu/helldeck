# helldeck — DOOM en el navegador

Port de DOOM a WebAssembly con [doomgeneric](https://github.com/ozkl/doomgeneric)
(puerto Emscripten basado en SDL). Reemplaza al experimento `goom` (Go + GLFW,
solo escritorio, deps de 2019): mismo WAD, ahora jugable en cualquier navegador.

## Estado

- V1: `doom1.wad` (shareware, el `DOOM1.WAD` que ya tenías) preloadeado, jugable.
- Sonido SFX por SDL. Música MIDI puede quedar muda sin timidity (normal en web).
- Freedoom 1/2 copiados en `wads/` para V2 (selector de WAD).

## Requisitos

- Docker (para `emscripten/emsdk`, sin instalar nada local)
- Python 3 (para servir) — o cualquier estático (caddy, nginx)
- WADs en `wads/` (ya copiados desde `goom`)

## Compilar

```bash
cd /home/ldgnu/Proyectos/doom-web
chmod +x build.sh serve.py
./build.sh            # usa wads/doom1.wad
./build.sh freedoom1.wad   # para probar otro WAD
```

Salida en `build/`: `doom.html` + `doom.js` + `doom.wasm` + `doom.data`.

## Jugar

```bash
./serve.py              # http://127.0.0.1:8080/doom.html
```

Click en la pantalla para activar video + sonido (el navegador exige gesto
del usuario para WebAudio). Controles en la página.

## Estructura

```
helldeck/
  upstream/    doomgeneric (clon, no tocar)
  wads/        doom1.wad + freedoom (local, ignorado por git)
  shell.html   cáscara HTML propia (canvas, overlay, controles)
  build.sh     compilación vía Docker emscripten
  serve.py     servidor estático con MIME correcto
  build/       salida (ignorado por git)
```

## Rollback

Nada de `goom` se tocó. Backup verificable previo:

- `/home/ldgnu/backups/goom-pre-web-20261011.tar.gz` (76M, incluye WADs)
- SHA256 en `goom-pre-web-20261011.sha256`

Para volver atrás: el proyecto viejo sigue en `/home/ldgnu/Proyectos/goom`.

## Licencias

- Motor: GPL-2.0 (doomgeneric).
- `doom1.wad` shareware: ver `DOOM1.LICENSE` en el backup.
- Freedoom: libre (BSD-like), ideal si publicás esto.
