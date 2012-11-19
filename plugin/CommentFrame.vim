"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~{{{"
"                                 CommentFrame!                                "
"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
"~~~~~~~~~~~~~~~~~~~~~~~~~~~~ by cometsong <benjamin at cometsong dot net> ~~~~~


"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
" This is a simple plugin to generate fancy-looking comments/section dividers  "
" with centered titles and append them at the current cursor position.         "
"                                                                              "
" Also CommentRight => line of comment (customizable for diff langs) with      "
"      string arg put on right end of line.                                    "
"                                                                              "
" To customize further, unmapping of default keysets can be done, plus         "
" creating any new combinations of frame types by using the CommentFrame       "
" Custom and CustomRight function in your vimrc.
"                                                                              "
"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}}}"

"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~{{{"
"   from: makesd/makecsd by Chase Venters <chase.venters@chaseventers.com>     "
"         http://www.vim.org/scripts/script.php?script_id=3253                 "
"                                                                              "
"                      Public Domain, same license as Vim.                     "
"        see: http://vimdoc.sourceforge.net/htmldoc/uganda.html#license        "
"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}}}"


"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
"                          CommentFrame function                            {{{"
"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
" Syntax: CommentFrame(comment char to start line,
"            comment char to end the line,
"            width of line,
"            character to fill space in frame border (e.g. '*', '-', '=', ' '),
"            character to fill space in title line,
"            number of spaces to leave around title string
"            title string in center of line)
function! s:CommentFrame(start_str, end_str, line_width, frame_fill, title_fill, spacing, titlestring)
  " check and mod arg vars
  let l:title_fill = s:CheckNotEmpty(' ', a:title_fill)
  let l:frame_fill = s:CheckNotEmpty(' ', a:frame_fill)

  " prepend/append spacing
  let l:titlestr = repeat(' ', a:spacing) . a:titlestring . repeat(' ', a:spacing)

  " combine and count
	let l:middle_length=a:line_width - len(a:start_str . a:end_str)
	let l:title_left_length=((l:middle_length / 2) - (len(l:titlestr) / 2))
  let l:title_left = repeat(l:title_fill, l:title_left_length)
	let l:title_right_length=l:middle_length - len(l:title_left) - len(l:titlestr)
  let l:title_right = repeat(l:title_fill, l:title_right_length)
  
  " build border lines
	let l:border=a:start_str . repeat(l:frame_fill, l:middle_length) . a:end_str
  " build title_line
	let l:title_line=a:start_str . l:title_left . l:titlestr . l:title_right . a:end_str

  " add comment lines to doc
	call append(line('.'), l:border)
	call append(line('.'), l:title_line)
	call append(line('.'), l:border)
endfunction
"}}}

"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
"                          CommentRight function                            {{{"
"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
" Syntax: CommentRight(comment char to start line,
"            comment char to end the line,
"            width of line,
"            width of right end of line (after title),
"            character to fill space (e.g. '*', '-', '=', ' '),
"            number of spaces to leave around title string
"            title string on right side of line)
function! s:CommentRight(start_str, end_str, line_width, right_width, title_fill, spacing, titlestring)
  " check and mod arg vars
  let l:title_fill = s:CheckNotEmpty(' ', a:title_fill)

  " prepend/append spacing
  let l:titlestr = repeat(' ', a:spacing) . a:titlestring . repeat(' ', a:spacing)

  " combine and count
  let l:middle_length=a:line_width - len(a:start_str . a:end_str)
  let l:title_right_length=a:right_width
  let l:title_right = repeat(l:title_fill, l:title_right_length)
  let l:title_left_length=(l:middle_length - len(l:titlestr) - l:title_right_length)
  let l:title_left = repeat(l:title_fill, l:title_left_length)

  " build title_line
	let title_line=a:start_str . l:title_left . l:titlestr . l:title_right . a:end_str

  " add comment lines to doc
  call append(line('.'), l:title_line)
endfunction
"}}}

"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ CheckNotEmpty function   {{{ ~~~~~
function! s:CheckNotEmpty(default_val, arg_val)
  if a:arg_val != ''
    return a:arg_val
  else
    return a:default_val
  endif
endfunction
"}}}

"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ MapKeys function   {{{ ~~~~~
function! s:MapKeys(modes, keys, target)
  " Build up a map command like
  " 'inoremap <Leader>keys target'
  let s:map_start = 'noremap <Leader>'
  for mode in (a:modes == '') ? [''] : split(a:modes, '\zs')
    if mode == 'i'
      let s:target = '<C-C>' . a:target . ' a'
    else
      let s:target = a:target
    endif
    if strlen(a:keys)
      execute mode . s:map_start . a:keys  . ' ' . s:target
    endif
  endfor
endfunction
" usage:  call MapKeys('nvi', 'do', 'doStuff')
"}}}



"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
"                               General Use Setup                           {{{"
"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Custom Comment Functions {{{ ~~~~~
function! CommentFrame#Custom(start_str, end_str, line_width, 
                     \frame_fill, title_fill, numspaces, titlestring)
  call s:CommentFrame(a:start_str, a:end_str, a:line_width, 
                     \a:frame_fill, a:title_fill, a:numspaces, a:titlestring)
endfunction

function! CommentFrame#CustomRight(start_str, end_str, line_width,
                     \right_width, title_fill, numspaces, titlestring)
  call s:CommentRight(a:start_str, a:end_str, a:line_width, a:right_width, 
                     \a:title_fill, a:numspaces, a:titlestring)
endfunction
"}}}

"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Commands, Mappings of Custom Functions {{{ ~~~~~
command! -nargs=+ CommentFrameCustom :call CommentFrame#Custom(<args>)
call MapKeys("ni", "cfc", ":CommentFrameCustom '#','#',80,'=','-',3,''<Left>")

command! -nargs=+ CommentRightCustom :call CommentFrame#CustomRight(<args>)
call MapKeys("ni", "crc", ":CommentRightCustom '#','',80,5,'~',1,''<Left>")

"}}}

"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Languages, CommentFrame {{{ ~~~~~
command! -nargs=+ CommentFrameSlashes     : call CommentFrame#Custom('//', '//', 80, '*', ' ', 0, <args>)
call MapKeys('ni', 'cfs', ':CommentFrameSlashes ""<Left>')

command! -nargs=+ CommentFrameSlashStar   : call CommentFrame#Custom('/*', '*/', 80, '*', ' ', 0, <args>)
call MapKeys('ni', 'cfS', ':CommentFrameSlashStar ""<Left>')

command! -nargs=+ CommentFrameHashDash    : call CommentFrame#Custom('#', '#', 80, '-', ' ', 0, <args>)
call MapKeys('ni', 'cfh', ':CommentFrameHashDash ""<Left>')

command! -nargs=+ CommentFrameHashEqual   : call CommentFrame#Custom('#', '#', 80, '=', '-', 5, <args>)
call MapKeys('ni', 'cfH', ':CommentFrameHashEqual ""<Left>')

command! -nargs=+ CommentFrameQuoteDash   : call CommentFrame#Custom('"', '"', 80, '-', ' ', 5, <args>)
call MapKeys('ni', 'cfq', ':CommentFrameQuoteDash ""<Left>')

command! -nargs=+ CommentFrameQuoteTilde  : call CommentFrame#Custom('"', '"', 80, '~', ' ', 5, <args>)
call MapKeys('ni', 'cfQ', ':CommentFrameQuoteTilde ""<Left>')

"}}}

"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Languages, CommentRight {{{ ~~~~~
command! -nargs=+ CommentRightHash      : call CommentFrame#CustomRight('#', '', 80, 5, '~', 1, <args>)
call MapKeys('ni', 'crh', ':CommentRightHash ""<Left>')

command! -nargs=+ CommentRightSlashes   : call CommentFrame#CustomRight('//', '', 80, 5, '~', 1, <args>)
call MapKeys('ni', 'crs', ':CommentRightSlashes ""<Left>')

command! -nargs=+ CommentRightSlashStar : call CommentFrame#CustomRight('/*', '*/', 80, 5, '~', 1, <args>)
call MapKeys('ni', 'crS', ':CommentRightSlashStar ""<Left>')

command! -nargs=+ CommentRightQuote     : call CommentFrame#CustomRight('"', '', 80, 5, '~', 1, <args>)
call MapKeys('ni', 'crq', ':CommentRightQuote ""<Left>')

"}}}

"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Plugin Menu Creation {{{ ~~~~~
amenu .170.1 &Plugin.Comment&Frames.Frame\ &Custom<Tab>cfc          <Leader>cfc
amenu .170.1 &Plugin.Comment&Frames.Frame\ &HashDash<Tab>cfh        <Leader>cfh
amenu .170.1 &Plugin.Comment&Frames.Frame\ Hash&Equal<Tab>cfH       <Leader>cfH
amenu .170.1 &Plugin.Comment&Frames.Frame\ &Slashes<Tab>cfs         <Leader>cfs
amenu .170.1 &Plugin.Comment&Frames.Frame\ &Slash\ Star<Tab>cfs     <Leader>cfS
amenu .170.1 &Plugin.Comment&Frames.Frame\ &QuoteDash<Tab>cfq       <Leader>cfq
amenu .170.1 &Plugin.Comment&Frames.Frame\ Quote&Tilde<Tab>cfQ      <Leader>cfQ
amenu .170.1 &Plugin.Comment&Frames.-Rights- :
amenu .170.1 &Plugin.Comment&Frames.Right\ &Custom<Tab>crc          <Leader>crc
amenu .170.1 &Plugin.Comment&Frames.Right\ &Hash<Tab>crh            <Leader>crh
amenu .170.1 &Plugin.Comment&Frames.Right\ &Slashes<Tab>crs         <Leader>crs
amenu .170.1 &Plugin.Comment&Frames.Right\ &Slash\ Stars<Tab>crS    <Leader>crS
amenu .170.1 &Plugin.Comment&Frames.Right\ &Quote<Tab>crq           <Leader>crq
"}}}
"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}}}
