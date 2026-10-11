// Puente JS <-> SDL_mixer (no tocar upstream: este archivo es nuestro).
// Permite subir/bajar/mutear la musica en vivo, sin recargar la pagina.
#include <SDL_mixer.h>
#include <emscripten.h>

void EMSCRIPTEN_KEEPALIVE DG_MusicVolume(int volume) {
	Mix_VolumeMusic(volume);
}

int EMSCRIPTEN_KEEPALIVE DG_MusicVolumeGet(void) {
	return Mix_VolumeMusic(-1);
}
