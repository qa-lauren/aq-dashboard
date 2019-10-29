@DeleteModal = React.createClass
  componentDidMount: ->
    $("#test-tabs").tabs()
    $(document.body).on('keydown', @handleKeyDown)

  handleDelete: (e) ->
    e.preventDefault()
    $.ajax
      method: 'DELETE'
      url: "/tags/#{ @props.tag.id }"
      dataType: 'JSON'
      success: () =>
        @props.handleClose
        @props.handleDeleteTag @props.tag


  stopParent: (e) ->
    e.stopPropagation()

  handleKeyDown: (e) ->
    if e.keyCode == 27
      @props.handleClose()

  render: ->
    React.DOM.div { className: 'delete-modal-backdrop', onClick: @props.handleClose },
      React.DOM.div { className: 'delete-modal', onClick: @stopParent },
        React.DOM.div { className: 'delete-header' },
          React.DOM.h3 { className: 'delete-title' }, "Delete #{ @props.tag.name }"
          React.DOM.p { className: 'delete-subtitle' }, "Warning: this application is associated with the following tests"

        React.DOM.div { className: 'delete-body' },
          React.DOM.div { className: "test-tabs", id: "test-tabs" },

            React.DOM.ul { id: "test-tabs-list" },
              React.DOM.li { className: "test-tabs-item" },
                React.DOM.a { className: "test-tabs-link", href: "#primary-tests-tab" }, "Application Tests"
              React.DOM.li { className: "test-tabs-item" },
                React.DOM.a { className: "test-tabs-link", href: "#feature-tests-tab" }, "Feature Tests"
              React.DOM.li { className: "test-tabs-item" },
                React.DOM.a { className: "test-tabs-link", href: "#indirect-tests-tab" }, "Filter Tests"

            React.DOM.div { className: 'test-tabs-body', id: "primary-tests-tab" },
              React.DOM.ul { className: 'list-group', id: 'delete-modal-tests' },
                for test in @props.tag.app_tests
                  React.createElement DeleteModalTest, test: test, key: test.id

            React.DOM.div { className: 'test-tabs-body', id: "feature-tests-tab" },
              React.DOM.ul { className: 'list-group', id: 'delete-modal-tests' },
                for test in @props.tag.feature_tests
                  React.createElement DeleteModalTest, test: test, key: test.id

            React.DOM.div { className: 'test-tabs-body', id: "indirect-tests-tab" },
              React.DOM.ul { className: 'list-group', id: 'delete-modal-tests' },
                for test in @props.tag.owner_tests
                  React.createElement DeleteModalTest, test: test, key: test.id

          React.DOM.div { className: 'delete-modal-buttons' },
            React.DOM.a { className: 'btn pwr-danger-btn btn-sm delete-modal-button', onClick: @handleDelete }, 'confirm'
            React.DOM.a { className: 'btn btn-default btn-sm delete-modal-button', onClick: @props.handleClose }, 'cancel'
