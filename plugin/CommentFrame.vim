"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
"                   CommentFrame by bleopold <cometsong.net>                   "
"                      Public Domain, same license as Vim.                     "
"        see: http://vimdoc.sourceforge.net/htmldoc/uganda.html#license        "
"                                                                              "
" This is a simple plugin to generate fancy-looking comments/section dividers  "
" with centered titles and append them at the current cursor position.         "
" Also: CommentRight => line of comment (customizable for diff langs) with     "
"       string arg put on right end of line.
"                                                                              "
"   from: makesd/makecsd by Chase Venters <chase.venters@chaseventers.com>     "
"         http://www.vim.org/scripts/script.php?script_id=3253                 "
"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"

function! _CommentFrame(start_line, end_line, line_width, linechar, titlelinechar, str)
	let middle_sz=a:line_width - len(a:start_line . a:end_line)
	let mkr=a:start_line . repeat(a:linechar, middle_sz) . a:end_line
	let slen=len(a:str)
	let title_left_sz=((middle_sz / 2) - (slen / 2))
	let title_line=a:start_line . repeat(a:titlelinechar, title_left_sz) . a:str
	let title_right_sz=a:line_width - len(title_line) - len(a:end_line)
	let title_line=title_line . repeat(a:titlelinechar,title_right_sz) . a:end_line

	call append(line('.'), mkr)
	call append(line('.'), title_line)
	call append(line('.'), mkr)
endfunction

function! _CommentRight(start_line, end_line, line_width, right_width, titlelinechar, str)
       let middle_sz=a:line_width - len(a:start_line . a:end_line)
       let slen=len(a:str)
       let title_right_sz=a:right_width
       let title_left_sz=(middle_sz - slen - title_right_sz - 2)
       let title_line=a:start_line . repeat(a:titlelinechar, title_left_sz) 
    let title_line=title_line .' '. a:str .' '
       let title_line=title_line . repeat(a:titlelinechar,title_right_sz) . a:end_line

       call append(line('.'), title_line)
endfunction


"------------------------------------------------------------------------------"
"                   Commands, Mappings of Multiple Lang Types                  "
"------------------------------------------------------------------------------"

"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ CommentFrame ~~~~~
function! _cmd_CommentCustom(edge, outer, inner, width, str)
       call _CommentFrame(a:edge, a:edge, a:width, a:outer, a:inner, '   ' . a:str . '   ')
endfunction
command! -nargs=+ CommentCustom :call _cmd_CommentCustom(<args>)
 noremap <Leader>cfc      :CommentCustom '#','=','-','80',''<Left>
inoremap <Leader>cfc <C-C>:CommentCustom '#','=','-','80',''<Left>

function! _cmd_CommentJava(str)
       call _CommentFrame('/* ', ' */', 80, '=', '=', '     ' . a:str . '     ')
endfunction
command! -nargs=+ CommentJava   :call _cmd_CommentC(<args>)
 noremap <Leader>cfj      :CommentJava ''<Left>
inoremap <Leader>cfj <C-C>:CommentJava ''<Left>

function! _cmd_CommentPerlDashSpace(str)
       call _CommentFrame('#', '#', 80, '-', ' ', '     ' . a:str . '     ')
endfunction
command! -nargs=+ CommentPerl     :call _cmd_CommentPlDashSpace(<args>)
 noremap <Leader>cfp      :CommentPerl ''<Left>
inoremap <Leader>cfp <C-C>:CommentPerl ''<Left>

function! _cmd_CommentPerlEq(str)
       call _CommentFrame('# ', ' #', 80, '=', '-', '     ' . a:str . '     ')
endfunction
command! -nargs=+ CommentPerlEq   :call _cmd_CommentPlEq(<args>)
 noremap <Leader>cfe      :CommentPlEq ''<Left>
inoremap <Leader>cfe <C-C>:CommentPlEq ''<Left>

function! _cmd_CommentVimBlock(str)
       call _CommentFrame('"', '"', 80, '-', ' ', '     ' . a:str . '     ')
endfunction
command! -nargs=+ CommentVim    :call _cmd_CommentVimBlock(<args>)
 noremap <Leader>cfv      :CommentVim ''<Left>
inoremap <Leader>cfv <C-C>:CommentVim ''<Left>

function! _cmd_CommentVimHeader(str)
       call _CommentFrame('"', '"', 80, '~', ' ', '     ' . a:str . '     ')
endfunction
command! -nargs=+ CommentVimHdr :call _cmd_CommentVimHeader(<args>)
 noremap <Leader>cfV      :CommentVimHeader ''<Left>
inoremap <Leader>cfV <C-C>:CommentVimHeader ''<Left>


"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ CommentRight ~~~~~
function! _cmd_CommentRightPerl(str)
       call _CommentRight('#', '', 80, 5, '~', a:str)
endfunction
command! -nargs=+ CommentRightPerl :call _cmd_CommentRightPerl(<args>)
 noremap <Leader>crp      :CommentRightPerl ''<Left>
inoremap <Leader>crp <C-C>:CommentRightPerl ''<Left>

function! _cmd_CommentRightJava(str)
       call _CommentRight('//', '', 80, 5, '~', a:str)
endfunction
command! -nargs=+ CommentRightJava :call _cmd_CommentRightJava(<args>)
 noremap <Leader>crj      :CommentRightJava ''<Left>
inoremap <Leader>crj <C-C>:CommentRightJava ''<Left>

function! _cmd_CommentRightVim(str)
       call _CommentRight('"', '', 80, 5, '~', a:str)
endfunction
command! -nargs=+ CommentRightVim :call _cmd_CommentRightVim(<args>)
 noremap <Leader>crv      :CommentRightVim ''<Left>
inoremap <Leader>crv <C-C>:CommentRightVim ''<Left>

