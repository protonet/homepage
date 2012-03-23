(function($){
  
  setTimeout(function(){
    $('#success, #error').fadeOut("slow");
  }, 3000);
  
  $('#success, #error').click(function(){
    $(this).fadeOut("slow");
  });
  
})(jQuery)