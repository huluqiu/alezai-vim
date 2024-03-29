" Use bundles config {
    if filereadable(expand("~/.vimrc.bundles"))
        source ~/.vimrc.bundles
    endif
" }

" General {
    set background=dark         " Assume a dark background
    set fileencodings=utf-8,ucs-bom,gb18030,gbk,gb2312,cp936
    set termencoding=utf-8
    set encoding=utf-8
    let $LANG='en_US'
    set langmenu=en_US

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

    set mouse=""

    let g:python_host_prog = '~/.pyenv/shims/python'
    let g:python3_host_prog = '~/.pyenv/shims/python3'
" }

" Vim UI {
    if isdirectory(expand("~/.vim/bundle/github.vim"))
        if (has("termguicolors"))
             set termguicolors
        endif
        colorscheme github
        let g:airline_theme = 'github'
    endif

    set cursorline                  " Highlight current line

    highlight clear SignColumn      " SignColumn should match background
    highlight clear LineNr          " Current line number row will have same background color in relative mode

    set backspace=indent,eol,start  " Backspace for dummies
    set number                      " Line numbers on
    set showmatch                   " Show matching brackets/parenthesis
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

" Custome filetype {
    autocmd BufNewFile,BufRead Podfile set ft=ruby
    autocmd BufNewFile,BufRead *.podspec set ft=ruby
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
    nnoremap <leader>b :bp<CR>:bd #<CR>

    " 快捷保存
    nnoremap <C-s> :w<CR>
    inoremap <C-s> <ESC>:w<CR>
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

            " toggle left sign
            noremap <leader>ts :call ToggleLeftSign()<CR>
        endif
    " }

    " NerdTree {
        if isdirectory(expand("~/.vim/bundle/nerdtree"))
            map <C-e> <plug>NERDTreeTabsToggle<CR>
            nnoremap <C-k> :NERDTreeTabsFind<CR>

            let NERDTreeShowBookmarks = 1
            let NERDTreeIgnore = [
                \   '\.py[cd]$',
                \   '\~$',
                \   '\.swo$',
                \   '\.swp$',
                \   '^\.git$',
                \   '^\.hg$',
                \   '^\.svn$',
                \   '\.bzr$',
                \   '\.DS_Store',
                \   '^__pycache__$',
            \   ]
            let NERDTreeShowHidden = 1
        endif
    " }

    " Startify {
        if isdirectory(expand("~/.vim/bundle/vim-startify"))
            autocmd VimEnter *
                        \   if !argc()
                        \ |   Startify
                        \ |   NERDTree
                        \ |   wincmd w
                        \ | endif
        endif
    " }

    " fzf {
        if isdirectory(expand("~/.vim/bundle/fzf.vim/"))
            nnoremap <c-p> :Files<Cr>
            let $FZF_DEFAULT_COMMAND = 'ag --hidden --ignore .git -l -g ""'
        endif
    " }

    " tagbar {
        if isdirectory(expand("~/.vim/bundle/tagbar/"))
            nnoremap <Leader>tt :TagbarToggle<CR>
            let g:tagbar_width = 30
            let g:tagbar_autofocus = 1
            let g:tagbar_sort = 0
        endif
    " }

    " indent_guides {
        if isdirectory(expand("~/.vim/bundle/vim-indent-guides/"))
            let g:indent_guides_start_level = 2
            let g:indent_guides_guide_size = 1
            let g:indent_guides_enable_on_vim_startup = 1
            "let g:indent_guides_auto_colors = 0
            "autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd ctermbg=black
            "autocmd VimEnter,Colorscheme * :hi IndentGuidesEven ctermbg=darkgrey
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
            let g:ycm_filetype_blacklist = {
                \ 'tagbar' : 1,
                \ 'qf' : 1,
                \ 'notes' : 1,
                \ 'unite' : 1,
                \ 'text' : 1,
                \ 'vimwiki' : 1,
                \ 'pandoc' : 1,
                \ 'infolog' : 1,
                \ 'mail' : 1
                \}
            nnoremap gd :YcmCompleter GoTo<CR>
            " Disable the neosnippet preview candidate window
            set completeopt-=preview
        endif
    " }

    " deoplete {
        if isdirectory(expand("~/.vim/bundle/deoplete.nvim/"))
            let g:deoplete#enable_at_startup = 1
            " <TAB>: completion.
            inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
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

            let g:ale_set_highlights = 0
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

    " Polyglot {
        if isdirectory(expand("~/.vim/bundle/vim-polyglot/"))
            "markdown
            let g:vim_markdown_folding_disabled = 1
            let g:vim_markdown_new_list_item_indent = 0
            let g:vim_markdown_toc_autofit = 1
            "plantuml
            let g:plantuml_executable_script='java -jar -DPLANTUML_LIMIT_SIZE=8192 ~/Documents/lib/java/plantuml.jar'
        endif
    " }

    " Markdown {
        if isdirectory(expand("~/.vim/bundle/vim-markdown-preview"))
            let vim_markdown_preview_hotkey='<leader>r'
            let vim_markdown_preview_browser='Google Chrome'
            let vim_markdown_preview_github=1
        endif
    " }

    " vim-multiple-cursors {
        if !has('gui_running')
            let g:multi_cursor_select_all_key='<leader><C-n>'
        endif
    " }
" }
