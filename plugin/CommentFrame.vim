"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
"                   CommentFrame by bleopold <cometsong.net>                   "
"                      Public Domain, same license as Vim.                     "
"        see: http://vimdoc.sourceforge.net/htmldoc/uganda.html#license        "
"                                                                              "
" This is a simple plugin to generate fancy-looking comments/section dividers  "
" with centered titles and append them at the current cursor position.         "
" Also: CommentRight => line of comment (customizable for diff langs) with     "
"       string arg put on right end of line.                                   "
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


"~~~~~~~~~~~~~~~~~~ Custom CommentFrame Function to be called by languages ~~~~~
function! _cmd_CommentFrameCustom(edge, outer, inner, width, spacing, str)
    call _CommentFrame(a:edge, a:edge, a:width, a:outer, a:inner, a:spacing . a:str . a:spacing)
endfunction
command! -nargs=+ CommentFrameCustom :call _cmd_CommentFrameCustom(<args>)
 noremap <Leader>cfc      :CommentFrameCustom '#','=','-','80','     ',''<Left>
inoremap <Leader>cfc <C-C>:CommentFrameCustom '#','=','-','80','     ',''<Left>


"------------------------------------------------------------------------------"
"                   Commands, Mappings of Multiple Lang Types                  "
"------------------------------------------------------------------------------"

"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Languages, CommentFrame ~~~~~
function! _cmd_CommentFrameSlashStar(str)
    call _CommentFrame('/*', '*/', 80, '*', ' ', a:str)
endfunction
command! -nargs=+ CommentFrameSlashStar   :call _cmd_CommentFrameSlashStar(<args>)
 noremap <Leader>cfs      :CommentFrameSlashStar ''<Left>
inoremap <Leader>cfs <C-C>:CommentFrameSlashStar ''<Left>

function! _cmd_CommentFrameHashDash(str)
    call _cmd_CommentFrameCustom('#', '-', ' ', 80, '     ', a:str)
endfunction
command! -nargs=+ CommentFrameHashDash  :call _cmd_CommentFrameHashDash(<args>)
 noremap <Leader>cfh      :CommentFrameHashDash ''<Left>
inoremap <Leader>cfh <C-C>:CommentFrameHashDash ''<Left>

function! _cmd_CommentFrameHashEqual(str)
    call _cmd_CommentFrameCustom('#', '=', '-', 80, '          ', a:str)
endfunction
command! -nargs=+ CommentFrameHashEqual   :call _cmd_CommentFrameHashEqual(<args>)
 noremap <Leader>cfH      :CommentFrameHashEqual ''<Left>
inoremap <Leader>cfH <C-C>:CommentFrameHashEqual ''<Left>

function! _cmd_CommentFrameQuoteDash(str)
    call _cmd_CommentFrameCustom('"', '-', ' ', 80, '     ', a:str)
endfunction
command! -nargs=+ CommentFrameQuoteDash    :call _cmd_CommentFrameQuoteDash(<args>)
 noremap <Leader>cfq      :CommentFrameQuoteDash ''<Left>
inoremap <Leader>cfq <C-C>:CommentFrameQuoteDash ''<Left>

function! _cmd_CommentQuoteTilde(str)
    call _cmd_CommentFrameCustom('"', '~', ' ', 80, '     ', a:str)
endfunction
command! -nargs=+ CommentQuoteTilde :call _cmd_CommentQuoteTilde(<args>)
 noremap <Leader>cfQ      :CommentQuoteTilde ''<Left>
inoremap <Leader>cfQ <C-C>:CommentQuoteTilde ''<Left>


"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Languages, CommentRight ~~~~~
function! _cmd_CommentRightHash(str)
    call _CommentRight('#', '', 80, 5, '~', a:str)
endfunction
command! -nargs=+ CommentRightHash :call _cmd_CommentRightHash(<args>)
 noremap <Leader>crh      :CommentRightHash ''<Left>
inoremap <Leader>crh <C-C>:CommentRightHash ''<Left>

function! _cmd_CommentRightSlashes(str)
    call _CommentRight('//', '', 80, 5, '~', a:str)
endfunction
command! -nargs=+ CommentRightSlashes :call _cmd_CommentRightSlashes(<args>)
 noremap <Leader>crs      :CommentRightSlashes ''<Left>
inoremap <Leader>crs <C-C>:CommentRightSlashes ''<Left>

function! _cmd_CommentRightQuote(str)
    call _CommentRight('"', '', 80, 5, '~', a:str)
endfunction
command! -nargs=+ CommentRightQuote :call _cmd_CommentRightQuote(<args>)
 noremap <Leader>crq      :CommentRightQuote ''<Left>
inoremap <Leader>crq <C-C>:CommentRightQuote ''<Left>

"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
