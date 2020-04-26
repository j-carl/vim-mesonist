" vim-mesonist - support for meson
" Maintainer:    Jens Carl <j dot carl43 at gmx dot de>
" Version:       0.2.0

if exists('g:loaded_mesonist')
  finish
endif
let g:loaded_mesonist = 1

if !exists('g:mesonist_meson_executable')
  let g:mesonist_meson_executable = 'meson'
endif

if !exists('g:mesonist_meson_builddir')
  let g:mesonist_meson_builddir = 'builddir'
endif

if !exists('g:mesonist_link_compilation_db')
  let g:mesonist_link_compilation_db = 0
endif

if !executable(g:mesonist_meson_executable)
  echoerr "vim-mesonist requires meson. Please install it and find via PATH or set g:mesonist_meson_executable"
  finish
endif

" utilty section

" escape file name (Thanks to Tim Pope and
" https://github.com/tpope/vim-fugitive.git)
function! s:fnameescape(file) abort
  if exists('*fnameescape')
    return fnameescape(a:file)
  else
    return escape(a:file," \t\n*?[{`$\\%#'\"|!<")
  endif
endfunction


" meson root path
let s:mesonist_meson_root_path = "" " store the meson root directory
function! s:MesonistRootPath() abort
  " Locate meson root path by finding the directory holding a file meson.build
  " with function project(...) on the first line.
  if s:mesonist_meson_root_path != ""
    return s:mesonist_meson_root_path
  endif

  for build_file in findfile("meson.build", ".;", -1)
    if !filereadable(build_file)
      continue
    endif
    let l:lines = readfile(build_file, '', 1)
    if lines[0] =~ 'project'
      let s:mesonist_meson_root_path = fnameescape(fnamemodify(build_file, ':p:h'))
      break
    endif
  endfor

  return s:mesonist_meson_root_path
endfunction

" Link compilation database
function! s:MesonistLinkCompilationDatabase() abort
  if s:mesonist_meson_root_path == ""
    let s:mesonist_meson_root_path = s:MesonistRootPath()
  endif

  let l:old_dir = chdir(s:mesonist_meson_root_path)

  if !filereadable(g:mesonist_meson_builddir . '/compile_commands.json')
    if old_dir != ""
      call chdir(l:old_dir)
    endif
    return
  endif

  if has("win32")
    exec "mklink" "../compile_commands.json" "compile_commands.json"
  else
    echo system("ln -sf " . s:fnameescape(g:mesonist_meson_builddir) . "/compile_commands.json compile_commands.json")
  endif

  if old_dir != ""
    call chdir(l:old_dir)
  endif
endfunction

" Setup meson project
function! s:MesonistSetup(...) abort
  if s:mesonist_meson_root_path == ""
    let s:mesonist_meson_root_path = s:MesonistRootPath()
  endif

  let l:old_dir = ""
  if getcwd() != s:mesonist_meson_root_path
    let l:old_dir = chdir(s:mesonist_meson_root_path)
  endif

  let l:environment_variables = []
  if exists("g:mesonist_env_vars")
    let l:environment_variables = g:mesonist_env_vars
  endif
  if exists("g:mesonist_c_compiler")
    let l:environment_variables += ["CC=" . g:mesonist_c_compiler]
  endif
  if exists("g:mesonist_cxx_compiler")
    let l:environment_variables += ["CXX=" . g:mesonist_cxx_compiler]
  endif
  if exists("g:mesonist_c_linker")
    let l:environment_variables += ["CC_LD=" . g:mesonist_c_linker]
  endif
  if exists("g:mesonist_cxx_linker")
    let l:environment_variables += ["CXX_LD=" . g:mesonist_cxx_linker]
  endif

  let &makeprg = join(l:environment_variables, " ") . " " . g:mesonist_meson_executable . ' setup ' . g:mesonist_meson_builddir . ' ' . join(a:000)
  silent make|redraw!
  execute "MesonLinkCompilationDatabase"

  let l:builddir = s:fnameescape(s:mesonist_meson_root_path . '/' . g:mesonist_meson_builddir)
  let &makeprg = g:mesonist_meson_executable . ' compile -C ' . l:builddir

  if old_dir != ""
    call chdir(l:old_dir)
  endif

endfunction

command! -nargs=0 -bang MesonLinkCompilationDatabase call s:MesonistLinkCompilationDatabase()
command! -nargs=0 -bar -bang MesonLocateRootDir echo s:MesonistRootPath()
command! -nargs=? -bar MesonSetup call s:MesonistSetup(<f-args>)

" vim:set sw=2 ts=2:
