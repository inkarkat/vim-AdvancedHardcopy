ADVANCED HARDCOPY
===============================================================================
_by Ingo Karkat_

DESCRIPTION
------------------------------------------------------------------------------

This plugin ...

### SOURCE

- [:HardcopyWithoutClosedFolds is inspiration](http://stackoverflow.com/questions/27504394/how-to-print-hardcopy-with-folds-in-vim)

### SEE ALSO
(Plugins offering complementary functionality, or plugins using this library.)

### RELATED WORKS
(Alternatives from other authors, other approaches, references not used here.)

USAGE
------------------------------------------------------------------------------

    :Hardcopy               Extended version of :hardcopy that works around
                            certain Vim deficiencies.

    :[range]HardcopyWithGuiFont[!] [arguments]
                            Send [range] lines (default whole file) to the
                            printer, setting 'guifont' to 'printfont'.

    :[range]HardcopyWithoutClosedFolds[!] [arguments]
                            Send [range] lines (default whole file) that are not
                            folded away to the printer.

    :[range]HardcopyWithFoldtext[!] [arguments]
                            Send [range] lines (default whole file), with closed
                            folds represented by the single line's 'foldtext', to
                            the printer.

    :SetColorsForPrinting   Make some highlight groups darker for better
                            visibility in printouts.

INSTALLATION
------------------------------------------------------------------------------

The code is hosted in a Git repo at
    https://github.com/inkarkat/vim-AdvancedHardcopy
You can use your favorite plugin manager, or "git clone" into a directory used
for Vim packages. Releases are on the "stable" branch, the latest unstable
development snapshot on "master".

This script is also packaged as a vimball. If you have the "gunzip"
decompressor in your PATH, simply edit the \*.vmb.gz package in Vim; otherwise,
decompress the archive first, e.g. using WinZip. Inside Vim, install by
sourcing the vimball or via the :UseVimball command.

    vim AdvancedHardcopy*.vmb.gz
    :so %

To uninstall, use the :RmVimball command.

### DEPENDENCIES

- Requires Vim 7.0 or higher.

CONFIGURATION
------------------------------------------------------------------------------

For a permanent configuration, put the following commands into your vimrc:
configvar

plugmap
CONTRIBUTING
------------------------------------------------------------------------------

Report any bugs, send patches, or suggest features via the issue tracker at
https://github.com/inkarkat/vim-AdvancedHardcopy/issues or email (address
below).

HISTORY
------------------------------------------------------------------------------

##### GOAL
First published version.

##### 0.01    09-Mar-2011
- Started development.

------------------------------------------------------------------------------
Copyright: (C) 2011-2022 Ingo Karkat -
The [VIM LICENSE](http://vimdoc.sourceforge.net/htmldoc/uganda.html#license) applies to this plugin.

Maintainer:     Ingo Karkat &lt;ingo@karkat.de&gt;
