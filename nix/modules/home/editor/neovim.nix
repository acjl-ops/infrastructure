{ config, pkgs, lib, inputs, ...}:
  with lib;
{
  imports = [
    ../local-scripts
  ];

  home.packages = with pkgs;
    [
      # GUI support
      neovim-qt

      # GUI alternative
      vscodium
    ];

  editorconfig = {
    enable = true;
    settings = {
      "*" = {
        charset = "utf-8";
        end_of_line = "lf";
        trim_trailing_whitespace = true;
        insert_final_newline = true;
        max_line_width = 80;
        indent_style = "space";
        indent_size = 4;
      };
    };
  };

  # for vim
  home.file.".vim/autoload/lightline/colorscheme/simple.vim".source =
    ./../../../../dots/core/.vim/autoload/lightline/colorscheme/simple.vim;
  home.file.".vim/colors/simple.vim".source =
    ./../../../../dots/core/.vim/colors/simple.vim;

  # for neovim
  home.file."${config.xdg.configHome}/nvim/autoload/lightline/colorscheme/simple.vim".source =
    ./../../../../dots/core/.vim/autoload/lightline/colorscheme/simple.vim;
  home.file."${config.xdg.configHome}/nvim/colors/simple.vim".source =
    ./../../../../dots/core/.vim/colors/simple.vim;

  programs.neovim = {
    enable = true;
    package = pkgs.neovim-unwrapped;
    extraConfig = lib.fileContents ./../../../../dots/core/.vimrc;
    extraLuaConfig = lib.fileContents ./nvim/init.lua;

    plugins = with pkgs.vimPlugins; [
      # basic dependencies
      plenary-nvim

      # core dependency for LSP
      nvim-lspconfig
      # a must for languages syntax highlights
      nvim-treesitter.withAllGrammars

      # basic plugins
      vim-surround
      vim-sleuth

      # utility / help plugins
      which-key-nvim # which keys help guide
      vim-illuminate # Highlight similar words
      neomake # auto make scripts to show on quickfix buffer
      nvim-tree-lua # side tree
      comment-nvim # add comment commands/keybinds
      tagbar # show tags

      {
        plugin = nvim-autopairs; # automatically pair scopes/strings
        config = ''
          packadd! nvim-autopairs
          lua << END
          require 'nvim-autopairs'.setup {
            map_bs = false,
            fast_wrap = {},
            disable_filetype = { "TelescopePrompt", "vim" },
          }
          END
        '';
      }

      # ui plugins
      popup-nvim # implement cute popups
      nvim-colorizer-lua # add extra colors to text
      nvim-web-devicons # icons
      barbar-nvim # buffer line (top)
      lightline-vim # status line (bottom)
      indent-blankline-nvim # blank lines indentation

      # telescope
      telescope-nvim
      telescope-cheat-nvim
      telescope-dap-nvim
      telescope-file-browser-nvim
      telescope-media-files-nvim
      telescope-fzf-writer-nvim
      telescope-fzf-native-nvim
      telescope-github-nvim
      telescope-live-grep-args-nvim
      telescope-project-nvim
      telescope-symbols-nvim
      telescope-ui-select-nvim
      telescope-z-nvim

      # git integration
      vim-fugitive
      gitsigns-nvim
    ];

    # Aliases
    viAlias      = true;
    vimAlias     = true;
    vimdiffAlias = true;

    # Providers
    withNodeJs  = true;
    withPython3 = true;
    withRuby    = true;
  };

  home.sessionVariables = {
    "EDITOR" = "$HOME/.local/bin/editor";
  };
  home.shellAliases = {
    "v" = "$EDITOR";
  };
}
