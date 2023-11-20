" AdvancedHardcopy/PDF.vim: Print to PDF instead to a printer.
"
" DEPENDENCIES:
"   - ingo-library.vim plugin
"
" Copyright: (C) 2023 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>

function! AdvancedHardcopy#PDF#Command( range, command ) abort
    let l:save_printexpr = &printexpr
    let &printexpr = printf('system(%s . " " . v:fname_in . " " . %s) . delete(v:fname_in) + v:shell_error',
    \   string(g:AdvancedHardcopy_PDFprinter),
    \   string(ingo#compat#fnameescape(expand('%:r') . '.pdf'))
    \)

    let l:command = empty(a:command)
    \   ? (exists(':Hardcopy') == 2 ? 'Hardcopy' : 'hardcopy')
    \   : a:command
    try
	execute a:range . l:command
	return 1
    catch
	call ingo#err#SetVimException()
	return 0
    finally
	let &printexpr = l:save_printexpr
    endtry
endfunction

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
