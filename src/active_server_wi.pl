% Licensed with Apache Public License
% by AAAI Research Group
% Department of Information Engineering and Computer Science and Mathematics
% University of L'Aquila, ITALY
% http://www.disim.univaq.it

% SWI-Prolog Linda Server Implementation
% Replaces SICStus library(linda/server)

:- use_module(library(socket)).

:- dynamic linda_tuple/1.

%% Start the Linda server
go :- go(3010, 'server.txt').
go(Port, Path) :-
    tcp_socket(Socket),
    tcp_setopt(Socket, reuseaddr),
    tcp_bind(Socket, Port),
    tcp_listen(Socket, 5),
    gethostname(Host),
    on_open(Host, Port, Path),
    write('Linda server started on '), write(Host), write(':'), write(Port), nl,
    linda_accept_loop(Socket).

linda_accept_loop(Socket) :-
    tcp_accept(Socket, ClientSocket, _Peer),
    tcp_open_socket(ClientSocket, In, Out),
    thread_create(linda_handle_client(In, Out), _, [detached(true)]),
    linda_accept_loop(Socket).

linda_handle_client(In, Out) :-
    catch(
        linda_client_loop(In, Out),
        _Error,
        true
    ),
    catch(close(In), _, true),
    catch(close(Out), _, true).

linda_client_loop(In, Out) :-
    catch(read_term(In, Term, []), _, (Term = end_of_file)),
    ( Term == end_of_file -> true
    ; linda_process(Term, Out),
      linda_client_loop(In, Out)
    ).

%% Process Linda operations
linda_process(out(Tuple), Out) :- !,
    assert(linda_tuple(Tuple)),
    write_term(Out, ok, [quoted(true)]), write(Out, '.'), nl(Out), flush_output(Out).

linda_process(in_noblock(Pattern), Out) :- !,
    ( retract(linda_tuple(Pattern)) ->
        write_term(Out, found(Pattern), [quoted(true)]), write(Out, '.'), nl(Out), flush_output(Out)
    ;
        write_term(Out, not_found, [quoted(true)]), write(Out, '.'), nl(Out), flush_output(Out)
    ).

linda_process(rd_noblock(Pattern), Out) :- !,
    ( linda_tuple(Pattern) ->
        copy_term(Pattern, Copy),
        write_term(Out, found(Copy), [quoted(true)]), write(Out, '.'), nl(Out), flush_output(Out)
    ;
        write_term(Out, not_found, [quoted(true)]), write(Out, '.'), nl(Out), flush_output(Out)
    ).

linda_process(bagof_rd_noblock(Template, Goal, _Bag), Out) :- !,
    ( bagof(Template, linda_tuple(Goal), Results) ->
        write_term(Out, found(Results), [quoted(true)]), write(Out, '.'), nl(Out), flush_output(Out)
    ;
        write_term(Out, not_found, [quoted(true)]), write(Out, '.'), nl(Out), flush_output(Out)
    ).

linda_process(_, Out) :-
    write_term(Out, error(unknown_request), [quoted(true)]), write(Out, '.'), nl(Out), flush_output(Out).

%% Write server connection info to file
on_open(Host, Port, Path) :-
    open(Path, write, Stream, []),
    format(Stream, "'~w':~d.~n", [Host, Port]),
    close(Stream).
