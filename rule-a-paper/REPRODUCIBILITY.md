# Whitehead-Chain Enumeration: Reproduction Notes

The ancillary files reproduce both enumeration tables in *The Local
Whitehead-Move Chain on Cubic Multigraphs*.
They are included in the arXiv `anc/` directory and run without a checkout of
the project repository.

Files:

- `gog_generate.py` enumerates connected cubic multigraph classes and all
  `3N` Whitehead moves per class.
- `verify_rule_a.py` checks completeness, transition reciprocity, the
  bridge-flow identity, and the reported conductance. It also hashes the
  ordered states and sparse transition counts and records per-size timings.
- `build_nauty_bridge.py` and `gog_nauty_bridge.c` provide an optional
  in-process interface to nauty/Traces.
- `rule-a-enumeration.json` is the record produced by the seven-size run. It
  contains aggregate counts, rational values, and SHA-256 digests, but not the
  full transition matrices.
- `render_rule_a_table.py` validates that record and generates the LaTeX rows
  used by the manuscript.

The commands below are run from the extracted `anc/` directory. They also
work from `rule-a-paper/` in the repository, except that the bridge build
command there is `python3 ../build_nauty_bridge.py`.

The pure-Python backend requires Python 3.10 or later and no external
packages. For a small check, run:

```sh
python3 verify_rule_a.py 8 --backend python --jobs 1
```

For the full table through `N=14`, install nauty/Traces and a C compiler,
build the native bridge, and run:

```sh
python3 build_nauty_bridge.py
python3 verify_rule_a.py 2 4 6 8 10 12 14 \
  --backend native --nauty-mode traces --jobs 1 \
  --json rerun-enumeration.json
```

The build script searches `/opt/homebrew`, `/usr/local`, and `/usr` for
nauty headers and libraries. For another installation prefix, pass
`--nauty-prefix /path/to/prefix` to `build_nauty_bridge.py`.

The reported batch used Python 3.14, nauty/Traces 2.9.3, and one worker on an
Apple M5 computer with 24 GB of memory. The JSON records the software
versions detected at run time, UTC generation time, source-file hashes,
the native bridge binary hash when present, per-size elapsed times, and
digests of the ordered states and transition counts. The hashed sources include
the generator, verifier, native bridge, and its build script. The `N=14`
calculation enumerates 21,096 classes and 886,032 Whitehead moves. Parallel
workers can be requested with `--jobs`, subject to the resources of the host
machine.

The archived `rule-a-enumeration.json` is read directly when the manuscript
tables are built. The command above writes to a different filename to leave
that record intact. To render the new run as LaTeX rows, use:

```sh
python3 render_rule_a_table.py \
  rerun-enumeration.json rerun-enumeration-table.tex
```

The renderer checks that all seven sizes `N=2,4,6,8,10,12,14` are present,
that the number of moves is `3N` times the number of classes, and that both
digests are present. It does not assume the exact conductance formula:
the verifier calculates conductance from the transition data and only then
compares it with the proved value. A mismatching row would still be
recorded.

The enumeration is exhaustive: no sampled state space or trajectory is used.
Compare the per-size counts and rational values in the new and archived
records. Running times will vary. The state and transition digests should
also agree when using the recorded native Traces backend and nauty/Traces
2.9.3. Different canonical-labeling backends can choose different vertex
orders for the same graphs, so their digests need not agree even when their
counts and rational values do. The pure-Python backend was checked this way
for `N=2,4,6,8`. The native-library hash depends on the compiler and platform
and is not a portable correctness check.

A full transition dump can also be generated with
`gog_generate.py --save-transitions`; it is omitted from the submission
package because the verifier reconstructs it.
