// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require jquery3
//= require jquery_ujs
//= require ./vendors/semantic.js
//= require ./vendors/jquery.noty.packaged.min.js
//= require ./app/notiy.js
//= require turbolinks
//= require best_in_place
//= require ./vendors/alertify.min.js
//= require jquery-ui
//= require best_in_place.jquery-ui
//= require cocoon


$(document).on('turbolinks:load', function (e) {
  $('.ui.dropdown').dropdown();
  $('.ui.checkbox').checkbox();
  $('.ui.radio.checkbox').checkbox();
  $('select.dropdown').dropdown();
  $('.ui.accordion').accordion();
  $('.ui.sticky').sticky({context: '#dashboard'});
  jQuery(".best_in_place").best_in_place();
    // Semantic UI based calender
    $('.ui.calendar').calendar({
        type: 'date',
        formatter: {
            date: function (date, settings) {
                if (!date) return '';
                var day = date.getDate();
                var month = date.getMonth() + 1;
                var year = date.getFullYear();
                if ((day / 10) < 1){ day = "0" + day }
                if ((month / 10) < 1){ month = "0" + month }
                return year + '-' + month + '-' + day;
            }}
    });

    $('.ui.modal')
        .modal({
            allowMultiple: true,
        });;

});

$.datepicker.setDefaults({
    dateFormat: 'yy-mm-dd'
});
