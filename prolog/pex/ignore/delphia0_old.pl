%   File: pex.pl
%
% Author: C2C Gavin Delphia
%
% Description: Rules for prelim 3
%
% Documentation: None.

% path(a, z, Path), write(Path).


% ----------------------------------------------------------------
% path( parameters ).
% Consequent: High-level description of the semantics of the rule;
%             i.e., what is implied if this rule is true.
% Parameters: Description of each parameter.
% Use: Sample use of the rule.

% Antecedent: If the predecessor and successor are the same then no
% event occured.
path(Event, Event, []).

% Antecedent: Checks if the Pred and Succ are linked by an
% activity and then check for a path between a Middle
% event and a Succ event. It builds a list as it goes.
path(Pred, Succ, [ Description | RestOfEvents]) :-
	activity(Pred, Middle, Description, _Time),
	path(Middle, Succ, RestOfEvents).
