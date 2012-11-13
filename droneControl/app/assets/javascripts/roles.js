var role_id;
var search_results;
var search_field;
var search_result_items = new Array();
var search_result_selected_index;

$(document).ready(function(){
    role_id = $('.user.edit').attr('data-id');
    search_field = $('.search_field');
    search_field.keyup(get_hints);
    search_field.keydown(keyboard_add_user);
    $('.role').click(fetch_privileges_for_role);
    $('form.users ul li').each(function(i,v) {
        instantiate_user_item(v);
    });
    $('form.privileges ul li').each(function(i,v) {
        instantiate_privilege_item(v);
    });
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

function get_hints(e) {
    var t = $(this);

    if (e.keyCode != 40 && e.keyCode != 38) {
        if (t.val().length > 0) {

            $.ajax({
                url: '/users/search.json',
                data: {query: t.val()}
            }).done(show_hints);
        } else {
            remove_search_results();
        }
    }
}

function show_hints(resp) {
    var results = new Object();
    if (resp.length > 0) {
        resp[0]['selected'] = true;
        results['users'] = resp;
        var content = $(SHT['roles/search_results'](results));
        if (search_results === undefined) {
            var t = $('form.users');
            t.append(content);
        } else {
            search_results.replaceWith(content);
        }
        search_result_selected_index = 0;
        search_result_items = new Array();
        content.find('li').each(function(i,v) {
            search_result_items.push($(v));
            instantiate_search_result(v);
        });
        search_results = content;
    }
}

function keyboard_add_user(e) {
    console.log(e.keyCode);
    if (e.keyCode == 13) {
        add_user(search_result_items[search_result_selected_index].attr('data-id'));

        return false;
    } else if (e.keyCode == 38 || e.keyCode == 40) {
        e.preventDefault();
        console.log(search_result_items);
        if (search_result_items.length > 0) {
            search_result_items[search_result_selected_index].removeClass('selected');
            if (e.keyCode == 38) {
                // UP
                if (search_result_selected_index > 0) {
                    search_result_selected_index--;
                }
            }
            else {
                // DOWN
                if (search_result_selected_index < search_result_items.length) {
                    search_result_selected_index++;
                }
            }
            search_result_items[search_result_selected_index].addClass('selected');
        }
    }
}

function add_user(id) {
    $.ajax({
        url: '/roles/'+role_id+'/add_users.json',
        type: 'POST',
        data: {users: [id]}
    }).done(replace_user_list);

    search_field.val('');

    remove_search_results();
}

function replace_user_list(resp) {
    var t = $('form.users ul');

    t.html('');

    $.each(resp, function(i, v) {
        var content = $(SHT['roles/user_item'](v));
        t.append(content);
        instantiate_user_item(content);
    });
}

function remove_search_results() {
    if (search_results !== undefined) {
        search_results.remove();
        search_results = undefined;
        search_result_items = new Array();
    }
}

function instantiate_user_item(item) {
    var t = $(item);
    t.find('.delete').click(function() {
        remove_user(t);
    });
}

function instantiate_search_result(item) {
    var t = $(item);
    var id = t.attr('data-id');
    t.click(function() {
        add_user(id);
    });
}

function instantiate_privilege_item(item) {
    var t = $(item);
    t.click(select_privilege);
    t.find('.delete').click(function() {
        remove_privilege(t);
    });
}

function remove_user(t) {
    t = $(t);
    $.ajax({
        url: '/roles/'+role_id+'/remove_users.json',
        type: 'POST',
        data: {users: [t.attr('data-id')]}
    }).done(function(e) {
        t.remove();
    })
}

function remove_privilege(t) {
    t = $(t);
    console.log("remove");
    /*$.ajax({
        url: '/roles/'+role_id+'/remove_users.json',
        type: 'POST',
        data: {users: [t.attr('data-id')]}
    }).done(function(e) {
        t.remove();
    })*/
}

function select_privilege() {
    console.log("select");
    t = $(this);
}
