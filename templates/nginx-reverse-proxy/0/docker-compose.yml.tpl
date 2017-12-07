version: '2'
nginx-rp:
  image: oorabona/nginx-rancher-rp:${NGINX_VERSION}
  labels:
    io.rancher.container.network: true
    io.rancher.container.hostname_override: container_name
    io.rancher.scheduler.affinity:host_label: ${affinity}
  environment:
    RANCHER_METADATA_HOST: ${rancher_host}
    IP_FIELD: ${ip_field_policy}
  ports:
   - "80:80"
  volumes:
    - nginx-conf:/etc/nginx
#    - '${base_dir}/certs:/etc/nginx/certs:ro'
    - nginx-html:/nginx/html:/usr/share/nginx/html'

lb:
  image: rancher/lb-service-haproxy
  ports:
  - 443
volumes:
  nginx-conf:
    driver: ${CONF_VOLUME_DRIVER}
  nginx-html:
    driver: ${HTML_VOLUME_DRIVER}
