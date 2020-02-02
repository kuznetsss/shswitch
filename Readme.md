# SHSwitch vim plugin

SHSwitch is a simple plugin to switch between header and source files. 

## Usage

SHSwitch provide only one command `:SHSwitch` to switch between header and source.

## Options

Available options and default values:

* `g:shswitch_source_extensions` - array of source files extensions. Default value: `['c', 'cpp']`
* `g:shswitch_header_extensions` - array of header files extensions. Default value: `['h', 'hpp']`
* `g:shswitch_root_flags` - array of project root files. Default value: `['CMakeLists.txt']`

## Algorithm of searching corresponding file 

* Check if corresponding file is in current directory.
* If not jump to parent directory until not find one of `g:shswitch_root_flags`.
* Use bash `find` command to find corresponding file in project root directory.

## Installation

To install via [Vim-Plug](https://github.com/junegunn/vim-plug) add line to your 'vimrc' file:
`Plug 'kuznetsss/shswitch'`

I haven't tested but similar line should work with other vim plugin managers.
