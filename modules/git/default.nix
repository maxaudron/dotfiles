{
  config,
  lib,
  pkgs,
  ...
}:

let
  conf = import ../config { inherit lib; };

in
{
  home.packages = with pkgs; [ bfg-repo-cleaner ];

  programs.delta ={
    enable = true;
    enableGitIntegration = true;
  };

  programs.git = {
    enable = true;
    lfs.enable = true;

    settings = {
      user = {
        name = conf.user.fullname;
        email = conf.user.email;
      };

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
        tool = "ediff";
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

        ediff = {
          cmd = ''
            emacs --eval \"\
            (progn\
              (defun ediff-write-merge-buffer ()\
                (let ((file ediff-merge-store-file))\
                  (set-buffer ediff-buffer-C)\
                  (write-region (point-min) (point-max) file)\
                  (message \\\"Merge buffer saved in: %s\\\" file)\
                  (set-buffer-modified-p nil)\
                  (sit-for 1)))\
              (setq ediff-quit-hook 'kill-emacs\
                    ediff-quit-merge-hook 'ediff-write-merge-buffer)\
              (ediff-merge-files-with-ancestor \\\"$LOCAL\\\" \\\"$REMOTE\\\"\
                    \\\"$BASE\\\" nil \\\"$MERGED\\\"))\"
          '';
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
      };

      core = {
        whitespace = "-trailing-space";
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
