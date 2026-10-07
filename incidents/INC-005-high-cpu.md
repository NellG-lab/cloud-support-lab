## Impact

Users experienced unusually slow server performance.

## Symptoms

The server appeared unusually slow.

Process inspection showed that the `yes` process
was consuming approximately 99.9% CPU.

## Investigation

Used `ps` to identify the processes consuming the
most CPU:

`ps -eo pid,user,comm,%cpu,%mem --sort=-%cpu | head`

The output showed that the `yes` process was
consuming approximately 99.9% CPU.

Then inspected the high-CPU process in more detail:

`ps -o pid,ppid,user,etime,%cpu,%mem,cmd -p 840`

The process was running as user `nellg`, had PID
`840`, PPID `348`, and was consuming approximately
99.9% CPU.

The parent process (PPID `348`) was identified as
`bash`, indicating that the `yes` process had been
started from an interactive shell session.

## Root Cause

The `yes` process had been started manually from a
Bash session and left running in the background,
consuming approximately 99.9% CPU.

## Resolution

Stopped the high-CPU process with:

`kill 840`

By default, `kill` sends `SIGTERM`, requesting that
the process terminate gracefully.
