# Headscale + Proxmox Integration Notes

This document focuses on using **Headscale** — a self-hosted coordination server for Tailscale clients — within Proxmox-based infrastructure. Headscale enables full control over access policies, device registration, and subnet routing without relying on the official Tailscale control plane.

---

## Overview

- **Role**: Open-source backend for managing Tailscale-compatible clients
- **Protocol**: Built on top of WireGuard
- **Primary Benefit**: Full control over node auth, DNS, routing, OIDC login, and policy enforcement
- **Typical Deployment**: Via LXC helper-scripts or a Docker Compose stack, optionally paired with a Web UI (e.g., Headscale UI, Headplane, Headscale Admin)
- **DERP Relay Note**: Headscale supports custom DERP relay configurations. You may choose to:
  - Use Tailscale's global DERP relay network (default)
  - Host your own private DERP relays for regional or air-gapped setups
  - Mix and override relay priorities depending on latency, region, or availability

---

## Proxmox Integration Considerations

### Host Deployment
- Headscale is typically deployed in a **Docker container** or **LXC VM**.
- It is **not recommended to install Headscale directly on the Proxmox host**. Using an isolated container or VM is preferred for security, modularity, and maintainability.
- LXC is often the preferred option for lightweight deployment, especially with helper scripts and reverse proxy integration.
- In some cases, a full VM may be used instead of an LXC if:
  - You want complete OS-level isolation for audit or compliance.
  - You are using advanced Docker networking or complex TLS setups.
- Tailscale clients can run inside **LXCs, VMs, or directly on the Proxmox host**, depending on routing and tunnel requirements. Running inside LXC provides isolation and avoids polluting host namespaces, while host installation allows full node-wide routing.

### OIDC Authentication
- Headscale supports OpenID Connect (OIDC) for secure logins.
- Azure Entra or other IdPs can be used for SSO across Proxmox-managed nodes and external users.
- Relevant for Proxmox users managing multi-tenant or MSP-like setups.

### Node Enrollment Flow
- Nodes (Proxmox, VMs, LXCs) still run the **Tailscale client**.
- Join Headscale via a one-time auth key or coordination through `headscale-cli`.
- Namespaces can represent environments (e.g., `prod`, `homelab`, `clients`).

---

## Ideal Use Cases in Proxmox

✅ Self-hosted alternative to Tailscale control for:
- Secure overlay networking between cloud + home Proxmox nodes
- Centralized identity and route control
- Devices running in non-public or air-gapped environments

---

## Directory Structure

To be documented in this folder:

### 🏗️ Deployment
- Docker and systemd install examples
- NGINX reverse proxy setup for `/ghost.cktechx.com`
- Persistent state volume structure and backup

### 🔐 Authentication
- Azure Entra OIDC setup with Headscale
- Domain-hinting, user mapping, and policy notes

### 🌐 Namespace Strategy
- Using namespaces to separate environments (e.g. `cktech`, `client-foo`, `infra`)
- Recommended tagging/naming conventions

### ⚙️ Proxmox & Client Integration
- CLI commands for enrolling Proxmox nodes
- Recommended service overrides for auto-connect
- SDN route injection planning
- When to install Tailscale client on host vs LXC

### 🔄 Reverse Proxy Considerations
- NGINX with systemd or standalone reverse proxy
- Traefik configuration basics for dynamic container routing
- NGINX Proxy Manager for simplified container-based TLS management
- TLS cert tips when exposing via DNS + public IP

### 🖥️ Web UI Options
- Headscale UI
- Headplane
- Headscale Admin
- Running UI in Docker alongside Headscale or split-stack
- UI + OIDC login testing inside Proxmox LXC

### ⚙️ Headscale Configuration
- `config.yaml` examples and required values for basic and advanced setups
- Mapping configuration to deployment choices (LXC, Docker, reverse proxy)
- Suggested layout for `data/`, `certs/`, and persistent bind mounts

### 📋 Access Control Lists (ACLs)
- Examples for restricting cross-namespace access
- Tagging devices and assigning policies
- Best practices for auditability and rollback

### 🌐 Custom DERP Relays
- Using Tailscale default DERP relays
- Hosting your own DERP relay (binary or Docker)
- Configuring Headscale to prefer or override regional DERPs
- Use cases for performance tuning or restricted environments

### 🧪 Troubleshooting
- Debugging registration failures
- Log file paths and HTTP errors
- Common port or reverse proxy misconfigurations

---

Maintained by [Christopher Kelley](https://github.com/ghostkellz)
