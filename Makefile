# - The -I flag introduces sub-directories
# - -use-ocamlfind is required to find packages (from Opam)
# - _tags file introduces packages, bin_annot flag for tool chain

.PHONY: all clean byte native

OCB_FLAGS = -use-ocamlfind -I src
OCB = ocamlbuild $(OCB_FLAGS)

all: native byte

clean:
	$(OCB) -clean

native:
	$(OCB) constants.native
	$(OCB) block.native
	$(OCB) blockchain.native
	$(OCB) main.native

byte:
	$(OCB) constants.byte
	$(OCB) block.byte
	$(OCB) blockchain.byte
	$(OCB) main.byte
