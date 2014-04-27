human( socrates ).
human( plato ).
human( aristotle ).

mortal( X ) :- human( X ).

mortals :-
  mortal( X ),
  write( X ),
  nl,
  fail.
