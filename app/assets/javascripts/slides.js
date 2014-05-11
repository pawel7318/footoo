function clone_checkboxes_values(src_form, src_prefix, dst_prefix) {
  $('#' + src_form + ' input:checkbox').change(function(){
   $('#' + dst_prefix + this.id.replace(src_prefix, '')).prop('checked', this.checked);
 });
}

function show_dialog_move_slides_to_album() {
  $( "#dialog-move-slides-to-album" ).dialog({
    resizable: false,
    draggable: false,
    modal: true,
    buttons: {
      "Move": function() {
        $('#form_move').submit();
      },
      Cancel: function() {
        $( this ).dialog( "close" );
      }
    }
  });
}
