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
                sha256 = "0px3fsw9fdhrj95h2c9yplxdvng4sphmzmcjngxwnz73i666gjmz";
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
