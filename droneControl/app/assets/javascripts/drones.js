var drone_id;

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
    var content = '';
    var drone_info = $('#drone_info');
    if (resp.drone != undefined) {
        console.log($('meta[name="csrf-token"]').attr('content'));
        resp['auth_token'] = $('meta[name="csrf-token"]').attr('content');
        content = $(SHT['drones/found_drone'](resp));
        drone_id = resp.drone.id;
    }

    drone_info.html(content);
    drone_info.find("#dronetable").submit(link_drone_to_company);
}

function link_drone_to_company() {

}
