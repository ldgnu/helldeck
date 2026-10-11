#!/usr/bin/env python3
"""Sirve build/ con el MIME correcto para .wasm. Uso: ./serve.py [puerto]"""
import http.server
import functools
import sys

PORT = int(sys.argv[1]) if len(sys.argv) > 1 else 8080


class H(http.server.SimpleHTTPRequestHandler):
    extensions_map = {
        **http.server.SimpleHTTPRequestHandler.extensions_map,
        ".wasm": "application/wasm",
        ".data": "application/octet-stream",
        ".js": "text/javascript",
    }

    def end_headers(self):
        # COOP/COEP para threads (por si se habilitan a futuro) + no-cache del html
        self.send_header("Cross-Origin-Opener-Policy", "same-origin")
        self.send_header("Cross-Origin-Embedder-Policy", "require-corp")
        self.send_header("Cache-Control", "no-store, must-revalidate")
        super().end_headers()

    def log_message(self, *a):
        pass  # silencioso


http.server.ThreadingHTTPServer(
    ("127.0.0.1", PORT),
    functools.partial(H, directory="build"),
).serve_forever()
