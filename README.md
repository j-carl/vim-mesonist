# vim-mesonist

[![j-carl](https://circleci.com/gh/j-carl/vim-mesonist.svg?style=shield)](https://circleci.com/gh/j-carl/vim-mesonist)

vim-mesonist is a Vim plugin to make working with
[meson](https://mesonbuild.com) easier.

## Usage

### Commamds

 * `:MesonSetup`: Set up a meson project.

 * `:MesonLocateRootDir`: Locates project root directory and echoes it.

### Variables

 * `g:mesonist_meson_executable` defines the meson executable to use.
 Default value is `meson`.

 * `g:mesonist_meson_builddir` sets the meson build directory to use.
 Defaults to `builddir`.

 * `g:mesonist_c_compiler` sets the C compiler to use. Same as environment
 variable `CC`.

 * `g:mesonist_cxx_compiler` sets the C++ compiler to use. Same as environment
 variable `CXX`.

## Installation

Install via your favorite package manager
 * [vim-plug](https://github.com/junegunn/vim-plug)
 * [vim-pathogen](https://github.com/tpope/vim-pathogen)
 * [Vundle](https://github.com/VundleVim/Vundle.vim)

or use Vim's built-in package support:

```shell
mkdir -p ~/.vim/pack/j-carl/start
cd ~/.vim/pack/j-carl/start
git clone https://github.com/j-carl/vim-menonist.git
vim -u NONE -c "helptags vim-mesonist/doc" -c q
```

## Acknowledgements

 * Thanks to [Junegunn Choi](https://junegunn.kr/), for
 [vader.vim](https://github.com/junegunn/vader.vim) his awesome testing
 framework.

## License

Copyright (c) Jens Carl. Distributed under BSD-2-Clause. See [LICENSE](LICENSE).
