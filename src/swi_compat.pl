% SWI-Prolog Compatibility Layer for DALI
% Provides SICStus-compatible predicates for SWI-Prolog
% Licensed with Apache Public License

%% These predicates are loaded into the user module via consult.
%% No module declaration needed since active_dali_wi.pl loads this with ['swi_compat.pl'].

:- discontiguous if/3.
:- discontiguous file_exists/1.

%% if(+Cond, +Then, +Else)
%  SICStus-style if/3 - used extensively throughout DALI
if(Cond, Then, _Else) :- Cond, !, call(Then).
if(_Cond, _Then, Else) :- call(Else).

%% file_exists(+File)
%  SICStus library(file_systems) predicate
file_exists(File) :- exists_file(File).

%% now(-Time)
%  SICStus library(system) now/1 - returns wallclock time
now(Time) :- get_time(T), Time is truncate(T).

%% datime(-datime(Year,Month,Day,Hour,Min,Sec))
%  SICStus library(system) datime/1
datime(datime(Year,Month,Day,Hour,Min,Sec)) :-
    get_time(Stamp),
    stamp_date_time(Stamp, date(Year,Month,Day,Hour,Min,SecF,_,_,_), local),
    Sec is truncate(SecF).

%% fdbg_assign_name(+Var, -Name)
%  SICStus library(fdbg) - assigns a printable name to a variable
%  In DALI this is used for naming variables in messages
%  We create a simple atom name based on the variable address
fdbg_assign_name(Var, Name) :-
    (var(Var) ->
        term_to_atom(Var, VarAtom),
        atom_concat('fdvar_', VarAtom, Name)
    ;
        Name = Var
    ).

%% remove_dups(+List, -NoDups)
%  SICStus library(lists) remove_dups/2
remove_dups([], []).
remove_dups([H|T], Result) :-
    (member(H, T) ->
        remove_dups(T, Result)
    ;
        remove_dups(T, Rest),
        Result = [H|Rest]
    ).

%% cons(+Elem, +List, -Result)
%  SICStus cons/3
cons(X, L, [X|L]).

%% walltime(-Time)
%  Helper: get walltime in milliseconds (SICStus statistics(walltime,...) compatible)
walltime(T) :-
    get_time(Stamp),
    T is truncate(Stamp * 1000).
