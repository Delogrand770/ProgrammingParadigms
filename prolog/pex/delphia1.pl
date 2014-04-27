%   File: delphia1.pl
%
% Author: C2C Gavin Delphia
%
% Description: Small chart facts for prelim 3
%
% Documentation: None.

% Facts for Dinner Pert Chart
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
% Use: end(g).
end(g).

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

activity(a, b, decide_on_food, 30).
activity(b, c, decide_on_dress, 10).
activity(b, d, cook_good, 40).
activity(b, e, decide_on_drink, 10).
activity(c, f, get_dressed, 35).
activity(d, f, set_table, 5).
activity(e, f, make_drinks, 10).
activity(f, g, eat, 60).
