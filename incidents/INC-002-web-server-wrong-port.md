# INC-002 — Web Server Listening on Wrong Port

## Impact
Users could not access the website through the expected HTTP endpoint.

## Symptoms
`curl -I http://localhost` failed to connect to port 80.

## Investigation
Checked whether any process was listening on the expected HTTP port:

`sudo ss -tulpn | grep ':80 '`

No output was returned, indicating that nothing was listening on port 80.

Confirmed that nginx was still active:

`systemctl is-active nginx`

Result:

`active`

Then checked which port nginx was actually listening on:

`sudo ss -tulpn | grep nginx`

nginx was listening on port `8080` instead of port `80`.

Then verified whether nginx responded correctly on port `8080`:

`curl -I http://localhost:8080`

The server returned:

`HTTP/1.1 200 OK`

Then inspected the active nginx site configuration:

`grep -n "listen" /etc/nginx/sites-enabled/default`

The configuration showed:

`listen 8080 default_server;`

`listen [::]:8080 default_server;`

This confirmed that nginx had been configured to listen on port `8080` instead of the expected port `80`.

## Root Cause
The nginx site configuration had been changed to listen on port `8080` instead of port `80`.

## Resolution

Edited the nginx site configuration:

`sudo nano /etc/nginx/sites-enabled/default`

Changed:

`listen 8080 default_server;`

`listen [::]:8080 default_server;`

to:

`listen 80 default_server;`
`listen [::]:80 default_server;`

Validated the corrected configuration using:

`sudo nginx -t`

The configuration test was successful.

Then applied the new configuration without fully restarting nginx:

`sudo systemctl reload nginx`

## Verification

Confirmed that nginx was still active:

`systemctl is-active nginx`

Result:

`active`

Confirmed that nginx was listening again on port `80`:

`sudo ss -tulpn | grep ':80 '`

Confirmed that the website responded correctly over HTTP:

`curl -I http://localhost`

Result:

`HTTP/1.1 200 OK`

## Lessons Learned

A web service can be unavailable to the client even when nginx is running correctly. If nginx is configured to listen on a different port than the one the client expects, HTTP requests to the expected port will fail.