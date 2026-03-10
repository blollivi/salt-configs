.PHONY: apply apply-dry install-salt sync help

SALT_DIR := /srv/salt

help:
	@echo "Usage:"
	@echo "  make install-salt   Install Salt (masterless)"
	@echo "  make sync           Sync states/pillar to /srv/salt"
	@echo "  make apply          Apply all states (live run)"
	@echo "  make apply-dry      Dry run — show what would change"

install-salt:
	@echo "→ Installing Salt..."
	curl -fsSL https://bootstrap.saltproject.io | sudo sh -s -- -X stable
	sudo mkdir -p /srv/salt/states /srv/salt/pillar
	sudo cp minion /etc/salt/minion

sync:
	@echo "→ Syncing to $(SALT_DIR)..."
	sudo rsync -av --delete states/ $(SALT_DIR)/states/
	sudo rsync -av --delete pillar/ $(SALT_DIR)/pillar/
	sudo cp top.sls $(SALT_DIR)/states/top.sls

apply: sync
	@echo "→ Applying states..."
	sudo salt-call --local state.apply

apply-dry: sync
	@echo "→ Dry run..."
	sudo salt-call --local state.apply test=True
