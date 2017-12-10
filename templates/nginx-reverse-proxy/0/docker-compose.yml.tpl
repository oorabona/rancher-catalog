version: '2'
services:
  nginx-rp-data:
    image: alpine:latest
    stdin_open: true
    labels:
      io.rancher.container.start_once: true
    volumes:
{{- if eq .Values.has_driver "true"}}
      - nginx-conf:/etc/nginx
      - nginx-html:/usr/share/nginx/html
{{- else}}
      - /etc/nginx
      - /usr/share/nginx/html
{{- end}}

  nginx-rp:
    image: oorabona/nginx-rancher-rp:${NGINX_VERSION}
    labels:
      io.rancher.container.pull_image: always
      io.rancher.container.network: true
      io.rancher.container.hostname_override: container_name
      io.rancher.scheduler.global: ${want_global}
      io.rancher.service.selector.link: nginx_rp=true
      io.rancher.sidekicks: nginx-rp-data
    ports:
{{- if eq .Values.want_haproxy "true"}}
      - 80
      - 443
{{- else}}
      - 80:80
      - 443:443
{{- end}}
    volumes_from:
      - nginx-rp-data
    environment:
      RANCHER_VERSION: ${rancher_api_version}
      CRON: ${CRON}
      MONGODB_URL: mongodb:27017
      MONGODB_NAME: ${MONGODB_NAME}
{{- if ne .Values.MONGODB_SERVICE ""}}
    external_links:
      - ${MONGODB_SERVICE}:mongodb
{{- else}}
    links:
      - mongodb:mongodb

  mongodb:
    image: mongo:3
{{- end}}

{{- if eq .Values.want_haproxy "true"}}
#  lb:
#    image: rancher/lb-service-haproxy
#    ports:
#    - 443
{{- end}}

{{- if eq .Values.has_driver}}
volumes:
  nginx-conf:
    driver: ${VOLUME_DRIVER}
  nginx-html:
    driver: ${VOLUME_DRIVER}
{{- end}}
