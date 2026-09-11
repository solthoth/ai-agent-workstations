VM_NAME := agent-dev
LIMA_CONFIG := ./lima/agent-dev.yaml

.PHONY: help create start stop restart shell status update bootstrap destroy rebuild validate

help:
	@echo ""
	@echo "Agent Development Machine"
	@echo ""
	@echo "Available commands:"
	@echo ""
	@echo "  make validate     Validate Lima configuration"
	@echo "  make create       Create and start the VM"
	@echo "  make start        Start the VM"
	@echo "  make stop         Stop the VM"
	@echo "  make restart      Restart the VM"
	@echo "  make shell        Open a shell inside the VM"
	@echo "  make status       Show Lima VM status"
	@echo "  make update       Pull bootstrap repo inside the VM"
	@echo "  make bootstrap    Re-run provisioning scripts"
	@echo "  make destroy      Delete the VM"
	@echo "  make rebuild      Destroy and recreate the VM"
	@echo ""

validate:
	limactl validate $(LIMA_CONFIG)

create: validate
	limactl start \
		--name $(VM_NAME) \
		$(LIMA_CONFIG)

start:
	limactl start $(VM_NAME)

stop:
	limactl stop $(VM_NAME)

restart:
	limactl stop $(VM_NAME)
	limactl start $(VM_NAME)

shell:
	limactl shell $(VM_NAME)

status:
	limactl list

update:
	limactl shell $(VM_NAME) -- \
		bash -lc 'cd ~/bootstrap && git pull --ff-only'

bootstrap:
	limactl shell $(VM_NAME) -- \
		bash -lc 'cd ~/bootstrap && ./scripts/bootstrap.sh'

destroy:
	limactl stop $(VM_NAME) || true
	limactl delete $(VM_NAME)

rebuild: destroy create