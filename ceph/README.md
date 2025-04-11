# Ceph Storage in Proxmox

This section provides an overview of using **Ceph** as a distributed storage backend within Proxmox. Ceph offers high availability, scalability, and fault tolerance by replicating data across multiple nodes. It's especially suited for Proxmox clusters requiring shared storage without external NAS or SAN.

---

## 🧱 What is Ceph?
Ceph is a unified, distributed storage system that supports object, block, and file storage. In Proxmox, Ceph is used primarily as a block storage backend for VMs and containers.

### Key Features
- Fault-tolerant and self-healing
- Horizontal scalability
- Built-in redundancy (replication or erasure coding)
- Deep Proxmox integration with GUI support
- No single point of failure

---

## ⚙️ Components Overview
- **OSD (Object Storage Daemon):** Handles data storage and replication
- **MON (Monitor):** Keeps track of the cluster state
- **MGR (Manager):** Provides cluster metrics and interfaces
- **MDS (Metadata Server):** Used only for CephFS
- **RADOS:** Underlying object store powering Ceph

---

## 🔧 Setup in Proxmox (High-Level)
1. Configure a dedicated Ceph network (public and cluster networks recommended)
2. Add MON nodes for cluster quorum
3. Deploy OSDs across nodes with available disks (recommended: 3+ nodes)
4. Configure Ceph pools and replication factor
5. Create Proxmox storage entries backed by Ceph RBD
6. Use CephFS optionally for shared filesystems

> 📘 Refer to the official [Proxmox Ceph guide](https://pve.proxmox.com/wiki/Ceph_Server) for step-by-step instructions.

---

## 📁 Planned Directory Structure
```
/ceph
  ├── config/           # ceph.conf examples and public_network settings
  ├── tips/             # Optimization tips and best practices
  ├── pools/            # Notes and YAML for pool setup and tuning
  └── integration/      # Mounting Ceph in containers, PBS, etc.
```

---

## 📝 Notes
- Ideal for clusters with **3+ nodes** and redundant networking
- Best paired with **10GbE+ NICs** and dedicated SSDs/NVMEs for OSDs
- Monitor latency and health with `ceph status`, `ceph df`, and `ceph osd tree`

---

Maintained by [Christopher Kelley](https://github.com/ghostkellz)
