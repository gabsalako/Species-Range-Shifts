library(here)
library(terra)
library(rangr)
here::i_am("Rscripts/RangeShifts.1.R")
here()
#load inputs raster/map
Abundance <- rast(here("Data", "Abundance.tif"))
TempC <- rast(here("Data", "Temp_Curr.tif")) / 10
Temp50 <- rast(here("Data", "Temp_2050.tif"))
Temp70 <- rast(here("Data", "Temp_2070.tif"))

stackAll <-c(Abundance, TempC, Temp50, Temp70)
#Check the alignment of all raster
stackAll
#plot all raster
plot(stackAll)
#Stack only Environmental carrying capacity (Climate data, Temperature)
StackClimatex <-c(TempC, Temp50, Temp70)
plot(StackClimatex)

#addressing NA
#1. Create a master mask by summing everything
master_mask <- Abundance + sum(StackClimatex)
#2. Mask Abundance
Abundance_clean <- mask(Abundance, master_mask)
#3.Mask the entire stack climate layers
# Using the master_mask ensures every layer in the stack matches Abundance
StackClimatex_clean <- mask(StackClimatex, master_mask)

#aggregate to lower resolution
Abundance_agg <- aggregate(Abundance_clean, fact = 4)
StackClimatex_agg <- aggregate(StackClimatex_clean, fact = 4)

#initial abundance raster as the baseline capacity
base_K <- Abundance_agg
# Calculate how much temperature changes relative to the 2020 baseline
# Layer 1 = 2020, Layer 2 = 2050, Layer 3 = 2070
scale_2020 <- StackClimatex_agg[[1]] / StackClimatex_agg[[1]] # Equals 1
scale_2050 <- StackClimatex_agg[[2]] / StackClimatex_agg[[1]]
scale_2070 <- StackClimatex_agg[[3]] / StackClimatex_agg[[1]]

# future temperature changes as a relative scaling factor for the abundance
# Multiply the baseline capacity by the climate change scale factors
K_functional_stack <- c(
  base_K * scale_2020,
  base_K * scale_2050,
  base_K * scale_2070
)
# Use 'K_functional_stack' for interpolation 
# Interpolate steps 1 to 31 (2020 to 2050)
K_part1 <- lapply(0:30, function(i) {
  base_K * scale_2020 + (i / 30) * (base_K * scale_2050 - base_K * scale_2020)
})
K_part1_stack <- rast(K_part1)

# 3. Interpolate steps 32 to 51 (2050 to 2070)
K_part2 <- lapply(1:20, function(i) {
  base_K * scale_2050 + (i / 20) * (base_K * scale_2070 - base_K * scale_2050)
})
K_part2_stack <- rast(K_part2)

# 4. Merge into a final 51-layer carrying capacity time-series
K_dynamic <- c(K_part1_stack, K_part2_stack)
names(K_dynamic) <- paste0("step_", 1:51)

#addressing NA
#1. Create a master mask by summing everything
master_mask2 <- Abundance_agg + sum(K_dynamic)
#2. Mask Abundance
Abundance_nl <- mask(Abundance_agg, master_mask2)
#3.Mask the entire stack climate layers
# Using the master_mask ensures every layer in the stack matches Abundance
KdynamicClim_<- mask(K_dynamic, master_mask2)

#simulation
#initialise
sim_dataSF <- initialise(
  n1_map =Abundance_nl,#represents NLmap
  K_map =KdynamicClim_, # represents carrying capacity map of each climate scenarios
  r = log(1.5),
  rate =  1 / 0.0001 # or 1/10000 
)

#set the time steps at 3, current, 2050 and 20270
sim_result_SF <- sim(obj = sim_dataSF, time = 51)
#use to plot the mean abundance graph at each time step
summary(sim_result_SF)
#plot the the predicted shift raster  at 3 time step
#t_1=current t_1=2050, t_1=2070
plot(sim_result_SF,
     time_points = c(1, 10, 20, 30, 40, 50),
     template = sim_dataSF$K_map
)
#convert to raster
SFR_rast <- to_rast(
  sim_result_SF,
  time_points = 1:sim_result_SF$simulated_time,
  template = sim_dataSF$K_map
)
plot(SFR_rast,
     time_points = c(1, 10, 30, 50))
#subset a raster from stack or multiple raster
K1_2020 <- SFR_rast[[1]]
K1_2050 <- SFR_rast[[30]]
K1_2070 <- SFR_rast[[50]]
plot(K1_2020)
StackSim <- c(K1_2020,K1_2050,K1_2070)
plot(StackSim)
#write raster in rast
writeRaster(K1_2020, "2020Range.grd", overwrite=TRUE)
writeRaster(K1_2050, "2050Range.grd", overwrite=TRUE)
writeRaster(K1_2070, "2070Range.grd", overwrite=TRUE)


