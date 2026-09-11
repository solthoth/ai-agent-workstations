# AI Agent Workstation

Repository to track my isolated workstations for ai-agents to have full control without worry about messing up my personal machines.

## Getting Started

### Mac OS

Install [Lima](https://lima-vm.io/docs/installation/)

```zsh
brew install lima

# Verify lima installed
limactl --version
```

#### Quick Launch

_Note: `--mount-none` flag to purposely not mount the home directory._

```zsh
limactl start \
  --name=agent-dev \
  --cpus=6 \
  --memory=8 \
  --disk=100 \
  --vm-type=vz \
  --mount-none \ 
  template:default

# Verify instance is running
limactl list

# Connect to running instance
limactl shell agent-dev
```
