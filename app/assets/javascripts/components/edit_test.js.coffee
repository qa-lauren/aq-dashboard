@EditTest = React.createClass
  getInitialState: ->
    edit: false

  getDefaultProps: ->
    app_tags: []
    feature_tags: []
    owner_tags: []

  handleToggle: (e) ->
    e.preventDefault()
    @setState edit: !@state.edit

  handleEdit: (e) ->
    e.preventDefault()

    data =
      app_tag: ReactDOM.findDOMNode(@refs.app_tag).value
      feature_tag: ReactDOM.findDOMNode(@refs.feature_tag).value
      owner_tag: ReactDOM.findDOMNode(@refs.owner_tag).value
      name: ReactDOM.findDOMNode(@refs.name).value
    $.ajax
      method: 'PUT'
      url: "/tests/#{ @props.test.id }"
      dataType: 'JSON'
      data:
        test: data
      success: (data) =>
        @setState edit: false
        @props.handleEditTest @props.test, data

  stopParent: (e) ->
    e.stopPropagation()

  handleDelete: (e) ->
    e.stopPropagation()
    $.ajax
      method: 'DELETE'
      url: "/tests/#{ @props.test.id }"
      dataType: 'JSON'
      success: () =>
        @props.handleDeleteTest @props.test

  testRow: ->
    React.DOM.tr { onClick: @handleToggle },
      React.DOM.td null,
        React.DOM.div { className: "edit-test-name" },
          React.DOM.a { href: @props.test.job_url, className: 'settings-test-link', target: "_blank", onClick: @stopParent }, @props.test.name

      if "app_tag" of @props.test
        React.DOM.td null, @props.test.app_tag.name
      else
        React.DOM.td null, ""

      if "feature_tag" of @props.test
        React.DOM.td null, @props.test.feature_tag.name
      else
        React.DOM.td null, ""

      if "owner_tag" of @props.test
        React.DOM.td null, @props.test.owner_tag.name
      else
        React.DOM.td null, ""

      React.DOM.td null,
        React.DOM.a { className: 'btn btn-sm pwr-danger-btn', onClick: @handleDelete }, 'delete'

  render: ->
    if !@state.edit
      @testRow()
    else
      React.DOM.tr null,
        React.DOM.td null,
          React.DOM.input { className: 'form-control form-control-sm', id: "name-input", type: "text", ref: 'name', defaultValue: @props.test.name, title: "Warning: Only change name if it has changed on Jenkins" }

        React.DOM.td null,
          React.DOM.select
            className: 'form-control form-control-sm'
            defaultValue: if "app_tag" of @props.test then @props.test.app_tag.id else 0
            ref: 'app_tag'
            for tag in @props.app_tags
              React.DOM.option { key: tag.id, value: tag.id }, tag.name
            React.DOM.option { value: 0 }, "None"

        React.DOM.td null,
          React.DOM.select
            className: 'form-control form-control-sm'
            defaultValue: if "feature_tag" of @props.test then @props.test.feature_tag.id else 0
            ref: 'feature_tag'
            for tag in @props.feature_tags
              React.DOM.option { key: tag.id, value: tag.id }, tag.name
            React.DOM.option { value: 0 }, "None"

        React.DOM.td null,
          React.DOM.select
            className: 'form-control form-control-sm'
            defaultValue: if "owner_tag" of @props.test then @props.test.owner_tag.id else 0
            ref: 'owner_tag'
            for tag in @props.owner_tags
              React.DOM.option { key: tag.id, value: tag.id }, tag.name
            React.DOM.option { value: 0 }, "None"

        React.DOM.td null,
          React.DOM.a { className: 'btn btn-sm pwr-confirm-btn edit-test-update', onClick: @handleEdit }, 'save'
          React.DOM.a { className: 'btn btn-sm pwr-danger-btn', onClick: @handleToggle}, 'cancel'
