# vim-mode-visual-blockwise

Add visual-blockwise operation to [vim-mode](https://atom.io/packages/vim-mode).

# Development state
Alpha

# Purpose of this package

**Temporarily** workaround, until vim-mode support visual block mode.  
I'm not intended to complete solution.

# Keymap
No keymap by default.

```coffeescript
'atom-text-editor.vim-mode.visual-mode':
  'j':      'vim-mode-visual-blockwise:j'
  'k':      'vim-mode-visual-blockwise:k'
  'h':      'vim-mode-visual-blockwise:h'
  'l':      'vim-mode-visual-blockwise:l'
  'I':      'vim-mode-visual-blockwise:I'
  'A':      'vim-mode-visual-blockwise:A'
  'D':      'vim-mode-visual-blockwise:D'
  'o':      'vim-mode-visual-blockwise:o'
  'escape': 'vim-mode-visual-blockwise:escape'
  'ctrl-[': 'vim-mode-visual-blockwise:escape'
  'ctrl-c': 'vim-mode-visual-blockwise:escape'
```

# Todo
[ ] Precise state check when escape from visual-block.
[ ] Support other insert-mode initiator like `a`, `i`.
[ ] Concatenate undo transaction.
