# vim-mode-visual-block

Add visual-block operation to [vim-mode](https://atom.io/packages/vim-mode).

![gif](https://raw.githubusercontent.com/t9md/t9md/375d45f661b76cd8fd874dbcacf93602e7d75c99/img/vim-mode-visual-blockwise.gif)

# What's this?

**Temporarily** workaround, until vim-mode support visual block mode natively.
I'm not intended to complete solution.

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
