(* llvm_disassembly.ml                                                     *)
(* Copyright (C) 2013 Carl Pulley <c.j.pulley@hud.ac.uk>                   *)
(*                                                                         *)
(* This program is free software; you can redistribute it and/or modify    *)
(* it under the terms of the GNU General Public License as published by    *)
(* the Free Software Foundation; either version 2 of the License, or (at   *)
(* your option) any later version.                                         *)
(*                                                                         *)
(* This program is distributed in the hope that it will be useful, but     *)
(* WITHOUT ANY WARRANTY; without even the implied warranty of              *)
(* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU        *)
(* General Public License for more details.                                *)
(*                                                                         *)
(* You should have received a copy of the GNU General Public License       *)
(* along with this program; if not, write to the Free Software             *)
(* Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA *)

open Unsigned

module Disassembly =
struct
	open BatLazyList

	type t

	external create: string -> t = "llvm_create_disasm"
	external disasm_instruction: t -> string -> UInt64.t -> int * string = "llvm_disasm_instruction"

	let get_instruction disassembler source pc =
		disasm_instruction disassembler source pc

	let rec get_instructions disassembler source pc =
		if source = "" then
			nil
		else
			let size, instr = disasm_instruction disassembler source pc in
			let next_pc = UInt64.add pc (UInt64.of_int size) in
				if size = 0 then
					nil
				else
					(pc, size, instr) ^:^ (get_instructions disassembler (String.sub source 0 size) next_pc)
end
