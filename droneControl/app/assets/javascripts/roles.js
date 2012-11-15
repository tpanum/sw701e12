var role_id;
var search_results;
var search_field;
var search_result_items = new Array();
var search_result_selected_index;
var privilege_selected;
var privilege_field;
var search_box;

$(document).ready(function(){
    role_id = $('.role.edit').attr('data-id');
    search_field = $('.search_field');
    search_field.keyup(get_hints);
    search_field.keydown(keyboard_add_user);
    privilege_field = $('form.privileges');
    $('.role.edit a.add_privilege').click(open_privilege_addition_box);
    $('form.users ul li').each(function(i,v) {
        instantiate_user_item(v);
    });
    privilege_field.find('ul li').each(function(i,v) {
        instantiate_privilege_item(v);
    });
});

function get_role_id(role) {
    var t_id = $(role).attr('id');
    return t_id.substr(2, t_id.length);
}

/* USERS */

function get_hints(e) {
    var t = $(this);

    if (e.keyCode != 40 && e.keyCode != 38) {
        if (t.val().length > 0) {

            $.ajax({
                url: '/users/search.json',
                data: {query: t.val(), role_id: role_id}
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
    if (e.keyCode == 13) {
        add_user(search_result_items[search_result_selected_index].attr('data-id'));

        return false;
    } else if (e.keyCode == 38 || e.keyCode == 40) {
        e.preventDefault();
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
                if (search_result_selected_index < search_result_items.length-1) {
                    search_result_selected_index++;
                }
            }
            search_result_items[search_result_selected_index].addClass('selected');
        }
    }
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

/* PRIVILEGE FUNCTIONS */

function instantiate_privilege_item(item) {
    var t = $(item);
    t.find('.name').click(function() {
        select_privilege(t);
    });
    t.find('.delete').click(function() {
        remove_privilege(t);
    });
}

function add_privilege(id) {
    $.ajax({
        url: '/roles/'+role_id+'/add_privileges.json',
        type: 'POST',
        data: {privileges: [id]}
    }).done(replace_privilege_list);
}

function replace_privilege_list(resp) {
    var t = privilege_field.find('ul');

    t.html('');

    $.each(resp, function(i, v) {
        var content = $(SHT['roles/privilege_item'](v));
        t.append(content);
        instantiate_privilege_item(content);
    });
}

function remove_privilege(t) {
    t = $(t);
    $.ajax({
        url: '/roles/'+role_id+'/remove_privileges.json',
        type: 'POST',
        data: {privileges: [t.attr('data-id')]}
    }).done(function(e) {
        t.remove();
    })
}

function select_privilege(t) {
    t = $(t);
    if (privilege_selected !== undefined) {
        privilege_selected.removeClass("selected");
    }
    privilege_selected = $(t);
    privilege_selected.addClass("selected");
    get_description_of_privilege(privilege_selected.attr('data-id'));
}

function get_description_of_privilege(privilege_id) {
    $.ajax({
        url: '/affiliate_privileges/'+privilege_id+'.json'
    }).done(update_privilege_tooltip);
}

function update_privilege_tooltip(resp) {
    privilege_field.find('.tooltip p').html(resp.description);
}


/** ADD PRIVILEGES WITH BOX **/

function open_privilege_addition_box() {
    if (search_box == undefined) {
        search_box = $(SHT['privileges/search_privileges_box']({}));

        $('.role.edit').append(search_box);
    }

    var search_box_field = search_box.find('form .search_field');

    search_box_field.keyup(get_privilege_suggestions);

    search_box.find('.mousehandler').click(hide_search_box);

    var press = jQuery.Event("keyup");
    press.ctrlKey = false;
    search_box_field.trigger(press);
}

function add_privileges_to_search(resp) {
    var t = search_box.find('.listcontainer');

    t.html('');

    var content = $(SHT['privileges/search_privileges_box_list']({privileges: resp}));
    content.find('li').click(add_privilege_to_role);
    t.append(content);
}

function get_privilege_suggestions(e) {
    var t = $(this);

    if (e.keyCode != 40 && e.keyCode != 38) {
        $.ajax({
            url: '/privileges/search.json',
            data: {role_id: role_id, query: t.val()}
        }).done(add_privileges_to_search);
    }
}

function add_privilege_to_role() {
    var t = $(this);

    hide_search_box();

    add_privilege(t.attr('data-id'));
}

function hide_search_box() {

    search_box.remove();
    search_box = undefined;
}
