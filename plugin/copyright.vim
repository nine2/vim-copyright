" ====================================================
"   Copyright (C) 2021  All rights reserved.
"
"   Author        : bbxytl
"   Email         : bbxytl@gmail.com
"   File Name     : copyright.vim
"   Last Modified : 2023-08-04 10:59
"   Describe      : Released under the MIT licence.
"       Add and update Copyright messag, eg. file name, last modified
"
" ====================================================


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
if !exists('g:file_copyright_company')
  let g:file_copyright_company = ""
endif
if !exists('g:file_copyright_rights')
  let g:file_copyright_rights = "All rights reserved."
endif

if !exists('g:file_copyright_auto_update')
  let g:file_copyright_auto_update = 1
endif


if !exists('g:file_copyright_auto_filetypes')
    let g:file_copyright_auto_filetypes = [
          \ 'sh', 'plx', 'pl', 'pm', 'py', 'python',
          \ 'h', 'hpp', 'c', 'cpp', 'java',
          \ 'ruby', 'rb', 'rake',
          \ 'uml', 'plantuml',
          \ 'go',
        \]
    " let g:file_copyright_auto_filetypes = [ ]
endif

if !exists('g:file_copyright_auto_filetypes_add')
    let g:file_copyright_auto_filetypes_add = []
endif


let g:file_copyright_comment_prefix_map_default = {
      \"python": "\#", "py":"\#",
      \"cpp":"/*", "c":"/*", "h":"/*", "hpp":"/*",
      \"go":"/*",
      \"vim":"\"", "vim9script": "\#",
      \"sh":"\#", "shell":"\#",
      \"ruby":"\#", "rb":"\#", "rake":"\#",
      \"uml":"/'", "plantuml":"/'",
\}

if !exists('g:file_copyright_comment_prefix_map')
  let __comment = getline(1) =~# "^vim9script" ? "\#": "\""
  let g:file_copyright_comment_prefix_map = {"vim": __comment}
endif

let g:file_copyright_comment_mid_prefix_map_default = {
      \"python": "\#", "py":"\#",
      \"cpp":"\#", "c":"\#", "h":"\#", "hpp":"\#",
      \"go":"\#",
      \"vim":"\"", "vim9script": "\#",
      \"sh":"\#", "shell":"\#",
      \"ruby":"\#", "rb":"\#", "rake":"\#",
      \"uml":"'", "plantuml":"'",
\}

if !exists('g:file_copyright_comment_mid_prefix_map')
  let __comment = getline(1) =~# "^vim9script" ? "\#": "\""
  let g:file_copyright_comment_mid_prefix_map = {"vim": __comment}
endif

let g:file_copyright_comment_end_map_default = {
      \"cpp":"*/", "c":"*/", "h":"*/", "hpp":"*/",
      \"go":"*/",
      \"uml":"'/", "plantuml":"'/",
\}

if !exists('g:file_copyright_comment_end_map')
  let g:file_copyright_comment_end_map = {}
endif


function! MatchFileType()
    for ft in g:file_copyright_auto_filetypes
        if ft ==# &filetype | return 1 | endif
    endfor

    for ft in g:file_copyright_auto_filetypes_add
        if ft ==# &filetype | return 1 | endif
    endfor

    return 0
endfunction
autocmd BufNewFile * if MatchFileType() | exec ":call <SID>AddTitle()" | endif


function SetCommentFlag()
  if !exists('g:file_copyright_comment_prefix')
    let g:file_copyright_comment_prefix = "\#"
    for item in keys(g:file_copyright_comment_prefix_map_default)
      if item == &filetype
        let g:file_copyright_comment_prefix = g:file_copyright_comment_prefix_map_default[&filetype]
      endif
    endfor
    for item in keys(g:file_copyright_comment_prefix_map)
      if item == &filetype
        let g:file_copyright_comment_prefix = g:file_copyright_comment_prefix_map[&filetype]
      endif
    endfor
  endif

  if !exists('g:file_copyright_comment_mid_prefix')
    let g:file_copyright_comment_mid_prefix = "\#"
    for item in keys(g:file_copyright_comment_mid_prefix_map_default)
      if item == &filetype
        let g:file_copyright_comment_mid_prefix = g:file_copyright_comment_mid_prefix_map_default[&filetype]
      endif
    endfor
    for item in keys(g:file_copyright_comment_mid_prefix_map)
      if item == &filetype
        let g:file_copyright_comment_mid_prefix = g:file_copyright_comment_mid_prefix_map[&filetype]
      endif
    endfor
  endif

  if !exists('g:file_copyright_comment_end')
    let g:file_copyright_comment_end = ""
    for item in keys(g:file_copyright_comment_end_map_default)
      if item == &filetype
        let g:file_copyright_comment_end = g:file_copyright_comment_end_map_default[&filetype]
      endif
    endfor
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
    for ftype in ['sh', 'perl', 'python', 'ruby', 'rb', 'rake', 'vim']
      if &filetype == ftype
        let l = 0
        break
      endif
    endfor

    if &filetype == 'python'
      if a:begin isnot 0
        let l = 2
      endif
    endif
    call append(l + 1,      g:file_copyright_comment_prefix." ====================================================")
    call append(l + 2,  g:file_copyright_comment_mid_prefix."   Copyright (C) ".strftime("%Y")." ".expand(g:file_copyright_company)." ".expand(g:file_copyright_rights))
    call append(l + 3,  g:file_copyright_comment_mid_prefix)
    call append(l + 4,  g:file_copyright_comment_mid_prefix."   Author        : ".expand(g:file_copyright_name))
    call append(l + 5,  g:file_copyright_comment_mid_prefix."   Email         : ".expand(g:file_copyright_email))
    call append(l + 6,  g:file_copyright_comment_mid_prefix."   File Name     : ".expand("%:t"))
    call append(l + 7,  g:file_copyright_comment_mid_prefix."   Last Modified : ".strftime("%Y-%m-%d %H:%M"))
    call append(l + 8,  g:file_copyright_comment_mid_prefix."   Describe      : " )
    call append(l + 9,  g:file_copyright_comment_mid_prefix)
    call append(l + 10, g:file_copyright_comment_mid_prefix." ====================================================".g:file_copyright_comment_end)
    call append(l + 11, "")
endfunction
let s:file_copyright_head_end_line_no = 9

function! <SID>UpdateFileHead(add)
    let curline = line(".")
    let curcol = col(".")
    " echom "AutoSetFileHead" | echo curline | echo curcol
    call SetCommentFlag()
    let n = 1
    let regline = '^'.g:file_copyright_comment_mid_prefix.'\s*\S*Last\sModified\s*:\s*\S*.*$'
    for n in range(1,14)
      let line = getline(n)
      if line =~ regline
        call <SID>UpdateTitle()
        call cursor(curline, curcol)
        return
      endif
    endfor

    if a:add isnot 0
      call <SID>SetComment(0)
    endif
endfunction

function! <SID>AutoSetFileHead()
    call <SID>UpdateFileHead(1)
endfunction

function! <SID>UpdateTitle()
    execute '/^'.g:file_copyright_comment_mid_prefix.'\s*\S*Last\sModified\s*:/s@:.*$@\=strftime(": %Y-%m-%d %H:%M")@'
    execute '/^'.g:file_copyright_comment_mid_prefix.'\s*\S*File\sName\s*:/s@:.*$@\=": ".expand("%:t")@'
    execute "noh"
    echohl WarningMsg | echo "Successful in updating the copy right." | echohl None
endfunction

" ##### 不同文件添加不同头总调用函数
function! <SID>AddTitle()
    let file_copyright_head_hase = 0
    "如果文件类型为.vim文件
    if &filetype == 'vim'
        call Title_vim()
        let file_copyright_head_hase = 1
    endif

    if &filetype == 'sh'
        call Title_sh()
        let file_copyright_head_hase = 1
    endif

    "ruby文件
    if &filetype == 'ruby' || &filetype == 'rb' || &filetype == 'rake'
        call Title_ruby()
        let file_copyright_head_hase = 1
    endif
    "rake
    if &filetype == 'rake'
        call Title_file()
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

    " go 文件
    if &filetype == 'go'
        call Title_go()
        let file_copyright_head_hase = 1
    endif

    " uml 文件
    let sub_uml = expand("%:e") == "uml" || expand("%:e") == "plantuml"
    if &filetype == 'uml' || &filetype == 'plantuml' || sub_uml
        call Title_uml()
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
func! Title_vim()
  let choice = confirm("create a vim9script script?", "&y\n&n\n")
  if choice == 1
    cal setline(1, "vim9script")
    let g:file_copyright_comment_prefix = "\#"
    let g:file_copyright_comment_mid_prefix = "\#"
    call <SID>SetComment(1)

  else
    call <SID>SetComment(0)
  endif
endfunc

func! Title_sh()
    call setline(1, "\#!/usr/bin/env bash")
    call <SID>SetComment(1)
endfunc

func! Title_ruby()
    call setline(1, "\#!/usr/bin/ruby")
    call <SID>SetComment(1)
endfunc

func! Title_perl()
    call setline(1, "\#!/usr/bin/perl -w")
    call <SID>SetComment(1)
endfunc


func! Title_python()
    call setline(1, "\#!/usr/bin/env python3")
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
    call append(line(".") + l + 2, "")
    call append(line(".") + l + 3, "")
    call setline(l + 3, "\#ifndef  _".toupper(expand("%:t:r"))."_H")
    call append(line(".") + l + 4, "")
    call setline(l + 4, "\#define  _".toupper(expand("%:t:r"))."_H")
    call append(line(".") + l + 5, "")
    call setline(l + 5, "")
    call append(line(".") + l + 6, "")
    call setline(l + 6, "\#endif // _".toupper(expand("%:t:r"))."_H")
endfunc

func! Title_c()
    call <SID>SetComment(1)
    " let l = 9
    let l = s:file_copyright_head_end_line_no
    echom l
    call append(line(".") + l + 1, "")
    call append(line(".") + l + 2, "")
    call append(line(".") + l + 3, "")
    call setline(l + 3, "\#include <stdio.h>")
    call append(line(".") + l + 4, "")
endfunc

func! Title_cpp()
    call <SID>SetComment(1)
    " let l = 9
    let l = s:file_copyright_head_end_line_no
    call append(line(".") + l + 1, "")
    call append(line(".") + l + 2, "")
    call append(line(".") + l + 3, "")
    call setline(l + 3, "\#include <iostream>")
    call append(line(".") + l + 4, "")
    call setline(l + 4, "using namespace std;")
    call append(line(".") + l + 5, "")
    " call setline(l + 5, "\#include \"".expand("%:t:r").".h\"")
    "call append(line(".") + l + 5, "\#include \"".expand("%:t:r").".h\"")
endfunc

func! Title_go()
    call <SID>SetComment(1)
    let l = s:file_copyright_head_end_line_no
    call append(line(".") + l + 1, "")
    call append(line(".") + l + 2, "")
    call append(line(".") + l + 2, "import \"fmt\"")
endfunc

func! Title_uml()
    " call <SID>SetComment(1)
    " let l = s:file_copyright_head_end_line_no
    call append(1, "")
    call setline(1, "@startuml")
    " call setline(2, "/' !includeurl https://raw.githubusercontent.com/xuanye/plantuml-style-c4/master/core.puml '/")
    call setline(2, "")
    call setline(3, "@enduml")
endfunc



func! Title_file()
    call <SID>SetComment(1)
    let l = s:file_copyright_head_end_line_no
    call append(line(".") + l + 1, "")
    call append(line(".") + l + 2, "")
endfunc


func! <SID>AutoUpdate()
  if exists('g:file_copyright_auto_update') && g:file_copyright_auto_update == 1
    call <SID>UpdateFileHead(0)
  endif
endfunc
au BufWritePre * call <SID>AutoUpdate()

""""""""""""""""""""""""""
" Shortcuts...
""""""""""""""""""""""""""
command! -nargs=0 CopyrightAdd :call <SID>AutoSetFileHead()
command! -nargs=0 CopyrightUpdate :call <SID>AutoSetFileHead()
" vim:set ft=vim sw=2 sts=2  fdm=marker et:
