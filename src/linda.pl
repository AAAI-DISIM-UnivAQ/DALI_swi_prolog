% Linda Tuple-Space Implementation for SWI-Prolog
% Replacement for SICStus library(linda/server) and library(linda/client)
% Uses SWI-Prolog threads and message queues to implement a shared blackboard
%
% Licensed with Apache Public License

:- module(linda_server, [
    linda/1,
    linda_client/1,
    out/1,
    in_noblock/2,
    in_noblock/1,
    rd_noblock/1,
    rd_noblock/2,
    bagof_rd_noblock/3,
    close_linda/0
]).

:- use_module(library(socket)).

:- dynamic linda_tuple/1.
:- dynamic linda_server_port/1.
:- dynamic linda_connected/0.

%% =============================================
%% LINDA SERVER
%% =============================================

%% linda(+(Host:Port)-Goal)
%  Starts the Linda server on the given port, then calls Goal with Host and Port bound.
linda((Host:Port)-Goal) :-
    gethostname(Host0),
    atom_codes(Host0, Host),
    tcp_socket(Socket),
    tcp_setopt(Socket, reuseaddr),
    tcp_bind(Socket, Port),
    tcp_listen(Socket, 5),
    assert(linda_server_port(Port)),
    format(atom(_), 'Linda server started on ~w:~w~n', [Host0, Port]),
    write('Linda server started on '), write(Host0), write(':'), write(Port), nl,
    call(Goal),
    % Start accepting connections in a loop
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
    read_term(In, Term, []),
    ( Term == end_of_file -> true
    ; linda_process_request(Term, Out),
      linda_client_loop(In, Out)
    ).

linda_process_request(out(Tuple), Out) :-
    assert(linda_tuple(Tuple)),
    write_term(Out, ok, [quoted(true)]), write(Out, '.'), nl(Out), flush_output(Out).

linda_process_request(rd_noblock(Tuple), Out) :-
    ( linda_tuple(Tuple) ->
        write_term(Out, found(Tuple), [quoted(true)]), write(Out, '.'), nl(Out), flush_output(Out)
    ;
        write_term(Out, not_found, [quoted(true)]), write(Out, '.'), nl(Out), flush_output(Out)
    ).

linda_process_request(in_noblock(Tuple), Out) :-
    ( retract(linda_tuple(Tuple)) ->
        write_term(Out, found(Tuple), [quoted(true)]), write(Out, '.'), nl(Out), flush_output(Out)
    ;
        write_term(Out, not_found, [quoted(true)]), write(Out, '.'), nl(Out), flush_output(Out)
    ).

linda_process_request(bagof_rd_noblock(Template, Tuple, Bag), Out) :-
    ( bagof(Template, linda_tuple(Tuple), Bag0) ->
        write_term(Out, found(Bag0), [quoted(true)]), write(Out, '.'), nl(Out), flush_output(Out)
    ;
        write_term(Out, not_found, [quoted(true)]), write(Out, '.'), nl(Out), flush_output(Out)
    ).

%% =============================================
%% LINDA CLIENT  
%% =============================================

%% linda_client(+Host:Port)
%  Connects to a Linda server. Stores connection info.
:- dynamic linda_stream_in/1.
:- dynamic linda_stream_out/1.
:- dynamic linda_socket/1.
:- dynamic linda_host_port/2.

linda_client(Host:Port) :-
    retractall(linda_host_port(_, _)),
    assert(linda_host_port(Host, Port)),
    assert(linda_connected).

%% Helper: open a temporary connection, send request, get reply, close
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

%% out(+Tuple)
%  Adds Tuple to the Linda tuple space
out(Tuple) :-
    linda_request(out(Tuple), _Reply).

%% in_noblock(+Tuple)
%  Non-blocking in: removes Tuple from tuple space if present, fails otherwise
in_noblock(Tuple) :-
    linda_request(in_noblock(Tuple), Reply),
    Reply = found(Tuple).

%% in_noblock(+Tuple, -Result)
in_noblock(Tuple, Result) :-
    linda_request(in_noblock(Tuple), Reply),
    ( Reply = found(Result0) -> Result = Result0 ; fail ).

%% rd_noblock(+Tuple)
%  Non-blocking rd: reads Tuple from tuple space if present, fails otherwise
rd_noblock(Tuple) :-
    linda_request(rd_noblock(Tuple), Reply),
    Reply = found(Tuple).

%% rd_noblock(+Tuple, -Result)
rd_noblock(Tuple, Result) :-
    linda_request(rd_noblock(Tuple), Reply),
    ( Reply = found(Result0) -> Result = Result0 ; fail ).

%% bagof_rd_noblock(+Template, +Tuple, -Bag)
bagof_rd_noblock(Template, Tuple, Bag) :-
    linda_request(bagof_rd_noblock(Template, Tuple, Bag), Reply),
    Reply = found(Bag).

%% close_linda/0
close_linda :-
    retractall(linda_host_port(_, _)),
    retractall(linda_connected).
