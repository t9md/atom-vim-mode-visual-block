_ = require 'underscore-plus'
{CompositeDisposable} = require 'atom'

module.exports =
  disposables: null
  active:      false

  activate: (state) ->
    @disposables = new CompositeDisposable
    @disposables.add atom.commands.add 'atom-text-editor',
      'vim-mode-visual-block:j': (event) => @blockOperation(event, 'j')
      'vim-mode-visual-block:k': (event) => @blockOperation(event, 'k')
      'vim-mode-visual-block:h': (event) => @blockOperation(event, 'h')
      'vim-mode-visual-block:l': (event) => @blockOperation(event, 'l')
      'vim-mode-visual-block:D': (event) => @blockOperation(event, 'D')
      'vim-mode-visual-block:o': (event) => @blockOperation(event, 'o')
      'vim-mode-visual-block:I':         => @startInsertAt('first')
      'vim-mode-visual-block:A':         => @startInsertAt('last')
      'vim-mode-visual-block:escape': (event) => @escape(event)
      'vim-mode-visual-block:debug':     => @debug()

  consumeVimMode: (@vimModeService) ->

  escape: (escape) ->
    @reset()
    if @isVisualBlockMode()
      @getVimEditorState().activateCommandMode()
      @getVimEditorState().resetCommandMode()
    else
      event.abortKeyBinding()

  isActive: ->
    @active

  startInsertAt: (where) ->
    @reset()
    @getVimEditorState().activateInsertMode()
    for cursor in @getActiveTextEditor().getCursors()
      if where is 'first'
        @getVimEditorState().activateInsertMode()
        # cursor.moveToFirstCharacterOfLine()
      else if where is 'last'
        # cursor.moveToEndOfLine()

  getActiveTextEditor: ->
    atom.workspace.getActiveTextEditor()

  getVimEditorState: ->
    editor = @getActiveTextEditor()
    @vimModeService.getEditorState(editor)

  debug: ->
    console.log @active
    editor = atom.workspace.getActiveTextEditor()
    state = @vimModeService.getEditorState(editor)
    console.log state

  isVisualBlockMode: ->
    {mode, submode} = @getVimEditorState()
    (mode is 'visual') and (submode is 'blockwise')

  reset: ->
    @active = false
    @startRow = null

  blockOperation: (event, direction) ->
    editor = @getActiveTextEditor()
    if @isVisualBlockMode() or @isActive()
      @active = true
      @startRow ?= editor.getLastCursor()?.getBufferRow()
      currentRow = editor.getLastCursor()?.getBufferRow()

      switch direction
        when 'j'
          if currentRow < @startRow
            editor.getLastCursor().destroy()
          else
            editor.addSelectionBelow()
        when 'k'
          if currentRow > @startRow
            editor.getLastCursor().destroy()
          else
            editor.addSelectionAbove()
        when 'D'
          @reset()
          @getVimEditorState().activateCommandMode()
          event.abortKeyBinding()
        when 'o'
          # [FIXME] quick&dirty implementation.
          @startRow = currentRow
        else
          event.abortKeyBinding()
    else
      event.abortKeyBinding()

  deactivate: ->
    @disposables.dispose()
