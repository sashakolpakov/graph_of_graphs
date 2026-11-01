PYTHON ?= python3
LATEXMK ?= latexmk
TABLE_JSON := rule-a-enumeration.json
TABLE_TEX := rule-a-enumeration-table.tex
ARXIV_ARCHIVE ?= ../rule-a-paper-arxiv.tar.gz
FIGURE_TEX := fig-whitehead-move.tex fig-two-state-chain.tex \
	fig-loop-change.tex fig-bridge-resolution.tex
FIGURE_PDF := $(FIGURE_TEX:.tex=.pdf)
MANUSCRIPT_FILES := local-whitehead-chain.tex local-whitehead-chain.bib \
	local-whitehead-chain.bbl $(TABLE_TEX) $(FIGURE_PDF)
INTERMEDIATE_EXT := aux bcf blg dvi fdb_latexmk fls lof log lot out \
	run.xml synctex synctex.gz toc xdv

.PHONY: all figures table arxiv submission packages clean

all: arxiv

figures: $(FIGURE_PDF)

table: $(TABLE_TEX)

$(TABLE_TEX): $(TABLE_JSON) render_rule_a_table.py
	$(PYTHON) render_rule_a_table.py $(TABLE_JSON) $(TABLE_TEX)

fig-%.pdf: fig-%.tex
	@set -eu; \
	build_dir=$$(mktemp -d); \
	trap 'rm -rf "$$build_dir"' 0; \
	$(LATEXMK) -pdf -interaction=nonstopmode -halt-on-error \
		-outdir="$$build_dir" "$<"; \
	cp "$$build_dir/$@" "$@"

arxiv: $(TABLE_TEX) $(FIGURE_PDF)
	@set -eu; \
	build_dir=$$(mktemp -d); \
	trap 'rm -rf "$$build_dir"' 0; \
	$(LATEXMK) -pdf -interaction=nonstopmode -halt-on-error \
		-outdir="$$build_dir" local-whitehead-chain.tex; \
	cp "$$build_dir/local-whitehead-chain.pdf" \
		"$$build_dir/local-whitehead-chain.bbl" .; \
	rm -f "$(ARXIV_ARCHIVE)"

submission: all
	@set -eu; \
	stage_dir=$$(mktemp -d); \
	trap 'rm -rf "$$stage_dir"' 0; \
	mkdir "$$stage_dir/anc"; \
	cp $(MANUSCRIPT_FILES) "$$stage_dir/"; \
	cp ../gog_generate.py verify_rule_a.py ../build_nauty_bridge.py \
		../gog_nauty_bridge.c render_rule_a_table.py $(TABLE_JSON) \
		"$$stage_dir/anc/"; \
	cp REPRODUCIBILITY.md "$$stage_dir/anc/README.md"; \
	rm -rf ../rule-a-paper-arxiv; \
	mv "$$stage_dir" ../rule-a-paper-arxiv

packages: submission
	COPYFILE_DISABLE=1 tar -czf "$(ARXIV_ARCHIVE)" \
		-C ../rule-a-paper-arxiv $(MANUSCRIPT_FILES) anc

clean:
	rm -f $(foreach stem,local-whitehead-chain $(FIGURE_TEX:.tex=),\
		$(addprefix $(stem).,$(INTERMEDIATE_EXT))) .DS_Store
	rm -rf __pycache__
