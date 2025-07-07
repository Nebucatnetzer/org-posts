{
  description = "A flake to build the blog of Andreas Zweili";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    org-publish-rss.url = "git+https://git.sr.ht/~taingram/org-publish-rss";
    org-publish-rss.flake = false;
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    let
      package = pkgs.emacs-nox.override { };
      emacsWithPackages = (pkgs.emacsPackagesFor package).emacsWithPackages;
      finalEmacs = emacsWithPackages (epkgs: [
        epkgs.htmlize
        org-publish-rss
      ]);
      pkgs = nixpkgs.legacyPackages."x86_64-linux";
      org-publish-rss = pkgs.callPackage (
        { emacsPackages }:
        emacsPackages.melpaBuild {
          pname = "org-publish-rss";
          version = "0-unstable-2025-05-15";
          src = inputs.org-publish-rss;
          unpackPhase = false;
        }
      ) { };
    in
    {
      packages.x86_64-linux.posts = pkgs.stdenvNoCC.mkDerivation {
        name = "posts";
        nativeBuildInputs = [ finalEmacs ];
        src = ./.;
        phases = [
          "unpackPhase"
          "buildPhase"
          "installPhase"
        ];
        buildPhase = ''
          export HOME="''$TMPDIR"
          emacs -Q --batch --script ./build-site.el
        '';
        installPhase = ''
          cp -r ./public $out
        '';
      };
      packages.x86_64-linux.build = pkgs.writeShellApplication {
        name = "build";
        runtimeInputs = [ finalEmacs ];
        text = ''
          rm -fr ./public
          emacs -Q --batch --script ./build-site.el
        '';
      };
      packages.x86_64-linux.publish = pkgs.writeShellApplication {
        name = "publish";
        runtimeInputs = [ pkgs.rsync ];
        excludeShellChecks = [
          "SC2029" # we want to exand this on the client side.
          "SC1091"
        ];
        text = ''
          # shellcheck source=/dev/null
          nix build .#posts
          source .env
          echo "Syncing posts to $BLOG_SERVER:$BLOG_DIRECTORY"
          ssh "$BLOG_SERVER" "mkdir -p $BLOG_DIRECTORY"
          rsync -av result/ "$BLOG_SERVER":"$BLOG_DIRECTORY"/
        '';
      };

      packages.x86_64-linux.default = self.packages.x86_64-linux.posts;

      devShells.x86_64-linux.default = pkgs.mkShellNoCC {
        packages = [
          self.packages.x86_64-linux.build
          self.packages.x86_64-linux.publish
        ];
      };
    };
}
