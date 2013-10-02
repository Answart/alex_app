// SOURCE: lib/assets/javascripts/microposts.js
// associated with:
//	 app/views/shared/_micropost_form.html.erb
//	 app/assets/stylesheets/custom.css.scss
// Exercise 10. 7

function updateCountdown() {
    // 140 is the max message length
    var remaining = 140 - jQuery('#micropost_content').val().length;
    jQuery('.countdown').text(remaining + ' characters remaining');
}

jQuery(document).ready(function($) {
    updateCountdown();
    $('#micropost_content').change(updateCountdown);
    $('#micropost_content').keyup(updateCountdown);
});