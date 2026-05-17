# 🌍 Climate-Driven Range Shifts of Soil Fauna Under Projected Warming Scenarios

> Modelling earthworm community abundance dynamics across the Upper Elbe floodplain, Germany, from 2020 to 2070 under high-emission climate forcing (CMIP6/SSP5-8.5).
---
## Overview
This repository contains data, scripts, and outputs for a spatiotemporal species distribution modelling study investigating how projected climate warming reshapes the abundance and spatial distribution of **earthworm communities** in the **Upper Elbe floodplain region, Germany**.
The study combines a **correlative** (Random Forest SDM) and **mechanistic** (rangr) modelling framework to simulate range dynamics at 10-year intervals from 2020 to 2070 at 1 km spatial resolution.
### Key Findings
- 🔼 **Poleward expansion** of high-abundance zones without evidence of southern population collapse
- 🟡 **Southwestern climatic refugium** — persistent and intensifying high-abundance patches emerge in the southwest by t_40 (2060) and t_50 (2070)
- 🔄 **Northeast-to-southwest redistribution** of the abundance core over the 50-year projection period, suggesting a complex spatial reorganisation rather than simple linear range shift

---

## Study System

| Parameter | Details |
|-----------|---------|
| **Taxa** | Earthworms (*Lumbricidae*) — ecological group community abundance |
| **Region** | Upper Elbe floodplain, Germany (~51.3–52.3°N, 11.5–14.5°E) |
| **Spatial Resolution** | 1 km² grid |
| **Temporal Scope** | 2020–2070 (10-year intervals) |
| **Climate Scenario** | CMIP6 / SSP5-8.5 (high-emission pathway) |
---
## Modelling Framework
### Step 1 — Correlative SDM (Random Forest)
A Random Forest model was trained on empirical earthworm abundance records and current climate/soil covariates to generate a **baseline abundance raster** (t_1, 2020).
### Step 2 — Mechanistic Range Shift Simulation (rangr)
The `rangr` package was used to simulate **spatially explicit population dynamics** and dispersal-driven range shifts forward through time, driven by CMIP6/SSP5-8.5 climate projections.
This hybrid approach captures both the **habitat suitability response** (correlative) and **population spread and dispersal constraints** (mechanistic), providing a more realistic picture of range dynamics than either approach alone.

---
## Temporal Snapshots

| Model Output | Year | Description |
|-------------|------|-------------|
| `t_1` | 2020 | Baseline — current abundance distribution |
| `t_10` | 2030 | Near-term projection |
| `t_20` | 2040 | Mid-century early |
| `t_30` | 2050 | Mid-century |
| `t_40` | 2060 | Late-century early — southwestern refugium emerging |
| `t_50` | 2070 | Late-century — southwestern refugium consolidated |
---
## Repository Structure
```
/
├── data/
│   ├── raw/              # Raw climate layers (CMIP6/SSP5-8.5), soil covariates
│   ├── processed/        # Processed rasters, abundance records
│   └── sdm_output/       # Baseline RF abundance raster (t_1)
│
├── scripts/
│   ├── 01_rf_sdm.R       # Random Forest SDM — baseline abundance modelling
│   ├── 02_rangr_sim.R    # rangr mechanistic range shift simulation
│   ├── 03_visualise.R    # Spatial maps and latitudinal profile plots
│   └── 04_analysis.R     # Summary statistics and abundance trend analysis
│
└── output/
    └── figures/          # All generated figures (spatial maps, latitudinal profiles)
```
---
## Dependencies
All analyses were conducted in **R**. The following packages are required:
```r
install.packages(c("rangr", "terra", "here"))
```
| Package | Role |
|---------|------|
| [`rangr`](https://cran.r-project.org/package=rangr) | Mechanistic range shift simulation |
| [`terra`](https://cran.r-project.org/package=terra) | Spatial raster processing and analysis |
| [`here`](https://cran.r-project.org/package=here) | Reproducible file path management |
---
## Output Summary
The key model output is a series of **1 km resolution abundance rasters** (ind/m²) alongside a **latitudinal abundance profile** comparing baseline (T1) and future (T2) distributions.
![Model Output](output/figures/range_shift_summary.png)
*Six-panel spatial abundance maps (t_1 to t_50) with latitudinal abundance profiles comparing baseline (2020) and projected future (2070) earthworm community abundance across the Upper Elbe floodplain.*
---
## Ecological Interpretation
The model outputs reveal a **spatially complex redistribution** of earthworm abundance rather than a simple poleward retreat:

1. **No southern collapse** — contrary to classic range contraction predictions under warming, southern populations do not disappear over the projection period
2. **Southwestern refugium** — by 2060–2070, high-abundance zones (>350 ind/m²) consolidate strongly in the southwest, likely reflecting locally buffered microclimatic or edaphic conditions
3. **Latitudinal profile shift** — the abundance peak moves northward (~52.0–52.2°N), consistent with warming-driven poleward expansion, but the southwest gains indicate a **diagonal rather than purely latitudinal** range shift trajectory

---
## Citation
If you use this code or data, please cite:
> **Salako, G.** (2025). *Climate-driven range shifts of soil fauna under projected warming scenarios*. Senckenberg Museum of Natural History Görlitz, Germany. GitHub Repository.
---
## Author

**Gabriel Salako, PhD**
Senckenberg Museum of Natural History Görlitz
Görlitz, Germany
---
## License
This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.
Earthworms mediate approximately 80% of soil organic matter decomposition and are primary indicators of soil ecosystem health. Their distributions are highly sensitive to temperature and precipitation — yet mechanistic projections of how earthworm community abundance will shift under future climate change remain scarce.
Existing models largely rely on correlative SDMs, which project habitat suitability envelopes but do not explicitly model dispersal, demography, or population dynamics. This repository addresses that gap using the `rangr` package, which implements spatially explicit population simulation — modelling the process of range shift rather than just the destination.
The simulation is directly connected to published national-scale earthworm distribution models from the BoBiKa and BONARES programmes (Salako et al. 2023, 2024), ensuring empirically grounded parameterisation.

**Scientific question:** How will earthworm community abundance shift spatially under SSP5-8.5, accounting for dispersal limitation and population dynamics — and at what point does mean abundance approach critical policy-relevant thresholds?
**Variable selection rationale:** MAT and PPT were selected as primary carrying capacity drivers based on variable importance analysis from the BoBiKa ensemble SDM (Salako et al. 2023), where soil variables (tecture), avg. temperature (Bio_1) and annual precipitation (Bio_12) were confirmed as major predictors. These results are consistent with global-scale variable importance analysis from the revised global earthworm occurrence database (Salako et al. in prep.).

---
## Full Workflow

**Step 1 — Load raster data** using `terra::rast()`: empirical abundance raster and three temperature rasters.
**Step 2 — Prepare and combine climate layers** into a multi-layer temporal raster stack.
**Step 3 — Handle missing values.** NA cells are removed using prior to model initialisation. Only cells with verified abundance records contribute to the simulation. Raster extents and CRS are aligned across all input layers.
**Step 4 — Aggregate raster resolution** using `terra::aggregate()` for computational efficiency. This is optional
**Step 5 — Initialise rangr model** using `initialise()`: initial abundance from BoBiKa raster; carrying capacity linked to temperature; dispersal kernel parameterised from earthworm dispersal literature.
**Step 6 — Simulate range shifts** using `sim()` across 2050 and 2070 climate layers, propagating dispersal, reproduction, and survival dynamics.
**Step 7 — Plot and export results:** three spatial abundance maps at current-2020, 2050 and 2070  (t₁, t₂, t₃) and mean abundance trajectory plot with policy threshold line. (plots are in the outputs folder)

| Limitation | Planned extension |
|---|---|
| Single GCM (CNRM-CM6-1) | Ensemble across MPI-ESM1-2-HR, UKESM1-0-LL, CanESM5 |
| Single scenario (SSP5-8.5) | Add SSP2-4.5 to bound optimistic and high-emission projections |
| Single climate variable (temperature) | Extend carrying capacity to include PPT as co-driver |
| Demographic parameters from literature | Latin hypercube sampling across dispersal, reproduction, survival parameter space |
| Regional scale (Germany) | Scale to revised global earthworm database (>30,000 records, >200 species) |

---
## Related Publications

- **Salako G., Russell D.J., Stucke A., Eberhardt E. (2023).** Multi-algorithm assessment of earthworm geographic distribution in Germany. *Biodiversity and Conservation* 32: 2365–2394.
- **Salako G., Zaitsev A., Betancur-Corredor B., Russell D.J. (2024).** Modelling and spatial prediction of earthworm distribution. *Ecological Indicators* 169: 112832.
- **Zeiss R., Briones M.J.I., …, Salako G. et al. (2024).** Climate change effects on European earthworm distributions. *Conservation Biology* 38(2): e14187.
- **Salako G. et al. (in preparation).** Revised global occurrence and predicted distribution of earthworm biodiversity: correcting Global South data bias.
- **Salako G., Russell D.J., Eberhardt E., Stucke A. (2025).** Geospatial Reference Values for Soil Organisms, Germany. *Umweltbundesamt Technical Report* [embedded in German federal policy].

-
## Acknowledgements
UBA BoBiKa (FKZ 3719-71-206-0), German Federal Environment Agency · BMBF BonaRes research network · CHELSA v2.1 climate data (Karger et al. 2017, *Scientific Data*).
</details>
---
## How to Cite
> Salako G. (2025). *Species range shift simulation of earthworm community abundance under climate change using rangr.* GitHub: https://github.com/gabsalako/Species-Range-Shifts
A `CITATION.cff` file is included for reference managers and GitHub's built-in citation tool.
---
## Author
**Gabriel Salako, PhD** · Senckenberg Museum of Natural History, Görlitz, Germany
[ORCID](https://orcid.org/0000-0001-7960-8200) · [GitHub](https://github.com/gabsalako) · [Google Scholar](https://scholar.google.com/citations?user=9xrm4cAAAAAJ)

---

*License: [MIT](LICENSE) · Abundance data subject to UBA data agreement — not redistributed here.*
