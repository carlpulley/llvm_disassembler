(* llvm_disassembly.mli                                                    *)
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

type t

(* [Disassembly.create triple] create a new disassembler using the gicen [triple]. 
	 See the constructor llvm::LLVMCreateDisasm. *)
external create: string -> t = "llvm_create_disasm"

(* [Disassembly.disasm_instruction source pc] disassemble an instruction from [source] starting at offset [pc].
	 See llvm::Disassembly::LLVMDisasmInstruction. *)
external disasm_instruction: t -> string -> UInt64.t -> int * string = "llvm_disasm_instruction"

(* Obtain the next instruction from an input source.

   The input source should be a str or bytearray or something that
   represents a sequence of bytes.

   This function will start reading bytes from the beginning of the
   source.

   The pc argument specifies the address that the first byte is at.

   This returns a 2-tuple of:

     int    number of bytes read. 0 if no instruction was read.
     string representation of instruction. This will be the assembly that
       represents the instruction.
*)
val get_instruction: t -> string -> UInt64.t -> int * string

(* Obtain multiple instructions from an input source.

   This is like get_instruction() except it is a lazy list of all the
   instructions within the source. It starts at the beginning of the
   source and reads instructions until no more can be read.

   Each member of the lazy list is a 3-tuple of:

     UInt64 address of instruction.
     int    size of instruction, in bytes.
     string representation of instruction.
*)
val get_instructions: t -> string -> UInt64.t -> (UInt64.t * int * string) BatLazyList.t
