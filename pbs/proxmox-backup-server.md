# 🧩 Proxmox Backup Server (PBS)

This directory contains configuration notes, setup scripts, and management tips for running **Proxmox Backup Server (PBS)** in a homelab environment. PBS is used to back up and restore virtual machines, containers, and host configurations from your Proxmox Virtual Environment (PVE) nodes.

---

## 🏡 Homelab Deployment
PBS is self-hosted on the local network and used to back up:
- **3-node Proxmox cluster** (home lab)
- **2 remote bare-metal Proxmox servers** (cloud production nodes)

Backups from both environments are securely transmitted and stored in this centralized PBS instance.

### 🔧 Features & Tools
- **Incremental, deduplicated backups** for VMs/CTs.
- **ZFS-based datastore** for reliability.
- **TLS encryption** and optional **access tokens** for secure client authentication.
- Scheduled backups with retention policies.

---

## 📁 Contents

- `setup/`: Installation scripts and PBS tuning options.
- `datastore/`: Configuration examples for ZFS-based PBS storage.
- `access/`: API token config, access control, and backup client settings.
- `remote/`: Instructions for backing up external Proxmox nodes (e.g., cloud)

---

## 🔐 Security Practices
- Isolated host on VLAN on local network 
- Fortigate 90G policies allowing only certain levels of local access via expected ports
-  nd trusted VPN routes are allowed to reach PBS.
- TLS certificates managed with either Proxmox ACME or DNS-01 challenge.
- All cloud-hosted nodes use **pull mode** with one-time tokens.

---

## ✅ Todo
- [ ] Automate snapshot pruning with custom retention logic.
- [ ] Set up remote sync from cloud backups to cold storage.
- [ ] Monitor PBS usage via Prometheus/Grafana.

---

Maintained by [Christopher Kelley](https://github.com/ghostkellz)
