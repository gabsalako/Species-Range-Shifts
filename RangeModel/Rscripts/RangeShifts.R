library(tidyverse)
library(terra)#essential
library(raster)
library(tidyterra)#geom_spat raster
library(ggplot2)
library(dplyr)
library(sf)
library(geodata)#
library(rangr)#essential 
library(here)#essential 

#################Range shift model#############################
#load Input maps using rast in terra package
##Earthworms abundance raster
###Environmental carrying capacity (Climate data, Temperature at 3 time steps)
Abundance <-rast("Abundance.tif")
#divide  current temp data by ten to make it comparable with other climate data
TempC <-rast("Temp_Curr.tif")/10
Temp50 <-rast("Temp_2050.tif")
Temp70 <-rast("Temp_2070.tif")
LUElbe19 <- rast("ElbeLU clip 2019.tif")#land use, optional 
stackAll <-c(Abundance, TempC, Temp50, Temp70)
#Check the alignmemnt of all raster
stackAll
#plot all rasters
plot(stackAll)
#Stack only Environmental carrying capacity (Climate data, Temperature)
StackClimatex <-c(TempC, Temp50, Temp70,LUElbe19)
plot(StackClimatex)

#res at 1km and dealing wth NA less ideal
Abundance[is.na(Abundance)] <- 0
StackClimatex[is.na(StackClimatex)] <- 0

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
sim_result_SF <- sim(obj = sim_dataSF, time = 4)
#use to plot the mean abundance graph at each time step
summary(sim_result_SF)
#plot the the predicted shift raster  at 3 time step
#t_1=current t_1=2050, t_1=2070
plot(sim_result_SF,
     time_points = c(1, 2, 3, 4),
     template = sim_dataSF$K_map
)



