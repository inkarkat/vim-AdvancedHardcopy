" AdvancedHardcopy.vim: Make hardcopies with more power.
"
" DEPENDENCIES:
"   - ingo/compat.vim autoload script
"   - ingo/err.vim autoload script
"   - ingo/folds/persistence.vim autoload script
"   - ingo/fs/tempfile.vim autoload script
"   - ingo/os.vim autoload script
"   - ingo/range.vim autoload script
"   - ingoenv.vim autoload script
"
" Copyright: (C) 2011-2017 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"	001	01-Nov-2017	file creation from ingocommands.vim

function! AdvancedHardcopy#Hardcopy( firstLnum, lastLnum, bang, arguments )
    try
	if ingo#os#IsWindows() && ! ingoenv#BufferAsciiCheck() && &encoding ==# 'utf-8'
	    " XXX: Vim can only correctly print non-ASCII characters when the
	    " global 'encoding' is identical to the file's.
	    let l:choice = confirm("Need to :set encoding=latin1 to correctly print non-ASCII characters.", "&Yes\n&No\n&Cancel")
	    if l:choice == 1
		if &l:modified
		    if filereadable(expand('%'))
			call ingo#err#Set("The buffer needs to be written and reloaded to apply the change of 'encoding'.")
			return 0
		    else
			" This buffer hasn't yet been persisted; it's probably
			" not meant to (a scratch buffer). DWIM and save
			" temporarily (with the same name) in a temp location.
			let l:filename = expand('%:t')
			let l:filename = (empty(l:filename) ? 'untitled' : l:filename)
			let l:tempFilespec = ingo#fs#tempfile#Make(l:filename)
			execute 'keepalt saveas!' ingo#compat#fnameescape(l:tempFilespec)
		    endif
		endif

		set encoding=latin1
		" Reload the current buffer so that the characters show up
		" correctly again.
		execute 'edit! +setlocal\ filetype=' . &l:filetype
	    elseif l:choice == 2
		" Do nothing.
	    else
		return 0
	    endif
	endif
	if has('unix') && ! has('gui_running') && &t_Co > 16
	    " XXX: Work around the |todo.txt| item
	    " "Using the cterm_color[] table is wrong when t_colors is > 16."
	    let l:choice = confirm("Need to reduce the color depth to 16 to print the correct (limited) colors. (For full colors, print from GVIM.)", "&Yes\n&No\n&Cancel")
	    if l:choice == 1
		set t_Co=16
		" To set the correct colors, the current colorscheme must
		" be reloaded. Account for a possible static CSApprox.vim
		" translation of the colorscheme; the original must be reloaded;
		" only it has the low-color cterm settings!
		execute 'colorscheme' substitute(g:colors_name, '-cterm$', '', '')
	    elseif l:choice == 2
		" Do nothing.
	    else
		return 0
	    endif
	endif

	execute printf('%d,%dhardcopy%s %s', a:firstLnum, a:lastLnum, a:bang, a:arguments)
	return 1
    catch /^Vim\%((\a\+)\)\=:/
	call ingo#err#SetVimException()
	return 0
    finally
	if exists('l:tempFilespec')
	    call delete(l:tempFilespec)
	endif
    endtry
endfunction



function! AdvancedHardcopy#Modified( modifyCommand, startLnum, endLnum, bang, arguments )
    let [l:startLnum, l:endLnum] = [ingo#range#NetStart(a:startLnum), ingo#range#NetEnd(a:endLnum)]

    let l:foldsHandle = ingo#folds#persistence#SaveManualFolds()
    let l:save_foldenable = &l:foldenable | setlocal nofoldenable
    let l:save_foldmethod = &l:foldmethod | setlocal foldmethod=manual  " Avoid time-consuming and potentially disrupting recalculation of folds.
    let l:save_modifiable = &l:modifiable | setlocal modifiable

    try
	let l:lineNum = line('$')
	execute printf('%d,%d%s', l:startLnum, l:endLnum, a:modifyCommand)
	let l:deletedLineNum = l:lineNum - line('$')
	let l:endLnum -= l:deletedLineNum
	execute printf('%d,%d%s%s',
	\   l:startLnum, l:endLnum,
	\   (exists(':Hardcopy') == 2 ? 'Hardcopy' : 'hardcopy'), a:bang
	\) a:arguments
	return 1
    catch /^Vim\%((\a\+)\)\=:/
	call ingo#err#SetVimException()
	return 0
    finally
	silent undo
	let &l:foldenable = l:save_foldenable
	let &l:foldmethod = l:save_foldmethod
	call ingo#folds#persistence#RestoreManualFolds(l:foldsHandle)
	let &l:modifiable = l:save_modifiable
    endtry
endfunction



function! AdvancedHardcopy#SetColorsForPrinting()
    highlight Constant   guifg=black
    highlight Special    guifg=black
    highlight Identifier guifg=black
    highlight Statement  guifg=black
    highlight PreProc    guifg=black
    highlight Type       guifg=black
    highlight Underlined guifg=black
    highlight Number     guifg=black
endfunction

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
