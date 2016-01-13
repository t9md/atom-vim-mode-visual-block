# vim-mode-visual-block

# **Not maintained**

I'm no longer maintaining this package.  
Use [vim-mode-plus](https://atom.io/packages/vim-mode-plus) instead it's have native visual-block-mode support.   

If you want to fix any bug for **this** package, fork it and I'm OK you to release forked version.  
Please don't ask me to fix this package.  

It might be better to unpublish this package?  
Please report issue if you have strong opinion for that.  

Thank's for using this my package.  

Note added at 2016.1.13

# What WAS this?

Add visual-block operation to [vim-mode](https://atom.io/packages/vim-mode).

![gif](https://raw.githubusercontent.com/t9md/t9md/375d45f661b76cd8fd874dbcacf93602e7d75c99/img/vim-mode-visual-blockwise.gif)


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
