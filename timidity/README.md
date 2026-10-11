# timidity/ — música MIDI

`gus/` = parches GUS libres (freepats) para que suene la música MIDI vía
SDL_mixer/timidity. Extraído de `freepats_20060219-1_all.deb` (Ubuntu universe).
`timidity.cfg` tiene `dir /gus` absoluto (el navegador no tiene /usr/share).

`default.cfg` pre-carga `timidity_cfg_path "/gus/timidity.cfg"` en el primer
arranque; después el motor lo guarda en IndexedDB junto a los saves.

Regenerar: bajar el .deb, `ar x`, `tar -xf data.tar.gz`, mover
`usr/share/midi/freepats/{Drum_000,Tone_000}` a `gus/`, y el cfg de
`etc/timidity/freepats.cfg` a `gus/timidity.cfg` cambiando el `dir`.
