return {
  cmd = { 'nil' },
  filetypes = { 'nix' },
  root_markers = { 'flake.nix', '.git' },
  settings = {
    Nix = {
      formatter = {
        external = {
          command = "nixfmt"
        }
      }
    }
  }
}
