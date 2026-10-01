## Impact
Users experienced application errors while the server
filesystem was critically low on available disk space.

## Symptoms

The affected filesystem was at 92% usage, with only 8 MB
of available space remaining.

## Investigation

Used `du` to identify which directory was consuming the
available disk space:

`du -sh /mnt/inc004-disk/*`

The output showed that `/var` was consuming 92 MB.

Then drilled down through the directory hierarchy until
identifying `/var/log/myapp/app.log` as the file
consuming the 92 MB of disk space.

## Root Cause

The `app.log` file had grown to approximately 92 MB
consuming most of the available space on the affected
filesystem.

## Resolution

Used `truncate` to reduce the size of `app.log` to 0
bytes without deleting the file:

`sudo truncate -s 0 /mnt/inc004-disk/var/log/myapp/applog`

## Verification

Confirmed that `app.log` had been reduced to 0 bytes.

Then verified with `df -h` that the filesystem had recovered the previously consumed disk space.