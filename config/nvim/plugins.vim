" Plugins will be downloaded under the specified directory.
call plug#begin('~/.vim/plugged')

" Lightline Status Bar
Plug 'itchyny/lightline.vim'

" Theme
Plug 'dracula/vim', { 'as': 'dracula' }

" Syntax Highlight
Plug 'sheerun/vim-polyglot'

" Ranger
Plug 'francoiscabrol/ranger.vim'

" List ends here. Plugins become visible to Vim after this call.
call plug#end()
