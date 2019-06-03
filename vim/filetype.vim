" Vim syntax highlight customizations
if exists("did_load_filetypes")
 finish
endif

augroup filetypedetect
 au! BufRead,BufNewFile in.*           setfiletype lammps
 au! BufRead,BufNewFile *.lmp          setfiletype lammps
 au! BufRead,BufNewFile *.lammps       setfiletype lammps
 au! BufRead,BufNewFile data.*         setfiletype lammps
 au! BufRead,BufNewFile *.vmd 				 setfiletype tcl
 au! BufRead,BufNewFile *.plist 			 setfiletype xml
 au! BufRead,BufNewFile *.ipy 				 setfiletype python
augroup END
