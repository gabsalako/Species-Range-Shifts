# Species-Range-Shifts
This project simulates species range shifts using raster data and climate projections in R, providing a reproducible workflow for modelling spatial dynamics with the rangr package.
# Range Shifts Model Simulation (Rangemodel)
## 🧪 Requirements Install required packages: ```r install.packages(c("terra", "rangr", "here"))
This repository contains an R-based workflow for simulating species range shifts using raster data and the `rangr` package.
## 📁 Project Structure
Rangemodel/ │ ├── Data/ # Input raster files ├── Rscripts/ # R script for model ├── Output/ # Model outputs ├── Rangemodel.Rproj # RStudio project └── README.md
## 📊 Input Data The `Data/` folder includes: - `Abundance.tif` → species abundance - `Temp_Curr.tif` → current temperature - `Temp_2050.tif` → projected temperature (2050) - `Temp_2070.tif` → projected temperature (2070) 
The model workflow: 
1. Load raster data using `terra` 
2. Prepare and combine climate layers 
3. Handle missing values 
4. Aggregate raster resolution 
5. Initialize model using `rangr` 
6. Simulate range shifts over time
 7. Plot results
Notes
•	Missing values (NA) are currently set to zero
•	Raster aggregation is applied for computational efficiency

