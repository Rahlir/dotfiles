function! s:getGruvColor(group)
  let guiColor = synIDattr(hlID(a:group), "fg", "gui") 
  let termColor = synIDattr(hlID(a:group), "fg", "cterm") 
  return [ guiColor, termColor ]
endfunction

function! s:HL(group, fg, ...)
  " Arguments: group, guifg, guibg, gui, guisp

  " foreground
  let fg = a:fg

  " background
  if a:0 >= 1
    let bg = a:1
  else
    let bg = s:none
  endif

  " emphasis
  if a:0 >= 2 && strlen(a:2)
    let emstr = a:2
  else
    let emstr = 'NONE,'
  endif

  " special fallback
  if a:0 >= 3
    if g:gruvbox_guisp_fallback != 'NONE'
      let fg = a:3
    endif

    " bg fallback mode should invert higlighting
    if g:gruvbox_guisp_fallback == 'bg'
      let emstr .= 'inverse,'
    endif
  endif

  let histring = [ 'hi', a:group,
        \ 'guifg=' . fg[0], 'ctermfg=' . fg[1],
        \ 'guibg=' . bg[0], 'ctermbg=' . bg[1],
        \ 'gui=' . emstr[:-2], 'cterm=' . emstr[:-2]
        \ ]

  " special
  if a:0 >= 3
    call add(histring, 'guisp=' . a:3[0])
  endif

  execute join(histring, ' ')
endfunction

let s:none = ['NONE', 'NONE']
let s:bold = 'bold,'
let s:italic = 'italic,'
let s:underline = 'underline,'

let s:bg0  = s:getGruvColor('GruvboxBg0')
let s:bg1  = s:getGruvColor('GruvboxBg1')
let s:bg2  = s:getGruvColor('GruvboxBg2')
let s:bg4  = s:getGruvColor('GruvboxBg4')
let s:fg0  = s:getGruvColor('GruvboxFg0')
let s:fg1  = s:getGruvColor('GruvboxFg1')
let s:fg2  = s:getGruvColor('GruvboxFg2')
let s:fg3  = s:getGruvColor('GruvboxFg3')
let s:fg4  = s:getGruvColor('GruvboxFg4')

let s:yellow = s:getGruvColor('GruvboxYellow')
let s:blue   = s:getGruvColor('GruvboxBlue')
let s:aqua   = s:getGruvColor('GruvboxAqua')
let s:orange = s:getGruvColor('GruvboxOrange')
let s:green = s:getGruvColor('GruvboxGreen')
let s:purple = s:getGruvColor('GruvboxPurple')
let s:red = s:getGruvColor('GruvboxRed')

call s:HL('semshiLocal', s:yellow, s:none, s:italic)
call s:HL('semshiGlobal', s:yellow, s:none, s:bold)
call s:HL('semshiImported', s:orange, s:none, s:bold)
call s:HL('semshiParameter', s:blue)
call s:HL('semshiParameterUnused', s:aqua, s:none, s:underline)
call s:HL('semshiFree', s:fg3)
call s:HL('semshiBuiltin', s:purple, s:none, s:bold)
call s:HL('semshiAttribute', s:yellow)
call s:HL('semshiSelf', s:blue, s:none, s:bold)
call s:HL('semshiUnresolved', s:fg2, s:none, s:underline)
call s:HL('semshiSelected', s:fg1, s:bg4)

hi semshiErrorSign       ctermfg=231 guifg=#ffffff ctermbg=160 guibg=#d70000
call s:HL('semshiErrorSign', s:fg0, s:red)
call s:HL('semshiErrorChar', s:fg0, s:red)

