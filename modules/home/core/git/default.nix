{
  config,
  pkgs,
  lib,
  ...
}:

let
  sign = config.my.user.signingkey != null;
in
{
  home.packages = with pkgs; [
    bfg-repo-cleaner
    git-filter-repo
  ];

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
  };

  programs.git = {
    enable = true;
    lfs.enable = true;

    settings = {
      user = {
        name = config.my.user.fullname;
        email = config.my.user.email;
        signingkey = lib.mkIf (config.my.user.signingkey != null) config.my.user.signingkey;
      };

      signing = {
        signByDefault = sign;
      };

      commit.gpgSign = sign;
      tag.gpgSign = sign;

      init = {
        defaultBranch = "main";
      };

      push = {
        followTags = true;
        autoSetupRemote = true;
      };

      pull = {
        ff = "only";
      };

      submodule.recurse = true;

      diff = {
        tool = "vimdiff";
        mnemonicPrefix = true;
        renames = true;
        wordRegex = ".";
        submodule = "log";
      };

      merge = {
        tool = "vimdiff";
        # confictStyle = "diff3";
        ff = "only";
      };

      rebase = {
        instructionFormat = "(%an <%ae>) %s";
        autoStash = true;
      };

      mergetool = {
        keepBackup = false;
        keepTemporaries = false;
        writeToTemp = true;
        prompt = false;

        nixfmt = {
          cmd = "nixfmt --mergetool \"$BASE\" \"$LOCAL\" \"$REMOTE\" \"$MERGED\"";
          trustExitCode = true;
        };
      };

      color = {
        ui = "auto";
      };

      alias = {
        st = "status";
        ci = "commit";
        oops = "commit --amend --no-edit";
        glog = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'";

        pushall = "!git remote | grep -E 'origin|upstream|github|gitlab|codeberg' | xargs -L1 -P 0 git push --all --follow-tags";
        fetchall = "!git remote | grep -E 'origin|upstream|github|gitlab|codeberg' | xargs -L1 -P 0 git fetch";
      };

      core = {
        whitespace = "-trailing-space";
        excludesFile = "${pkgs.writeText ".gitignore" ''
          .serena/
          result/
          .DS_Store
          .claude
        ''}";
      };

      versionsort = {
        prereleaseSuffix = [
          "-pre"
          ".pre"
          "-beta"
          ".beta"
          "-rc"
          ".rc"
        ];
      };

      grep = {
        extendedRegexp = true;
      };

      log = {
        abbrevCommit = true;
        follow = true;
      };
    };
  };
}
