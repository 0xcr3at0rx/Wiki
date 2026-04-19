{
  description = "Description for the project";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {

      # allow use on any system
      systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];

      perSystem =
        { self', pkgs, lib, ... }:
        let
          # Get all files in the scripts directory
          scriptFiles = builtins.attrNames (builtins.readDir ./scripts);
          
          # Helper to create a package from a script name
          mkScriptPkg = name: pkgs.writeShellApplication {
            inherit name;
            runtimeInputs = with pkgs; [ curl jq fzf less yt-dlp mpv chafa wl-clipboard w3m lynx ];
            text = builtins.readFile (./scripts + "/${name}");
          };

          # Create an attribute set of packages: { scriptName = package; ... }
          scriptPkgs = lib.genAttrs scriptFiles mkScriptPkg;
        in
        {
          packages = scriptPkgs // {
            default = if builtins.hasAttr "wiki" scriptPkgs then scriptPkgs.wiki else (lib.head (builtins.attrValues scriptPkgs));
          };
        };
    };
}
