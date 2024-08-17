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
            # FIXME: remove this after upgrade
            config.permittedInsecurePackages = [
                "openssl-1.1.1w"
            ];
        };

        rubyVersion  = nixpkgs.lib.fileContents ./.ruby-version;
        ruby = (nixpkgs-rb.lib.mkRuby { inherit pkgs rubyVersion; });

        gems = pkgs.bundlerEnv {
            name = "gemset";
            inherit ruby;
            gemfile = ./Gemfile;
            lockfile = ./Gemfile.lock;
            gemset = ./gemset.nix;
            groups = [ "default" "production" "development" "test" ];
        };

        buildInputs = with pkgs; [
            ruby
            # gems
        ];

        tools = with pkgs; [
            ruby-lsp
            bundix
        ];
    in {
        devShells.${system}.default = pkgs.mkShell {
            name = "lucia-core";
            inherit buildInputs;
            packages = tools;
        };
    };
}
