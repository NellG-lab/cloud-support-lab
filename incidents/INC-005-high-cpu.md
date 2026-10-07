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

The output showed that the `yes` process was consuming approximately 99.9% CPU.