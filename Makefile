NIXVIM_CONFIG ?= $(HOME)/$(shell nix eval --raw --file "$(CURDIR)/nix/lib/settings.nix" paths.nixvimConfig)

.PHONY: update switch

update:
	nix flake update

switch:
	nix run path:$(CURDIR)#switch --override-input nixvim-config "path:$(NIXVIM_CONFIG)"
