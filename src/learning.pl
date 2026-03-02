% Licensed with Apache Public License
% by AAAI Research Group
% Department of Information Engineering and Computer Science and Mathematics
% University of L'Aquila, ITALY
% http://www.disim.univaq.it

gest_learn(Var_H):-clause(past(learn(Var_H),Var_T,Var_U),_),learn_if(Var_H,Var_T,Var_U).
evi(gest_learn(Var_H)):-retractall(past(learn(Var_H),_,_)),
                        clause(agente(_,_,_,Var_S),_),
                        name(Var_S,Var_N),
                        append(Var_L,[46,112,108],Var_N),
                        name(Var_F,Var_L),
                        manage_lg(Var_H,Var_F),a(learned(Var_H)).



cllearn:- clause(agente(_,_,_,Var_S),_),
                           name(Var_S,Var_N),append(Var_L,[46,112,108],Var_N),
                           append(Var_L,[46,116,120,116],Var_To),
                           name(Var_FI,Var_To),
                           open(Var_FI,read,Stream,[]),
                           repeat,
                           read(Stream,Var_T),
                           arg(1,Var_T,Var_H),write(Var_H),nl,
                           Var_T==end_of_file,!,
                           close(Stream).



send_msg_learn(Var_T,Var_A,Var_Ag):-a(message(Var_Ag,confirm(learn(Var_T),Var_A))).


      