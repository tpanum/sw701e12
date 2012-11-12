$(document).ready(function(){

    $('.role').click(fetch_privileges_for_role);

});

function fetch_privileges_for_role() {
    var t = $(this);

    $.ajax({
        url: '/roles/'+getRoleId(t)+'/get_privileges.json',
    }).done(showPrivileges);
}

function getRoleId(role) {
    var t_id = $(role).attr('id');
    return t_id.substr(2, t_id.length);
}

function showPrivileges(resp) {
    var t = $('#privilege_list');
    t.html('');
    $.each(resp, function(i, v) {
        var content = SHT['privileges/list_item'](v);
        t.append(content);
    });
}
