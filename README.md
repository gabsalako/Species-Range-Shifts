•	Species Range Shifts of Earthworm Communities Under Climate Change
•	A reproducible mechanistic simulation workflow using rangr | CHELSA CMIP6 SSP5-8.5 | Empirical BoBiKa abundance data   
•	________________________________________
•	Scientific Background
•	Earthworms mediate approximately 80% of soil organic matter decomposition and are primary indicators of soil ecosystem health. Their spatial distributions are highly sensitive to temperature and precipitation — yet despite this ecological importance, mechanistic projections of how earthworm community abundance will shift under future climate change remain scarce.
•	Existing global and national biodiversity models are largely built on correlative species distribution models (SDMs), which project habitat suitability envelopes under future climate but do not explicitly model the demographic and dispersal processes that govern whether and how fast communities can actually track shifting conditions. This repository addresses that gap.
•	This workflow implements a spatially explicit, mechanistic simulation of earthworm community abundance dynamics using the rangr R package — going beyond static envelope projection to model the population-level processes of dispersal, reproduction, and survival under changing climate conditions across three time steps: current, 2050, and 2070.
•	The simulation is directly connected to, and extends, published national-scale earthworm distribution models from the UBA BoBiKa research programme (Salako et al. 2023, 2024), ensuring that the mechanistic parameterisation is empirically grounded rather than hypothetical.
•	________________________________________
•	Key Scientific Question
•	How will earthworm community abundance shift spatially under high-emission climate change (SSP5-8.5), accounting for dispersal limitation and population dynamics — and at what point does mean community abundance approach critical policy-relevant thresholds?
•	________________________________________
•	Climate Parameterisation
•	Parameter	•	Value
•	Climate dataset	•	CHELSA v2.1
•	General Circulation Model (GCM)	•	CNRM-CM6-1
•	Emission scenario	•	SSP5-8.5 (high-emission)
•	Climate variables	•	Mean Annual Temperature (MAT) · Annual Precipitation (PPT)
•	Time steps	•	Current · 2050 · 2070
•	Variable selection rationale: Temperature variable (MAT) was selected as primary carrying capacity drivers based on expected rise in future temperature variable importance analysis from the national-scale SDM (Salako et al. 2024, Biodiversity and Conservation), where temperature) and annual precipitation ( were confirmed as dominant predictors of earthworm density (abundance) distribution across Germany. These results are consistent with global-scale variable importance analysis from the revised global earthworm occurrence database (Salako et al. in prep.).
•	________________________________________
•	Empirical Data Provenance
•	Species abundance data (Abundance.tif): Earthworm community abundance data derived from the UBA BoBiKa project (FKZ 3719-71-206-0) — a federally funded national-scale soil biodiversity survey across Germany. The BoBiKa programme produced geospatial reference benchmarks for soil organisms as environmental quality indicators, the outputs of which are now embedded in German federal environmental policy (Umweltbundesamt Technical Report, 2025).
•	Data availability: Raw Edaphobase (Senckenberg Museum of Natural History Görlitz). Raw data are available on requaests  For full data context, see:
•	Salako G., Russell D.J., Eberhardt E., Stucke A. (2025). Geospatial Reference Values for Soil Organisms as Environmental Quality Indicators across Germany. Umweltbundesamt Technical Report. [UBA, Germany]
•	Climate rasters (Temp_Curr.tif, Temp_2050.tif, Temp_2070.tif): Derived from CHELSA v2.1 bioclimatic layers under CMIP6 CNRM-CM6-1 SSP5-8.5. CHELSA data are freely available at chelsa-climate.org.
•	Note on NA handling: Grid cells with missing abundance values (NA) are removed prior to model simulation using na.omit(). This approach treats missing cells as unsampled rather than unoccupied — preserving the biological integrity of the abundance surface by avoiding the false assumption that absence of a record equates to absence of earthworms. Only cells with verified abundance values are used to initialise and run the rangr population dynamics simulation. This is ecologically preferable to NA-to-zero imputation, which would artificially inflate the extent of zero-abundance cells and bias both the dispersal kernel fitting and the threshold detection analysis.
•	________________________________________
•	Repository Structure
•	Species-Range-Shifts/
•	│
•	├── RangeModel/
•	│   ├── Data/
•	│   │   ├── Abundance.tif          # Empirical earthworm community abundance (BoBiKa)
•	│   │   ├── Temp_Curr.tif          # Current temperature (CHELSA)
•	│   │   ├── Temp_2050.tif          # Projected temperature 2050 (CHELSA CMIP6 SSP5-8.5)
•	│   │   └── Temp_2070.tif          # Projected temperature 2070 (CHELSA CMIP6 SSP5-8.5)
•	│   ├── Rscripts/
•	│   │   └── rangr_simulation.R     # Main simulation script
•	│   ├── Output/
•	│   │   └── [simulation figures]   # Range shift maps and abundance trajectory plot
•	│   └── Rangemodel.Rproj           # RStudio project file
•	│
•	├── README.md                      # This file
•	└── CITATION.cff                   # Formal citation metadata
•	________________________________________
•	Requirements
•	Install required packages:
•	install.packages(c("terra", "rangr", "here"))
•	Package	•	Version tested	•	Purpose
•	terra	•	≥ 1.7	•	Raster data loading, processing, aggregation
•	rangr	•	≥ 1.0	•	Spatially explicit population dynamics simulation
•	here	•	≥ 1.0	•	Reproducible file path management
•	________________________________________
•	Workflow Overview
•	The simulation proceeds in seven steps:
•	Step 1 — Load raster data using terra::rast(). Input layers: empirical abundance raster and three temperature rasters (current, 2050, 2070).
•	Step 2 — Prepare and combine climate layers into a multi-layer raster stack representing the temporal sequence of climate forcing.
•	Step 3 — Handle missing values. NA cells are removed using na.omit() prior to model initialisation (see data provenance note above). This preserves the biological integrity of the abundance surface — only cells with verified abundance records contribute to the simulation. Raster extents and CRS are aligned across all input layers.
•	Step 4 — Aggregate raster resolution for computational efficiency using terra::aggregate(). Aggregation factor is documented in the script.
•	Step 5 — Initialise rangr model using initialise(). Key parameters:
•	Initial population abundance from empirical BoBiKa raster
•	Carrying capacity linked to temperature via habitat suitability function
•	Dispersal kernel parameterised from earthworm dispersal literature
•	Step 6 — Simulate range shifts over time using sim(). The model propagates population dynamics — dispersal, reproduction, survival — across the 2050 and 2070 climate layers, producing spatially explicit abundance maps at each time step.
•	Step 7 — Plot and export results. Three spatial abundance maps (t₁ current, t₂ 2050, t₃ 2070) and a mean abundance trajectory plot showing decline relative to a policy-relevant threshold line.
•	________________________________________
•	Key Results
•	The simulation reveals a pronounced spatially explicit decline in earthworm community abundance under SSP5-8.5 forcing:
•	Current (t₁): High community abundance concentrated in the western and central portions of the study landscape, consistent with the empirical BoBiKa distribution.
•	2050 (t₂): Significant range contraction — the western habitat core reduces markedly under warming and precipitation change.
•	2070 (t₃): Near-absence across the majority of the study landscape. Mean community abundance approaches the policy-relevant threshold defined within the BoBiKa soil quality benchmarks.
•	The mean abundance trajectory crosses toward the threshold between 2050 and 2070 — signalling a policy trigger point at which current German federal soil quality benchmarks would require revision under this climate scenario.
•	________________________________________
•	Limitations & Planned Extensions
•	Limitation	•	Planned extension
•	Single GCM (CNRM-CM6-1)	•	Repeat simulation across GCM ensemble (MPI-ESM1-2-HR, UKESM1-0-LL, CanESM5) to quantify climate forcing uncertainty
•	Single scenario (SSP5-8.5)	•	Add SSP2-4.5 to bound optimistic and high-emission projections
•	Single climate variable (temperature)	•	Extend carrying capacity function to include precipitation (PPT) as co-driver alongside MAT
•	Demographic parameters from literature	•	Latin hypercube sampling across dispersal, reproduction, and survival parameter space to quantify structural uncertainty
•	Regional scale (Germany)	•	Scale rangr framework to revised global earthworm occurrence database (>30,000 records, >200 species)
•	________________________________________
•	Related Work & Publications
•	This repository is part of a broader research programme on global earthworm biodiversity:
•	Salako G., Russell D.J., Stucke A., Eberhardt E. (2023). Assessment of multiple model algorithms to predict earthworm geographic distribution in Germany. Biodiversity and Conservation 32: 2365–2394. [Cited: 22]
•	Salako G., Zaitsev A., Betancur-Corredor B., Russell D.J. (2024). Modelling and spatial prediction of earthworm distribution reveal habitat and landscape preferences. Ecological Indicators 169: 112832. [Cited: 10]
•	Zeiss R., Briones M.J.I., …, Salako G. et al. (2024). Effects of climate change on the spatial distribution and conservation planning of European earthworms. Conservation Biology 38(2): e14187. [Cited: 20]
•	Salako G. et al. (in preparation). Revised global occurrence and predicted distribution of earthworm biodiversity: correcting Global South data bias. Colloquium presented at Dept. of Soil Biodiversity Modelling, Senckenberg, 21 May 2025.
•	Salako G., Russell D.J., Eberhardt E., Stucke A. (2025). Geospatial Reference Values for Soil Organisms as Environmental Quality Indicators across Germany. Umweltbundesamt Technical Report [PI — embedded in German federal environmental policy].
•	________________________________________
•	How to Cite
•	If you use this workflow, please cite:
•	Salako G. (2025). Species range shift simulation of earthworm community abundance under climate change using rangr. GitHub repository: https://github.com/gabsalako/Species-Range-Shifts
•	A formal CITATION.cff file is included in this repository for reference managers and GitHub's built-in citation tool.
•	________________________________________
•	Author
•	Gabriel Salako, PhD Senckenberg Museum of Natural History, Görlitz, Germany Dept. of Soil Biodiversity Modelling (SMNG)
•	ORCID: 0000-0001-7960-8200
•	GitHub: gabsalako
•	Google Scholar: Profile
•	________________________________________
•	Acknowledgements
•	This work was conducted within the UBA BoBiKa research programme (FKZ 3719-71-206-0), funded by the German Federal Environment Agency (Umweltbundesamt), and the BMBF BonaRes research network. Climate data were obtained from CHELSA v2.1 (Karger et al. 2017, Scientific Data).
•	________________________________________
•	License
•	This repository is released under the MIT License. The underlying empirical abundance data are subject to UBA data agreement terms and are not redistributed here.
•	
