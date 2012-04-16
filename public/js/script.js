(function($){
  
  setTimeout(function(){
    $('#success, #error').fadeOut("slow");
  }, 3000);
  
  $('#success, #error').click(function(){
    $(this).fadeOut("slow");
  });
  
  $('.testimonials a').bind("hover click", function(){
    var $elem = $(this);
    
    $('.testimonials li.active').removeClass("active");
    $elem.parent().addClass("active");
    
    return false;
  });
  
  setInterval(function(){
    if ($(".testimonials").is(":hover")) return;
    
    var $active = $('.testimonials li.active');
    if ($active.is('.testimonials li:last')) {
      $('.testimonials li:first a').trigger("click");      
    }else{
      $active.next("li").find("a").trigger("click");
    }
    
  }, 3000);
  
})(jQuery)