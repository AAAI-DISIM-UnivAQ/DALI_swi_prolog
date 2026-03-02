% Licensed with Apache Public License
% by AAAI Research Group
% Department of Information Engineering and Computer Science and Mathematics
% University of L'Aquila, ITALY
% http://www.disim.univaq.it

% SWI-Prolog version - Linda client for user interface
:- use_module(library(socket)).

:- dynamic linda_host_port/2.
:- dynamic ind/1.

%% Linda client operations for SWI-Prolog
linda_client(Host:Port) :-
    retractall(linda_host_port(_, _)),
    assert(linda_host_port(Host, Port)).

linda_request(Request, Reply) :-
    linda_host_port(Host, Port),
    tcp_socket(Socket),
    catch(
        (
            tcp_connect(Socket, Host:Port),
            tcp_open_socket(Socket, In, Out),
            write_term(Out, Request, [quoted(true)]), write(Out, '.'), nl(Out), flush_output(Out),
            read_term(In, Reply, []),
            close(In),
            close(Out)
        ),
        Error,
        (
            catch(tcp_close_socket(Socket), _, true),
            throw(Error)
        )
    ).

out(Tuple) :- linda_request(out(Tuple), _).
in_noblock(Tuple) :- linda_request(in_noblock(Tuple), Reply), Reply = found(Tuple).
rd_noblock(Tuple) :- linda_request(rd_noblock(Tuple), Reply), Reply = found(Tuple).

%% fdbg_assign_name compatibility
fdbg_assign_name(Var, Name) :-
    (var(Var) ->
        term_to_atom(Var, VarAtom),
        atom_concat('fdvar_', VarAtom, Name)
    ;
        Name = Var
    ).

%%%%%%%%%%%
%% Procedure loop that keeps the user agent continuously active and waiting for user interaction.
%% When the user types a message from the console an event is triggered, a timestamp is associated for the unicity.
%% Once the message is sent to the blackboard it is discarded.
%%%%%%%%%%%
procedure_message(I):-nl, print('New message'),nl,
                      print('Insert name of addressee'), nl, read(D),
                      print('Insert From'), nl, read(From),
                      print('Insert message'), nl, read(M),
                      variables(M), clause(result_format(F),_),
                      out(message(I,D,I,From,italian,[],F)), nl,
                      procedure_message(I).

% Trigger for variables with 3 rules that parse the message
% and puts fd_var front of the variables that appear in the message
variables(T):-variables(T,_,[]).

% if it is a variable, puts fd_var front of the variables that appear in the message
variables(X,[X|L0],L):-var(X), fdbg_assign_name(X,N), X=N, !, L=L0.

% if it is not a variable, analyzes the functor
variables(T,L0,L):-nonvar(T), functor(T,_,A), variables(0,A,T,L0,L).

:- dynamic result_format/1.
variables(A,A,T,L0,L):-retractall(result_format(_)),assert(result_format(T)),!,L=L0.
variables(A0,A,T,L0,L):-A0<A, A1 is A0+1, arg(A1,T,X), variables(X,L0,L1), variables(A1,A,T,L1,L).

% similar as the following, but it is called within by the goal 'utente.'.
utente:-
        linda_client('localhost':3010),
        out(agente_attivo(user,'localhost':3010)),
        procedure_message('localhost':3010).

% Opens the file with the linda server information, connects to this,
% writes on the backboard that the agent 'user' is active and calls the
% loop procedure for processing the messages.
user_interface :-
    linda_client('localhost':3010),
    out(agente_attivo(user,'localhost':3010)),
    assert(ind('localhost':3010)),
    procedure_message('localhost':3010).
