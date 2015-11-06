# vim-mode-visual-block

Add visual-block operation to [vim-mode](https://atom.io/packages/vim-mode).

![gif](https://raw.githubusercontent.com/t9md/t9md/375d45f661b76cd8fd874dbcacf93602e7d75c99/img/vim-mode-visual-blockwise.gif)

# What's this?

**Temporarily** workaround, until vim-mode support visual block mode natively.
I'm not intended to complete solution.

# NOTE

Added 2015.11.06

Since I started yet another vim-mode project as [vim-mode-plus](https://atom.io/packages/vim-mode-plus) which have built-in visula-block-mode, I no longer use vim-mode and offcourse this package.  

If you found any issue on this packages, I'm OK you to fork , fix and release as different package(or I might can transfer ownership of this project).

# Keymap

From version 0.2.5, starting to provide [default keymap](https://github.com/t9md/atom-vim-mode-visual-block/blob/master/keymaps/vim-mode-visual-block.cson).  

For older version user
* Remove explicit keymap from `keymap.cson` and use default keymap.

# Limitation
- Count not supported.
- Currently yank and paste for block range is not supported.
- No support for non-contiguous multi selection.

# Todo
* [x] Precise state check when escape from visual-block.
* [x] Support other insert-mode initiator like `a`, `i`, `C`.
* [ ] Yank and paste support.
* [ ] Concatenate undo transaction?.
