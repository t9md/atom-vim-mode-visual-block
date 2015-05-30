_ = require 'underscore-plus'
{CompositeDisposable} = require 'atom'

module.exports =
  disposables: null

  activate: (state) ->
    @disposables = new CompositeDisposable
    @disposables.add atom.commands.add 'atom-text-editor',
      'vim-mode-visual-blockwise:j': (event) => @blockOperation(event, 'j')
      'vim-mode-visual-blockwise:k': (event) => @blockOperation(event, 'k')
      'vim-mode-visual-blockwise:h': (event) => @blockOperation(event, 'h')
      'vim-mode-visual-blockwise:l': (event) => @blockOperation(event, 'l')
      'vim-mode-visual-blockwise:D': (event) => @blockOperation(event, 'D')
      'vim-mode-visual-blockwise:o': (event) => @blockOperation(event, 'o')
      'vim-mode-visual-blockwise:I':         => @insertAt('first')
      'vim-mode-visual-blockwise:A':         => @insertAt('last')
      'vim-mode-visual-blockwise:escape': (event) => @escape(event)
      'vim-mode-visual-blockwise:debug':     => @debug()

  consumeVimMode: (@vimModeService) ->

  escape: (escape) ->
    @reset()
    console.log @active
    if @isVisualBlockMode()
      # [TODO] delete cursors except LastCursor()
      @getVimEditorState().activateCommandMode()
      @getVimEditorState().resetCommandMode()
    else
      event.abortKeyBinding()

  isActive: ->
    @active

  insertAt: (where) ->
    @reset()
    @getVimEditorState().activateInsertMode()
    for cursor in @getActiveTextEditor().getCursors()
      if where is 'first'
        cursor.moveToFirstCharacterOfLine()
      else if where is 'last'
        cursor.moveToEndOfLine()

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
