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
  commands:    'jkhlDCoIA'.split('').concat('escape')

  toggleDebug: ->
    atom.config.toggle("#{@prefix}.debug")
    state = atom.config.get("#{@prefix}.debug") and "enabled" or "disabled"
    console.log "#{@prefix}: debug #{state}"

  debug: (msg) ->
    return unless atom.config.get("#{@prefix}.debug")
    console.log msg

  activate: (state) ->
    @disposables = new CompositeDisposable
    blockwiseCommands = {}
    for command in @commands
      do (command) =>
        name = "#{@prefix}:#{command}"
        blockwiseCommands[name] = (event) => @blockOperation(event, command)

    blockwiseCommands["#{@prefix}:toggle-debug"] = => @toggleDebug()
    @disposables.add atom.commands.add('atom-text-editor', blockwiseCommands)
    @reset()

  consumeVimMode: (@vimModeService) ->

  isActive: ->
    @active

  reset: ->
    @active = false
    @startRow = null

  getActiveTextEditor: ->
    atom.workspace.getActiveTextEditor()

  getVimEditorState: ->
    editor = @getActiveTextEditor()
    @vimModeService.getEditorState(editor)

  # Curretly submode, blockwise is cleared by vim-mode.
  # So I need explicitly manage state via @active variable.
  isVisualBlockMode: ->
    if @isActive()
      return true
    else
      {mode, submode} = @getVimEditorState()
      (mode is 'visual') and (submode is 'blockwise')

  blockOperation: (event, command) ->
    @debug command

    unless @isVisualBlockMode()
      event.abortKeyBinding()
      @debug "active?: #{@isActive()}"
      return

    @active     = true
    editor      = @getActiveTextEditor()
    @startRow  ?= editor.getLastCursor()?.getBufferRow()
    currentRow  = editor.getLastCursor()?.getBufferRow()
    vimState    = @getVimEditorState()

    switch command
      when 'j'
        if currentRow < @startRow
          # GUARD ensure we never destroy() last cursor.
            if (editor.getCursors().length < 2)
              @reset()
              break
            _.first(editor.getCursorsOrderedByBufferPosition())
            .destroy()
        else
          editor.addSelectionBelow()
      when 'k'
        if currentRow > @startRow
          # GUARD ensure we never destroy() last cursor.
          if (editor.getCursors().length < 2)
            @reset()
            break
          _.last(editor.getCursorsOrderedByBufferPosition())
            .destroy()
        else
          editor.addSelectionAbove()
      when 'D', 'C'
        vimState.activateCommandMode()
        event.abortKeyBinding()
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
        vimState.activateCommandMode()
        vimState.activateInsertMode()

        if command is 'A' and  cursorsAdjusted.length
          cursor.moveRight() for cursor in cursorsAdjusted

      when 'escape'
        vimState.activateCommandMode()
        @getActiveTextEditor().clearSelections()
      when 'o'
        @startRow = currentRow
      else
        event.abortKeyBinding()

    if vimState.mode isnt 'visual'
      @reset()
    @debug "active?: #{@isActive()}, #{@startRow}, #{currentRow}"

  deactivate: ->
    @disposables.dispose()
