/*
* Unobtrusive autocomplete
*
* To use it, you just have to include the HTML attribute autocomplete
* with the autocomplete URL as the value
*
*   Example:
*       <input type="text" autocomplete="/url/to/autocomplete">
* 
* Optionally, you can use a jQuery selector to specify a field that can
* be updated with the element id whenever you find a matching value
*
*   Example:
*       <input type="text" autocomplete="/url/to/autocomplete" id_element="#id_field">
*/

function setSubElements(obj, ui) {
  if ($(obj).attr('sub_elements')) {
    $.each($(obj).attr('sub_elements').split(" "), function(index, element) {
      $("#" + element).val(ui.item[element]);
    });
  }
}

$(document).ready(function(){
  $('input[data-autocomplete]').each(function(i){
    $(this).autocomplete({
      source: $(this).attr('data-autocomplete'),
      select: function(event, ui) {
        $(this).val(ui.item.value);
        setSubElements(this, ui)
        return false;
      }
    });
  });
});