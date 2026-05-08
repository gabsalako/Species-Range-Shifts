library(here)
library(terra)
library(rangr)
here::i_am("Rscripts/RangeShifts.R")
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

#aggregate to lower resolution to run faster
Abundance_agg <- aggregate(Abundance, fact = 4)
StackClimatex_agg <- aggregate(StackClimatex, fact = 4)

#dealing wth NA less ideal
Abundance_agg[is.na(Abundance_agg)] <- 0
StackClimatex_agg[is.na(StackClimatex_agg)] <- 0

#initialise
sim_dataSF <- initialise(
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
#plot the the predicted shift raster  at 3 time step
#t_1=current t_1=2050, t_1=2070
plot(sim_result_SF,
     time_points = c(1, 2, 3),
     template = sim_dataSF$K_map
)



