version: '2'
services:
  imgproxy:
    image: darthsim/imgproxy
    labels:
      io.rancher.container.pull_image: always
      io.rancher.container.network: true
      io.rancher.container.hostname_override: container_name
      io.rancher.service.selector.link: nginx_rp=true
    ports:
{{- if eq .Values.want_haproxy "true"}}
      - 80:8080
{{- end}}
    environment:
      IMGPROXY_KEY: ${IMGPROXY_KEY}
      IMGPROXY_SALT: ${IMGPROXY_SALT}
      IMGPROXY_TTL: ${IMGPROXY_TTL}
{{- if eq .Values.want_serve_local "true"}}
      IMGPROXY_LOCAL_FILESYSTEM_ROOT: ${IMGPROXY_LOCAL_FILESYSTEM_ROOT}
{{- end}}
{{- if eq .Values.use_keyfiles "true"}}
    volumes:
      - ${KEYSALT_PATH}:/etc/imgproxy
    command:
      imgproxy -keypath /etc/imgproxy/key -saltpath /etc/imgproxy/salt
{{- end}}

{{- if eq .Values.want_haproxy "true"}}
#  lb:
#    image: rancher/lb-service-haproxy
#    ports:
#    - 443
{{- end}}
