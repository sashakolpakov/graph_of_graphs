# Whitehead moves, periods and rewrite histories

This repository contains manuscripts in TeX and PDF, Wolfram notebooks,
and the code and data needed to reproduce their computations. There are
eight manuscripts, each with one PDF, and two notebooks.

## Manuscripts

| Source | PDF | Pages | Results |
|---|---|---:|---|
| [Local Whitehead chain](rule-a-paper/local-whitehead-chain.tex) | [PDF](rule-a-paper/local-whitehead-chain.pdf) | 20 | The stationary law of the local walk on cubic multigraphs, spectral bounds, exact loop and bridge formulas, and mixing lower bounds. |
| [Field dynamics](whitehead-field-dynamics.tex) | [PDF](whitehead-field-dynamics.pdf) | 31 | Pair averaging on evolving cubic graphs, finite consensus schedules and contraction estimates. |
| [Computational companion](whitehead-field-dynamics-computational-notes.tex) | [PDF](whitehead-field-dynamics-computational-notes.pdf) | 8 | Exact finite calculations accompanying the field-dynamics paper and notebooks. |
| [Quartic period torsor](integral-torsor-paper/integral-torsor.tex) | [PDF](integral-torsor-paper/integral-torsor.pdf) | 16 | A rank-two period system, its local series and finite Hermitian matrix integrals; classification of positive representations and selection of the strongest moment bounds. |
| [Outer space](outer-space-paper/outer-space.tex) | [PDF](outer-space-paper/outer-space.pdf) | 8 | Cubic refinement transfer, Euler-characteristic observables under the Whitehead stationary law, and an explicit Morita cycle/cocycle certificate. |
| [Bessel recursion](bessel-recursion-paper/bessel-recursion.tex) | [PDF](bessel-recursion-paper/bessel-recursion.pdf) | 8 | Identification of the Broadhurst–Roberts recursion with the inverse de Rham pairing, including resonance, and factorial-scaled integrality. |
| [Histories and states](history-state-paper/history-states.tex) | [PDF](history-state-paper/history-states.pdf) | 11 | Permutation-torsor presentations, schedule weights, a criterion for observations to inherit the history median, event-bit repairs and confluent systems with nontrivial state topology. |
| [Curvature from causal orders](causal-order-paper/causal-order.tex) | [PDF](causal-order-paper/causal-order.pdf) | 9 | Recovery of latent null ranks from unlabelled two-dimensional orders, optimal curvature estimation for positive smooth densities, and stability under the choice of realizer. |

Page counts refer to the included PDFs.

The local Whitehead paper continues the diameter work of Rafi–Tao and the
expansion and spectral work of Grave de Peralta–Kolpakov and Li. It determines
the stationary law for the multiplicity chain and proves explicit spectral
bounds and an exact conductance formula for the bridge cut. The field-dynamics
paper and computational companion develop pair averaging on the evolving
graphs.

The Outer space paper recovers the Euler characteristics of
Smillie–Vogtmann and Borinsky–Vogtmann through expectations under the same
stationary law, and gives a direct certificate for the first Morita class.

## Repository contents

Each manuscript has a build target. The later papers have separate folders;
the field-dynamics paper and its companion retain their original root paths.
Bibliographies, TeX figures and table sources are included.

The Python files at the root enumerate Whitehead moves and analyse the
resulting chains. Paper-specific checks and their exact data live beside
the manuscripts or under research/. The scripts/ directory builds and
checks the notebooks and their bundled models. Wolfram/ contains the local
Wolfram package; lean/ contains the finite algebraic verification.

Manuscript PDFs and both notebooks are tracked. LaTeX intermediates,
generated figure PDFs, submission archives, reference downloads, reasoning
notes and exploratory scripts remain local. README.md is the repository
guide; the paper reproduction notes and Wolfram package documentation live
beside their sources.

## Build and reproduce

Python 3.11 or later, LaTeX with latexmk, pdflatex and BibTeX, and
abbrvurl.bst are required. The tested Python package versions are recorded
in [requirements-repro.txt](requirements-repro.txt):

    python3 -m pip install -r requirements-repro.txt
    make papers

To build one paper:

    make paper
    make computational-notes
    make rule-a-paper
    make integral-torsor
    make outer-space-paper
    make bessel-recursion-paper
    make history-state-paper
    make causal-order-paper

The full check also needs Lean's lake command and the native nauty bridge.
With nauty/Traces installed, build the bridge first:

    python3 build_nauty_bridge.py

Then build the manuscripts, check the Lean identities and small-model
resource, and run the paper-specific exact computations:

    make check

Use the interpreter in which the dependencies were installed. It can be
selected explicitly with make check PYTHON=/path/to/python3.

Individual checks are also available:

    python3 rule-a-paper/verify_rule_a.py 8 --backend python --jobs 1
    make integral-torsor-check
    make outer-space-check
    make bessel-recursion-check
    make history-state-check
    make causal-order-check

The history check compares independent incidence and execution
enumerations, exhaustively tests 4,890 observation partitions, and checks
the additive criteria, repair sets and confluent counterexamples.
The Bessel checker compares the literal recursion, differential operator
and full connection elimination for 3 through 32 Bessel factors.
Quartic checks use exact rational arithmetic and Arb enclosures.
The Outer space checks include orientation signs, refinement
multiplicities and the cycle/cocycle certificate.
The causal-order checks enumerate 7,456 two-realizers and independently
verify the metric curvature, kernel identities and explicit examples.

[Lean sources](lean/GogVerification/Averaging.lean) verify the specified
finite averaging and permutation identities and consensus schedules over
the rationals. They do not formalize the full graph or probability
arguments. The toolchain is fixed in [lean/lean-toolchain](lean/lean-toolchain).

## Whitehead computations

Rule A chooses one of the 3N/2 edges and one of its two Whitehead
resolutions, retaining multiplicities; choosing a loop leaves the graph
unchanged. Its stationary distribution is proportional to the reciprocal
of the full incidence automorphism order, including loop flips and
parallel-edge permutations. Rule B gives each distinct nonself neighbour
probability 1/(3N) and stays put on the remaining ticks; its stationary
distribution is uniform on unlabelled classes.

The complete unlabelled class counts for N=2,4,6,8,10,12,14 are
2, 5, 17, 71, 388, 2592, 21096.
For a small complete run:

    mkdir -p artifacts/csv
    python3 gog_generate.py 8 --backend auto --jobs 1 \
      --save artifacts/gog_N8.json \
      --save-transitions artifacts/transitions_N8.json
    python3 gog_edge_model_experiments.py artifacts/transitions_N8.json \
      --csv-dir artifacts/csv --summary-json artifacts/edge-summary-N8.json
    python3 gog_support_feature_analysis.py artifacts/transitions_N8.json \
      --max-cycle 4 --eigenvalues 6 \
      --summary-json artifacts/feature-summary-N8.json
    python3 gog_ball_growth.py --load artifacts/gog_N8.json \
      --max-radius 4 --sample 71

At N=8 the output contains 71 classes and 1,704 moves counted with
multiplicity. Complete tables give finite evidence; a sampled trajectory
does not establish an asymptotic claim. Truncated tables must not be used
as complete enumerations.

The pure Python canonicalizer handles small examples. Larger runs use
nauty/Traces, either through dreadnaut or the optional native bridge:

    python3 build_nauty_bridge.py
    python3 gog_degree_diagnostics.py artifacts/gog_N8.json --lowest 20

The degree diagnostic requires dreadnaut. Set NAUTY_PREFIX or pass
--nauty-prefix when the library is installed outside the usual locations.
The Outer backend-comparison check requires the compiled native bridge;
run the bridge build before make outer-space-check or make check.

## Wolfram notebooks

Both notebooks remain in the repository:

- [Interactive field-dynamics companion](whitehead-field-dynamics.nb)
- [Executable computational notes](whitehead-field-dynamics-computational-notes.nb)

They use Wolfram Language 14.3 or later and the local
[GogFieldDynamics package](Wolfram/GogFieldDynamics/README.md).
The bundled exact models cover N=2,4,6,8 and are checked with:

    make notebook-data-check
    make notebook-paclet-check
    make notebook-check

To rebuild and check the computational-notes notebook:

    make computational-notes-notebook
    make computational-notes-notebook-check

The interactive notebook build uses a Mathematica front end and has an
optional SetReplace path engine. SetReplace is not required by the
computational-notes notebook. Pass
WOLFRAM_KERNEL=/path/to/WolframKernel to make when needed.
The scripts under scripts/ build the notebooks, reproduce their text
outputs and check their evaluations; edit those sources for future
notebook changes.
For the computational companion's deterministic text transcript, run
scripts/notebook_report_outputs.wls with WolframKernel.

## arXiv submission

    make rule-a-paper-submission

This builds the current Whitehead figures and manuscript and prepares the
separate rule-a-paper-arxiv/ directory. It contains the manuscript source,
bibliography, four figure PDFs, generated table, and standalone reproduction
files under anc/. Compress the contents of that directory for upload, choosing
local-whitehead-chain.tex as the main file and pdfLaTeX as the compiler.
Refresh the directory with the same command after editing the paper.

To compress it automatically, run make rule-a-paper-packages. This refreshes
the directory and writes rule-a-paper-arxiv.tar.gz beside it. Builds use
temporary directories for LaTeX intermediates. The generated submission
directory, archives, downloaded reference copies and working research notes
remain local.
