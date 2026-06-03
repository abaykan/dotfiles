" Custom VSCode Dark colorscheme - matching kitty palette
set background=dark
highlight clear

if exists("syntax_on")
  syntax reset
endif

let g:colors_name = "onedark-custom"

" === Palette (VSCode Dark) ===
" bg         #1e1e1e
" fg         #cccccc
" cursor     #ffffff
" selection  #264f78
" black      #000000 / #666666
" red        #f14c4c / #cd3131
" green      #23d18b / #0dbc79
" yellow     #f5f543 / #e5e510
" blue       #3b8eea / #2472c8
" magenta    #d670d6 / #bc3fbc
" cyan       #29b8db / #11a8cd
" white      #e5e5e5

" === Editor ===
hi Normal         guifg=#cccccc guibg=#1e1e1e
hi CursorLine     guibg=#2a2d2e
hi CursorColumn   guibg=#2a2d2e
hi LineNr         guifg=#858485 guibg=#1e1e1e
hi CursorLineNr   guifg=#cccccc guibg=#2a2d2e gui=bold
hi VertSplit      guifg=#414140 guibg=#1e1e1e
hi StatusLine     guifg=#cccccc guibg=#3a3d41
hi StatusLineNC   guifg=#858485 guibg=#3a3d41
hi Pmenu          guifg=#cccccc guibg=#3a3d41
hi PmenuSel       guifg=#1e1e1e guibg=#3b8eea
hi PmenuSbar      guibg=#3a3d41
hi PmenuThumb     guibg=#666666
hi Visual         guibg=#264f78
hi Search         guifg=#1e1e1e guibg=#f5f543
hi IncSearch      guifg=#1e1e1e guibg=#f5f543
hi MatchParen     guifg=#f5f543 guibg=NONE gui=bold
hi ColorColumn    guibg=#2a2d2e
hi SignColumn     guifg=#858485 guibg=#1e1e1e
hi FoldColumn     guifg=#858485 guibg=#1e1e1e
hi Folded         guifg=#858485 guibg=#2a2d2e
hi NonText        guifg=#414140
hi SpecialKey     guifg=#414140
hi Directory      guifg=#3b8eea
hi Title          guifg=#23d18b gui=bold
hi ErrorMsg       guifg=#f14c4c guibg=NONE
hi WarningMsg     guifg=#f5f543
hi Question       guifg=#23d18b
hi MoreMsg        guifg=#23d18b
hi ModeMsg        guifg=#23d18b
hi Cursor         guifg=#1e1e1e guibg=#ffffff

" === Syntax ===
hi Comment        guifg=#666666 gui=italic
hi String         guifg=#ce9178
hi Character      guifg=#ce9178
hi Number         guifg=#b5cea8
hi Boolean        guifg=#569cd6
hi Float          guifg=#b5cea8
hi Constant       guifg=#569cd6
hi Identifier     guifg=#9cdcfe
hi Function       guifg=#dcdcaa
hi Statement      guifg=#c586c0
hi Conditional    guifg=#c586c0
hi Repeat         guifg=#c586c0
hi Label          guifg=#c586c0
hi Operator       guifg=#d4d4d4
hi Keyword        guifg=#569cd6
hi Exception      guifg=#c586c0
hi PreProc        guifg=#c586c0
hi Include        guifg=#c586c0
hi Define         guifg=#c586c0
hi Macro          guifg=#c586c0
hi PreCondit      guifg=#c586c0
hi Type           guifg=#569cd6
hi StorageClass   guifg=#569cd6
hi Structure      guifg=#569cd6
hi Typedef        guifg=#569cd6
hi Special        guifg=#d7ba7d
hi SpecialChar    guifg=#d7ba7d
hi Tag            guifg=#569cd6
hi Delimiter      guifg=#d4d4d4
hi SpecialComment guifg=#666666
hi Debug          guifg=#f14c4c
hi Underlined     gui=underline
hi Error          guifg=#f14c4c guibg=NONE
hi Todo           guifg=#d7ba7d guibg=NONE gui=bold,italic

" === Diff ===
hi DiffAdd        guifg=#23d18b guibg=#2a2d2e
hi DiffChange     guifg=#f5f543 guibg=#2a2d2e
hi DiffDelete     guifg=#f14c4c guibg=#2a2d2e
hi DiffText       guifg=#29b8db guibg=#2a2d2e

" === Git Signs ===
hi GitGutterAdd          guifg=#23d18b
hi GitGutterChange       guifg=#f5f543
hi GitGutterDelete       guifg=#f14c4c
hi GitGutterChangeDelete guifg=#f5f543

" === Diagnostics ===
hi ErrorDiagnostic   guifg=#f14c4c guibg=NONE
hi WarnDiagnostic    guifg=#f5f543 guibg=NONE
hi InfoDiagnostic    guifg=#3b8eea guibg=NONE
hi HintDiagnostic    guifg=#29b8db guibg=NONE
