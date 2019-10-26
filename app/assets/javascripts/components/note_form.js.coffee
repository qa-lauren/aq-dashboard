@NoteForm = React.createClass
  getInitialState: ->
    jira_number: ''
    body: ''

  handleChange: (e) ->
    @setState "#{ e.target.name }": e.target.value

  valid: ->
    @state.body or @state.jira_number

  handleSubmit: (e) ->
    e.preventDefault()
    owner = "build_id"
    owner_val = @props.build.id

    data =
      jira_number: ReactDOM.findDOMNode(@refs.jira_number).value
      body: ReactDOM.findDOMNode(@refs.body).value
      "#{owner}": owner_val

    $.post "/notes", { note: data }, ((data) =>
      @props.handleNewNote data
      )
      , 'JSON'

  componentDidMount: ->
    ReactDOM.findDOMNode(@refs.body).focus()

  render: ->
    React.DOM.div { className: "add-ticket-form" },
      React.DOM.form { onSubmit: @handleSubmit, className: "note-form" },
        React.DOM.div { className: "form-group" },

          React.DOM.textarea
            type: 'text'
            className: 'form-control input-sm'
            placeholder: 'Note'
            name: 'body'
            ref: "body"
            onChange: @handleChange

          React.DOM.input
            type: 'text'
            className: 'form-control input-sm add-note-input jira-number-form'
            placeholder: 'Jira Number'
            name: 'jira_number'
            ref: "jira_number"
            onChange: @handleChange

          React.DOM.div { className: "add-ticket-buttons" },
            React.DOM.button { className: 'ion ion-md-checkmark-circle custom-icon-checkmark', disabled: !@valid(), id: 'custom-icon-checkmark-enabled' if @valid()}, ""
            React.DOM.a { className: "ion ion-md-close-circle custom-icon-close", onClick: @props.handleClose }, ""
