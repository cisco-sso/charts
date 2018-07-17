
# NGINX

A generic enginx chart which sports serving a single vhost.


### Providing a custom virtual host

You can use the `vhost` value to provide a custom virtual host for NGINX to use.
To do this, create a values files with your virtual host:

_custom-vhost.yaml_
```yaml
vhost: |-
  server {
    listen 0.0.0.0:80;
    location / {
      return 200 "hello!";
    }
  }
```


Inspired by the bitnami chart
