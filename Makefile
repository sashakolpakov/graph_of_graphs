PYTHON ?= python3
LATEXMK ?= latexmk
WOLFRAM_KERNEL ?= /Applications/Wolfram.app/Contents/MacOS/WolframKernel

.PHONY: all papers check paper computational-notes lean python-check \
	notebook-data-check notebook notebook-paclet-check notebook-check \
	computational-notes-notebook computational-notes-notebook-check \
	rule-a-paper rule-a-paper-submission rule-a-paper-packages \
	integral-torsor integral-torsor-check \
	outer-space-paper outer-space-check outer-forest-check \
	bessel-recursion-paper bessel-recursion-check \
	history-state-paper history-state-check causal-order-paper causal-order-check clean

all: papers

papers: paper rule-a-paper computational-notes integral-torsor \
	outer-space-paper bessel-recursion-paper history-state-paper causal-order-paper

check: papers lean python-check notebook-data-check integral-torsor-check \
	outer-space-check bessel-recursion-check history-state-check causal-order-check

paper:
	$(LATEXMK) -pdf -interaction=nonstopmode -halt-on-error whitehead-field-dynamics.tex

computational-notes:
	$(LATEXMK) -pdf -interaction=nonstopmode -halt-on-error \
		whitehead-field-dynamics-computational-notes.tex

rule-a-paper:
	$(MAKE) -C rule-a-paper all

rule-a-paper-submission:
	$(MAKE) -C rule-a-paper submission

rule-a-paper-packages:
	$(MAKE) -C rule-a-paper packages

integral-torsor:
	$(MAKE) -C integral-torsor-paper all

integral-torsor-check:
	$(MAKE) -C integral-torsor-paper check

outer-space-paper:
	$(MAKE) -C outer-space-paper all

outer-space-check:
	$(MAKE) -C outer-space-paper check

bessel-recursion-paper:
	$(MAKE) -C bessel-recursion-paper all

bessel-recursion-check:
	$(MAKE) -C bessel-recursion-paper check

history-state-paper:
	$(MAKE) -C history-state-paper all

history-state-check:
	$(MAKE) -C history-state-paper check

causal-order-paper:
	$(MAKE) -C causal-order-paper all

causal-order-check:
	$(MAKE) -C causal-order-paper check

outer-forest-check:
	$(PYTHON) research/outer-forest-complex/check_forested_complex.py --max-rank 4
	$(PYTHON) research/outer-forest-complex/check_witness.py
	$(PYTHON) research/outer-forest-complex/check_backends.py

lean:
	cd lean && lake build

python-check:
	$(PYTHON) -m py_compile \
		gog_generate.py gog_ball_growth.py gog_degree_diagnostics.py \
		gog_edge_model_experiments.py gog_support_feature_analysis.py \
		scripts/build_small_gog_models.py rule-a-paper/verify_rule_a.py \
		rule-a-paper/render_rule_a_table.py history-state-paper/check_history_states.py \
		causal-order-paper/check_rank_ambiguity.py causal-order-paper/check_curvature.py

notebook-data-check:
	$(PYTHON) scripts/build_small_gog_models.py --check

notebook:
	"$(WOLFRAM_KERNEL)" -noinit -noprompt -script \
		scripts/build_math_notebook.wls

notebook-paclet-check:
	"$(WOLFRAM_KERNEL)" -noinit -noprompt -script \
		scripts/check_gog_paclet.wls

notebook-check: notebook-data-check notebook-paclet-check
	"$(WOLFRAM_KERNEL)" -noinit -noprompt -script \
		scripts/check_math_notebook.wls

computational-notes-notebook:
	"$(WOLFRAM_KERNEL)" -noinit -noprompt -script \
		scripts/build_computational_notes_notebook.wls

computational-notes-notebook-check: notebook-data-check
	"$(WOLFRAM_KERNEL)" -noinit -noprompt -script \
		scripts/check_computational_notes_notebook.wls

clean:
	$(LATEXMK) -c whitehead-field-dynamics.tex
	$(LATEXMK) -c whitehead-field-dynamics-computational-notes.tex
	$(MAKE) -C rule-a-paper clean
	$(MAKE) -C integral-torsor-paper clean
	$(MAKE) -C outer-space-paper clean
	$(MAKE) -C bessel-recursion-paper clean
	$(MAKE) -C history-state-paper clean
	$(MAKE) -C causal-order-paper clean
