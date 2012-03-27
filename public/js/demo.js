if (protonet.config.user_is_stranger) {

  var $account = $("<div id='hint-account'>");
  $account.css({
    "position":"absolute",
    "bottom":"45px",
    "right":"20px",
    "width": "295px",
    "height": "50px",
    "background":"url(http://localhost:9393/demo/account.png)"
  });
  $('.inner-body .login').append($account);

  var $box = $("<div id='hint-box'>");
  $box.css({
    "position":"absolute",
    "top":"20px",
    "left":"-115px",
    "width": "243px",
    "height": "66px",
    "background":"url(http://localhost:9393/demo/box.png)"
  });
  $('.inner-body').append($box);

  var $channel = $("<div id='hint-channel'>");
  $channel.css({
    "position":"absolute",
    "top":"35px",
    "left":"-150px",
    "width": "178px",
    "height": "120px",
    "background":"url(http://localhost:9393/demo/channel.png)"
  });
  $('.inner-body .main-content').append($channel);

  var $message = $("<div id='hint-message'>");
  $message.css({
    "position":"absolute",
    "top":"-75px",
    "left":"-60px",
    "width": "396px",
    "height": "93px",
    "background":"url(http://localhost:9393/demo/message.png)"
  });
  $('.inner-body .main-content').append($message);

  var $files = $("<div id='hint-files'>");
  $files.css({
    "position":"absolute",
    "top":"-15px",
    "right":"-200px",
    "width": "197px",
    "height": "124px",
    "background":"url(http://localhost:9393/demo/files.png)"
  });
  $('#file-widget').append($files);

  var $users = $("<div id='hint-users'>");
  $users.css({
    "position":"absolute",
    "top":"-15px",
    "right":"-170px",
    "width": "171px",
    "height": "97px",
    "background":"url(http://localhost:9393/demo/users.png)"
  });
  $('#user-widget').append($users);
}
