# Cloud Support Lab

A hands-on troubleshooting lab focused on building practical skills for Junior Cloud Support and IT Infrastructure roles.

The project documents simulated Linux support incidents using a structured troubleshooting approach:

**symptom → investigation → hypothesis → root cause → remediation → verification**

Each incident includes technical documentation and selected command-line evidence showing how the issue was investigated and resolved.

## Incident Library

| Incident | Scenario | Main Skills |
| --- | --- | --- |
| [INC-001](incidents/INC-001-web-server-down.md) | Web server down | nginx, systemd, ports, HTTP troubleshooting |
| [INC-002](incidents/INC-002-web-server-wrong-port.md) | Web server listening on the wrong port | nginx configuration, ports, `ss`, `curl` |
| [INC-003](incidents/INC-003-permission-denied.md) | Website returns 403 due to file permissions | Linux permissions, nginx users, `chmod` |
| [INC-004](incidents/INC-004-disk-space.md) | Server filesystem critically low on disk space | `df`, `du`, log investigation, `truncate` |
| [INC-005](incidents/INC-005-high-cpu.md) | Server performance degradation caused by a high-CPU process | `ps`, PID/PPID investigation, process management |

## Skills Demonstrated

Linux troubleshooting, nginx administration, process investigation, filesystem and permission management, disk-space analysis, basic networking and HTTP diagnostics, Git/GitHub workflows, incident documentation, root cause analysis, and verification of remediation.

## Troubleshooting Approach

The goal is not only to execute Linux commands, but to understand what diagnostic question each command answers.

For example:

`df` → Is the filesystem actually low on space?

`du` → Where is the disk space being consumed?

`ps` → Which process is consuming resources?

`ss` → Is a service listening on the expected port?

`curl` → Can the client reach the HTTP endpoint?

`systemctl` → Is the service running?

## Repository Structure

`incidents/` contains the completed incident reports.

`evidence/` contains selected command outputs captured during troubleshooting.

`linux/` and `networking/` contain supporting notes and troubleshooting exercises.

Recent incidents also use feature branches, progressive commits, Pull Requests, and merges to document how the investigation evolved.

## Project Goal

Build practical troubleshooting skills for Junior Cloud Support roles and progressively move from guided Linux diagnostics toward independent troubleshooting, automation, and cloud-based environments.