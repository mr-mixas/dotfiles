set nocompatible

set backspace=indent,eol,start      " Allow backspace in I mode

if has("syntax")
    syntax on
    colorscheme peachpuff
    set hlsearch
endif

set showmatch       " Show matching brackets.
set ignorecase      " Do case insensitive matching
set smartcase       " Do smart case matching
set incsearch       " Incremental search
set ruler           " Show the cursor position all the time
set nowrap          " Disable wrap for everything
set number          " Line numbers
set autoindent
set smartindent

" Softtabs
set tabstop=4
set shiftwidth=4
set expandtab

" Always display the status line
"set laststatus=2

" Display extra whitespace
set list!
set list listchars=tab:>-,trail:-

" Highlight lines lengths
set colorcolumn=80,120
highlight ColorColumn ctermbg=0

" Tabs in v mode idents code
vmap <tab> >gv
vmap <s-tab> <gv
