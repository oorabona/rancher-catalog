version: '2'
services:
  nginx-cdn-config:
    restart: always
    image: oorabona/nginx-cdn-config:v0.1.0
    volumes:
      - ${base_dir}:/var/www:ro
    labels:
      io.rancher.container.hostname_override: container_name
  nginx-cdn:
    restart: always
    image: nginx:latest
    labels:
      io.rancher.sidekicks: nginx-cdn-config
      io.rancher.container.pull_image: always
      io.rancher.container.network: true
      io.rancher.container.hostname_override: container_name
      io.rancher.scheduler.global: ${want_global}
      io.rancher.scheduler.affinity:host_label: ${affinity}
    ports:
      - 80:80/tcp
    volumes_from:
      - nginx-cdn-config
