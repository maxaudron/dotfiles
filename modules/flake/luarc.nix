# sourced from https://github.com/mrcjkb/nix-gen-luarc-json
{ self, ... }:

{

  perSystem =
    inputs@{
      system,
      pkgs,
      lib,
      ...
    }:
    {
      devShells.default = pkgs.mkShell (
        let
          homeConfig = self.lib.mkHomeConfig "headless" system;
          luarc = pkgs.mk-luarc-json {
            plugins = homeConfig.config.programs.neovim.plugins;
            libraries = lib.optionals pkgs.stdenv.isLinux [ "${pkgs.hyprland.dev}/share/hypr/stubs" ];
          };

        in
        {
          shellHook = ''
            ln -fs ${luarc} .luarc.json
          '';
        }
      );
    };

  flake = {
    overlays.mk-luarc = final: prev: {
      mk-luarc-json =
        attrs: final.writeText ".luarc.json" (final.lib.generators.toJSON { } (final.mk-luarc attrs));
      mk-luarc =
        {
          # list of plugins that have a /lua directory
          nvim ? final.neovim-unwrapped,
          libraries ? [ ],
          plugins ? [ ],
          meta ? { },
          # 5.1, 5.2, 5.3, 5.4, ... , jit51, jit52
          lua-version ? "5.1",
          disabled-diagnostics ? [ ],
        }:
        let
          pluginPackages = map (x: if x ? plugin then x.plugin else x) plugins;
          partitions = builtins.partition (
            plugin: plugin.vimPlugin or false || plugin.pname or "" == "nvim-treesitter"
          ) pluginPackages;
          nvim-plugins = partitions.right;
          rocks = partitions.wrong;
          lua-version-dir =
            if lua-version == "jit51" then
              "5.1"
            else if lua-version == "jit52" then
              "5.2"
            else
              lua-version;
          runtime-version-str =
            if lua-version == "jit51" || lua-version == "jit52" then "LuaJIT" else "Lua ${lua-version}";
          plugin-luadirs = builtins.map (plugin: "${plugin}/lua") nvim-plugins;
          pkg-libdirs = builtins.map (pkg: "${pkg}/lib/lua/${lua-version-dir}") rocks;
          pkg-sharedirs = builtins.map (pkg: "${pkg}/share/lua/${lua-version-dir}") rocks;
        in
        {
          runtime.version = runtime-version-str;
          workspace = {
            library = [
              "${nvim}/share/nvim/runtime/lua"
              "\${3rd}/busted/library"
              "\${3rd}/luassert/library"
            ]
            ++ libraries
            ++ plugin-luadirs
            ++ pkg-libdirs
            ++ pkg-sharedirs;
            ignoreDir = [
              ".git"
              ".github"
              ".direnv"
              "result"
              "nix"
              "doc"
            ];
          };
          diagnostics = {
            libraryFiles = "Disable";
            disable = disabled-diagnostics;
          };
        };
    };
  };
}
