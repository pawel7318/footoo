$.fn.toggleClick=function(){
  var functions=arguments, iteration=0
  return this.click(function(){
    functions[iteration].call()
    iteration= (iteration+1) %functions.length;
  })
}


function move_selected_slides() {
  $('#_method').val("PATCH");
  var new_album_id = $('#select_new_album_id option:selected').val();
  $('#new_album_id').val(new_album_id);
  $('#slide_select_form').submit();
}

function delete_selected_slides() {
  $('#_method').val("DELETE");
  $('#slide_select_form').submit();
}

function show_dialog_move_slides_to_album() {
  $( "#dialog-move-slides-to-album" ).dialog({
    resizable: false,
    draggable: false,
    modal: true,
    buttons: {
      "Move": function() { move_selected_slides() }
      ,
      Cancel: function() {
        $( this ).dialog( "close" );
      }
    }
  });
}

function transform_portrait_images() {
  $( ".zoom-container img" ).each(function() {

    var aspectRatio = $(this).width()/$(this).height();
    $(this).data("aspect-ratio", aspectRatio);
    
    if(aspectRatio < 1) {
      $(this).addClass("portrait");
    }
  });
}

function glow_checked() {

  $(this).closest(".zoom-caption").addClass("oxo");
  
}
