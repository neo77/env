function! Prompt() 
    let line = getline('.')
	execute "normal" "dd"
	lcd(line)
	call append(".",line.">")
	execute "normal" "G$a"
endfunction

function! ExecuteCommand()
    let promptline = getline('.')
	let cur_dir = system("pwd")
	let line = substitute(promptline,cur_dir.">",'','')
    let result = system(line.";echo;pwd")
    let nresult = substitute(result,'\%x00', '\r',"g")
    call append(".",nresult)
    return
endfunction


inoremap <CR>   <ESC>:call ExecuteCommand()<CR>G:s/\r/\r/g<CR>k:call Prompt()<CR>o
let cur_dir = system("pwd")
let ncur_dir = substitute(cur_dir,"\%00",'','g')
call append(".",ncur_dir.">")
execute "normal" "G$a"

