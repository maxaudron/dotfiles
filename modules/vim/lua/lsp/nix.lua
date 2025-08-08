return {
  cmd = { 'nil' },
  filetypes = { 'nix' },
  root_markers = { 'flake.nix', '.git' },
  settings = {
    ['nil'] = {
      formatter = {
        external = {
          command = "nixfmt"
        }
      },
      nix = {
        flake = {
          autoArchive = true,
          autoEvalInputs = false,
        }
      }
    }
  }
}
