# Consolidation Plan for Proxmox Infrastructure

**CK Technology LLC**
**Phase: August 2025 Infrastructure Isolation & Optimization**

---

## Overview

This document outlines the consolidation, isolation, and modernization plan for the Proxmox infrastructure maintained by CK Technology LLC. The objective is to reduce public exposure, consolidate workloads, optimize backup and monitoring, and streamline DevOps practices under a single administrative framework powered by GitOps, Tailscale, and ghostctl.

---

## Infrastructure Summary

### Proxmox Nodes (6 Total)

* **Home Cluster**

  * `Chromium`
  * `Palladium`
  * `Osmium`
  * `Thallium`
* **Cloud Cluster**

  * `Titanium` (Legacy NGINX, Reverse Proxy, LXC hosting)
  * `Loki` (HestiaCP, DNS, Docker workloads)

### Additional Components

* **PBS**: Proxmox Backup Server (in home cluster)
* **MinIO**: Deployed as S3-compatible storage for snapshot offload (planned)
* **Dell OptiPlex**: Cold backup server (Tailscale only)
* **Asgard**: Docker VM for public ingress, centralized control plane

---

## Goals for August 2025

1. **Retire legacy NGINX VM on Titanium**
2. **Migrate all reverse proxy duties to Asgard (public IP only)**
3. **Consolidate Docker workloads into Portainer on Asgard**
4. **Isolate all Proxmox nodes behind Tailscale SDN / VLANs**
5. **Centralize backups to PBS + MinIO (as offsite S3 target)**
6. **Push Proxmox configs, hook metadata into GitHub for ghostctl automation**
7. **Monitor all exposed services with Wazuh + CrowdSec**

---

## Migration Steps

### 1. Reverse Proxy Consolidation

* [ ] Move NGINX VM configs from Titanium to Asgard
* [ ] Point DNS records to Asgard's public IP
* [ ] Issue Let's Encrypt DNS-01 certs
* [ ] Remove NGINX from Titanium after validation

### 2. Backup Modernization

* [ ] Configure PBS to back up all 6 Proxmox nodes
* [ ] Enable remote PBS pull mode from all cloud nodes
* [ ] Deploy MinIO (cloud or home node)
* [ ] Configure offsite S3 backup targets from PBS

### 3. Portainer Unification

* [ ] Set up Portainer agent on all Docker-capable nodes
* [ ] Connect agents to Portainer master on Asgard
* [ ] Decommission legacy Portainer VMs (home + Titanium)

### 4. Security and Visibility

* [ ] Deploy Wazuh to Asgard (multi-node monitoring setup)
* [ ] Enable CrowdSec bouncers for NGINX and SSH
* [ ] Use ghostctl to push and apply agent config across cluster

### 5. Tailscale/Headscale Mesh

* [ ] Join all Proxmox and PBS nodes to Tailscale Enterprise
* [ ] Create tailnet ACL for backup, DNS, SSH, and ghostscale
* [ ] Remove all local public port exposure except via Asgard

---

## GitHub & GitOps Integration

* Create a private GitHub repo: `proxmox-infra`
* Structure:

  ```
  proxmox-infra/
  ├── nodes/
  │   ├─ chromium.yaml
  │   ├─ titanium.yaml
  │   └─ ...
  ├─ backup/
  │   ├─ pbs-config.yaml
  │   └─ minio-endpoints.yaml
  ├─ proxy/
  │   └─ asgard-ingress.yaml
  ├─ tailscale/
  │   ├─ acl.json
  │   └─ auth-keys.md
  └─ ghostscale/
      └─ dnsmap.yaml
  ```
* CI/CD with GitHub Actions or manual sync via `ghostctl push`

---

## Outcome

By the end of August 2025:

* Public attack surface reduced from 6 IPs to 2
* All nodes backed up to PBS + offsite MinIO
* Centralized Docker + Monitoring + Proxy
* Git-based infrastructure state tracking
* Ready foundation for `ghostscale` and full automation platform
* Ghostscale will be a tailscale based tool for DNS magic DNS querks. Ghostmesh Mesh VPN is not even Alpha, got a long way to go with that one.

---

