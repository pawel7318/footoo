$(document).ready(function() {  

  $('#slide_select_form').attr('action',$(this).attr('data-action'));

  $('#move_selected_button').click(function() { show_dialog_move_slides_to_album() });

  $('#delete_selected_button').click(function() { delete_selected_slides() });

  $('#edit_mode_button').toggleClick(
    function() {
      $('.edit-button').fadeToggle('slow', function() { $('#selectable').selectable("enable") });
    },
    function() {
      $('.edit-button').fadeToggle('slow', function() { $('#selectable').selectable("disable") });
    });


  $('#selectable').selectable({
    filter: 'li',
    disabled: true,
    selected: function(event, ui) {
      $(ui.selected).children('.multi-select').prop('checked', true);
    },
    unselected: function(event, ui) {
      $(ui.unselected).children('.multi-select').prop('checked', false);
    }
  });

  $('.slide-thumb').click(function() {
    $current_slide = $(this);

    src=$(this).data("srcMedium");

    $('#slideshow_slide_placeholder').attr("src", src).load(function() {
      $('#slideshow_div').fadeIn();
      $('#slideshow_slide_placeholder').fadeIn();
    });
  });

  $('#next_button').click(function() {
    $next = $current_slide.closest('li').next().find('img');
    $('#slideshow_slide_placeholder').hide();
    $next.click();
  });

  $('#prev_button').click(function() {
    $next = $current_slide.closest('li').prev().find('img');
    $('#slideshow_slide_placeholder').hide();
    $next.click();
  });

  $('#close_button').click(function() {
    $('#slideshow_div').css("display", "none");
    $("body").css("overflow", "auto");
  }
  );

  $('#slideshow_slide_placeholder').mouseout(function() {
    $('.slideshow-button').fadeIn();
  }).mouseover(function() {
    $('.slideshow-button').fadeOut();
  });
});
