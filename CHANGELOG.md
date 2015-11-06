## 0.2.14 - Add note to README
- Put link to vim-mode-plus.

## 0.2.13 - Revert
- Completely remove `activationCommands`.

## 0.2.12 - Improve
- Now activated by `vim-mode:activate-blockwise-visual-mode`.
- Delete deprecated keymap notification.

## 0.2.11 - Quick FIX for #3
- Disable activationCommands to avoid `getEditorState` throw error because of `@vimModeService` is undefined.

## 0.2.10

## 0.2.9 - Follow renaming to NormalMode
- Use `activateNormalMode` instead of `activateCommandMode`.

## 0.2.8 - Improve
* Refactoring.
* `activationCommands`.

## 0.2.7 - Improve
* `ctrl-v` within visual-block now work same as escape. #1

## 0.2.6 - Fix Typo
* Fix README.md typo.

## 0.2.5 - Improve
* Add provide default keymap.
* No longer use `vimState.resetCommandMode()`.
* No longer manage explicit @active state.
* Improve resetting @startRow.
* [FIX] selection range got wrong in some case.

## 0.2.4 - Stability improve
* Never accidentally destroy(), last cursor()

## 0.2.3 - GIF update.
## 0.2.2 - Improve `I`, `A` further
## 0.2.1 - Improve `I`, `A`.
## 0.2.0 - Rename Package name
## 0.1.1 - Doc update.
## 0.1.0 - First Release
