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
                sha256 = "18vz893w6xka9axk6vizh8aslyna3gx19bkpsqng1rhf67b3gqj9";
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
