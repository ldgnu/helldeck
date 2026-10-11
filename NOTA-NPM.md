# NPM: vhost manual de helldeck (VPS outblast)

El proxy host de `doom.solisjavier.com.ar` se creó a MANO en
`~/self-hosted/nginx-proxy/data/nginx/proxy_host/30.conf` del VPS
(la API de NPM pide login admin).

Si NPM lo pisa (rebuild/upgrade desde la UI):

```bash
sudo cp ~/self-hosted/helldeck/30.conf.NPM-backup \
        ~/self-hosted/nginx-proxy/data/nginx/proxy_host/30.conf
sudo docker exec nginx-proxy nginx -s reload
```

A futuro: crearlo por UI/API para que quede en la DB de NPM.
