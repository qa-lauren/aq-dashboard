@EditTags = React.createClass
  getInitialState: ->
    tags: @props.data
    delete_modal: false

  getDefaultProps: ->
    tags: []

  showDeleteModal: (tag) ->
    @setState modal_tag: tag
    @setState delete_modal: true

  closeDeleteModal: ->
    @setState delete_modal: false

  addTag: (tag) ->
    tags = @state.tags.slice()
    tags.push(tag)
    @setState tags: tags

  deleteTag: (tag) ->
    tags = @state.tags.slice()
    index = tags.indexOf tag
    tags.splice index, 1
    @replaceState tags: tags

  updateTag: (tag, data) ->
    index = @state.tags.indexOf tag
    tags = React.addons.update(@state.tags, { $splice: [[index, 1, data]] })
    @replaceState tags: tags


  render: ->
    React.DOM.div { className: 'tests' },
      React.createElement TagForm, handleNewTag: @addTag
      React.DOM.table { className: 'table table-bordered edit-test-table', id: 'edit-tags-table' },
        React.DOM.thead null,
          React.DOM.tr null,
            React.DOM.th { className: "tag-name-field" }, 'Tag'
            React.DOM.th { className: "tag-type-field" }, 'Type'
            React.DOM.th { className: "tag-actions-field" }, ''
        React.DOM.tbody { id: "tag-table-body" },
          for tag in @state.tags
            React.createElement EditTag, key: tag.id, tag: tag, handleDeleteTag: @deleteTag, handleEditTag: @updateTag, handleDeleteModal: @showDeleteModal
      React.DOM.table { id: "header-fixed", className: "table table-bordered" }
      if @state.delete_modal
        React.createElement DeleteModal, tag: @state.modal_tag, handleClose: @closeDeleteModal, handleDeleteTag: @deleteTag
