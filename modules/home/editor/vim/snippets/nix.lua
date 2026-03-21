return {
	{
		desc = "Import modules in default.nix",
		prefix = "importedModules",
		body = [[
let
  modules = [
    $0
  ];
  importedModules = map (m: import m) modules;
in
importedModules
    ]],
	},

	{
		desc = "add enable option",
		prefix = "enable",
		body = [[
options.my.progs.$0 = {
  enable = lib.mkEnableOption "$0";
};
    ]],
	},
}
