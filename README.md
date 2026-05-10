# Range Shifts Model Simulation (Rangemodel)
This repository provides a reproducible R workflow for simulating spatially explicit, mechanistic range shifts of earthworm community abundance under future climate change. Using the rangr package, the simulation models dispersal, reproduction, and survival dynamics — going beyond correlative SDM envelope projection — driven by temperature change under CHELSA CMIP6 CNRM-CM6-1 SSP5-8.5 across three time steps: current · 2050 · 2070. Community abundance is empirically parameterised from the UBA BoBiKa national-scale soil biodiversity survey (FKZ 3719-71-206-0), Germany.
## 🧪 Requirements Install required packages: ```r install.packages(c("terra", "rangr", "here"))
This repository contains an R-based workflow for simulating species range shifts using raster data and the `rangr` package.
## 📁 Project Structure
Rangemodel/ │ ├── Data/ # Input raster files ├── Rscripts/ # R script for model ├── Output/ # Model outputs ├── Rangemodel.Rproj # RStudio project └── README.md
## 📊 Input Data The `Data/` folder includes: - `Abundance.tif` → species abundance - `Temp_Curr.tif` → current temperature - `Temp_2050.tif` → projected temperature (2050) - `Temp_2070.tif` → projected temperature (2070) 
Repository Structure
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
•	│   │   └── [simulation figures]   # Range shift maps and abundance trajectory- 2 plots (1) policy informed threshold with clean background (2) raw outputs
•	│   └── Rangemodel.Rproj           # RStudio project file
•	│
•	├── README.md                      # This file
•	└── CITATION.cff                   # Formal citation metadata
•	________________________________________
Variable selection rationale: Temperature variable (MAT) was selected as primary carrying capacity drivers based on expected rise in future global temperature and variable importance analysis from the national-scale SDM (Salako et al. 2024, Biodiversity and Conservation), where temperature was confirmed as one of the principal dominant predictors of earthworm density (abundance) distribution across Germany (Salako et al 2024). These results are consistent with global-scale variable importance analysis from the revised global earthworm occurrence database (Salako et al. in prep.).
The model workflow: 
1. Load raster data using `terra` 
2. Prepare and combine climate layers 
3. Handle missing values 
4. Aggregate raster resolution 
5. Initialize model using `rangr` 
6. Simulate range shifts over time
 7. Plot results
Notes-
•	Missing values (NA) are treated as unsampled rather than unoccupied, preserving the biological integrity of the abundance surface and avoiding bias in dispersal kernel fitting and threshold detection.
•	Raster aggregation is applied for computational efficiency
**If you use this workflow, please cite**:
Salako G. (2025). Species range shift simulation of earthworm community abundance under climate change using rangr. GitHub repository: https://github.com/gabsalako/Species-Range-Shifts

**Related Work & Publications
This repository is part of a broader research programme on global earthworm biodiversity:**
Salako G., Russell D.J., Stucke A., Eberhardt E. (2023). Assessment of multiple model algorithms to predict earthworm geographic distribution in Germany. Biodiversity and Conservation 32: 2365–2394. [Cited: 22]
Salako G., Zaitsev A., Betancur-Corredor B., Russell D.J. (2024). Modelling and spatial prediction of earthworm distribution reveal habitat and landscape preferences. Ecological Indicators 169: 112832. [Cited: 10]
Zeiss R., Briones M.J.I., …, Salako G. et al. (2024). Effects of climate change on the spatial distribution and conservation planning of European earthworms. Conservation Biology 38(2): e14187. [Cited: 20]
Salako G. et al. (in preparation). Revised global occurrence and predicted distribution of earthworm biodiversity: correcting Global South data bias. Colloquium presented at Dept. of Soil Biodiversity Modelling, Senckenberg, 21 May 2025.
