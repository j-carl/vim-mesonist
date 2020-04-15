" Vim compiler file
" Language:         meson
" Maintainer:       Jens Carl <j [dot] carl43 [at] gmx [dot] de>
" URL:              https://github.com/j-carl/vim-mesonist
" Last Change:      2020-04-13

if exists("current_compiler")
    finish
endif
let current_compiler = "meson"

if exists(":CompilerSet") != 2      " older Vim always used :setlocal
    command -nargs=* CompilerSet setlocal <args>
endif

let s:cpo_save = &cpo
set cpo&vim

" Sample meson error line
" meson.build:3:0: ERROR: Unknown variable "test".
CompilerSet errorformat=
    \%f:%l:%c:\ %tRROR:\ %m,
    \%f:%l:%c:\ %tARNING:\ %m,
    \%f:%l:%c:\ %tEPRECATION:\ %m

let &cpo = s:cpo_save
unlet s:cpo_save
