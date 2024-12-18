{
  description = "AyuGram Desktop";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };
  };
  outputs =
    {
      self,
      nixpkgs,
      ...
    }@inputs:
    let
      forAllSystems =
        function:
        nixpkgs.lib.genAttrs [
          "x86_64-linux"
          "aarch64-linux"
        ] (system: function nixpkgs.legacyPackages.${system});
    in
    {

      nixosModules = {
        default = self.nixosModules;
      };

      homeManagerModules = {
        default = self.nixosModules;
      };

      packages = forAllSystems (pkgs: {
        ayugram-desktop = pkgs.libsForQt5.callPackage ./default.nix { };
      });

      nixConfig = {
        sandbox = nixpkgs.stdenv.isLinux;
        extra-substituters = [
          "https://cache.garnix.io"
        ];
        extra-trusted-public-keys = [
          "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
        ];
      };
    };

}
