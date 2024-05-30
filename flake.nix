{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];

      perSystem = { pkgs, lib, system, ... }: {
        imports = [ "${nixpkgs}/nixos/modules/misc/nixpkgs.nix" ];
        nixpkgs = {
          hostPlatform = system;
          config.allowUnfree = true;
        };
        formatter = pkgs.nixfmt;

        packages = rec {
          default = (pkgs.vscode.override { isInsiders = true; }).overrideAttrs
            (oldAttrs: {
              src = (builtins.fetchTarball {
                url =
                  "https://code.visualstudio.com/sha/download?build=insider&os=linux-x64";
                sha256 = "0hrh6m3ww1vn16qcilhsaivzs4hr1czhm0fryb34wbw80sdlh3q3";
              });
              version = "latest";

              buildInputs = oldAttrs.buildInputs ++ [ pkgs.krb5 ];

              meta.mainProgram = "code-insiders";
            });
          vscode-insiders = default;
        };
      };

    };
}
