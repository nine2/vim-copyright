# Add Copyright for Vim

vim-copyright is a plug for your file to add/update copyright by bbxytl.

## Installation

Copy the file on your .vim/plug folder.

### Vundle

```
Bundle "nine2/vim-copyright"
```

## Useg

add the config to your .vimrc to set your name / email :

```
let g:file_copyright_company = "your company, default: null"
let g:file_copyright_rights = "custom_rights, default:'All rights reserved.'"
let g:file_copyright_name = "your name"
let g:file_copyright_email = "your email"

" auto update copyright when save file. Default: 1; 0:close auto.
let g:file_copyright_auto_update = 1
```

### HotKey

- use `:CopyrightAdd` to add copyright for your file.
- use `:CopyrightUpdate` to update copyright.
- use `nmap uh :CopyrightUpdate<cr>` to your .vimrc file as hotkey.

### CustomConfig

add the config to auto add copyright to your file:

Default:
```
let g:file_copyright_auto_filetypes = [
        \ 'sh', 'plx', 'pl', 'pm', 'py', 'python',
        \ 'h', 'hpp', 'c', 'cpp', 'java',
        \ 'ruby', 'rb', 'rake',
        \ 'uml', 'plantuml'
]
```

custom filetype:
```
let g:file_copyright_auto_filetypes = [
        \ 'py', 'python'
]
```

you can set comment_prefix map:

```
let g:file_copyright_comment_prefix_map  = {
    \"python": "\#", "py":"\#",
    \"cpp":"/*", "c":"/*", "h":"/*", "hpp":"/*",
    \"go":"/*",
    \"vim":"\"",
    \"sh":"\#", "shell":"\#",
\}

let g:file_copyright_comment_mid_prefix_map = {
    \"python": "\#", "py":"\#",
    \"cpp":"\#", "c":"\#", "h":"\#", "hpp":"\#",
    \"go":"\#",
    \"vim":"\"",
    \"sh":"\#", "shell":"\#",
\}

let g:file_copyright_comment_end_map = {
    \"cpp":"*/", "c":"*/", "h":"*/", "hpp":"*/",
    \"go":"*/",
\
```

or set for filetype(default):

```
    let g:file_copyright_comment_prefix = "\#"
    let g:file_copyright_comment_mid_prefix = "\#"
    let g:file_copyright_comment_end = ""
```


## Copyright.eg

- python file:

```
# ====================================================
#   Copyright (C) 2018 All rights reserved.
#
#   Author        : your name
#   Email         : your email
#   File Name     : eg.py
#   Last Modified : 2018-04-06 14:27
#   Describe      :
#
# ====================================================
```

- cpp file:

```
/* ====================================================
#   Copyright (C) 2018 All rights reserved.
#
#   Author        : your name
#   Email         : your email
#   File Name     : eg.cpp
#   Last Modified : 2018-04-06 14:27
#   Describe      :
#
# ====================================================*/
```

