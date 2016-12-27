#!/usr/bin/env bash

############################  SETUP PARAMETERS
app_name='alezai-vim'
[ -z "$APP_PATH" ] && APP_PATH="$HOME/.alezai-vim"
[ -z "$REPO_URI" ] && REPO_URI='https://github.com/huluqiu/alezai-vim.git'
[ -z "$REPO_BRANCH" ] && REPO_BRANCH='master'
debug_mode='1'
[ -z "$VUNDLE_URI" ] && PLUG_URL="https://github.com/junegunn/vim-plug.git"

############################  BASIC SETUP TOOLS
msg() {
    printf '%b\n' "$1" >&2
}

success() {
    if [ "$ret" -eq '0' ]; then
        msg "\33[32m[✔]\33[0m ${1}${2}"
    fi
}

error() {
    msg "\33[31m[✘]\33[0m ${1}${2}"
    exit 1
}

debug() {
    if [ "$debug_mode" -eq '1' ] && [ "$ret" -gt '1' ]; then
        msg "An error occurred in function \"${FUNCNAME[$i+1]}\" on line ${BASH_LINENO[$i+1]}, we're sorry for that."
    fi
}

program_exists() {
    local ret='0'
    command -v "$1" >/dev/null 2>&1 || { local ret='1'; }

    # fail on non-zero return value
    if [ "$ret" -ne 0 ]; then
        return 1
    fi

    return 0
}

program_must_exist() {
    program_exists "$1"

    # throw error on non-zero return value
    if [ "$?" -ne 0 ]; then
        error "You must have '$1' installed to continue."
    fi
}

variable_set() {
    if [ -z "$1" ]; then
        error "You must have your HOME environmental variable set to continue."
    fi
}

lnif() {
    if [ -e "$1" ]; then
        ln -sf "$1" "$2"
    fi
    ret="$?"
    debug
}

############################ SETUP FUNCTIONS

sync_repo() {
    local repo_path="$1"
    local repo_uri="$2"
    local repo_branch="$3"
    local repo_name="$4"

    msg "Trying to update $repo_name"

    if [ ! -e "$repo_path" ]; then
        mkdir -p "$repo_path"
        git clone -b "$repo_branch" "$repo_uri" "$repo_path"
        ret="$?"
        success "Successfully cloned $repo_name."
    else
        cd "$repo_path" && git pull origin "$repo_branch"
        ret="$?"
        success "Successfully updated $repo_name"
    fi

    debug
}

create_symlinks() {
    local source_path="$1"
    local target_path="$2"

    lnif "$source_path/.vimrc"         "$target_path/.vimrc"
    lnif "$source_path/.vimrc.bundles" "$target_path/.vimrc.bundles"
    lnif "$source_path/compiler"      "$target_path/.vim/compiler"
    lnif "$source_path/after"         "$target_path/.vim/after"

    if program_exists "nvim"; then
        mkdir "$HOME/.config" 
        lnif "$HOME/.vim"              "$target_path/.config/nvim"
        lnif "$source_path/.vimrc"     "$target_path/.config/nvim/init.vim"
    fi

    ret="$?"
    success "Setting up vim symlinks."
    debug
}

setup_plug() {
    local system_shell="$SHELL"
    export SHELL='/bin/sh'

    if [ -e "$HOME/.vim/bundle/vim-plug" ]; then
        mkdir "$HOME/.vim/bundle/vim-plug/autoload"
        lnif "$HOME/.vim/bundle/vim-plug/plug.vim" "$HOME/.vim/bundle/vim-plug/autoload/plug.vim"
    fi

    # add local plug
    local plugin_alezai="$HOME/.vim/bundle/vim-alezai/plugin"
    if [ ! -e "$plugin_alezai" ]; then
        mkdir -p "$plugin_alezai"
    fi
    lnif "$APP_PATH/vim-alezai.vim" "$plugin_alezai/vim-alezai.vim"

    VIM=vim
    if program_exists "nvim"; then
        VIM=nvim
    fi

    $VIM \
        -u "$1" \
        "+set nomore" \
        "+PlugInstall!" \
        "+PlugClean" \
        "+qall"

    export SHELL="$system_shell"

    success "Now updating/installing plugins using vim-plug"
    debug
}

setup_powerline_font() {
    local font_repo_path="$HOME/.vim/bundle/vim-airline/fonts"

    sync_repo       "$font_repo_path" \
                    "https://github.com/powerline/fonts.git" \
                    "master" \
                    "fonts"

    if [ "$ret" -eq '0' ]; then
        cd "$font_repo_path" && sh install.sh
    fi
}

############################ MAIN()
variable_set "$HOME"
program_must_exist "vim"
program_must_exist "git"

sync_repo       "$APP_PATH" \
                "$REPO_URI" \
                "$REPO_BRANCH" \
                "$app_name"

sync_repo       "$HOME/.vim/bundle/vim-plug" \
                "$PLUG_URL" \
                "master" \
                "vim-plug"

create_symlinks "$APP_PATH" \
                "$HOME"

setup_plug    "$APP_PATH/.vimrc.bundles"

setup_powerline_font

msg             "\nInstalling completed."
