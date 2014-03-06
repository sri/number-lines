RangeFinder = require './range-finder'

module.exports =
  activate: ->
    atom.workspaceView.command 'number-lines:number', '.editor', ->
      editor = atom.workspaceView.getActivePaneItem()
      numberLines(editor)

numberLines = (editor) ->
  sortableRanges = RangeFinder.rangesFor(editor)
  sortableRanges.forEach (range) ->
    i = 1
    textLines = editor.getTextInBufferRange(range).split("\n").map (line) ->
      "#{i++} #{line}"
    editor.setTextInBufferRange(range, textLines.join("\n"))
