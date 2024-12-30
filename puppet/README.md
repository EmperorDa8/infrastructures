# Puppet Configuration for Multi-Node Setup

This Puppet configuration manages the installation and configuration of multiple software packages across 20 nodes.

## Installed Software

- Python 3 with pip and requests library
- Apache Web Server
- Node.js
- Putty
- Redis Server

## Directory Structure

```
puppet/
├── manifests/
│   └── site.pp              # Main manifest file
├── data/
│   └── common.yaml          # Hiera configuration
└── modules/
    └── database/
        └── templates/
            └── redis.conf.erb  # Redis configuration template
```

## Usage

1. Install Puppet on all nodes
2. Copy these files to your Puppet master in the appropriate directories
3. Configure the Puppet agents on all nodes to point to your Puppet master
4. Run Puppet on all nodes:
   ```bash
   puppet agent -t
   ```

## Node Naming Convention

Nodes should be named `node1` through `node20` to match the node definition in site.pp.

## Configuration Management

- All package versions are managed through Hiera in `common.yaml`
- Redis configuration can be customized by modifying the template or Hiera values
- Service dependencies are properly managed to ensure correct installation order