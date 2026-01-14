local gen_loader = require('mini.snippets').gen_loader

return {
  "nvim-mini/mini.snippets",
  version = false, -- Never set this value to "*"! Never!
  opts = {
    snippets = {
      -- Load snippets based on current language by reading files from
      -- "snippets/" subdirectories from 'runtimepath' directories.
      gen_loader.from_lang(),
    };
  },
}
