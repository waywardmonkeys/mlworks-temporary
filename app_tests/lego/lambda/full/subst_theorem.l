(*
 * Copyright 2013 Ravenbrook Limited <http://www.ravenbrook.com/>.
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are
 * met:
 * 
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
 * IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED
 * TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
 * PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 * HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
 * TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 * PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * $Log: subst_theorem.l,v $
 * Revision 1.1  1998/08/06 10:36:11  jont
 * new unit
 * Lego test application
 *
 *
 *)
Goal
 {ve1|val_env}{e'|exp}{esafe:safe e' ve1}
 {a|val}{s,s'|state}{e2_eval:sem ve1 s e' a s'}
 {ve2|val_env}{veq:ve_equiv ve1 ve2}
 {e|exp}{ve1',ve2'|val_env}
 {s1,s1',s2,s2'|state}{r1,r2|val}
 {eval1: sem (ve_append ve1' (extend_ve a ve1)) s1 e r1 s1'}
 {eval2: sem (ve_append ve2' ve2) s2 (sub e e' (ve_len ve2')) r2 s2'}
 {seq:state_equiv s1 s2}
 {veq': ve_equiv ve1' ve2'}
 and (equiv r1 r2)(state_equiv s1' s2');
Intros _________;

[iprop [e:exp] =
{ve1',ve2'|val_env}
{s1,s1',s2,s2'|state}
{r1,r2|val}
{eval1: sem (ve_append ve1' (extend_ve a ve1)) s1 e r1 s1'}
{eval2: sem (ve_append ve2' ve2) s2 (sub e e' (ve_len ve2')) r2 s2'}
{seq:state_equiv s1 s2}
{veq': ve_equiv ve1' ve2'}
and (equiv r1 r2)(state_equiv s1' s2')];
Refine exp_elim iprop [el:explist]forall_explist el iprop;

(* Numbers *)
intros;
Expand iprop;
intros;
Refine extract_num eval1;intros;
Refine extract_num eval2;intros;
Qrepl H;Qrepl H1;Qrepl H2;Qrepl H3;
andI;
Refine equiv_eq;
Refine Q_refl;
Refine seq;

(* Variables *)
intros;
Expand iprop;
intros _________;
Refine extract_var eval1;
intros __;
Qrepl H;Qrepl H1;
Refine lt_complete v (ve_len ve2');

(* local variable *)
intros _;
Qrepl sub_thm_less H2 e';
intros;
Refine cut (extract_var eval2);
Refine and_elim;intros;
Qrepl H3;Qrepl H4;
andI;
Qrepl append_lookup_thm_less H2 ve2;
Claim is_tt (lt v (ve_len ve1'));
Qrepl append_lookup_thm_less ?+2 (extend_ve a ve1);
Refine ve_equiv_thm veq';
Refine seq;
Qrepl equiv_len_thm veq';
Refine H2;

(* Case equal -- the substituted variable *)
intros _;
Qrepl sub_thm_equal H2 e';
intros;
Refine lift_lemma veq seq;
Refine e';
Refine ve2';
Claim is_tt (neq v (ve_len ve1'));
Qrepl append_lookup_thm_equal ?+2 a ve1;
Refine safe_theorem esafe e2_eval;
Refine eval2;
Qrepl equiv_len_thm veq';
Refine H2;

(* Case greater -- its a "global" variable *)
Intros _;
Qrepl sub_thm_greater H2 e';
intros;
Refine cut (extract_var eval2);
Refine and_elim;intros;
Qrepl H3;Qrepl H4;andI;
Refine equiv_trans;
Next +1;
Refine equiv_eq;
Refine append_lookup_thm_gt;
Qrepl equiv_len_thm veq';
Refine H2;
Refine ve_equiv_thm;
Refine append_equiv_thm;
Refine veq';
Refine veq;
Refine seq;

(* Applications *)
intros;Expand iprop;intros _________;
Claim Q (sub (app f arg) e' (ve_len ve2'))(app (sub f e' (ve_len ve2'))(sub arg e' (ve_len ve2')));
Qrepl ?+1;Next +1;Refine Q_refl;
intros;
Refine extract_app eval1;intros ____;Refine and3_elim;intros;
Refine extract_app eval2;intros ____;Refine and3_elim;intros;
Refine equiv_app H2 H5;
Claim and ? ?;
Refine +1 and1 ?+5;
Refine +1 and2 ?+3;
Next +1;Refine arg_ih H1 H4;Immed;
Claim and ? ?;Refine and2 ?+4;Refine and1 ?+2;
Refine f_ih H H3;Immed;

(* Abstractions *)
intros;Expand iprop;
Intros _________;
Claim Q (sub (fn body) e' (ve_len ve2')) (fn (sub body e' (S (ve_len ve2'))));
Qrepl ?+1;Next +1;Refine Q_refl;
intros;
Refine extract_fn eval1;intros;
Refine extract_fn eval2;intros;
Qrepl H;Qrepl H1;Qrepl H2;Qrepl H3;
andI;Refine +1 seq;
Refine equiv_intro;
intros;
apply_thm H4;
Refine cut (apply_thm H4);intros;
Refine cut (apply_thm H5);intros;
Refine body_ih;
Refine extend_ve x1 ve1';
Refine extend_ve x2 ve2';
Refine s11;
Refine s21;
Qrepl append_thm x1 ve1' (extend_ve a ve1);
Refine H8;
Qrepl append_thm x2 ve2' ve2;
Refine H9;
Refine H7;
andI;
Refine H6;
Refine veq';

(* Letrec *)
intros;Expand iprop;intros _________;
Qrepl letrec_sub fl body e' (ve_len ve2');
intros;Refine cut (extract_letrec eval1);
intros;Refine cut (extract_letrec eval2);
intros;
Refine body_ih;
Refine +2 s1;
Refine +2 s2;
Refine ve_append ? ?;
Refine +1 ve1';
Next +2;
Qrepl Q_sym (append_assoc ?+1 ve1' (extend_ve a ve1));
Refine H;
Refine ve_append;
Next +2;
Qrepl (Q_sym (append_assoc ?+1 ?+2 ve2));
Claim Q (ve_len (ve_append ?+1 ?+2)) (add (el_length fl) (ve_len ve2'));
Qrepl ?+5;
Refine H1;
Refine seq;
Refine append_equiv_thm;
Refine +1 veq';
Refine rec_thm;
Next +1;
intros;
Refine explist_elim1[el:explist](forall_explist el iprop)->
(ve_equiv (nonrecextend (ve_append ve1' (extend_ve a ve1)) (explist_to_expLL el) ve11) (nonrecextend (ve_append ve2' ve2) (explist_to_expLL (explist_sub el e' (S (add (el_length fl) (ve_len ve2'))))) ve1'1));
intros;
Refine empty_ve_equiv;
intros;
andI;
Next +1;
Refine cdr_ih;
Refine H5;
intros;
Refine H7;
Refine equiv_intro;
intros;
Refine cut (apply_thm H6);intros;
Refine cut (apply_thm H7);intros;
Refine H5;intros;
Refine H12;
Refine (extend_ve x1 (ve_append ve11 ve1'));
Refine extend_ve x2 (ve_append ve1'1 ve2');
Refine s11;
Refine s21;
Qrepl append_thm x1 (ve_append ve11 ve1')(extend_ve a ve1);
Qrepl Q_sym (append_assoc ve11 ve1' (extend_ve a ve1));
Refine H10;
Qrepl append_thm x2 (ve_append ve1'1 ve2') ve2;
Qrepl Q_sym (append_assoc ve1'1 ve2' ve2);
Claim Q (ve_len (extend_ve x2 (ve_append ve1'1 ve2'))) (S (add (el_length fl) (ve_len ve2')));
Qrepl ?+3;
Refine H11;
Refine H9;
andI;
Refine H8;
Refine append_equiv_thm;
Refine H4;
Refine veq';
Refine Q_resp S;
Refine Q_trans;
Next +1;
Refine ve_append_len_thm;
Qrepl (Q_sym H3);
Qrepl H2;
Refine Q_refl;
Refine fl_ih;
Qrepl explist_sub_len_thm fl e' (S (add (el_length fl) (ve_len ve2')));
Refine Q_refl;
Qrepl ve_append_len_thm (recextend (ve_append ve2' ve2) (explist_to_expLL (explist_sub fl e' (S (add (el_length fl) (ve_len ve2')))))) ve2';
Qrepl recextend_len (ve_append ve2' ve2)(explist_to_expLL (explist_sub fl e' (S (add (el_length fl) (ve_len ve2')))));
Qrepl explist_sub_len_thm fl e' (S (add (el_length fl) (ve_len ve2')));
Refine Q_refl;

(* Bopapp *)
intros;Expand iprop;intros _________;
Qrepl bopapp_sub b arg e' (ve_len ve2');
Refine extract_bopapp eval1;intros __;Refine and_elim;intros;
Refine extract_bopapp eval2;intros __;Refine and_elim;intros;
Refine bopapp_equiv H1 H3;
Claim and ? ?;Refine and1 ?+4;Refine and2 ?+2;
Refine arg_ih H H2 seq veq';

(* Tuple *)
intros;Expand iprop;intros _________;
Qrepl tuple_sub vl e' (ve_len ve2');
intros;
Refine extract_tuple eval1;
intros _;
Refine and_elim;intros;
Refine extract_tuple eval2;Intros _;Refine and_elim;intros;
Refine explist_elim1[el:explist](forall_explist el iprop)->
{s1,s2,t,t1:state}
{s3,s4:val_env}
(state_equiv s1 s2) ->
(sem_list (ve_append ve1' (extend_ve a ve1)) s1 el s3 t) ->
(sem_list (ve_append ve2' ve2) s2 (explist_sub el e' (ve_len ve2')) s4 t1) ->
 and (ve_equiv s3 s4) (state_equiv t t1);
intros;
Qrepl sem_list_nil_vl H6;
Qrepl sem_list_nil_vl H7;
Qrepl Q_sym (sem_list_nil_state H6);
Qrepl Q_sym (sem_list_nil_state H7);
andI;
Refine empty_ve_equiv;
Refine H5;
intros;
Refine extract_list H6;
intros ___;
Refine and3_elim;intros;
Refine extract_list H7;Intros ___;Refine and3_elim;intros;
Qrepl H8;Qrepl H11;
andI;
Refine extend_equiv;
Claim and ? ?;Refine and1 ?+5;
Next +1;
Refine and2 ?+3;
Next +1;
Refine cdr_ih;
Refine +4 H10;
Refine +3 H13;
Refine H4;
intros;
Refine H15;
Claim and ? ?;Refine and2 ?+4;Refine and1 ?+2;
Refine H4;
intros;
Refine H14;
Refine +4 H9;
Refine +2 H12;
Refine H5;
Refine veq';
Refine vl;Refine vl_ih;
Refine +7 H1;
Refine +4 H3;
Refine seq;
intros;
andI;
Qrepl H;Qrepl H2;
Refine tuple_equiv;
Refine H4;
Refine H5;

(* expnil *)
Refine true;

(* expcons *)
intros;
andI;
Refine car_ih;
Refine cdr_ih;

Save subst_theorem;
