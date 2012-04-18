"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
"                   CommentFrame by bleopold <cometsong.net>                   "
"                      Public Domain, same license as Vim.                     "
"        see: http://vimdoc.sourceforge.net/htmldoc/uganda.html#license        "
"                                                                              "
" This is a simple plugin to generate fancy-looking comments/section dividers  "
" with centered titles and append them at the current cursor position.         "
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

"------------------------------------------------------------------------------"
"                  Functions, Commands of Multiple Lang Types                  "
"------------------------------------------------------------------------------"
function! _cmd_CommentCustom(edge, outer, inner, width, str)
	call _CommentFrame(a:edge, a:edge, a:width, a:outer, a:inner, '   ' . a:str . '   ')
endfunction
command! -nargs=+ CommentCustom :call _cmd_CommentCustom(<args>)

function! _cmd_CommentJava(str)
	call _CommentFrame('/* ', ' */', 80, '=', '=', '     ' . a:str . '     ')
endfunction
command! -nargs=+ CommentJava   :call _cmd_CommentC(<args>)

function! _cmd_CommentPlDashSpace(str)
	call _CommentFrame('#', '#', 80, '-', ' ', '     ' . a:str . '     ')
endfunction
command! -nargs=+ CommentPl     :call _cmd_CommentPlDashSpace(<args>)

function! _cmd_CommentPlEq(str)
	call _CommentFrame('# ', ' #', 80, '=', '-', '     ' . a:str . '     ')
endfunction
command! -nargs=+ CommentPlEq   :call _cmd_CommentPlEq(<args>)

function! _cmd_CommentVimBlock(str)
	call _CommentFrame('"', '"', 80, '-', ' ', '     ' . a:str . '     ')
endfunction
command! -nargs=+ CommentVim    :call _cmd_CommentVimBlock(<args>)

function! _cmd_CommentVimHeader(str)
	call _CommentFrame('"', '"', 80, '~', ' ', '     ' . a:str . '     ')
endfunction
command! -nargs=+ CommentVimHdr :call _cmd_CommentVimHeader(<args>)

