forward timer_player_started(id);
forward timer_player_finished(id);
forward timer_player_record(id);
forward timer_player_world_record(id);
forward timer_player_category_changed(id);

native set_user_finished(id, value);
native get_user_finished(id);

native get_user_best(id);
native get_user_category(id, name[], len);