$(document).ready(function(){
    $('#drone_form').submit(fetch_drone_info);
});

function fetch_drone_info(e) {
    var t = $(this);

    var value = t.find('.query').val();

    $.ajax({
        url: '/drones/get_information.json',
        data: {query: value}
    }).done(fill_out_information);

    return false;
}

function fill_out_information(resp) {
    console.log(resp);
}
