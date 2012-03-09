//= require jquery
//= require jquery-ui
//= require jquery_ujs
//= require_tree .


jQuery(document).ready(function(){
  jQuery('form a.form-submit-button').click(function(){
    jQuery(this).closest('form').submit();
  })
});

