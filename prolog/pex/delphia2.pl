%   File: delphia2.pl
%
% Author: C2C Gavin Delphia
%
% Description: Large chart facts for prelim 3
%
% Documentation: None.

% Facts for Becoming Friends Pert Chart
%
% ----------------------------------------------------------------
% event( letter_of_event ).
% Purpose: Describes that an event is defined with a letter.
% Parameters: letter_of_event: The event letter.
% Use: event(a).
event(a).
event(b).
event(c).
event(d).
event(e).
event(f).
event(g).
event(h).
event(i).
event(j).
event(k).

% ----------------------------------------------------------------
% start( letter_of_start ).
% Purpose: Describes which lettered event is the starting point.
% Parameters: letter_of_start: The event letter.
% Use: start(a).
start(a).

% ----------------------------------------------------------------
% end( letter_of_end ).
% Purpose: Describes which lettered event is the ending point.
% Parameters: letter_of_end: The event letter.
% Use: end(k).
end(k).

% ----------------------------------------------------------------
% activity( predecessor_letter, successor_event, event_description,
%	     event_time ).
% Purpose: Describes what to linked events are.
% Parameters:
% predecessor_letter: letter of predecessor event.
% successor_event: letter of successor event.
% event_description: A string description of the event.
% event_time: The time the event take (integer).
% Use: activity(a, b, decide_on_meal, 1).

activity(a, h, do_not_pressure_into_being_friends, 1).
activity(a, b, spend_time_with_people, 4).
activity(a, c, join_a_club, 1).
activity(a, d, join_a_sports_team, 1).

activity(h, i, be_loyal, 2).
activity(b, e, talk_to_people, 3).
activity(c, e, find_people_with_similar_interests, 4).
activity(d, f, support_the_team, 4).

activity(i, j, be_a_good_listener, 1).
activity(e, g, ask_them_out_to_lunch, 1).
activity(e, g, hang_out_with_them_after, 1).
activity(f, g, hang_out_with_them_after, 1).

activity(j, g, be_trustworthy, 3).
activity(g, k, become_friends, 2).