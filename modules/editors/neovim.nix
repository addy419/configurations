{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [
      {
        plugin = dracula-vim;
        config = ''
          syntax on
          packadd! dracula-vim
          colorscheme dracula
          highlight Comment gui=italic
        '';
      }
      {
        plugin = lightline-vim;
        config = ''
          set noshowmode
          let g:lightline = { 'colorscheme': 'dracula' }
        '';
      }
      vim-polyglot
      {
        plugin = ranger-vim;
        config = ''
          let g:ranger_map_keys = 0
          let g:ranger_replace_netrw = 1
          map <silent> <Space>. :RangerEdit<CR>
        '';
      }
    ];
    extraPackages = with pkgs; [ ranger ];
    extraConfig = ''
      if (has("termguicolors"))  
        set termguicolors
      endif

      set mouse=n
      set number
      set relativenumber
      set nofixendofline
      set tabstop=2
      set shiftwidth=2
      set expandtab
    '';
  };
}
