$(document).ready(function() {
    $("#button").bind("click", function() {
        // Generate unique id
        var rand = Math.random().toString().split(".")[1];
        var input = '<input type="file" name="f['+rand+']" class="f['+rand+']" />';
        $(this).before(input);
    });
    $("#button").trigger("click");
});
