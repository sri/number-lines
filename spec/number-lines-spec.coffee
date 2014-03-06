{WorkspaceView} = require 'atom'

describe "numbering lines", ->
  [activationPromise, editor, editorView] = []

  numberLines = (callback) ->
    editorView.trigger "number-lines:number"
    waitsForPromise -> activationPromise
    runs(callback)

  beforeEach ->
    atom.workspaceView = new WorkspaceView
    atom.workspaceView.openSync()

    editorView = atom.workspaceView.getActiveView()
    editor = editorView.getEditor()

    activationPromise = atom.packages.activatePackage('number-lines')

  describe "when no lines are selected", ->
    it "numbers all the lines", ->
      editor.setText "A\nB\nC\n"
      editor.setCursorBufferPosition([0, 0])
      numberLines ->
        expect(editor.getText()).toBe "1 A\n2 B\n3 C\n4 "

  describe "when entire lines are selected", ->
    it "numbers the selected lines", ->
      editor.setText "A\nB\nC"
      editor.setSelectedBufferRange([[0,0], [2,0]])
      numberLines ->
        expect(editor.getText()).toBe "1 A\n2 B\nC"

  describe "when partial lines are selected", ->
    it "nubers the selected lines", ->
      editor.setText "A for apple\nB for ballon\nC for cat"
      editor.setSelectedBufferRange([[0,8], [1,9]])
      numberLines ->
        expect(editor.getText()).toBe "1 A for apple\n2 B for ballon\nC for cat"

  describe "when there are multiple selection ranges", ->
    it "numbers the lines in each selection range", ->
      editor.setText "A\nB\nC\nD\nE\nF\nG\nH\nI\nJ\nK\nL"
      editor.addSelectionForBufferRange([[0, 0], [2, 0]])
      editor.addSelectionForBufferRange([[4, 0], [8, 0]])
      numberLines ->
        expect(editor.getText()).toBe(
          "1 A\n2 B\nC\nD\n1 E\n2 F\n3 G\n4 H\nI\nJ\nK\nL")
