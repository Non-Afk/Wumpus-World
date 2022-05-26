:-dynamic([
  gold_location/1,
  pit_location/1,
  wumpus_location/1,
  agent_location/1,
  breeze_location/1,
  stench_location/1,
  check_perception/3,
  check_breeze/2,
  check_gold/2,
  check_pit/2,
  check_stench/2,
  check_wumpus/2]).


start:-
  init_world,
  init_stench,
  init_breeze,
  format('Start game.~n',[]),
  step.


init_world:-
  retractall(gold_location(_)),
  assert(gold_location([2,3])),

  retractall(pit_location(_)),
  assert(pit_location([3,1])),
  assert(pit_location([3,3])),
  assert(pit_location([4,4])),

  retractall(wumpus_location(_)),
  assert(wumpus_location([1,3])),

  retractall( agent_location(_) ),
  assert( agent_location([1,1]) ),
  
  retractall(check_breeze(_)),
  retractall(check_gold(_)),
  retractall(check_perception(_)),
  retractall(check_pit(_)),
  retractall(check_stench(_)),
  retractall(check_wumpus(_)).


init_breeze:-
  pit_location([X,Y]),
  retractall(breeze_location(_)),
  X1 is X-1, assert(breeze_location([X1,Y])),
  X2 is X+1, assert(breeze_location([X2,Y])),
  Y1 is Y-1, assert(breeze_location([X,Y1])),
  Y2 is Y+1, assert(breeze_location([X,Y2])).

init_stench:-
  wumpus_location([X,Y]),
  retractall(stench_location(_)),
  X1 is X-1, assert(stench_location([X1,Y])),
  X2 is X+1, assert(stench_location([X2,Y])),
  Y1 is Y-1, assert(stench_location([X,Y1])),
  Y2 is Y+1, assert(stench_location([X,Y2])).



check_pit(pit):-
  agent_location([X1,Y1]),
  pit_location([X2,Y2]),
  X1 = X2, Y1 = Y2,
  format('Fall into the pit.~n',[]).
check_pit(no_pit):-
  format('No pits~n',[]).

check_breeze(feel_breeze):-
  agent_location([X1,Y1]),
  breeze_location([X2,Y2]),
  X1 = X2, Y1 = Y2,
  format('There is a pit nearby.~n',[]).

check_breeze(no_breeze):-
  format('No pits.~n',[]).

check_wumpus(wumpus):-
  agent_location([X1,Y1]),
  wumpus_location([X2,Y2]),
  X1 = X2, Y1 = Y2,
  format('You died.~n',[]).

check_wumpus(no_wumpus):-
  format('No wumpus.~n',[]).

check_stench(small_stench):-
  agent_location([X1,Y1]),
  stench_location([X2,Y2]),
  X1 = X2, Y1 = Y2,
  format('There is a Wumpus nearby.~n',[]).

check_stench(no_stench):-
  format('No stench.~n',[]).

check_gold(gold):-
  agent_location([X1,Y1]),
  gold_location([X2,Y2]),
  X1 = X2, Y1 = Y2,
  format('You win.~n',[]).

check_gold(no_gold):-
  format('No gold here.~n',[]).

check_perception(safe):-
  check_breeze(no_breeze),
  check_pit(no_pit),
  check_stench(no_stench),
  check_wumpus(no_wumpus).

check_perception(unsafe):-
  check_breeze(feel_breeze),
  check_stench(small_stench).

check_perception(deadly):-
  check_pit(pit),
  check_wumpus(wumpus).

%name_perception([Poction]):-
%  check_perception(Poction),
%  format('You are in a ~p place.~n',[Poction]).
  %check_gold(Gold),
  %check_breeze(Breeze),
  %check_stench(Stench),
  %check_perception(Poction),
  %heck_pit(Pit),
  %heck_wumpus(Wumpus).

%update_perception([Gold,Breeze,Stench,Poction]):-
%  format('You are in a ~p location.~n',[Poction]),
 %% format('Gold: ~p.~n',[Gold]),
  %format('Breeze: ~p.~n',[Breeze]),
  %format('Stench: ~p.~n',[Stench]).


%not_member(_, []).
%not_member([X,Y], [[U,V]|Ys]) :-
%    ( X=U,Y=V -> fail
%    ; not_member([X,Y], Ys)
%    ).
%
%  step(VisitedList) :-
%    not_member(L, VisitedList),
%    update_agent_location(L).



step:-
  agent_location(AL),
  format('Your located ~p~n',[AL]),
  %name_perception.
  %update_agent_location([Location]),
  %format('Here is the information:~p',[Information]).
  check_breeze,
  check_gold,
  check_perception,
  check_pit,
  check_stench,
  check_wumpus.


  right:-
    agent_location([X1,Y]),
    X2 is X1+1, assert(agent_location([X2,Y])),
    step.

  left:-
    agent_location([X1,Y]),
    X2 is X1-1,assert(agent_location([X2,Y])),
    step.

  up:-
    agent_location([X,Y1]),
    Y2 is Y1+1,assert(agent_location([X,Y2])),
    step.

  down:-
    agent_location([X,Y1]),
    Y2 is Y1-1,assert(agent_location([X,Y2])),
    step.

