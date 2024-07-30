build:
	sudo nixos-rebuild build --flake . --impure
boot:
	sudo nixos-rebuild build --flake . --impure
switch:
	sudo nixos-rebuild switch --flake . --impure
test:
	sudo nixos-rebuild test --flake . --impure
