var role_id;
var search_results;
var selected_user;

$(document).ready(function(){
    role_id = $('.user.edit').attr('data-id');
    $('.search_field').keyup(get_hints);
    $('.search_field').keypress(add_user);
    $('.role').click(fetch_privileges_for_role);
});

function fetch_privileges_for_role() {
    var t = $(this);

    $.ajax({
        url: '/roles/'+get_role_id(t)+'/get_privileges.json',
    }).done(show_privileges);
}

function get_role_id(role) {
    var t_id = $(role).attr('id');
    return t_id.substr(2, t_id.length);
}

function show_privileges(resp) {
    var t = $('#privilege_list');
    t.html('');
    $.each(resp, function(i, v) {
        var content = SHT['privileges/list_item'](v);
        t.append(content);
    });
}

function get_hints() {
    var t = $(this);

    if (t.val().length > 0) {

        $.ajax({
            url: '/users/search.json',
            data: {query: t.val()}
        }).done(show_hints);
    } else {
        if (search_results !== undefined) {
            search_results.remove();
            search_results = undefined;
        }
    }
}

function show_hints(resp) {
    var results = new Object();
    resp[0]['selected'] = true;
    selected_user = resp[0]['id'];
    results['users'] = resp;
    var content = $(SHT['roles/search_results'](results));
    if (search_results === undefined) {
        var t = $('form.users');
        t.append(content);
    } else {
        search_results.replaceWith(content);
    }
    search_results = content;
}

function add_user(e) {
    if (e.keyCode == 13) {
        $.ajax({
            url: '/roles/'+role_id+'/add_users.json',
            type: 'POST',
            data: {users: [selected_user]}
        });

        return false;
    }
}
