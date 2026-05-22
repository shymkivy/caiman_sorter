# caiman_sorter

MATLAB GUI to manually curate cells extracted by [CaImAn](https://github.com/flatironinstitute/CaImAn) / OnACID. Loads a CaImAn HDF5 (`*_results_cnmf.hdf5`) or a previously saved sort (`*_sort.mat`), lets you accept/reject components, tune evaluation thresholds, merge duplicates, and run deconvolution on the surviving cells.

> **A Python port is also available.** If you prefer Python or want a cross-platform install without a MATLAB license, see **[shymkivy/caiman_sorter_py](https://github.com/shymkivy/caiman_sorter_py)**. The two sorters read each other's `.mat` and `.h5` sort files interchangeably.

## Requirements

- MATLAB **R2019a or later** (uifigure tooltips, programmatic callback wiring). Compatible up to R2023.
- **Signal Processing Toolbox** (for `pwelch`-based noise estimation).
- *Optional*: **Optimization Toolbox** (`fmincon`) — enables the `dual` foopsi solver.
- *Optional*: **[CVX](http://cvxr.com/cvx/download/)** — enables the `cvx` foopsi solver (highest quality, slowest).
- *Optional*: legacy MCMC deconvolution also relies on CVX.

OASIS is **vendored** in `caiman_sorter_functions/deconvolution_dep/oasis/` and works with no external deps, so you can run the GUI without installing anything beyond MATLAB + Signal Processing Toolbox.

## Usage

1. Add `caiman_sorter_functions/` (and its subfolders) to the MATLAB path, or just open `caiman_sorter.mlapp` — the project's `startupFcn` adds itself.
2. Launch the GUI: open `caiman_sorter.mlapp` in App Designer and click **Run**, or call it from the command line.
3. **Browse** to a CaImAn `*.hdf5` or a sort `*.mat` and click **Load**.
4. Review cells; toggle accept/reject via right-click on the ROI maps or via the Accept/Reject buttons; tune thresholds in the right panel and click **Evaluate**.
5. Optionally **Find similar components** to detect and merge duplicates.
6. Optionally run a **deconvolution** (smooth dF/dt, constrained foopsi, or MCMC).
7. **Save data** writes a `*_sort.mat` next to the source file.

## Deconvolution

The "constrained foopsi" tab exposes a solver dropdown:

| Method | Dependencies | Notes |
|---|---|---|
| **`oasis`** | none (vendored) | Fast, no install needed. Default on systems without CVX / Optimization Toolbox. |
| **`cvx`** | [CVX](http://cvxr.com/cvx/download/) | Highest quality, slowest. |
| **`dual`** | Optimization Toolbox | Built-in fallback when you have a MATLAB toolbox license but no CVX. |

Items the dropdown labels `(not installed)` are still selectable — the backend warns and falls back to whichever solver is available. The **Fudge factor** field (default 0.99) shrinks the AR poles to compensate for time-constant estimation bias, and now propagates into all three solvers (including OASIS).

## Settings persistence

GUI parameters (thresholds, deconv settings, merge params, view toggles, last loaded file path) auto-save to `<prefdir>/caiman_sorter_options.mat` between sessions. The exact path is logged on startup. Toggle the **Auto-save options** checkbox to disable. Saving also triggers on:

- App close.
- Save Data.
- Evaluate.
- Toggling the auto-save checkbox itself (so an off state is persisted).

## Cross-compatibility with the Python sorter

Sort files saved by [`shymkivy/caiman_sorter_py`](https://github.com/shymkivy/caiman_sorter_py) load directly in this GUI, and vice versa. Both implementations follow the same on-disk schema for `est` / `proc` / `ops`, including:

- 1-based MATLAB indices for `idx_components` / `idx_components_bad`
- Sparse `est.A` in MATLAB's `data/ir/jc` format
- `logical` (uint8) booleans for accept masks and eval flags
- The `est.R` ↔ `est.YrA` alias
- Per-cell contour cell-arrays
- The `'CaImAn evaluate'` / `'Reject threshhold'` switch strings (case-insensitive on load)

Old sort `.mat` files missing newer fields (e.g. no `merge_parents`, no per-cell `fudge_factor`) still load — defaults fill in.

## Dependencies (third-party, vendored)

- `deconvolution_dep/oasis/` — Pengcheng Zhou's [OASIS_matlab](https://github.com/zhoupc/OASIS_matlab) port. Synced with upstream bug-fix commits.
- `deconvolution_dep/MCMC/` — Eftychios Pnevmatikakis' MCMC deconvolution code.
- `deconvolution_dep/constrained_foopsi.m`, `lars_regression_noise.m`, etc. — CaImAn-MATLAB constrained-deconv stack.
