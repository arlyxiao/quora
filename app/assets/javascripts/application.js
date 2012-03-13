//= require jquery
//= require jquery-ui
//= require jquery_ujs
//= require_tree .


jQuery(document).ready(function(){
  jQuery('form a.form-submit-button').click(function(){
    jQuery(this).closest('form').submit();
  })
});

////////////////

jQuery(document).ready(function(){
  
  var answer_flash = function(answer_elm){
    answer_elm
      .css({'background-color':'#ffffaa'})
      .animate({'background-color':'#ffffff'}, 1000)
      .css({'background-color':''});
  };
  
  jQuery('.page-question-show .answers .ops .vote-up').live('click',function(){
    var elm = jQuery(this);
    var answer_elm = elm.closest('.answer');
    var answer_id = answer_elm.data('id');
    
    jQuery.ajax({
      url : '/answers/' + answer_id + '/vote_up',
      type : 'POST',
      success : function(res){
        answer_flash(answer_elm);
        
        var sum_elm = answer_elm.find('.ops .sum');
        sum_elm.html(res.vote_sum);
        
        jQuery('<div class="ani">+1</div>')
          .css({'top':20, 'color':'#4D964B'})
          .appendTo(sum_elm)
          .animate({'top':-20}, 600)
          .fadeOut(100, function(){jQuery(this).remove();})
      }
    })
  });
  
  jQuery('.page-question-show .answers .ops .vote-down').live('click',function(){
    var elm = jQuery(this);
    var answer_elm = elm.closest('.answer');
    var answer_id = answer_elm.data('id');
    
    jQuery.ajax({
      url : '/answers/' + answer_id + '/vote_down',
      type : 'POST',
      success : function(res){
        answer_flash(answer_elm);
        
        var sum_elm = answer_elm.find('.ops .sum');
        sum_elm.html(res.vote_sum);
        
        jQuery('<div class="ani">-1</div>')
          .css({'top':-20, 'color':'#ff0000'})
          .appendTo(sum_elm)
          .animate({'top':20}, 600)
          .fadeOut(100, function(){jQuery(this).remove();})
      }
    })
  });
  
})

