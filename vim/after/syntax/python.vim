syn region pythonDocString
			\ start=+^\s*"""+ end=+"""+ keepend

hi def link pythonDocString Comment
