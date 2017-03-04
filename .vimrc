" Use bundles config {
    if filereadable(expand("~/.vimrc.bundles"))
        source ~/.vimrc.bundles
    endif
" }

" General {
    set background=dark         " Assume a dark background
    set encoding=utf-8
    let $LANG='en'
    set langmenu=en

    set virtualedit=onemore     " Allow for cursor beyond last character
    set history=1000            " Store a ton of history (default is 20)

    set nobackup
    set nowritebackup
    set noswapfile

    set undofile                " So is persistent undo ...
    set undolevels=1000         " Maximum number of changes that can be undone
    set undoreload=10000        " Maximum number lines to save for undo on a buffer reload

    filetype plugin indent on   " Automatically detect file types.
    syntax on                   " Syntax highlighting
" }

" Vim UI {
    "if filereadable(expand("~/.vim/bundle/vim-colors-solarized/colors/solarized.vim"))
        "let g:solarized_termcolors=256
        "let g:solarized_termtrans=1
        "let g:solarized_contrast="high"
        "let g:solarized_visibility="normal"
        "color solarized             " Load a colorscheme
    "endif
    if filereadable(expand("~/.vim/bundle/github.vim/colors/github.vim"))
        if (has("termguicolors"))
             set termguicolors
        endif
        let g:airline_theme='github'
        colorscheme github
    endif

    set cursorline                  " Highlight current line

    highlight clear SignColumn      " SignColumn should match background
    highlight clear LineNr          " Current line number row will have same background color in relative mode

    set backspace=indent,eol,start  " Backspace for dummies
    set number                      " Line numbers on
    set showmatch                   " Show matching brackets/parenthesis
    set nohlsearch
    set incsearch                   " Find as you type search
    set ignorecase                  " Case insensitive search
    set smartcase                   " Case sensitive when uc present
    set wildmenu                    " Show list instead of just completing
    set wildmode=list:longest,full  " Command <Tab> completion, list matches, then longest common part, then all.
    set whichwrap=b,s,h,l,<,>,[,]   " Backspace and cursor keys wrap too
    set scrolljump=5                " Lines to scroll when cursor leaves screen
    set scrolloff=3                 " Minimum lines to keep above and below cursor
    set list
    set listchars=tab:›\ ,trail:•,extends:#,nbsp:. " Highlight problematic whitespace
" }

" Formatting {
    set nowrap                      " Do not wrap long lines
    set autoindent                  " Indent at the same level of the previous line
    set shiftwidth=4                " Use indents of 4 spaces
    set expandtab                   " Tabs are spaces, not tabs
    set tabstop=4                   " An indentation every four columns
    set softtabstop=4               " Let backspace delete indent
    set nojoinspaces                " Prevents inserting two spaces after punctuation on a join (J)
    set splitright                  " Puts new vsplit windows to the right of the current
    set splitbelow                  " Puts new split windows to the bottom of the current
" }

" Key (re)Mappings {
    let mapleader = ','
    nnoremap <leader>sv :source $MYVIMRC<CR>

    map <C-J> <C-W>j
    map <C-K> <C-W>k
    map <C-L> <C-W>l
    map <C-H> <C-W>h

    cnoremap <C-p> <Up>
    cnoremap <C-n> <Down>

    " Easier horizontal scrolling
    map zl zL
    map zh zH

    " Yank from the cursor to the end of the line, to be consistent with C and D.
    nnoremap Y y$

    " Find merge conflict markers
    map <leader>fc /\v^[<\|=>]{7}( .*\|$)<CR>

    " Visual shifting (does not exit Visual mode)
    vnoremap < <gv
    vnoremap > >gv

    " Allow using the repeat operator with a visual selection (!)
    " http://stackoverflow.com/a/8064607/127816
    vnoremap . :normal .<CR>

    " For when you forget to sudo.. Really Write the file.
    cmap w!! w !sudo tee % >/dev/null

    " Map <Leader>ff to display all lines with keyword under cursor and ask which one to jump to
    nmap <Leader>ff [I:let nr = input("Which one: ")<Bar>exe "normal " . nr ."[\t"<CR>

    " Buffer
    nnoremap <silent> [b :bprevious<CR>
    nnoremap <silent> ]b :bnext<CR>
    nnoremap <silent> [B :bfirst<CR>
    nnoremap <silent> ]B :blast<CR>

    " copy
    vnoremap <C-c> "*y

    " close buffer(兼容Nerdtree)
    nnoremap <leader>b :bp<cr>:bd #<cr>
" }

" Plugins {
    " Alezai {
        if isdirectory(expand("~/.vim/bundle/vim-alezai"))
            " Dirs
            let g:alezai_undodir = $HOME . '/.vim/.vimundo/'
            let g:alezai_rescur = 1

            " Locatoin list
            nmap <script> <silent> <leader>l :call ToggleLocationList()<CR>
            nnoremap <silent> [l :call LocationPreviousCycle()<CR>
            nnoremap <silent> ]l :call LocationNextCycle()<CR>
            nnoremap <silent> [L :lfirst<CR>
            nnoremap <silent> ]L :llast<CR>

            " Quickfix list
            nmap <script> <silent> <leader>q :call ToggleQuickfixList()<CR>
            nnoremap <silent> ]c :call QuickfixNextCycle()<CR>
            nnoremap <silent> [c :call QuickfixPreviousCycle()<CR>
            nnoremap <silent> [C :cfirst<CR>
            nnoremap <silent> ]C :clast<CR>
        endif
    " }

    " NerdTree {
        if isdirectory(expand("~/.vim/bundle/nerdtree"))
            map <C-e> <plug>NERDTreeTabsToggle<CR>

            let NERDTreeShowBookmarks=1
            let NERDTreeIgnore=['\.py[cd]$', '\~$', '\.swo$', '\.swp$', '^\.git$', '^\.hg$', '^\.svn$', '\.bzr$', '\.DS_Store']
            let NERDTreeShowHidden=1
        endif
    " }

    " ctrlp {
        if isdirectory(expand("~/.vim/bundle/ctrlp.vim/"))
            let g:ctrlp_working_path_mode = 'ra'
            let g:ctrlp_custom_ignore = {
                \ 'dir':  '\.git$\|\.hg$\|\.svn$',
                \ 'file': '\.exe$\|\.so$\|\.dll$\|\.pyc$' }

            let g:ctrlp_user_command = {
                \ 'types': {
                    \ 1: ['.git', 'cd %s && git ls-files . --cached --exclude-standard --others'],
                    \ 2: ['.hg', 'hg --cwd %s locate -I .'],
                \ },
                \ 'fallback': 'find %s -type f'
            \ }

            if isdirectory(expand("~/.vim/bundle/ctrlp-funky/"))
                " CtrlP extensions
                let g:ctrlp_extensions = ['funky']

                "funky
                nnoremap <Leader>fu :CtrlPFunky<Cr>
            endif
        endif
    "}

    " tagbar {
        if isdirectory(expand("~/.vim/bundle/tagbar/"))
            nnoremap <Leader>tt :TagbarToggle<CR>
        endif
    " }

    " indent_guides {
        if isdirectory(expand("~/.vim/bundle/vim-indent-guides/"))
            let g:indent_guides_start_level = 2
            let g:indent_guides_guide_size = 1
            let g:indent_guides_enable_on_vim_startup = 1
        endif
    " }

    " vim-airline {
        if isdirectory(expand("~/.vim/bundle/vim-airline/"))
            set laststatus=2
            let g:airline_powerline_fonts = 1
            let g:airline#extensions#tabline#enabled = 1

            let g:airline_section_a = airline#section#create(['mode'])
            let g:airline_section_c = airline#section#create(['filetype'])

            let g:airline_section_x = ''    "placeholder
            let g:airline_section_y = airline#section#create(['%P'])
            let g:airline_section_z = airline#section#create_right(['%l','%c'])
        endif
    " }

    " YouCompleteMe {
        if isdirectory(expand("~/.vim/bundle/YouCompleteMe/"))
            let g:ycm_global_ycm_extra_conf = $HOME."/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py"
            let g:ycm_collect_identifiers_from_tags_files = 1
            let g:ycm_use_ultisnips_completer = 1
            let g:ycm_show_diagnostics_ui = 0
            let g:ycm_python_binary_path = 'python'
            let g:ycm_server_python_interpreter = 'python3'
            nnoremap gd :YcmCompleter GoTo<CR>

            " Disable the neosnippet preview candidate window
            set completeopt-=preview
        endif
    " }

    " ultisnips {
        if isdirectory(expand("~/.vim/bundle/ultisnips/"))
            let g:UltiSnipsExpandTrigger = '<C-j>'
            let g:UltiSnipsJumpForwardTrigger = '<C-j>'
            let g:UltiSnipsJumpBackwardTrigger = '<C-k>'
        endif
    " }

    " fugitive {
        if isdirectory(expand("~/.vim/bundle/vim-fugitive/"))
            nnoremap <silent> <leader>gs :Gstatus<CR>
            nnoremap <silent> <leader>gd :Gvdiff<CR>
        endif
    " }

    " ale {
        if isdirectory(expand("~/.vim/bundle/ale/"))
            let g:ale_linters = {
            \   'c': ['clang'],
            \   'c++': ['gcc'],
            \   'python': ['flake8'],
            \   'javascript': ['eslint'],
            \}

            let g:ale_sign_column_always = 1
            let g:ale_sign_error = '✗'
            let g:ale_sign_warning = '⚠'
            let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'

            nmap <silent> ]e <Plug>(ale_next_wrap)
            nmap <silent> [e <Plug>(ale_previous_wrap)

            " flake8
            let g:ale_python_flake8_executable = 'flake8'
            "let g:ale_python_flake8_executable = '/usr/local/bin/python3'
            "let g:ale_python_flake8_args = '-m flake8'
        endif
    " }

    " AsyncRun {
        if isdirectory(expand("~/.vim/bundle/asyncrun.vim/"))
            let g:airline_section_x = airline#section#create(['%{g:asyncrun_status}'])

            command! -bang -nargs=* -complete=file Make AsyncRun -program=make @ <args>

            nnoremap <leader>c :Make<CR>
            nnoremap <leader>. :AsyncStop<CR>
        endif
    " }
" }
