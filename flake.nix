{
    description = "Lucia Core API";

    nixConfig = {
        extra-substituters = "https://nixpkgs-ruby.cachix.org";
        extra-trusted-public-keys = "nixpkgs-ruby.cachix.org-1:vrcdi50fTolOxWCZZkw0jakOnUI1T19oYJ+PRYdK4SM=";
    };

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
        nixpkgs-rb = {
            url = "github:bobvanderlinden/nixpkgs-ruby/master";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = { self, nixpkgs, nixpkgs-rb, ... } @ inputs:
    let
        system = "x86_64-linux";
        overlays = [ nixpkgs-rb.overlays.default ];
        pkgs = import nixpkgs {
            inherit system overlays;
        };

        rubyVersion  = nixpkgs.lib.fileContents ./.ruby-version;
        ruby = (nixpkgs-rb.lib.mkRuby { inherit pkgs rubyVersion; });

        buildInputs = [
            ruby
        ];

        tools = [
            # Installing the LSP through the editor usually works better
            # rubyPackages_3_3.ruby-lsp
        ];
    in {
        devShells.${system}.default = pkgs.mkShell {
            name = "lucia-core";
            inherit buildInputs;
            packages = tools;

            shellHook = ''
              export BUNDLE_USER_CACHE="''${XDG_CACHE_HOME:-$HOME/.cache}/bundler"
              export BUNDLE_USER_CONFIG="''${XDG_CONFIG_HOME:-$HOME/.config}/bundler"
              export BUNDLE_USER_PLUGIN="''${XDG_DATA_HOME:-$HOME/.local/share}/bundler"
            '';
        };
    };
}
