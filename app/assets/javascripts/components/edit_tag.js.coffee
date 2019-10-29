@EditTag = React.createClass
  getInitialState: ->
    edit: false

  handleToggle: (e) ->
    e.preventDefault()
    @setState edit: !@state.edit

  handleEdit: (e) ->
    e.preventDefault()
    data =
      name: ReactDOM.findDOMNode(@refs.name).value
      tag_type: ReactDOM.findDOMNode(@refs.tag_type).value
    $.ajax
      method: 'PUT'
      url: "/tags/#{ @props.tag.id }"
      dataType: 'JSON'
      data:
        tag: data
      success: (data) =>
        @setState edit: false
        @props.handleEditTag @props.tag, data

  showModal: (e) ->
    $(window).scrollTop(0);
    e.preventDefault()
    e.stopPropagation()
    @props.handleDeleteModal @props.tag

  handleDelete: (e) ->
    e.preventDefault()
    $.ajax
      method: 'DELETE'
      url: "/tags/#{ @props.tag.id }"
      dataType: 'JSON'
      success: () =>
        @props.handleDeleteTag @props.tag

  hasTests: ->
    @props.feature_tests.length > 0 or @props.app_tests.length > 0 or @props.owner_tests.length > 0

  editTagForm: ->
    React.DOM.tr null,
      React.DOM.td null,
        React.DOM.input { className: 'form-control', type: 'text', defaultValue: @props.tag.name, ref: 'name' }

      React.DOM.td null,
        React.DOM.select { className: 'form-control', defaultValue: @props.tag.tag_type, ref: 'tag_type' },
          React.DOM.option { value: "Application" }, "Application"
          React.DOM.option { value: "Feature" }, "Feature"
          React.DOM.option { value: "Owner" }, "Owner"

      React.DOM.td null,
        React.DOM.a { className: 'btn pwr-confirm-btn btn-sm edit-test-update', onClick: @handleEdit }, 'save'
        React.DOM.a { className: 'btn pwr-danger-btn btn-sm', onClick: @handleToggle }, 'cancel'

  editTagRow: ->
    React.DOM.tr { onClick: @handleToggle },
      React.DOM.td null, @props.tag.name
      React.DOM.td null, @props.tag.tag_type
      React.DOM.td null,
        React.DOM.a { className: 'btn pwr-danger-btn btn-sm', onClick: @showModal }, "delete"

  render: ->
    if @state.edit
      @editTagForm()
    else
      @editTagRow()
