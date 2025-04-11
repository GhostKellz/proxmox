# ZFS Configuration and Usage for Proxmox

This directory contains notes, tweaks, and configuration examples for using ZFS as a storage backend in Proxmox across homelab and cloud environments.

---

## Overview
ZFS is a robust, high-performance filesystem and volume manager ideal for virtualization workloads. Proxmox supports native ZFS integration, making it a preferred option for data integrity and snapshot functionality.

### Key Features:
- Built-in snapshotting and cloning
- End-to-end checksumming
- Compression support (lz4, zstd)
- Integrated volume management
- ARC (Adaptive Replacement Cache) with tunable memory footprint
- Scrubbing, resilvering, and smart error detection
- Native support for encryption and deduplication (use with care)

---

## Deployment Use Cases

### Home Proxmox Cluster (Galaxy - 3 Nodes)
- Two nodes use:
  - 2TB NVMe boot
  - 2TB NVMe secondary
  - 2x 4TB SATA SSD for ZFS
- Third node:
  - 2TB NVMe only (ZFS)
  - Synology NFS for auxiliary storage

### Cloud Proxmox Nodes (2 Bare Metal)
- **Node 1:** ZFS mirror of 2x 4TB NVMe drives for speed and redundancy.
- **Node 2:** ZFS RAIDz2 of 2x 2TB NVMe + 2x 4TB SATA SSDs for capacity and fault tolerance.
- Both leverage ZFS for VM image storage and backup targets.

---

## Recommended ARC Cache Sizing
Use the following guidelines to tune ARC size based on system RAM:

| System RAM | ARC Size Range       | Notes                                                                 |
|------------|----------------------|-----------------------------------------------------------------------|
| 16 GB      | 1–2 GB               | Stick closer to 1 GB for raw performance; 2 GB if caching is needed. |
| 32 GB      | 4–6 GB               | 4 GB is stable; 6 GB if many VMs are active concurrently.             |
| 64 GB      | 8–12 GB              | 8 GB for speed; 12 GB for redundancy-focused workloads.               |
| 96 GB      | 12–18 GB             | 12 GB if running light VMs; 18 GB if PBS or frequent snapshots used.  |
| 128 GB     | 16–24 GB             | 16 GB for performance; 24 GB for larger dedup/caching environments.   |
| 256 GB     | 24–48 GB             | Start around 24 GB, scale up for datasets with high churn or dedup.  |

To apply a static ARC limit:
```bash
echo options zfs zfs_arc_max=<bytes> | sudo tee /etc/modprobe.d/zfs.conf
```

Example for 16 GB ARC:
```bash
echo options zfs zfs_arc_max=17179869184 > /etc/modprobe.d/zfs.conf
```

---

## ZFS Tips, Utilities, and Best Practices

### Compression & Space Saving
```bash
zfs set compression=zstd <pool>/<dataset>
```
- Use `zstd` for a balance of performance and efficiency.
- Use `lz4` if compatibility is a concern.

### Scrubbing & Health Checks
```bash
zpool scrub <pool>
```
- Run monthly scrubs via `cron` or `systemd timer`.
- Use `zpool status -v` to monitor for errors or degradation.

### Snapshots
```bash
zfs snapshot <pool>/<dataset>@<name>
```
- Snapshots are space-efficient and can be replicated to PBS.
- Consider automating daily/weekly snapshots for rollback or backup.

### Dataset Organization
- Create datasets per VM or project:
```bash
zfs create rpool/vm-100-disk-0
```
- Helps with replication, performance tuning, and granular control.

### Exporting/Importing Pools
```bash
zpool export <pool>
zpool import <pool>
```
- Use during node migration or when reattaching storage.

---

## Integration with Proxmox
- ZFS pools are auto-detected and assignable to VMs/CTs.
- Use distinct datasets for:
  - `rpool/data` – VM disk images
  - `rpool/ct` – Containers
- Integrate with PBS:
```bash
pvesr create-local-job <vmid> local-zfs pbs --rate 10240 --mode snapshot
```

---

## Planned Directory Structure
- `/zfs/benchmarks/` – Compression benchmarks, disk latency stats
- `/zfs/scripts/` – Helper scripts for pool creation, scrubs, snapshots
- `/zfs/examples/` – Sample datasets, ARC tuning profiles, PBS jobs
- `/zfs/docs/` – Official ZFS docs, blog links, tuning guides

---

Maintained by [Christopher Kelley](https://github.com/ghostkellz)

