NIXVIM_CONFIG ?= $(HOME)/github/nixvim-config

.PHONY: update switch

update:
	nix flake update

switch:
	nix run path:$(CURDIR)#switch --override-input nixvim-config "path:$(NIXVIM_CONFIG)"
