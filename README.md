distorm
=======

OCaml bindings to the LLVM Disassembler (http://llvm.org/).

First ensure that LLVM 3.2 is built and installed with:
  * opam install llvm

TODO: Currently, you'll need to manually edit _oasis and change the CCLib field of the 
test (Executable) section for your target installation (sorry, $pkg_llvm/.. wasn't 
working for myself!).

To build:
  1. oasis setup
  2. ocaml setup.ml -configure
  3. ocaml setup.ml -build
  4. [optional] ocaml setup.ml -test
  5. ocaml setup.ml -install
