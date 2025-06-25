# flake.nix
{
  description = "A reproducible development environment for WordPress projects using Podman.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      # Support standard systems
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forEachSupportedSystem = f: nixpkgs.lib.genAttrs supportedSystems (system: f system);
    in
    {
      # The development shell, activated by `nix develop` or `direnv`
      devShells = forEachSupportedSystem (
        system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        {
          default = pkgs.mkShell {
            name = "nixpress-shell";

            # These packages will be available in the shell
            packages = with pkgs; [
              podman # The container engine
              podman-compose # The compose tool
              direnv # For auto-loading .envrc
              wp-cli # The WordPress command-line interface
              gnumake # For running the Makefile
            ];

            shellHook = ''
              echo "
              🚀 Welcome to the NixPress Environment!

              All tools (podman, wp-cli, etc.) are now in your PATH.
              Run 'make help' to see available commands.
              "
            '';
          };
        }
      );
    };
}
