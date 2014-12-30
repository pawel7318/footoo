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
