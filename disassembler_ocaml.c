// disassembly_ocaml.c
// Copyright (C) 2013 Carl Pulley <c.j.pulley@hud.ac.uk>
//
// This program is free software; you can redistribute it and/or modify
// it under the bitcodes of the GNU General Public License as published by
// the Free Software Foundation; either version 2 of the License, or (at
// your option) any later version.
//
// This program is distributed in the hope that it will be useful, but
// WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
// General Public License for more details. 
//
// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA 

#include <stdlib.h>
#include <stdio.h>

#include <caml/mlvalues.h>
#include <caml/memory.h>
#include <caml/alloc.h>
#include <caml/callback.h>
#include <caml/fail.h>
#include <caml/custom.h>

#include "llvm-c/Target.h"
#include "llvm-c/Disassembler.h"

// Copied from https://github.com/ocamllabs/ocaml-ctypes/commit/6ede17ae0749d4660bbb27719ad2c523e616ae24#src/unsigned_stubs.h
#include "ctypes_unsigned_stubs.h"

// string -> LLVMDisasmContextRef
CAMLprim LLVMDisasmContextRef llvm_create_disasm(value triple) {
	return LLVMCreateDisasm(String_val(triple), NULL, 0, NULL, NULL);
}

// LLVMDisasmContextRef -> unit
CAMLprim value llvm_dispose_disasm(LLVMDisasmContextRef dc) {
	LLVMDisasmDispose(dc);

	return Val_unit;
}

// LLVMDisasmContextRef -> string -> UInt64.t -> int * string
CAMLprim value llvm_disasm_instruction(LLVMDisasmContextRef dc, value v_source, value v_pc) {
	uint8_t* bytes;
	int bytes_len;
	char out_str[255];
	size_t size;
	uint64_t pc;

	CAMLparam2(v_source, v_pc);
	CAMLlocal2(v_result, v_out_str);

	bytes = (uint8_t*)String_val(v_source);
	bytes_len = caml_string_length(v_source);
	pc = Uint64_val(v_pc);

	if (bytes_len == 0) {
		v_result = alloc_tuple(2);
		Field(v_result, 0) = Val_int(0);
		v_out_str = copy_string("");
		Field(v_result, 1) = v_out_str;

		CAMLreturn(v_result);
	}

	size = LLVMDisasmInstruction(dc, bytes, bytes_len, pc, out_str, 255);
	
	v_result = alloc_tuple(2);
	Field(v_result, 0) = Val_int(size);
	if (size > 0) {
		v_out_str = copy_string(out_str);
	} else {
		v_out_str = copy_string("");
	}
	Field(v_result, 1) = v_out_str;

	CAMLreturn(v_result);
}
