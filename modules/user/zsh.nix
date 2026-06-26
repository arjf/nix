{
  config,
  lib,
  pkgs,
  my,
  ...
}:
let
  pathExtra = lib.concatStringsSep ":" ([ "$HOME/bin" ] ++ my.pathAdditions);
in
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableVteIntegration = pkgs.stdenv.isLinux;
    autocd = true;
    autosuggestion.enable = true;
    dotDir = "${config.xdg.configHome}/zsh";
    history = {
      expireDuplicatesFirst = true;
      extended = true;
      ignoreDups = true;
      ignoreSpace = true;
      path = "${config.xdg.dataHome}/zsh/history";
      save = 10000;
      share = true;
    };
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "aws"
        "kubectl"
        "docker"
        "asdf"
      ];
      theme = "robbyrussell";
    };
    plugins = [
      {
        name = "nix-zsh-completions";
        src = pkgs.nix-zsh-completions;
        file = "share/zsh/plugins/nix/nix-zsh-completions.plugin.zsh";
        functions = [ "share/zsh/site-functions" ];
      }
      {
        name = "vi-mode";
        src = pkgs.zsh-vi-mode;
        file = "share/zsh/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
      }
      {
        name = "fast-syntax-highlighting";
        src = pkgs.zsh-fast-syntax-highlighting;
        file = "share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh";
      }
      {
        name = "autopair";
        inherit (pkgs.zsh-autopair) src;
        file = "zsh-autopair.plugin.zsh";
      }
      {
        name = "history-substring-search";
        src = pkgs.zsh-history-substring-search;
        file = "share/zsh-history-substring-search/zsh-history-substring-search.zsh";
      }
    ];
    envExtra = ''
      export LESSHISTFILE="${config.xdg.dataHome}/less_history"
      export CARGO_HOME="${config.xdg.cacheHome}/cargo"
    '';
    initContent = lib.mkMerge [
      # Workaround for home-manager#2562: completions from home.packages aren't in fpath
      (lib.mkOrder 561 ''
        fpath+=("${config.home.profileDirectory}"/share/zsh/site-functions \
                "${config.home.profileDirectory}"/share/zsh/$ZSH_VERSION/functions \
                "${config.home.profileDirectory}"/share/zsh/vendor-completions)
      '')
      ''
        export PATH="${pathExtra}:$PATH"

        # Aliases
        alias ls='lsd'
        alias l='ls -l'
        alias la='ls -a'
        alias lla='ls -la'
        alias lt='ls --tree'
        alias kys="shutdown now"
        alias respring="systemctl reboot"
        alias db="distrobox"

        eval "$(atuin init zsh)" 2>/dev/null || true

        export MAMBA_ROOT_PREFIX="$HOME/micromamba"
        eval "$(micromamba shell hook --shell=zsh)" 2>/dev/null || true

        # FZF shell integration (key bindings: CTRL-R, CTRL-T, ALT-C)
        source <(fzf --zsh) 2>/dev/null || true

        # Up arrow handled by atuin init above
        bindkey "''${terminfo[kcud1]}" down-line-or-history
        bindkey '^[[B' down-line-or-history

        ${pkgs.nix-your-shell}/bin/nix-your-shell -- zsh | source /dev/stdin

        bindkey "''${terminfo[khome]}" beginning-of-line
        bindkey "''${terminfo[kend]}" end-of-line
        bindkey "''${terminfo[kdch1]}" delete-char
        bindkey "^[[1;5C" forward-word
        bindkey "^[[1;3C" forward-word
        bindkey "^[[1;5D" backward-word
        bindkey "^[[1;3D" backward-word

        # SSH key loading
        if ! ssh-add -l >/dev/null 2>&1; then
          for k in ~/.ssh/id_ed25519 ~/.ssh/id_rsa ~/.ssh/id_ecdsa ~/.ssh/identity; do
            [ -f "$k" ] && ssh-add "$k" 2>/dev/null || true
          done
        fi

        # Environment variables
        export DBX_CONTAINER_MANAGER="docker"
        export cons=~/clones/docker/containers
        export vols=~/clones/docker/volumes

        local CONST_SSH_SOCK="$HOME/.ssh/ssh-auth-sock"
        if [ ! -z ''${SSH_AUTH_SOCK+x} ] && [ "$SSH_AUTH_SOCK" != "$CONST_SSH_SOCK" ]; then
          rm -f "$CONST_SSH_SOCK"
          ln -sf "$SSH_AUTH_SOCK" "$CONST_SSH_SOCK"
          export SSH_AUTH_SOCK="$CONST_SSH_SOCK"
        fi

        # System info on startup
        ${pkgs.fastfetch}/bin/fastfetch 2>/dev/null || true
      ''
    ];
  };
}
