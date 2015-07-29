_ = require 'underscore-plus'
{CompositeDisposable} = require 'atom'

Config =
  debug:
    type: 'boolean'
    default: false

module.exports =
  disposables: null
  active:      false
  prefix:      'vim-mode-visual-block'

  activate: (state) ->
    @disposables = new CompositeDisposable
    blockwiseCommands = {}
    commands = 'jkoDCIA'.split('')
    commands.push 'escape', 'ctrl-v'
    for command in commands
      do (command) =>
        name = "#{@prefix}:#{command}"
        blockwiseCommands[name] = (event) => @blockOperation(event, command)

    # blockwiseCommands["#{@prefix}:toggle-debug"] = => @toggleDebug()
    @disposables.add atom.commands.add('atom-text-editor', blockwiseCommands)
    @reset()

  deactivate: ->
    @disposables.dispose()

  consumeVimMode: (@vimModeService) ->

  reset: ->
    @startRow = null

  getEditor: ->
    atom.workspace.getActiveTextEditor()

  isVisualBlockMode: (vimState) ->
    (vimState.mode is 'visual') and (vimState.submode is 'blockwise')

  getVimEditorState: (editor) ->
    @vimModeService.getEditorState editor

  adjustSelections: (editor, options) ->
    for selection in editor.getSelections()
      range = selection.getBufferRange()
      selection.setBufferRange range, options

  blockOperation: (event, command) ->
    editor   = @getEditor()
    vimState = @getVimEditorState editor

    unless @isVisualBlockMode vimState
      event.abortKeyBinding()
      @reset()
      return

    # May be non-continuous execution.
    if editor.getCursors().length is 1
      @reset()

    currentRow  = editor.getLastCursor()?.getBufferRow()
    @startRow  ?= currentRow

    switch command
      when 'o'
        @startRow = currentRow
      when 'D', 'C'
        vimState.activateNormalMode()
        event.abortKeyBinding()
      when 'escape', 'ctrl-v'
        vimState.activateNormalMode()
        editor.clearSelections()
      when 'j', 'k'
        cursors      = editor.getCursorsOrderedByBufferPosition()
        cursorTop    = _.first cursors
        cursorBottom = _.last cursors

        if (command is 'j' and cursorTop.getBufferRow() >= @startRow) or
            (command is 'k' and cursorBottom.getBufferRow() <= @startRow)
          lastSelection = editor.getLastSelection()

          if command is 'j'
            editor.addSelectionBelow()
          else
            editor.addSelectionAbove()

          # [FIXME]
          # When addSelectionAbove(), addSelectionBelow() doesn't respect
          # reversed stated, need improved.
          #
          # and one more..
          #
          # When selection is NOT empty and add selection by addSelectionAbove()
          # and then move right, selection range got wrong, maybe this is bug..
          @adjustSelections editor, reversed: lastSelection.isReversed()
        else
          # [FIXME]
          # Guard to not destroying last cursor
          # This guard is no longer needed
          # Remove unnecessary code after re-think.
          if (editor.getCursors().length < 2)
            @reset()
            return

          if command is 'j'
            cursorTop.destroy()
          else
            cursorBottom.destroy()
      when 'I', 'A'
        cursorsAdjusted = []

        adjustCursor = (selection) ->
          {start, end} = selection.getBufferRange()
          pointEndOfLine = editor.bufferRangeForBufferRow(start.row).end
          pointTarget    = {'I': start, 'A': end}[command]
          {cursor}       = selection

          if pointTarget.isGreaterThanOrEqual(pointEndOfLine)
            pointTarget = pointEndOfLine
            cursorsAdjusted.push cursor
          cursor.setBufferPosition(pointTarget)

        adjustCursor(selection) for selection in editor.getSelections()
        vimState.activateNormalMode()
        vimState.activateInsertMode()

        if command is 'A' and  cursorsAdjusted.length
          cursor.moveRight() for cursor in cursorsAdjusted

    unless @isVisualBlockMode vimState
      @reset()

  toggleDebug: ->
    oldState = atom.config.get("#{@prefix}.debug")
    atom.config.set("#{@prefix}.debug", not oldState)
    state = atom.config.get("#{@prefix}.debug") and "enabled" or "disabled"
    console.log "#{@prefix}: debug #{state}"

  debug: (msg) ->
    return unless atom.config.get("#{@prefix}.debug")
    console.log msg

  # dump: ->
  #   @debug "@startRow = #{@startRow}"
