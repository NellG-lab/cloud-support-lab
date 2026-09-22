# Disk Full Troubleshooting

## Problem
A server is running out of disk space.

## First checks
- Check overall disk usage.
- Identify which directories are using the most space.
- Inspect large log files.

## Commands
```bash
df -h
du -sh /*