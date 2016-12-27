" Vim compiler file
" Compiler: python3
" Maintainer: alezai
" Last Change: 2016 Dec 26

if exists("current_compiler")
    finish
endif
let current_compiler = "python3"

if exists(":CompilerSet") != 2  " older Vim always used :setlocal
    command -nargs=* CompilerSet setlocal <args>
endif

CompilerSet makeprg=python3

CompilerSet errorformat=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m
