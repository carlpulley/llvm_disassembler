open OUnit
open Unsigned
open BatOption

let dc = ref None

let setup _ = 
  dc := Some(Llvm_disassembler.create "i386-unknown-linux-gnu")

let teardown _ = 
  Llvm_disassembler.dispose(get !dc);
  dc := None

let test_disasm_inc1 () =
  let size, instr = Llvm_disassembler.get_instruction (get !dc) "AAAA" (UInt64.of_int 0xd4) in
    assert_equal size 1;
    assert_equal instr "\tincl\t%ecx"

let test_disasm_inc4 () =
  let result = BatLazyList.to_list(Llvm_disassembler.get_instructions (get !dc) "AAAA" (UInt64.of_int 0xd4)) in
    assert_equal (List.length result) 4;
    List.iteri 
      (fun o (a, s, i) ->
        assert_equal a (UInt64.of_int(o + 0xd4));
        assert_equal s 1;
        assert_equal i "\tincl\t%ecx"
      )
      result

let suite = "OUnit Llvm_disassembler tests" >::: [
  "test_disasm_inc1" >:: (bracket setup test_disasm_inc1 teardown);
  "test_disasm_inc4" >:: (bracket setup test_disasm_inc4 teardown)
]

let _ =
  run_test_tt_main suite
