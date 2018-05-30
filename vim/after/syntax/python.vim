syn region pythonDocString
			\ start=+^\s*"""+ end=+"""+ keepend contains=pythonTodo

hi def link pythonDocString Statement
