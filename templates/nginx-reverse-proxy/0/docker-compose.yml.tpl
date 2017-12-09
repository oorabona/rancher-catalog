version: '2'
services:
  nginx-rp:
    image: oorabona/nginx-rancher-rp:${NGINX_VERSION}
    labels:
      io.rancher.container.pull_image: always
      io.rancher.container.network: true
      io.rancher.container.hostname_override: container_name
      io.rancher.scheduler.global: ${want_global}
      io.rancher.service.selector.link: nginx_rp=true
      io.rancher.sidekicks: nginx-rp-data
    environment:
      RANCHER_VERSION: ${rancher_version}
      CRON: ${CRON}
{{- if eq .Values.MONGODB_SERVICE ""}}
      MONGODB_URL: mongodb:27017
    links:
      - mongodb
{{- else}}
      MONGODB_URL: mongodb:27017
    external_links:
      - ${MONGODB_SERVICE}:mongodb
{{- end}}

#    ports:
#      - "80:80"
    volumes_from:
      - nginx-rp-data

  nginx-rp-data:
    image: busybox
    stdin_open: true
    volumes:
{{- if eq .Values.has_driver}}
      - nginx-conf:/etc/nginx
      - nginx-html:/usr/share/nginx/html
{{- else}}
      - /etc/nginx
      - /usr/share/nginx/html
{{- end}}

#  lb:
#    image: rancher/lb-service-haproxy
#    ports:
#    - 443

{{- if eq .Values.MONGODB_SERVICE ""}}
  mongodb:
    image: mongo:3
{{- end}}

{{- if eq .Values.has_driver}}
volumes:
  nginx-conf:
    driver: ${VOLUME_DRIVER}
  nginx-html:
    driver: ${VOLUME_DRIVER}
{{- end}}
