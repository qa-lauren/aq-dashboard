@Note = React.createClass
  handleDelete: (e) ->
    e.preventDefault()
    $.ajax
      method: 'DELETE'
      url: "/notes/#{ @props.note.id }"
      dataType: 'JSON'
      success: () =>
        @props.handleDeleteNote @props.note

  render: ->
    React.DOM.li { className: "note-li" },
      React.DOM.a { className: "icon ion-md-trash custom-icon-trash", onClick: @handleDelete }
         React.DOM.span { className: "note-author" },
           "#{formatDate(@props.note.created_at)}"
      if @props.note.jira_number
         React.DOM.a { href: ticketURL(@props.note), target: "_blank"},
            React.DOM.p { className: "icon ion-md-bug custom-icon-bug"},
               React.DOM.span { className: "jira-number"},
                  "#{@props.note.jira_number}"
      React.DOM.p { className: "note-body" },  "#{@props.note.body}"
