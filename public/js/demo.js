if (protonet.config.user_is_stranger) {

  var $account = $("<div id='hint-account'>");
  $account.css({
    "position":"absolute",
    "bottom":"73px",
    "right":"60px",
    "width": "246px",
    "height": "43px",
    "background":"url(http://protonet.info/demo/account.png)"
  });
  $('.inner-body .login').append($account);

  var $box = $("<div id='hint-box'>");
  $box.css({
    "position":"absolute",
    "top":"90px",
    "left":"50%",
    "width": "184px",
    "height": "56px",
    "margin-left": "-550px",
    "background":"url(http://protonet.info/demo/box.png)"
  });
  $('.inner-body').append($box);

  var $channel = $("<div id='hint-channel'>");
  $channel.css({
    "position":"absolute",
    "top":"60px",
    "left":"-130px",
    "width": "153px",
    "height": "87px",
    "background":"url(http://protonet.info/demo/channel.png)"
  });
  $('.inner-body .main-content').append($channel);

  var $message = $("<div id='hint-message'>");
  $message.css({
    "position":"absolute",
    "top":"-55px",
    "left":"-30px",
    "width": "295px",
    "height": "73px",
    "background":"url(http://protonet.info/demo/message.png)"
  });
  $('.inner-body .main-content').append($message);

  var $files = $("<div id='hint-files'>");
  $files.css({
    "position":"absolute",
    "top":"-40px",
    "right":"-125px",
    "width": "165px",
    "height": "87px",
    "background":"url(http://protonet.info/demo/files.png)"
  });
  $('#file-widget').append($files);

  var $users = $("<div id='hint-users'>");
  $users.css({
    "position":"absolute",
    "top":"-72px",
    "right":"-55px",
    "width": "188px",
    "height": "65px",
    "background":"url(http://protonet.info/demo/users.png)"
  });
  $('#user-widget').append($users);
}
