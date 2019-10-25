//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require rails-ujs
//= require jquery
//= require jquery-ui/widgets/autocomplete
//= require jquery-ui/widgets/tooltip
//= require jquery-ui/widgets/tabs
//= require jquery-ui/widgets/slider
//= require jquery_ujs
//= require bootstrap
//= require remarkable-bootstrap-notify
//= require react
//= require react_ujs
//= require components
//= require_tree .
//= require_tree .

$(document).ajaxComplete(function(event, request) {
	var msg = request.getResponseHeader('X-Message');
	var type = request.getResponseHeader('X-Message-Type');
	if (msg) {
    $.notify({
      message: msg
    },{
      type: type,
      delay: 1000
    });
	}
});
