
@htmlEncode = (value) ->
  $('<div/>').html(value).text()

@ticketURL = (note) ->
  "https://powerreviews.atlassian.net/browse/#{note.jira_number}"

@formatDate = (date) ->
  options =
    hour: '2-digit'
    minute: '2-digit'

  new Date(date).toLocaleString(options)
