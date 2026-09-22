# Port Not Listening

## Problem
A web service should be available on port 443, but the connection fails.

## First checks
- Verify whether the host is reachable.
- Check whether something is listening on port 443.
- Confirm that the service is running.

## Commands
```bash
ping server-ip
ss -tulpn | grep 443