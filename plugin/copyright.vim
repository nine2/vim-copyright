" Vim plugin to change the working directory to the project root.
"
" Copyright 2018-2018 bbxytl, <bbxytl@gmail.com>
" Released under the MIT licence.

if exists('g:loaded_file_copyright') || &cp
  finish
endif
let g:loaded_file_copyright = 1

" ###### 加入注释， 主要以 # 和 c++系列 进行注释的语言
if !exists('g:file_copyright_name')
  let g:file_copyright_name = "在 vimrc 文件中添加 let g:file_copyright_name = 'your name'"
endif
if !exists('g:file_copyright_email')
  let g:file_copyright_email = "在 vimrc 文件中添加 let g:file_copyright_email = 'your email'"
endif

if !exists('g:file_copyright_auto_filetypes')
    " let g:file_copyright_auto_filetypes = ['sh', 'plx', 'pl', 'pm', 'py', 'python', 'h', 'hpp', 'c', 'cpp', 'java']
    let g:file_copyright_auto_filetypes = [ ]
endif

if !exists('g:file_copyright_comment_prefix_map ')
  let g:file_copyright_comment_prefix_map  = {
        \"python": "\#", "py":"\#",
        \"cpp":"/*", "c":"/*", "h":"/*", "hpp":"/*",
        \"go":"/*",
        \"vim":"\"",
        \"sh":"\#", "shell":"\#",
  \}
endif

if !exists('g:file_copyright_comment_mid_prefix_map')
  let g:file_copyright_comment_mid_prefix_map = {
        \"python": "\#", "py":"\#",
        \"cpp":"\#", "c":"\#", "h":"\#", "hpp":"\#",
        \"go":"\#",
        \"vim":"\"",
        \"sh":"\#", "shell":"\#",
  \}
endif

if !exists('g:file_copyright_comment_end_map')
  let g:file_copyright_comment_end_map = {
        \"cpp":"*/", "c":"*/", "h":"*/", "hpp":"*/",
        \"go":"*/",
  \}
endif


function! MatchFileType()
    for ft in g:file_copyright_auto_filetypes
        if ft ==# &filetype | return 1 | endif
    endfor
    return 0
endfunction
autocmd BufNewFile * if MatchFileType() | exec ":call <SID>AddTitle()" | endif


function SetCommentFlag()
  if !exists('g:file_copyright_comment_prefix')
    let g:file_copyright_comment_prefix = "\#"
    for item in keys(g:file_copyright_comment_prefix_map)
      if item == &filetype
        let g:file_copyright_comment_prefix = g:file_copyright_comment_prefix_map[&filetype]
      endif
    endfor
  endif
  if !exists('g:file_copyright_comment_mid_prefix')
    let g:file_copyright_comment_mid_prefix = "\#"
    for item in keys(g:file_copyright_comment_mid_prefix_map)
      if item == &filetype
        let g:file_copyright_comment_mid_prefix = g:file_copyright_comment_mid_prefix_map[&filetype]
      endif
    endfor
  endif
  if !exists('g:file_copyright_comment_end')
    let g:file_copyright_comment_end = ""
    for item in keys(g:file_copyright_comment_end_map)
      if item == &filetype
        let g:file_copyright_comment_end = g:file_copyright_comment_end_map[&filetype]
      endif
    endfor
  endif
endfunction

function! <SID>SetComment(begin)
    call SetCommentFlag()
    let l = -1
    let cx= 0
    if &filetype == 'sh' || &filetype == "perl" || &filetype == "python"
        let l = 0
        let cx= 1
    endif
    if &filetype == 'python'
      if a:begin isnot 0
        let l = 2
      endif
    endif
    call append(l + 1,      g:file_copyright_comment_prefix." ====================================================")
    call append(l + 2,  g:file_copyright_comment_mid_prefix."   Copyright (C)".strftime("%Y")." All rights reserved.")
    call append(l + 3,  g:file_copyright_comment_mid_prefix)
    call append(l + 4,  g:file_copyright_comment_mid_prefix."   Author        : ".expand(g:file_copyright_name))
    call append(l + 5,  g:file_copyright_comment_mid_prefix."   Email         : ".expand(g:file_copyright_email))
    call append(l + 6,  g:file_copyright_comment_mid_prefix."   File Name     : ".expand("%:t"))
    call append(l + 7,  g:file_copyright_comment_mid_prefix."   Last Modified : ".strftime("%Y-%m-%d %H:%M"))
    call append(l + 8,  g:file_copyright_comment_mid_prefix."   Describe      :")
    call append(l + 9,  g:file_copyright_comment_mid_prefix)
    call append(l + 10, g:file_copyright_comment_mid_prefix." ====================================================".g:file_copyright_comment_end)
    call append(l + 11, "")
endfunction
let s:file_copyright_head_end_line_no = 9

function! <SID>AutoSetFileHead()
    call SetCommentFlag()
    let n = 1
    let regline = '^'.g:file_copyright_comment_mid_prefix.'\s*\S*Last\sModified\s*:\s*\S*.*$'
    while n < 15
        let line = getline(n)
        if line =~ regline
            call <SID>UpdateTitle()
            return
        endif
        let n = n + 1
    endwhile
    call <SID>SetComment(0)
endfunction

function! <SID>UpdateTitle()
    execute '/'.g:file_copyright_comment_mid_prefix.'\s*\S*Last\sModified\s*:/s@:.*$@\=strftime(": %Y-%m-%d %H:%M")@'
    execute '/'.g:file_copyright_comment_mid_prefix.'\s*\S*File\sName\s*:/s@:.*$@\=": ".expand("%:t")@'
    execute "noh"
    echohl WarningMsg | echo "Successful in updating the copy right." | echohl None
endfunction

" ##### 不同文件添加不同头总调用函数
function! <SID>AddTitle()
    let file_copyright_head_hase = 0
    "如果文件类型为.sh文件
    if &filetype == 'sh'
        call Title_sh()
        let file_copyright_head_hase = 1
    endif

    "如果文件类型为perl文件
    if &filetype == 'perl'
        call Title_perl()
        let file_copyright_head_hase = 1
    endif

    "如果文件类型为python
    if &filetype == 'python'
        call Title_python()
        let file_copyright_head_hase = 1
    endif

    " Pike 文件
    if &filetype == 'pike'
        call Title_pike()
        let file_copyright_head_hase = 1
    endif

    " H 文件
    let hf = expand("%:e") == "h" || expand("%:e") == "hpp"
    if hf
        call Title_h()
        let file_copyright_head_hase = 1
    endif

    " C 文件
    if &filetype == 'c' && !hf
        call Title_c()
        let file_copyright_head_hase = 1
    endif

    " CPP 文件
    if &filetype == "cpp" && !hf || expand("%:e") == "cc"
        call Title_cpp()
        let file_copyright_head_hase = 1
    endif

    if &filetype == 'go'
        call Title_go()
        let file_copyright_head_hase = 1
    endif

    if file_copyright_head_hase is 0
        call Title_file()
    endif

    normal G
    normal o
    normal o
endfunc

" ##### 具体实现函数
func! Title_sh()
    call setline(1, "\#!/bin/bash")
    call <SID>SetComment(1)
endfunc

func! Title_perl()
    call setline(1, "\#!/usr/bin/perl -w")
    call <SID>SetComment(1)
endfunc


func! Title_python()
    call setline(1, "\#!/usr/bin/env python")
    call append(1, "\# encoding: utf-8")
    call append(2, "\# coding style: pep8")
    call <SID>SetComment(1)
    let l = s:file_copyright_head_end_line_no + 2
    call append(line(".") + l + 1, "")
    call append(line(".") + l + 2, "import sys")
    call append(line(".") + l + 3, "\# import os")
endfunc

func! Title_pike()
    call <SID>SetComment(1)
endfunc

func! Title_h()
    call <SID>SetComment(1)
    " let l = 9
    let l = s:file_copyright_head_end_line_no
    call append(line(".") + l + 1, "")
    call append(line(".") + l + 2, "\#ifndef  _".toupper(expand("%:t:r"))."_H")
    call append(line(".") + l + 3, "\#define  _".toupper(expand("%:t:r"))."_H")
    call append(line(".") + l + 4, "")
    call append(line(".") + l + 5, "")
    call append(line(".") + l + 6, "\#endif // _".toupper(expand("%:t:r"))."_H")
endfunc

func! Title_c()
    call <SID>SetComment(1)
    " let l = 9
    let l = s:file_copyright_head_end_line_no
    echom l
    call append(line(".") + l + 1, "")
    call append(line(".") + l + 2, "\#include <stdio.h>")
    call append(line(".") + l + 3, "")
    call append(line(".") + l + 4, "")
endfunc

func! Title_cpp()
    call <SID>SetComment(1)
    " let l = 9
    let l = s:file_copyright_head_end_line_no
    call append(line(".") + l + 1, "")
    call append(line(".") + l + 2, "\#include <iostream>")
    call append(line(".") + l + 3, "using namespace std;")
    call append(line(".") + l + 4, "")
    call append(line(".") + l + 6, "")
    "call append(line(".") + l + 5, "\#include \"".expand("%:t:r").".h\"")
endfunc

func! Title_go()
    call <SID>SetComment(1)
    let l = s:file_copyright_head_end_line_no
    call append(line(".") + l + 1, "")
    call append(line(".") + l + 2, "")
    call append(line(".") + l + 2, "import \"fmt\"")
endfunc

func! Title_file()
    call <SID>SetComment(1)
    let l = s:file_copyright_head_end_line_no
    call append(line(".") + l + 1, "")
    call append(line(".") + l + 2, "")
endfunc



""""""""""""""""""""""""""
" Shortcuts...
""""""""""""""""""""""""""
command! -nargs=0 CopyrightAdd :call <SID>AutoSetFileHead()
command! -nargs=0 CopyrightUpdate :call <SID>AutoSetFileHead()

" vim:set ft=vim sw=2 sts=2  fdm=marker et:
