/*---LEFT BAR ACCORDION----*/
$(function() {
  $('#nav-accordion').dcAccordion({
    eventType: 'click',
  autoClose: true,
  saveState: true,
  disableLink: true,
  speed: 'slow',
  showCount: false,
  autoExpand: true,
  //        cookie: 'dcjq-accordion-1',
  classExpand: 'dcjq-current-parent'
  });
});

var Script = function () {


  //    sidebar dropdown menu auto scrolling

  jQuery('#sidebar .sub-menu > a').click(function () {
    var o = ($(this).offset());
    diff = 250 - o.top;
    if(diff>0)
    $("#sidebar").scrollTo("-="+Math.abs(diff),500);
    else
    $("#sidebar").scrollTo("+="+Math.abs(diff),500);
  });



  //    sidebar toggle

  $(function() {
    function responsiveView() {
      var wSize = $(window).width();
      if (wSize <= 768) {
	$('#container').addClass('sidebar-close');
	$('#sidebar > ul').hide();
      }

      if (wSize > 768) {
	$('#container').removeClass('sidebar-close');
	$('#sidebar > ul').show();
      }
    }
    $(window).on('load', responsiveView);
    $(window).on('resize', responsiveView);
  });

  $('.fa-bars').click(function () {
    if ($('#sidebar > ul').is(":visible") === true) {
      $('#main-content').css({
	'margin-left': '0px'
      });
      $('#sidebar').css({
	'margin-left': '-210px'
      });
      $('#sidebar > ul').hide();
      $("#container").addClass("sidebar-closed");
    } else {
      $('#main-content').css({
	'margin-left': '210px'
      });
      $('#sidebar > ul').show();
      $('#sidebar').css({
	'margin-left': '0'
      });
      $("#container").removeClass("sidebar-closed");
    }
  });

  // widget tools

  jQuery('.panel .tools .fa-chevron-down').click(function () {
    var el = jQuery(this).parents(".panel").children(".panel-body");
    if (jQuery(this).hasClass("fa-chevron-down")) {
      jQuery(this).removeClass("fa-chevron-down").addClass("fa-chevron-up");
      el.slideUp(200);
    } else {
      jQuery(this).removeClass("fa-chevron-up").addClass("fa-chevron-down");
      el.slideDown(200);
    }
  });

  jQuery('.panel .tools .fa-times').click(function () {
    jQuery(this).parents(".panel").parent().remove();
  });


  //    tool tips

  $('.tooltips').tooltip();

  //    popovers

  $('.popovers').popover();



  // custom bar chart

  if ($(".custom-bar-chart")) {
    $(".bar").each(function () {
      var i = $(this).find(".value").html();
      $(this).find(".value").html("");
      $(this).find(".value").animate({
	height: i
      }, 2000);
    });
  }

  var $panzoom = $('.panzoom').panzoom({
                $zoomIn:  $(".zoom-in"),
                  $zoomOut: $(".zoom-out"),
                  $zoomRange: $(".zoom-range"),
                  $reset: $(".reset"),
		 startTransform: 'scale(0.5)'
  });

  $panzoom.parent().on('mousewheel.focal', function( e ) {
    e.preventDefault();
    var delta = e.delta || e.originalEvent.wheelDelta;
    var zoomOut = delta ? delta < 0 : e.originalEvent.deltaY > 0;
    $panzoom.panzoom('zoom', zoomOut, {
      increment: 0.1,
      animate: false,
      focal: e
    });
     });



  //Right form handler

  $(".sidebar-menu.left li").click(function() {
    $(".without_model").hide();
    $(".with_model").fadeIn("fast");
    obj_id = parseInt($(this).find("a").first().attr("class").replace(/active/gi, ""));
    $('.edit_form').hide();
    $('.' + obj_id).show();

  });
  
  $('.edit_form').hide();
  $('.new_model_button').click(function(){
  	$(".without_model").hide();
    $(".with_model").fadeIn("fast");
  	$('.edit_form').hide();
    $('.new_model_form').show();
  });
  
  $('.drop_model_button').click(function(){
  	$(".without_model").hide();
    $(".with_model").fadeIn("fast");
  	$('.edit_form').hide();
    $('.drop_model_form').show();
  });
  
  
  $('.new_table_button').click(function(){
  	$(".without_model").hide();
    $(".with_model").fadeIn("fast");
  	$('.edit_form').hide();
    $('.new_table_form').show();
  });
  $('.drop_table_button').click(function(){
  	$(".without_model").hide();
    $(".with_model").fadeIn("fast");
  	$('.edit_form').hide();
    $('.drop_table_form').show();
  });
  
   $('.add_model_column').click(function(){
   	$('#model_colums_counter').val(parseInt($('#model_colums_counter').val()) + 1);
   	$('#new_model_form_body').append('<div class="form-group"><div class="col-md-8"><label class="control-label col-md-3">ColumnName<span class="required"> * </span> </label><input type="text"  autocomplete="off" class="form-control" name="new_model[column_data][' + $('#model_colums_counter').val() + '][column_name]"  /><select id="new_model_column_data_0_data_type" name="new_model[column_data][' + $('#model_colums_counter').val() + '][data_type]"><option>binary</option><option>boolean</option><option>date</option><option>datetime</option><option>decimal</option><option>float</option><option>integer</option><option>primary_key</option><option>references</option><option>string</option><option>text</option><option>time</option><option>timestamp </option></select><label class="control-label col-md-3">Limit<span class="required"> * </span> </label><input type="text" autocomplete="off" class="form-control" name="new_model[column_data][' + $('#model_colums_counter').val() + '][limit]"  /><label class="control-label col-md-3">default<span class="required"> * </span> </label><input type="text" autocomplete="off" class="form-control" name="new_model[column_data][' + $('#model_colums_counter').val() + '][default]"  /><label class="control-label col-md-3">Null<span class="required"> * </span> </label><input type="radio" name="new_model[column_data][' + $('#model_colums_counter').val() + '][null]" value="true" checked="checked">true<br><input type="radio" name="new_model[column_data][' + $('#model_colums_counter').val() + '][null]" value="false">false<button type="button" class="close" >X</button></div></div>');
   	$('.close').click(function(){
   	$(this).parent().parent().remove();
   });
   });
   
    $('.add_table_column').click(function(){
   	$('#table_colums_counter').val(parseInt($('#table_colums_counter').val()) + 1);
   	$('#new_table_form_body').append('<div class="form-group"><div class="col-md-8"><label class="control-label col-md-3">ColumnName<span class="required"> * </span> </label><input type="text"  autocomplete="off" class="form-control" name="new_model[column_data][' + $('#table_colums_counter').val() + '][column_name]"  /><select id="new_model_column_data_0_data_type" name="new_model[column_data][' + $('#table_colums_counter').val() + '][data_type]"><option>binary</option><option>boolean</option><option>date</option><option>datetime</option><option>decimal</option><option>float</option><option>integer</option><option>primary_key</option><option>references</option><option>string</option><option>text</option><option>time</option><option>timestamp </option></select><label class="control-label col-md-3">Limit<span class="required"> * </span> </label><input type="text" autocomplete="off" class="form-control" name="new_model[column_data][' + $('#table_colums_counter').val() + '][limit]"  /><label class="control-label col-md-3">default<span class="required"> * </span> </label><input type="text" autocomplete="off" class="form-control" name="new_model[column_data][' + $('#table_colums_counter').val() + '][default]"  /><label class="control-label col-md-3">Null<span class="required"> * </span> </label><input type="radio" name="new_model[column_data][' + $('#table_colums_counter').val() + '][null]" value="true" checked="checked">true<br><input type="radio" name="new_model[column_data][' + $('#table_colums_counter').val() + '][null]" value="false">false<button type="button" class="close" >X</button></div></div>');
   	$('.close').click(function(){
   	$(this).parent().parent().remove();
   });
   });

  }();
