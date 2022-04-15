{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [ delta bfg-repo-cleaner ];

  programs.git = {
    enable = true;

    userName = "Max Audron";
    userEmail = "audron@cocaine.farm";

    extraConfig = {
      init = { defaultBranch = "master"; };

      push = { followTags = true; };
      pull = { ff = "only"; };

      diff = {
        tool = "ediff";
        mnemonicPrefix = true;
        renames = true;
        wordRegex = ".";
        submodule = "log";
      };

      merge = {
        tool = "ediff";
        confictStyle = "diff3";
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

      color = { ui = "auto"; };

      alias = {
        st = "status";
        ci = "commit";
        oops = "commit --amend --no-edit";
        glog =
          "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'";
      };

      core = {
        whitespace = "-trailing-space";
        pager = "delta";
      };

      versionsort = {
        prereleaseSuffix = [ "-pre" ".pre" "-beta" ".beta" "-rc" ".rc" ];
      };

      grep = { extendedRegexp = true; };

      log = {
        abbrevCommit = true;
        follow = true;
      };
    };
  };
}
