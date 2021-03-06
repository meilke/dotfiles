" vim: foldmethod=marker

" Cursor stack manipulation {{{1
"
" In order to make the pattern of saving the cursor and restoring it
" afterwards easier, these functions implement a simple cursor stack. The
" basic usage is:
"
"   call sideways#util#PushCursor()
"   " Do stuff that move the cursor around
"   call sideways#util#PopCursor()

" function! sideways#util#PushCursor() {{{2
"
" Adds the current cursor position to the cursor stack.
function! sideways#util#PushCursor()
  if !exists('b:cursor_position_stack')
    let b:cursor_position_stack = []
  endif

  call add(b:cursor_position_stack, getpos('.'))
endfunction

" function! sideways#util#PopCursor() {{{2
"
" Restores the cursor to the latest position in the cursor stack, as added
" from the sideways#util#PushCursor function. Removes the position from the stack.
function! sideways#util#PopCursor()
  if !exists('b:cursor_position_stack')
    let b:cursor_position_stack = []
  endif

  call setpos('.', remove(b:cursor_position_stack, -1))
endfunction

" function! sideways#util#DropCursor() {{{2
"
" Drops the last cursor location from the stack.
function! sideways#util#DropCursor()
  if !exists('b:cursor_position_stack')
    let b:cursor_position_stack = []
  endif

  call remove(b:cursor_position_stack, -1)
endfunction

" function! sideways#util#PeekCursor() {{{2
"
" Returns the last saved cursor position from the cursor stack.
" Note that if the cursor hasn't been saved at all, this will raise an error.
function! sideways#util#PeekCursor()
  return b:cursor_position_stack[-1]
endfunction

" Text replacement {{{1
"
" Vim doesn't seem to have a whole lot of functions to aid in text replacement
" within a buffer. The ":normal!" command usually works just fine, but it
" could be difficult to maintain sometimes. These functions encapsulate a few
" common patterns for this.

" function! sideways#util#ReplaceMotion(motion, text) {{{2
"
" Replace the normal mode "motion" with "text". This is mostly just a wrapper
" for a normal! command with a paste, but doesn't pollute any registers.
"
"   Examples:
"     call sideways#util#ReplaceMotion('Va{', 'some text')
"     call sideways#util#ReplaceMotion('V', 'replacement line')
"
" Note that the motion needs to include a visual mode key, like "V", "v" or
" "gv"
function! sideways#util#ReplaceMotion(motion, text)
  let original_selection = &selection
  let &selection = "inclusive"

  let original_reg      = getreg('z')
  let original_reg_type = getregtype('z')

  let @z = a:text
  exec 'normal! '.a:motion.'"zp'

  call setreg('z', original_reg, original_reg_type)
  let &selection = original_selection
endfunction

" function! sideways#util#ReplaceCols(line, start, end, text) {{{2
"
" Replace the area defined by the 'start' and 'end' columns on the given
" line with 'text'
function! sideways#util#ReplaceCols(line, start, end, text)
  let line_offset = line2byte(a:line)
  let start_byte  = line_offset + a:start - 1
  let end_byte    = line_offset + a:end - 1

  call sideways#util#ReplaceMotion(start_byte.'gov'.end_byte.'go', a:text)
  return 1
endfunction

" Text retrieval {{{1
"
" These functions are similar to the text replacement functions, only retrieve
" the text instead.

" function! sideways#util#GetMotion(motion) {{{2
"
" Execute the normal mode motion "motion" and return the text it marks.
"
" Note that the motion needs to include a visual mode key, like "V", "v" or
" "gv"
function! sideways#util#GetMotion(motion)
  call sideways#util#PushCursor()

  let original_selection = &selection
  let &selection = "inclusive"

  let original_reg      = getreg('z')
  let original_reg_type = getregtype('z')

  exec 'normal! '.a:motion.'"zy'
  let text = @z

  call setreg('z', original_reg, original_reg_type)
  let &selection = original_selection

  call sideways#util#PopCursor()

  return text
endfunction

" function! sideways#util#GetCols(line, start, end) {{{2
"
" Retrieve the text from columns "start" to "end" on the given line.
function! sideways#util#GetCols(line, start, end)
  return strpart(getline(a:line), a:start - 1, a:end - a:start + 1)
endfunction

" Positioning the cursor {{{1
"

" function! sideways#util#SetPos(line, col) {{{2
"
" Positions the cursor at the given column.
function! sideways#util#SetPos(line, col)
  let position = getpos('.')
  let position[1] = a:line
  let position[2] = a:col
  call setpos('.', position)
endfunction
