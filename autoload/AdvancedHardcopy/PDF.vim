" AdvancedHardcopy/PDF.vim: Print to PDF instead to a printer.
"
" DEPENDENCIES:
"   - ingo-library.vim plugin
"
" Copyright: (C) 2023-2024 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>

function! AdvancedHardcopy#PDF#Command( range, command, ... ) abort
    let l:filename = expand('%:t:r')
    let l:pdfDirspec = ingo#plugin#setting#GetBufferLocal('AdvancedHardcopy_PDFdir')
    let l:pdfFilespec = empty(l:pdfDirspec)
    \   ? expand('%:r') . '.pdf'
    \   : ingo#fs#path#Combine(l:pdfDirspec, (empty(l:filename) ? 'unnamed' : l:filename) . '.pdf')

    let l:save_printexpr = &printexpr
    let &printexpr = printf('system(%s . " " . v:fname_in . " " . %s%s) . delete(v:fname_in) + v:shell_error',
    \   string(g:AdvancedHardcopy_PDFprinter),
    \   string(ingo#compat#shellescape(l:pdfFilespec)),
    \   (a:0 ? ' . " && " . ' . string(substitute(a:1, '%', ingo#compat#shellescape(l:pdfFilespec), 'g')) : '')
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
