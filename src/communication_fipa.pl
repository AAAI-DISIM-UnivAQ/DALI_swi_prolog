
:-dynamic receive/1.

:-dynamic send/2.

:-dynamic isa/3.

receive(send_message(Var_X,Var_Ag)):-told(Var_Ag,send_message(Var_X)),call_send_message(Var_X,Var_Ag).

receive(propose(Var_A,Var_C,Var_Ag)):-told(Var_Ag,propose(Var_A,Var_C)),
                                call_propose(Var_A,Var_C,Var_Ag).

receive(cfp(Var_A,Var_C,Var_Ag)):-told(Var_Ag,cfp(Var_A,Var_C)),
                                call_cfp(Var_A,Var_C,Var_Ag).


receive(accept_proposal(Var_A,Var_Mp,Var_Ag)):-told(Var_Ag,accept_proposal(Var_A,Var_Mp),Var_T),
                                call_accept_proposal(Var_A,Var_Mp,Var_Ag,Var_T).

receive(reject_proposal(Var_A,Var_Mp,Var_Ag)):-told(Var_Ag,reject_proposal(Var_A,Var_Mp),Var_T),
                                call_reject_proposal(Var_A,Var_Mp,Var_Ag,Var_T).

receive(failure(Var_A,Var_M,Var_Ag)):-told(Var_Ag,failure(Var_A,Var_M),Var_T),
                                call_failure(Var_A,Var_M,Var_Ag,Var_T).

receive(cancel(Var_A,Var_Ag)):-told(Var_Ag,cancel(Var_A)),
                                call_cancel(Var_A,Var_Ag).


receive(execute_proc(Var_X,Var_Ag)):-told(Var_Ag,execute_proc(Var_X)),call_execute_proc(Var_X,Var_Ag).

receive(query_ref(Var_X,Var_N,Var_Ag)):-told(Var_Ag,query_ref(Var_X,Var_N)),call_query_ref(Var_X,Var_N,Var_Ag).

receive(inform(Var_X,Var_M,Var_Ag)):-told(Var_Ag,inform(Var_X,Var_M),Var_T),call_inform(Var_X,Var_Ag,Var_M,Var_T).

receive(inform(Var_X,Var_Ag)):-told(Var_Ag,inform(Var_X),Var_T),call_inform(Var_X,Var_Ag,Var_T).

receive(refuse(Var_X,Var_Ag)):-told(Var_Ag,refuse(Var_X),Var_T),call_refuse(Var_X,Var_Ag,Var_T).

receive(agree(Var_X,Var_Ag)):-told(Var_Ag,agree(Var_X)),call_agree(Var_X,Var_Ag).

receive(confirm(Var_X,Var_Ag)):-told(Var_Ag,confirm(Var_X),Var_T),call_confirm(Var_X,Var_Ag,Var_T).

receive(disconfirm(Var_X,Var_Ag)):-told(Var_Ag,disconfirm(Var_X)),call_disconfirm(Var_X,Var_Ag).

receive(reply(Var_X,Var_Ag)):-told(Var_Ag,reply(Var_X)).

send(Var_To,query_ref(Var_X,Var_N,Var_Ag)):-tell(Var_To,Var_Ag,query_ref(Var_X,Var_N)),send_m(Var_To,query_ref(Var_X,Var_N,Var_Ag)).

send(Var_To,send_message(Var_X,Var_Ag)):-tell(Var_To,Var_Ag,send_message(Var_X)),send_m(Var_To,send_message(Var_X,Var_Ag)).

send(Var_To,reject_proposal(Var_X,Var_L,Var_Ag)):-tell(Var_To,Var_Ag,reject_proposal(Var_X,Var_L)),send_m(Var_To,reject_proposal(Var_X,Var_L,Var_Ag)).

send(Var_To,accept_proposal(Var_X,Var_L,Var_Ag)):-tell(Var_To,Var_Ag,accept_proposal(Var_X,Var_L)),send_m(Var_To,accept_proposal(Var_X,Var_L,Var_Ag)).

send(Var_To,confirm(Var_X,Var_Ag)):-tell(Var_To,Var_Ag,confirm(Var_X)),send_m(Var_To,confirm(Var_X,Var_Ag)).

send(Var_To,propose(Var_X,Var_C,Var_Ag)):-tell(Var_To,Var_Ag,propose(Var_X,Var_C)),send_m(Var_To,propose(Var_X,Var_C,Var_Ag)).

send(Var_To,disconfirm(Var_X,Var_Ag)):-tell(Var_To,Var_Ag,disconfirm(Var_X)),send_m(Var_To,disconfirm(Var_X,Var_Ag)).

send(Var_To,inform(Var_X,Var_M,Var_Ag)):-tell(Var_To,Var_Ag,inform(Var_X,Var_M)),send_m(Var_To,inform(Var_X,Var_M,Var_Ag)).

send(Var_To,inform(Var_X,Var_Ag)):-tell(Var_To,Var_Ag,inform(Var_X)),send_m(Var_To,inform(Var_X,Var_Ag)).

send(Var_To,refuse(Var_X,Var_Ag)):-tell(Var_To,Var_Ag,refuse(Var_X)),send_m(Var_To,refuse(Var_X,Var_Ag)).

send(Var_To,failure(Var_X,Var_M,Var_Ag)):-tell(Var_To,Var_Ag,failure(Var_X,Var_M)),send_m(Var_To,failure(Var_X,Var_M,Var_Ag)).

send(Var_To,execute_proc(Var_X,Var_Ag)):-tell(Var_To,Var_Ag,execute_proc(Var_X)),send_m(Var_To,execute_proc(Var_X,Var_Ag)).

send(Var_To,agree(Var_X,Var_Ag)):-tell(Var_To,Var_Ag,agree(Var_X)),send_m(Var_To,agree(Var_X,Var_Ag)).


call_send_message(Var_X,Var_Ag):-send_message(Var_X,Var_Ag).
call_execute_proc(Var_X,Var_Ag):-execute_proc(Var_X,Var_Ag).


call_query_ref(Var_X,Var_N,Var_Ag):-clause(agent(Var_A),_),not(var(Var_X)),meta_ref(Var_X,Var_N,Var_L,Var_Ag),a(message(Var_Ag,inform(query_ref(Var_X,Var_N),values(Var_L),Var_A))).

call_query_ref(Var_X,_,Var_Ag):-clause(agent(Var_A),_),var(Var_X),a(message(Var_Ag,refuse(query_ref(variable),motivation(refused_variables),Var_A))).

call_query_ref(Var_X,Var_N,Var_Ag):-clause(agent(Var_A),_),not(var(Var_X)),not(meta_ref(Var_X,Var_N,_,_)),a(message(Var_Ag,inform(query_ref(Var_X,Var_N),motivation(no_values),Var_A))).

call_agree(Var_X,Var_Ag):-clause(agent(Var_A),_),ground(Var_X),meta_agree(Var_X,Var_Ag),a(message(Var_Ag,inform(agree(Var_X),values(yes),Var_A))).

call_confirm(Var_X,Var_Ag,Var_T):-ground(Var_X),get_time(_WallStampF1_), Var_Tp is truncate(_WallStampF1_*1000),
asse_cosa(past_event(Var_X,Var_T)),retractall(past(Var_X,Var_Tp,Var_Ag)),assert(past(Var_X,Var_Tp,Var_Ag)).

call_disconfirm(Var_X,Var_Ag):-ground(Var_X),retractall(past(Var_X,_,Var_Ag)),
                               retractall(past_event(Var_X,_)).

call_agree(Var_X,Var_Ag):-clause(agent(Var_A),_),ground(Var_X),not(meta_agree(Var_X,_)),a(message(Var_Ag,inform(agree(Var_X),values(no),Var_A))).

call_agree(Var_X,Var_Ag):-clause(agent(Var_A),_),not(ground(Var_X)),a(message(Var_Ag,refuse(agree(variable),motivation(refused_variables),Var_A))).

call_inform(Var_X,Var_Ag,Var_M,Var_T):-
asse_cosa(past_event(inform(Var_X,Var_M,Var_Ag),Var_T)),get_time(_WallStampF2_), Var_Tp is truncate(_WallStampF2_*1000),retractall(past(inform(Var_X,Var_M,Var_Ag),_,Var_Ag)),
assert(past(inform(Var_X,Var_M,Var_Ag),Var_Tp,Var_Ag)).

call_inform(Var_X,Var_Ag,Var_T):-
asse_cosa(past_event(inform(Var_X,Var_Ag),Var_T)),get_time(_WallStampF3_), Var_Tp is truncate(_WallStampF3_*1000),retractall(past(inform(Var_X,Var_Ag),_,Var_Ag)),
assert(past(inform(Var_X,Var_Ag),Var_Tp,Var_Ag)).

call_refuse(Var_X,Var_Ag,Var_T):-clause(agent(Var_A),_),asse_cosa(past_event(Var_X,Var_T)),get_time(_WallStampF4_), Var_Tp is truncate(_WallStampF4_*1000),retractall(past(Var_X,_,Var_Ag)),assert(past(Var_X,Var_Tp,Var_Ag)),a(message(Var_Ag,reply(received(Var_X),Var_A))).


call_cfp(Var_A,Var_C,Var_Ag):-clause(agent(Var_AgI),_),
                                  clause(ext_agent(Var_Ag,_,Var_Ontology,_),_),
                                  asserisci_ontologia(Var_Ag,Var_Ontology,Var_A),
                                  once(call_meta_execute_cfp(Var_A,Var_C,Var_Ag,B)),
                                  a(message(Var_Ag,propose(Var_A,[B],Var_AgI))),
                                  retractall(ext_agent(Var_Ag,_,Var_Ontology,_)).




call_propose(Var_A,Var_C,Var_Ag):-clause(agent(Var_AgI),_),
                                  clause(ext_agent(Var_Ag,_,Var_Ontology,_),_),
                                  asserisci_ontologia(Var_Ag,Var_Ontology,Var_A),
                                  once(call_meta_execute_propose(Var_A,Var_C,Var_Ag)),
                                  a(message(Var_Ag,accept_proposal(Var_A,[],Var_AgI))),
                                  retractall(ext_agent(Var_Ag,_,Var_Ontology,_)).

call_propose(Var_A,Var_C,Var_Ag):-clause(agent(Var_AgI),_),
                            clause(ext_agent(Var_Ag,_,Var_Ontology,_),_),
                            not(call_meta_execute_propose(Var_A,Var_C,Var_Ag)),
                            a(message(Var_Ag,reject_proposal(Var_A,[],Var_AgI))),
                            retractall(ext_agent(Var_Ag,_,Var_Ontology,_)).

call_accept_proposal(Var_A,Var_Mp,Var_Ag,Var_T):-asse_cosa(past_event(accepted_proposal(Var_A,Var_Mp,Var_Ag),Var_T)),get_time(_WallStampF5_), Var_Tp is truncate(_WallStampF5_*1000),
retractall(past(accepted_proposal(Var_A,Var_Mp,Var_Ag),_,Var_Ag)),
assert(past(accepted_proposal(Var_A,Var_Mp,Var_Ag),Var_Tp,Var_Ag)).

call_reject_proposal(Var_A,Var_Mp,Var_Ag,Var_T):-asse_cosa(past_event(rejected_proposal(Var_A,Var_Mp,Var_Ag),Var_T)),get_time(_WallStampF6_), Var_Tp is truncate(_WallStampF6_*1000),retractall(past(rejected_proposal(Var_A,Var_Mp,Var_Ag),_,Var_Ag)),assert(past(rejected_proposal(Var_A,Var_Mp,Var_Ag),Var_Tp,Var_Ag)).

call_failure(Var_A,Var_M,Var_Ag,Var_T):-asse_cosa(past_event(failed_action(Var_A,Var_M,Var_Ag),Var_T)),get_time(_WallStampF7_), Var_Tp is truncate(_WallStampF7_*1000),retractall(past(failed_action(Var_A,Var_M,Var_Ag),_,Var_Ag)),assert(past(failed_action(Var_A,Var_M,Var_Ag),Var_Tp,Var_Ag)).

call_cancel(Var_A,Var_Ag):-if(clause(high_action(Var_A,Var_Te,Var_Ag),_),retractall(high_action(Var_A,Var_Te,Var_Ag)),true),if(clause(normal_action(Var_A,Var_Te,Var_Ag),_),retractall(normal_action(Var_A,Var_Te,Var_Ag)),true).



% PROCEDURE DI APPOGGIO
%ACTIONS PROPOSE

external_refused_action_propose(Var_A,Var_Ag):-clause(not_executable_action_propose(Var_A,Var_Ag),_).

evi(external_refused_action_propose(Var_A,Var_Ag)):-clause(agent(Var_Ai),_),
                           a(message(Var_Ag, failure(Var_A,motivation(false_conditions),Var_Ai))),
                           retractall(not_executable_action_propose(Var_A,Var_Ag)).


refused_message(Var_AgM,Var_Con):-clause(eliminated_message(Var_AgM,_,_,Var_Con,_),_).
refused_message(Var_To,Var_M):-clause(eliminated_message(Var_M,Var_To,motivation(conditions_not_verified)),_).
evi(refused_message(Var_AgM,Var_Con)):-clause(agent(Var_Ai),_),
             a(message(Var_AgM, inform(Var_Con,motivation(refused_message),Var_Ai))),
                           retractall(eliminated_message(Var_AgM,_,_,Var_Con,_)),
retractall(eliminated_message(Var_Con,Var_AgM,motivation(conditions_not_verified))).

%RITORNO MESSAGGIO JASPER
send_jasper_return_message(Var_X,Var_S,Var_T,Var_S0):-clause(agent(Var_Ag),_),a(message(Var_S, send_message(sent_rmi(Var_X,Var_T,Var_S0),Var_Ag))).


