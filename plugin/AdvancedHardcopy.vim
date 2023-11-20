" AdvancedHardcopy.vim: Make hardcopies with more power.
"
" DEPENDENCIES:
"   - ingo-library.vim plugin
"
" Copyright: (C) 2011-2023 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>

" Avoid installing twice or when in unsupported Vim version.
if exists('g:loaded_AdvancedHardcopy') || (v:version < 700)
    finish
endif
let g:loaded_AdvancedHardcopy = 1
let s:save_cpo = &cpo
set cpo&vim

"- configuration ---------------------------------------------------------------

if ! exists('g:AdvancedHardcopy_PDFprinter')
    let g:AdvancedHardcopy_PDFprinter = executable('ps2pdf') ? 'ps2pdf' : ''
endif


"- commands --------------------------------------------------------------------

command! -bar -bang -nargs=? -range=% Hardcopy if ! AdvancedHardcopy#Hardcopy(<line1>, <line2>, <q-bang>, <q-args>) | echoerr ingo#err#Get() | endif

command! -bar -bang -nargs=? -range=% HardcopyWithGuiFont
\   let save_printfont = &printfont|
\   let &printfont = &guifont|
\       execute '<line1>,<line2>' . (exists(':Hardcopy') == 2 ? 'Hardcopy' : 'hardcopy') . '<bang>' <q-args>|
\   let &printfont = save_printfont|
\   unlet save_printfont

command! -bar -bang -nargs=? -range=% HardcopyWithoutClosedFolds if ! AdvancedHardcopy#Modified('DeleteClosedFolds', <line1>, <line2>, <q-bang>, <q-args>) | echoerr ingo#err#Get() | endif
command! -bar -bang -nargs=? -range=% HardcopyWithFoldtext if ! AdvancedHardcopy#Modified('RenderClosedFolds', <line1>, <line2>, <q-bang>, <q-args>) | echoerr ingo#err#Get() | endif



command! -bar SetColorsForPrinting call AdvancedHardcopy#SetColorsForPrinting()

if ! empty(g:AdvancedHardcopy_PDFprinter)
    command! -bar -nargs=* -complete=command -range=% PDF if ! AdvancedHardcopy#PDF#Command('<line1>,<line2>', <q-args>) | echoerr ingo#err#Get() | endif
endif

let &cpo = s:save_cpo
unlet s:save_cpo
" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
