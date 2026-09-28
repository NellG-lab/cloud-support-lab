# INC-002 — Terminal Evidence

## Healthy Baseline

### Service status

```bash
$ systemctl is-active nginx
active
```

### HTTP response

```bash
$ curl -I http://localhost
HTTP/1.1 200 OK
Server: nginx/1.28.3 (Ubuntu)
```

### Expected listening port

```bash
$ sudo ss -tulpn | grep ':80 '
tcp LISTEN ... 0.0.0.0:80 ... nginx
tcp LISTEN ... [::]:80 ... nginx
```

### Initial nginx configuration

```bash
$ grep -n "listen" /etc/nginx/sites-enabled/default
22:     listen 80 default_server;
23:     listen [::]:80 default_server;
```

## Incident Evidence

### Service remained active

```bash
$ systemctl is-active nginx
active
```

### HTTP request on the expected port failed

```bash
$ curl -I http://localhost
curl: (7) Failed to connect to localhost port 80 after 1 ms: Could not connect to server
```

### Nothing was listening on port 80

```bash
$ sudo ss -tulpn | grep ':80 '
(no output)
```

### nginx was listening on another port

```bash
$ sudo ss -tulpn | grep nginx
tcp LISTEN ... 0.0.0.0:8080 ... nginx
tcp LISTEN ... [::]:8080 ... nginx
```

### nginx responded correctly on port 8080

```bash
$ curl -I http://localhost:8080
HTTP/1.1 200 OK
```

## Root Cause Evidence

```bash
$ grep -n "listen" /etc/nginx/sites-enabled/default
22:     listen 8080 default_server;
23:     listen [::]:8080 default_server;
27:     # listen 443 ssl default_server;
28:     # listen [::]:443 ssl default_server;
80:#    listen 80;
81:#    listen [::]:80;
```

nginx was running correctly, but its active configuration instructed it to listen on port `8080` instead of the expected HTTP port `80`.

## Recovery

The configuration was changed back from port `8080` to port `80`.

Before applying the change, the nginx configuration was validated:

```bash
$ sudo nginx -t
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful
```

The corrected configuration was then applied:

```bash
$ sudo systemctl reload nginx
```

## Recovery Verification

### Service active

```bash
$ systemctl is-active nginx
active
```

### Port 80 listening again

```bash
$ sudo ss -tulpn | grep ':80 '
tcp LISTEN ... 0.0.0.0:80 ... nginx
tcp LISTEN ... [::]:80 ... nginx
```

### HTTP service restored

```bash
$ curl -I http://localhost
HTTP/1.1 200 OK
Server: nginx/1.28.3 (Ubuntu)
```