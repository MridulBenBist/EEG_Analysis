# EEG Band Power Analysis — AD vs. FTD vs. Healthy Controls

A preliminary MATLAB analysis comparing canonical EEG frequency-band power across three groups — Alzheimer's disease (AD), frontotemporal dementia (FTD), and healthy controls (CN) — from eyes-closed resting-state recordings. The script loads BIDS-formatted preprocessed EEG, computes Welch power spectra, averages within delta, theta, alpha, and beta bands, and plots group means side-by-side.

> **Exploratory analysis.** Group means only — no statistical testing or multiple-comparison correction yet.

---

## What the script does

1. Reads `participants.tsv` and counts subjects per group (`A` = AD, `F` = FTD, `C` = control).
2. For every subject, loads the preprocessed `.set` file under `derivatives/<sub>/eeg/` via EEGLAB.
3. Averages across channels to a single mean signal, then runs Welch's PSD (`pwelch` with default window/overlap).
4. Integrates power within four canonical bands:
   - **Delta** 1–4 Hz
   - **Theta** 4–8 Hz
   - **Alpha** 8–13 Hz
   - **Beta** 13–30 Hz
5. Computes per-group means and plots them as a 1×4 bar-chart panel.

---

## Dataset

This analysis uses the publicly available OpenNeuro dataset **ds004504**:

> Miltiadous, A., Tzimourta, K. D., Afrantou, T., Ioannidis, P., Grigoriadis, N., Tsalikakis, D. G., Angelidis, P., Tsipouras, M. G., Glavas, E., Giannakeas, N., & Tzallas, A. T. (2023). *A Dataset of Scalp EEG Recordings of Alzheimer's Disease, Frontotemporal Dementia and Healthy Subjects from Routine EEG.* **Data**, 8(6), 95. [doi:10.3390/data8060095](https://doi.org/10.3390/data8060095)

OpenNeuro DOI: [10.18112/openneuro.ds004504.v1.0.8](https://doi.org/10.18112/openneuro.ds004504.v1.0.8) — License: CC0

The dataset is **not** redistributed in this repo; download it directly from OpenNeuro and place it so that `participants.tsv` and `derivatives/` are visible from the working directory.

---

## Requirements

- MATLAB R2024b (or any recent release with the Signal Processing Toolbox for `pwelch`)
- [EEGLAB](https://sccn.ucsd.edu/eeglab/) on the MATLAB path (used for `pop_loadset`)
- The ds004504 dataset, already preprocessed under `derivatives/`

---

## How to run

From the project directory (which should contain `participants.tsv` and `derivatives/`):

```matlab
run('eeg_band_power.m')
```

The script prints per-subject progress, then displays a four-panel bar chart titled *"EEG Band Power by Group (All Subjects Averaged)"*.

---

## Expected output

A figure with four subplots (one per band), each showing three bars — AD (red/orange), CN (green), FTD (blue) — for mean power in µV²/Hz.

The literature on this dataset broadly reports increased low-frequency power (delta/theta) and reduced alpha power in AD vs. controls, with FTD showing a different profile. Whether this script reproduces that pattern depends on preprocessing choices in the `derivatives/` files.

---

## Method notes and caveats

- **Channel averaging before PSD.** The script averages all channels into a single time series, then computes one PSD. This collapses spatial information (so a topographical effect in one region is diluted) and can introduce phase-cancellation artifacts. A per-channel PSD followed by averaging the spectra would be more standard.
- **Default `pwelch` parameters.** Window length and overlap default to MATLAB's heuristics, which depend on signal length. For reproducibility across subjects with different recording lengths, set these explicitly (e.g., 2-second Hamming windows, 50% overlap).
- **No relative power.** Absolute band power is sensitive to electrode impedance, reference choice, and individual scalp/skull conductivity. Reporting *relative* band power (each band divided by total 1–30 Hz power) is more comparable across subjects.
- **No statistics.** The current script only plots group means — no standard errors, no group-comparison tests, no FDR correction.
- **Hardcoded path.** The header comment hardcodes `/Users/mridulbenbist/Documents/MATLAB/eeg`; change this for portability.



---

## Citation

If you use this code, please cite the dataset and the original analysis paper:

- Miltiadous et al. (2023). *Data*, 8(6), 95. [doi:10.3390/data8060095](https://doi.org/10.3390/data8060095)
- Miltiadous, A., Gionanidis, E., Tzimourta, K. D., Giannakeas, N., & Tzallas, A. T. (2023). *DICE-net: A Novel Convolution-Transformer Architecture for Alzheimer Detection in EEG Signals.* **IEEE Access**. [doi:10.1109/ACCESS.2023.3294618](https://doi.org/10.1109/ACCESS.2023.3294618)

---

