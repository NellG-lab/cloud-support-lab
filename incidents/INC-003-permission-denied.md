# INC-003 — Website Forbidden Due to File Permissions

## Impact
Users could not access the webpage because the server returned a `403 Forbidden` response.

## Symptoms
The webpage responded with an `HTTP/1.1 403 Forbidden` status.

## Investigation

First, checked the nginx error log:

`sudo tail -n 20 /var/log/nginx/error.log`

No useful output was returned, and the log file was empty.

Then checked which user nginx worker processes were running as:

`grep -n "^user" /etc/nginx/nginx.conf`

and:

`ps -eo user,pid,cmd | grep '[n]ginx'`

The nginx worker processes were running as `www-data`.

Checked the permissions of the webpage file:

`ls -l /var/www/html/index.nginx-debian.html`

The file permissions were:

`-rw------- root root`

Only the owner (`root`) could read the file. The nginx worker user (`www-data`) had no read permission.

Then tested whether the nginx worker user could read the file directly:

`sudo -u www-data cat /var/www/html/index.nginx-debian.html`

The command returned:

`Permission denied`

This confirmed that `www-data` did not have permission to read the webpage file.

## Root Cause

The nginx worker user (`www-data`) could not read the webpage file because the file permissions denied read access to `others`.

## Resolution
Changed the webpage file permissions from `600` to `644`:

`sudo chmod 644 /var/www/html/index.nginx-debian.html`

This restored read permission for `others`, allowing the nginx worker user (`www-data`) to read the file.

## Verification
Confirmed that the nginx worker user (`www-data`) could read the webpage file successfully.

Then verified that the website responded correctly over HTTP:

`curl -I http://localhost`

Result:

`HTTP/1.1 200 OK`

## Lessons Learned
A web server can be running and listening on the expected port while the website is still inaccessible. File permissions must also be checked because the nginx worker user needs permission to read the files it serves.