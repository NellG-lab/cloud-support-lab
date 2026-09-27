# INC-001 — Web Server Down

## Impact
Users could not access the web page.

## Symptoms
`curl http://localhost` failed to connect to port 80.

## Investigation
Checked whether any process was listening on port 80 using:

`sudo ss -tulpn | grep :80`

No output was returning, indicating no process was listening on port 80.

Then checked the nginx service status using:

`systemctl status nginx`

The service was `Active: inactive (dead)`

## Root Cause
The nginx had been manually stopped.

## Resolution
The nginx service was started using:

`sudo systemctl start nginx`

## Verification
Confirmed the nginx service was running using:

`system status nginx`

Then verified the wed server was responding correctly using:

`curl http://localhost`

## Lessons Learned
When nginx is stopped no process is available to serve HTTP requests on port 80. `curl http://localhost` helped confirm that the web server was not responding.