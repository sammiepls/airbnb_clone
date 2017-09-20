// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery3
//= require popper
//= require bootstrap-sprockets
//= require jquery_ujs
//= require turbolinks
//= require_tree .


$(document).on('turbolinks:load', function() {
    // Adding padding to body to offset the fixed navbar
    $("body").css("padding-top", $(".navbar").outerHeight());

    $('#check_in').on('change', function(date){
      var newDate = date.target.value.split('-').join('/');
      var minDateObject = new Date(newDate);
      var newMinDateObject = minDateObject.setDate(minDateObject.getDate() + 1);
      var minDate =  new Date(newMinDateObject).toISOString().split('T')[0];
      $('#check_out')[0].min = minDate;
    });

});
