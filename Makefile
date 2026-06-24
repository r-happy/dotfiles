update:
	nix flake update

switch:
	nix run path:$(CURDIR)#switch
