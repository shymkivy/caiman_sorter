# caiman_sorter

MATLAB GUI to manually curate cells extracted by [CaImAn](https://github.com/flatironinstitute/CaImAn) / OnACID. Loads a CaImAn HDF5 (`*_results_cnmf.hdf5`) or a previously saved sort (`*_sort.mat`), lets you accept/reject components, tune evaluation thresholds, merge duplicates, and run deconvolution on the surviving cells.

> **A Python port is also available: [shymkivy/caiman_sorter_py](https://github.com/shymkivy/caiman_sorter_py).** The two sorters read each other's `.mat` and `.h5` sort files interchangeably.

## Requirements

- MATLAB **R2019a or later** (uifigure tooltips, programmatic callback wiring). Compatible up to R2023.
- **Signal Processing Toolbox** (for `pwelch`-based noise estimation).

## Usage

1. Add `caiman_sorter_functions/` (and its subfolders) to the MATLAB path, or just open `caiman_sorter.mlapp` — the project's `startupFcn` adds itself.
2. Launch the GUI: open `caiman_sorter.mlapp` in App Designer and click **Run**, or call it from the command line.
3. **Browse** to a CaImAn `*.hdf5` or a sort `*.mat` and click **Load**.
4. Review cells; toggle accept/reject via right-click on the ROI maps or via the Accept/Reject buttons; tune thresholds in the right panel and click **Evaluate**.
5. Optionally **Find similar components** to detect and merge duplicates.
6. Optionally run a **deconvolution** (smooth dF/dt, constrained foopsi, or MCMC).
7. **Save data** writes a `*_sort.mat` next to the source file.

## Deconvolution

Each method has its own tab.

| Method | Dependencies | Notes |
|---|---|---|
| **Smooth dF/dt** | none | Gaussian-smoothed first-difference of `C + YrA`. Fast, no model. |
| **Constrained foopsi** | `constrained foopsi/oasis` — fast · `cvx` (install [CVX](http://cvxr.com/cvx/download/)) — highest quality, slowest · `dual` (Optimization Toolbox) — built-in fallback via `fmincon` | Noise-constrained sparse deconvolution. |
| **MCMC** | install [CVX](http://cvxr.com/cvx/download/) | Bayesian sampling-based. |

Upstream repos:

- constrained foopsi/oasis — [zhoupc/OASIS_matlab](https://github.com/zhoupc/OASIS_matlab)
- cvx / dual — [CaImAn-MATLAB](https://github.com/flatironinstitute/CaImAn-MATLAB/tree/master/deconvolution) `constrained_foopsi.m` stack (`deconvolution_dep/`)
- MCMC — Eftychios Pnevmatikakis' code, from [flatironinstitute/CaImAn-MATLAB](https://github.com/flatironinstitute/CaImAn-MATLAB/tree/master/deconvolution/MCMC) (`deconvolution_dep/MCMC/`)
