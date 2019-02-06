syn region pythonDocString start=+[uU]\=\z('''\|"""\)+ end="\z1" keepend contains=pythonEscape,pythonSpaceError,pythonDoctest,@Spell

hi def link pythonDocString		PreProc
