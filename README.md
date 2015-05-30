# vim-mode-visual-blockwise

Add visual-blockwise operation to [vim-mode](https://atom.io/packages/vim-mode).

![gif](https://raw.githubusercontent.com/t9md/t9md/97168c5fdbfd311eb3a7d0b9d22bb0d761ea7d74/img/vim-mode-visual-blockwise.gif)

# Development state
Alpha

# Purpose of this package

**Temporarily** workaround, until vim-mode support visual block mode.  
I'm not intended to complete solution.

# Keymap
No keymap by default.

Configure following keymap to your `keymap.cson`.

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
  'ctrl-v': 'vim-mode:activate-blockwise-visual-mode'
```

# Caution
Since vim-mode currently not implement visual-block mode and vim-mode's native `j`, `l` reset `blockwise`(@submode) to normal `visual` mode, I need to track blockwise @active state explicitly.  

So always use `vim-mode-visual-blockwise:escape` to escape from visual block mode for precise tracking of visual-block mode by setting appropriate keymap.

# Todo
* [ ] Precise state check when escape from visual-block.
* [ ] Support other insert-mode initiator like `a`, `i`, `C`.
* [ ] Concatenate undo transaction.
