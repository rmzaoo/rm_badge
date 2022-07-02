$(document).ready(function(){
  window.addEventListener('message', function( event ) {
    if (event.data.action == 'open') {
      $('#rm_badge').show();
      $("#imgdisplay1").attr("src",event.data.img);
      $(".infos h4").text(event.data.grade);
      $(".infos h5").text(event.data.name);

    } else if (event.data.action == 'close') {
      $('#rm_badge').hide();
    }
  });
});
