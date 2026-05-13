# Species Range Shifts of Earthworm Communities Under Climate Change
**Mechanistic simulation using `rangr` | CHELSA CMIP6 CNRM-CM6-1 SSP5-8.5 | Empirical BoBiKa abundance data**
---
## This repository provides a reproducible R workflow for simulating **spatially explicit, mechanistic range shifts of earthworm community abundance** under future climate change. Using the [`rangr`](https://cran.r-project.org/package=rangr) package, the simulation models dispersal, reproduction, and survival dynamics — going beyond correlative SDM envelope projection — driven by temperature change under **CHELSA CMIP6 CNRM-CM6-1 SSP5-8.5** across three time steps: **current · 2050 · 2070**. Community abundance is empirically parameterised from the **UBA BoBiKa** national-scale soil biodiversity survey (FKZ 3719-71-206-0), Germany.
**Key result:** Earthworm community abundance shows pronounced spatial contraction by 2050, approaching a policy-relevant threshold between 2050 and 2070 under the high-emission scenario — indicating that current German federal soil quality benchmarks require revision under future climate.
---
## Climate Parameterisation
| Parameter | Value |
|---|---|
| Climate dataset | CHELSA v2.1 |
| GCM | CNRM-CM6-1 (CMIP6) |
| Scenario | SSP5-8.5 |
| Drivers | Mean Annual Temperature (MAT)) |
| Time steps | Current · 2050 · 2070 |
---
 Data
**Abundance (`Abundance.tif`):** Earthworm community abundance derived from the UBA BoBiKa project — a federally funded national-scale soil biodiversity survey across Germany whose outputs are embedded in German federal environmental policy (Salako et al. 2025, Umweltbundesamt Technical Report). Raw records and raster layers are held under edaphobase-UBA data agreement and are available on request. NA cells are addressed prior to simulation — treating missing cells as unsampled rather than unoccupied, preserving the biological integrity of the abundance surface.
**Climate rasters (`Temp_Curr.tif`, `Temp_2050.tif`, `Temp_2070.tif`):** CHELSA v2.1 bioclimatic layers under CMIP6 CNRM-CM6-1 SSP5-8.5, freely available at [chelsa-climate.org](https://chelsa-climate.org/).
---
## Repository Structure
```
Species-Range-Shifts/
├── RangeModel/
│   ├── Data/          # Abundance and climate rasters
│   ├── Rscripts/      # rangr simulation script
│   └── Output/        # Range shift maps and abundance trajectory figures
├── README.md
└── CITATION.cff
```
## Quick Start

```r
install.packages(c("terra", "rangr", "here"))
# Then open RangeModel/Rangemodel.Rproj and run Rscripts/rangr_simulation.R
```
## Key Results
- **Current (t₁):** High community abundance in western and central study landscape — consistent with empirical BoBiKa distribution
- **2050 (t₂):** Pronounced spatial contraction; western habitat core reduces markedly under SSP5-8.5 forcing
- **2070 (t₃):** Near-absence across majority of landscape; mean abundance crosses policy-relevant threshold
<summary><strong>Full scientific background, workflow, limitations & references — click to expand</strong></summar
---
## Scientific Background
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
