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
      }, 2000)
    })
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
    console.log(obj_id);

  });



  //Arrows and boxes
  $("li.sub-menu").click(function() {
    $(".main_arrows_and_boxes").html($(this).find(".aab_source").val()).arrows_and_boxes();
  });
  //Arrows and boxes


  }();
