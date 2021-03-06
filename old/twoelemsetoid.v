(* Copyright © 1998-2006
 * Henk Barendregt
 * Luís Cruz-Filipe
 * Herman Geuvers
 * Mariusz Giero
 * Rik van Ginneken
 * Dimitri Hendriks
 * Sébastien Hinderer
 * Bart Kirkels
 * Pierre Letouzey
 * Iris Loeb
 * Lionel Mamane
 * Milad Niqui
 * Russell O’Connor
 * Randy Pollack
 * Nickolay V. Shmyrev
 * Bas Spitters
 * Dan Synek
 * Freek Wiedijk
 * Jan Zwanenburg
 *
 * This work is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This work is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this work; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 *)

Require Export CSetoidFun.

Section p68E1b1.

(**
** Example of a setoid: setoids with two elements
*)

Inductive M1:Set :=
e1:M1 | u:M1.

Definition M1_eq :(Relation M1):= fun a => fun b => (a=b).

Definition M1_ap : (Crelation M1):= fun a => fun b => Not (a=b).

Lemma M1_ap_irreflexive: (irreflexive M1_ap).
Proof.
 intro x.
 unfold M1_ap.
 red.
 intuition.
Qed.

Lemma M1_ap_symmetric: (Csymmetric M1_ap).
Proof.
 unfold Csymmetric.
 unfold M1_ap.
 red.
 intuition.
Qed.

Lemma M1_ap_cotransitive:  (cotransitive M1_ap).
Proof.
 unfold cotransitive.
 unfold M1_ap.
 unfold Not.
 intros x y H z.
 induction x.
  induction y.
   intuition.
  induction z.
   intuition.
  intuition.
 induction y.
  induction z.
   intuition.
  intuition.
 intuition.
Qed.

Lemma M1_eq_dec: forall(x:M1),(M1_eq x e1) or (M1_eq x u).
Proof.
 intros x.
 induction x.
  left.
  unfold M1_eq.
  reflexivity.
 right.
 unfold M1_eq.
 reflexivity.
Qed.

Definition  is_e1 (x:M1):Prop :=
match x with
|e1 => True
|u => False
end.

Lemma not_M1_eq_e1_u:Not (M1_eq e1 u).
Proof.
 red.
 intros  H.
 change (is_e1 u).
 unfold M1_eq in H.
 rewrite<- H.
 exact I.
Qed.

Lemma M1_ap_tight: (tight_apart  M1_eq M1_ap).
Proof.
 unfold tight_apart.
 unfold M1_eq.
 unfold M1_ap.
 intros x y.
 split.
  induction x.
   induction y.
    intuition.
   unfold Not.
   intro H.
   cut (e1=u -> False).
    intuition.
   apply not_M1_eq_e1_u.
  induction y.
   2:intuition.
  2:unfold Not.
  2:intuition.
 unfold Not.
 intro H.
 cut (e1=u -> False ).
  intuition.
 apply not_M1_eq_e1_u.
Qed.

Definition M1_is_CSetoid:(is_CSetoid M1 M1_eq M1_ap) :=
(Build_is_CSetoid M1 M1_eq M1_ap M1_ap_irreflexive M1_ap_symmetric M1_ap_cotransitive M1_ap_tight).

Definition M1_as_CSetoid: CSetoid :=
(Build_CSetoid M1 M1_eq M1_ap M1_is_CSetoid).

Definition M1_mult (x:M1)(y:M1):M1:=
match x with
|e1 => y
|u => match y with
       |e1 => u
       |u => e1
       end
end.

Definition M1_CS_mult: M1_as_CSetoid -> M1_as_CSetoid -> M1_as_CSetoid.
Proof.
 simpl.
 exact M1_mult.
Defined.

Lemma M1_CS_mult_strext:(bin_fun_strext M1_as_CSetoid M1_as_CSetoid M1_as_CSetoid M1_CS_mult).
Proof.
 unfold bin_fun_strext.
 intros x1 x2 y1 y2.
 case x1.
  case x2.
   case y1.
    case y2.
     simpl.
     intuition.
    simpl.
    intuition.
   case y2.
    simpl.
    intuition.
   simpl.
   intuition.
  case y1.
   case y2.
    simpl.
    intuition.
   simpl.
   unfold M1_ap.
   unfold Not.
   intuition.
  case y2.
   simpl.
   unfold M1_ap.
   unfold Not.
   intuition.
  simpl.
  intro H.
  left.
  apply M1_ap_symmetric.
  exact H.
 case x2.
  case y1.
   case y2.
    simpl.
    intuition.
   simpl.
   unfold M1_ap.
   unfold Not.
   intuition.
  case y2.
   simpl.
   unfold M1_ap.
   unfold Not.
   intuition.
  simpl.
  intro H.
  left.
  apply M1_ap_symmetric.
  exact H.
 case y1.
  case y2.
   simpl.
   intuition.
  simpl.
  intro H.
  right.
  apply M1_ap_symmetric.
  exact H.
 case y2.
  simpl.
  intro H.
  right.
  apply M1_ap_symmetric.
  exact H.
 simpl.
 unfold M1_ap.
 unfold Not.
 intuition.
Qed.

Definition M1_mult_as_bin_fun:=
(Build_CSetoid_bin_fun M1_as_CSetoid M1_as_CSetoid M1_as_CSetoid M1_CS_mult M1_CS_mult_strext).

Definition M2_mult (x:M1)(y:M1):M1:=
match x with
|e1 => y
|u => u
end.

Definition M2_CS_mult: M1_as_CSetoid -> M1_as_CSetoid -> M1_as_CSetoid.
Proof.
 simpl.
 exact M2_mult.
Defined.

Lemma M2_CS_mult_strext: (bin_fun_strext M1_as_CSetoid M1_as_CSetoid M1_as_CSetoid M2_CS_mult).
Proof.
 unfold bin_fun_strext.
 intros x1 x2 y1 y2.
 case x1.
  case x2.
   case y1.
    case y2.
     simpl.
     intuition.
    simpl.
    intuition.
   case y2.
    simpl.
    intuition.
   simpl.
   intuition.
  case y1.
   case y2.
    simpl.
    intuition.
   simpl.
   intuition.
  case y2.
   simpl.
   unfold M1_ap.
   unfold Not.
   intuition.
  simpl.
  intuition.
 case x2.
  case y1.
   case y2.
    simpl.
    intuition.
   simpl.
   unfold M1_ap.
   unfold Not.
   intuition.
  case y2.
   simpl.
   intuition.
  simpl.
  unfold M1_ap.
  unfold Not.
  intuition.
 case y1.
  case y2.
   simpl.
   intuition.
  simpl.
  intuition.
 case y2.
  simpl.
  intuition.
 simpl.
 intuition.
Qed.

Definition M2_mult_as_bin_fun:=
  (Build_CSetoid_bin_fun M1_as_CSetoid M1_as_CSetoid M1_as_CSetoid
  M2_CS_mult M2_CS_mult_strext).

End p68E1b1.
