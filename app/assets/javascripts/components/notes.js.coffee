@Notes = React.createClass
  getInitialState: ->
    notes: @props.notes
    show: false
    new_note: false
    mouseDownOnNotes: false

  toggleNotes: ->
    @setState show: !@state.show, new_note: false

  toggleForm: ->
    @setState new_note: !@state.new_note, show: false

  addNote: (note) ->
    notes = @state.notes.slice()
    notes.push(note)
    @setState notes: notes, new_note: false, show: true

  removeNote: (note) ->
    notes = @state.notes.slice()
    index = notes.indexOf note
    notes.splice index, 1
    @replaceState(notes: notes, show: true)

  pageClick: ->
    return if @state.mouseDownOnNotes
    @setState show: false, new_note: false

  handleMouseDown: ->
    @setState mouseDownOnNotes: true

  handleMouseUp: ->
    @setState mouseDownOnNotes: false

  componentDidMount: ->
    window.addEventListener('mousedown', @pageClick, false)

  notesList: ->
    React.DOM.ul { className: "sub note-test" },
      for note in @state.notes
        React.createElement Note, key: note.id, note: note, handleDeleteNote: @removeNote

      React.DOM.a { className: "icon ion-md-add-circle custom-icon-add", onClick: @toggleForm }

  render: ->
    React.DOM.div { onMouseDown: @handleMouseDown, onMouseUp: @handleMouseUp },
      if @state.notes.length
         React.DOM.a { className: "icon ion-md-list-box custom-icon-list", onClick: @toggleNotes },
            ""
            React.DOM.span { className: "badge", id:"active-badge"}, @state.notes.length
      else
         React.DOM.a { className: "icon ion-md-list-box custom-icon-list no-display", onClick: @toggleNotes },
            ""

      if @state.show
        @notesList()

      if @state.new_note
        React.createElement NoteForm, build: @props.build, handleNewNote: @addNote, handleClose: @toggleForm
