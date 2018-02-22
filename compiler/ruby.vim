" Vim compiler file
" Compiler: ruby
" Maintainer: alezai
" Last Change: 2018 Feb 22

if exists("current_compiler")
    finish
endif
let current_compiler = "ruby"

if exists(":CompilerSet") != 2  " older Vim always used :setlocal
    command -nargs=* CompilerSet setlocal <args>
endif

CompilerSet makeprg=ruby

CompilerSet errorformat=\%W%*\\s%*\\d)\ Failure:,
                        \%E%*\\s%*\\d)\ Error:,
                        \%Z---Backtrace---,
                        \%Z%*\\s[%f:%l:in\ %m,
                        \%Z%*\\s[(%\\w%#://%.%#)\ %f:%l:in\ %m,
                        \%*\\d:%*\\d:%*\\d.%*\\d%*\\s(%*\\w)%*\\sfrom\ .%\\?%f:%l:%m,
                        \%*\\d:%*\\d:%*\\d.%*\\d%*\\s(%*\\w)%*\\s.%\\?%f:%l:%m,
                        \%-A%*\\d:%*\\d:%*\\d.%*\\d%*\\s(%*\\w)\ %m,
                        \%Z%*\\s%f:%l:in\ %m,
                        \%-G%*\\s(%\\w%#://%.%#)\ /usr/lib/ruby/1.8/drb/drb.rb:%l:in\ %m,
                        \%m:in\ (%\\w%#://%.%#)\ %f:%l:in\ %.%#,
                        \%m:in\ %f:%l:in\ %.%#,
                        \%.%#]:\ %f:%l:in\ %m,
                        \(%\\w%#://%.%#)\ %f:%l:in\ %m,
                        \%*\\s(%\\w%#://%.%#)\ %f:%l:in\ %m,
                        \%*\\s(%\\w%#://%.%#)\ %f:%l,
                        \%.%#:%*\\d:%.%#:\ %*[^/]%f:%l:\ %m(SyntaxError),
                        \%f:%l:\ parse\ error\\,\ %m,
                        \%f:%l:\ warning:\ %m,
                        \%f:%l:%m\(%*\\w\),
                        \%C%m\ [%f:%l]:,
                        \%+C%*\\w(%*\\w):,
                        \%+C%*\\w:\ %m,
                        \%C%[%^\ ]%\\@=%m,
                        \%C%\\s%#,
                        \%*\\sfrom\ (%\\w%#://%.%#)\ %f:%l:in\ %m,
                        \%*\\sfrom\ (%\\w%#://%.%#)\ %f:%l,
                        \%*\\sfrom\ %f:%l:in\ %m,
                        \%*\\sfrom\ %f:%l,
                        \%*\\s%f:%l:in\ %m,
                        \%*\\s%f:%l,
                        \%f:%l:in\ %m,
                        \%f:%l:%m
