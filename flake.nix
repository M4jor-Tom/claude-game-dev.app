{
  description = "Claude Code, pre-loaded with the claude-game-dev profile";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    systems.url = "github:nix-systems/default";
  };

  outputs =
    { self
    , nixpkgs
    , systems
    }:
    let
      inherit (nixpkgs) lib;
      eachSystem = f: lib.foldl' lib.recursiveUpdate { } (map f (import systems));

      overlay = final: prev: {
        claude-game-dev = final.callPackage ./package.nix {
          profileName = "claude-game-dev";
          configRepo = "https://github.com/M4jor-Tom/claude-game-dev.git";
          dirEnvVar = "CLAUDE_GAME_DEV_DIR";
        };
      };
    in
    eachSystem
      (system:
      let
        # claude-code is unfree, so this flake allows it for its own nixpkgs.
        # Without this, `nix run github:...` fails at evaluation for everyone.
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          overlays = [ overlay ];
        };
      in
      {
        packages.${system} = {
          default = pkgs.claude-game-dev;
          claude-game-dev = pkgs.claude-game-dev;
        };

        apps.${system} = {
          default = {
            type = "app";
            program = "${pkgs.claude-game-dev}/bin/claude-game-dev";
            meta.description = "Claude Code running the claude-game-dev profile";
          };
          claude-game-dev = {
            type = "app";
            program = "${pkgs.claude-game-dev}/bin/claude-game-dev";
            meta.description = "Claude Code running the claude-game-dev profile";
          };
        };

        devShells.${system}.default = pkgs.mkShell {
          buildInputs = with pkgs; [ nixpkgs-fmt ];
        };
      }) // {
      overlays.default = overlay;
    };
}
