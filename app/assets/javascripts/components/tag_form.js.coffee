@TagForm = React.createClass
  getInitialState: ->
    name: ''
    tag_type: ''

  handleSubmit: (e) ->
    e.preventDefault()
    data =
      name: ReactDOM.findDOMNode(@refs.name).value
      tag_type: ReactDOM.findDOMNode(@refs.tag_type).value

    $.post("/tags", { tag: data }, ((data) =>
      @props.handleNewTag data
      @refs.name.value = ""
      @setState name: '')
      , 'JSON')

  handleChange: (e) ->
    @setState "#{ e.target.name }": e.target.value

  addTag: (tag) ->
    tags = @state.tags.slice()
    tags.push(tag)
    @setState tags: tags

  valid: ->
    @state.name

  render: ->
    React.DOM.form { onSubmit: @handleSubmit, className: 'form-inline add-tag-form' },
      React.DOM.div { className: 'form-group', id: 'tag-form-group' },
        React.DOM.div {className: 'pwr-tag-form-control'},
          React.DOM.input { type: 'text', className: 'form-control', placeholder: 'Name', name: 'name', ref: "name", onChange: @handleChange }
        React.DOM.div {className: 'pwr-tag-select-control'},
          React.DOM.select { className: 'form-control', ref: 'tag_type' },
             React.DOM.option { value: "Application" }, "Application"
             React.DOM.option { value: "Feature" }, "Feature"
             React.DOM.option { value: "Owner" }, "Owner"
        React.DOM.div {},
          React.DOM.button { type: 'submit', className: 'btn pwr-confirm-btn', disabled: !@valid() }, 'Add Tag'
