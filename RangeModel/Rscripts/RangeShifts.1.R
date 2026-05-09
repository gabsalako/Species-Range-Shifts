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
#Check the alignmemnt of all raster
stackAll
#plot all rasters
plot(stackAll)
#Stack only Environmental carrying capacity (Climate data, Temperature)
StackClimatex <-c(TempC, Temp50, Temp70)
plot(StackClimatex)
#Addressing NA in the grids
#1. Create a master mask by summing everything
master_mask <- Abundance + sum(StackClimatex)
#2. Mask Abundance
Abundance_clean <- mask(Abundance, master_mask)
#3.Mask the entire climate layers
#Using the master_mask ensures every layer in the climate matches abundance 
StackClimatex_clean <- mask(StackClimatex, master_mask)
#initialise
sim_dataSF <- initialise(
  n1_map =Abundance_clean ,#represents NLmap
  K_map =StackClimatex_clean, # represents Kmap Lu can be 2006 or 2019 or climate scenarios
  r = log(2),
  rate = 1 / 1e3
)
#you may wish to aggregate to lower resolution to run faster
Abundance_agg <- aggregate(Abundance_clean, fact = 4)
StackClimatex_agg <- aggregate(StackClimatex_clean, fact = 4)
sim_dataSF1 <- initialise(
  n1_map =Abundance_agg ,#represents NLmap
  K_map =StackClimatex_agg, # represents Kmap Lu can be 2006 or 2019 or climate scenarios
  r = log(2),
  rate = 1 / 1e3
)
#Check the summary of initialization
summary(sim_dataSF) 
#set the time steps at 3, current, 2050 and 20270
sim_result_SF <- sim(obj = sim_dataSF, time = 3)
#use to plot the mean abundance graph at each time step
summary(sim_result_SF)
#plot the the predicted shift raster  at 3 time steps
#t_1=current t_1=2050, t_1=2070
plot(sim_result_SF,
     time_points = c(1, 2, 3),
     template = sim_dataSF$K_map
)



