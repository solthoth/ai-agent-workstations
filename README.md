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

When you are done having fun, stop and clean up your instance as needed

```zsh
# Stop the running VM
limactl stop agent-dev
# Delete the VM instance
limactl delete agent-dev
```

#### Using Configuration Files

In order to create and run a VM based on a config execute with the appropriate config file.

```zsh
limactl start \
  --name agent-dev \
  ./lima/agent-dev.yaml
```

Because of docker modifies group memberships, you will need to exit your logged in session in order to work with docker without using `sudo`.

```zsh
limactl stop agent-dev
limactl start agent-dev
limactl shell agent-dev
```

You can test if docker works fine by running

```zsh
docker run --rm hello-world
```

#### J5 Agent Fleet local UI

The configuration forwards the J5 Agent Fleet runner's local status and
Controls UI from the guest to the Mac host. After installing the runner inside
the VM, open [http://localhost:7242](http://localhost:7242) on the Mac.

The runner itself does not require this inbound port to connect to J5 Agent
Fleet. The forwarding is only for accessing its local UI from outside the VM.

For an `agent-dev` instance created before this port was added, stop the VM and
run `limactl edit agent-dev`. Add the `guestPort: 7242` / `hostPort: 7242`
mapping under `portForwards`, save, and start the VM again.
