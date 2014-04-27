% File: delphia0.pl
%
% Author: C2C Gavin Delphia
%
% Description: Pex 3
%
% Documentation: C2C Alex Thomson told me how to use methods I had
% already created in my other methods.

% ----------------------------------------------------------------
% path( EventA, EventB, Path ).
% Consequent: There is a path from EventA to EventB and the
% description of the path is the Path.
% Parameters: EventA: the first event in the path.
%	      EventB: the second event in the path.
%	      Path: The Description of each event in the path
%		from EventA to EventB.
% Use: path(a, b, Path).

% Antecedent: If the predecessor and successor are the same then
% no event occured.
path(Event, Event, []).

% Antecedent: Checks if the Pred and Succ are linked by an
% activity and then check for a path between a Middle
% event and a Succ event. It builds a list as it goes.
path(Pred, Succ, [ Description | RestOfEvents]) :-
	activity(Pred, Middle, Description, _Time),
	path(Middle, Succ, RestOfEvents).

% ----------------------------------------------------------------
% time( Path, Time ).
% Consequent: The Path will take the time, Time to complete.
% Parameters: Path: A path of events.
%	      Time: The total time of all the events in the Path.
% Use: time([a, f], Time).

% Antecedent: If the Path is empty then the time is zero.
time([], 0).

% Antecedent: Traverses through the event Path list and adds the
% time of each corresponding activity to the total Time.
time([Head | Tail], Time) :-
	activity(_Start, _End, Head, EventTime),
	time(Tail, RunningTime),
	Time is RunningTime + EventTime.

% ----------------------------------------------------------------
% longer_path( EventA, EventB, Time ).
% Consequent: There exists a Path from EventA to EventB with a
% time longer than Time.
% Parameters: EventA: the first event in the path.
%			  EventB: the second event in the path.
%			  Time: The time that will be compared to the time
%					between EventA and EventB.
% Use: longer_path(a, e, 10).

% Antecedent: Finds a path between EventA and EventB, then
% calculates the time of that path and compares it to the
% supplied Time.
longer_path(EventA, EventB, Time) :-
	path(EventA, EventB, ResultPath),
	time(ResultPath, Time2),
	Time2 > Time.

% ----------------------------------------------------------------
% critical_path( Path, Time ).
% Consequent: The longest time to traverse the path, Path, is
%		Time.
% Parameters: Path: A path of activities.
%	      Time: The time it will take to traverse the Path.
% Use: critical_path([foundation, walls, ceiling, painting], 18).

% Antecedent: Uses the start and end events for the events needed.
critical_path(Path, Time) :-
	start(A),
	end(B),
	critical_path(A, B, Path, Time).

% Antecedent: Uses custom events for the events needed.
%		Custom Events are A and B.
critical_path(A, B, Path, Time) :-
	path(A, B, Path),
	time(Path, Time),
	not(longer_path(A, B, Time)).

% ----------------------------------------------------------------
% float_time( Activity, Time ).
% Consequent: The time the activity can be delayed without
%		delaying the rest of the PERT chart.
% Parameters: Activity: The activity to get the float_time for.
%			Time: The float_time for the activity.
% Use: float_time(walls, Time).

% Antecedent: Calculates the Critical Path time and subtracts
% the activity time, the start time, and the end time to get
% the float time.
float_time(Activity, Time) :-
	%Get critical path
	start(A),
	end(B),
	critical_path(A, B, Path, CriticalTime),

	%Get activity info
	activity(StartEvent, EndEvent, Activity, ActivityTime),

	%Get start to activity length
	critical_path(A, StartEvent, Path, StartTime),

	%Get activity to end length
	critical_path(EndEvent, B, Path, EndTime),

	Time is CriticalTime - StartTime - EndTime - ActivityTime.

% ----------------------------------------------------------------
% critical_activities.
% Consequent: Displays the activities with a float_time of zero.
% Parameters: None
% Use: critical_activities.

% Antecedent: Writes all the activities with a float_time of zero.
critical_activities :-
	float_time(Activity, 0),
	writeln(Activity),
	fail.

% ----------------------------------------------------------------
% lead_time(Activity, Time).
% Consequent: The Activity has a lead time of Time.
% Parameters: Activity: The activity to compare the lead_time for.
%			Time: The lead_time of the activity.
% Use: lead_time(walls, Time).

% Antecedent: Finds the critical_path between the activity
%	      EndEvent and the end event of the PERT chart.
lead_time(Activity, Time) :-
	end(B),

	%Get activity info
	activity(_StartEvent, EndEvent, Activity, _ActivityTime),

	%Get activity to end length
	critical_path(EndEvent, B, _Path, Time).
