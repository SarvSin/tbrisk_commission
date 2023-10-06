# Predicting spatial distribution of TB risk

Introduction
Tuberculosis (TB) is a highly contagious health threat, and quantification of its risk across a region is a crucial task. In this report, the factors influencing the rate of TB cases per unit population are assessed. For a period of 3 years, data on the number of cases in each region are analysed in association with information on various socio-economic variables.  The aim is to understand the influences of socio-economy, spatial, temporal and spatio-temporal factors on the level and spread of TB risk across Brazil. 

                                      <img width="224" alt="image" src="https://github.com/SarvSin/tbrisk_commission/assets/117599272/e14fdfe3-6814-45d6-af0b-2009bac3f5c5">

                                                    Figure 1: Spatial distribution of TB risk according to model, 2013

Methods 
The Generalised Additive Models framework will be used to analyse this problem. Public health data, especially concerning the risk and spread of disease, involves dependence on multiple socio-economic, spatial, and temporal covariates. Forcing a fixed parametric form on complex, unknown relationships can lead to ill-fitting models with adverse consequences. However, GAMs do not require any assumptions on specific forms of relationship between the covariates and the response variable. It is this flexibility that makes this framework ideal for the present problem. 

The number of cases observed in circumscribed monitoring regions depends on the population living in each region. Since this number is different for different regions, modelling the rate instead of count is pursued. To do so, a log of the population size in each monitoring location is added as an “offset” to the covariates as a rearrangement of log of the rate given by cases/unit of population. In addition, because the proportion of cases in a population is small, the Poisson approximation to a Binomial is appropriate. 

Finally, for a response variable distributed according to Poisson, the variance is equal to the mean. After adjusting the structure of the model as described above, extra variance and significant deviance remained. In this analysis, overdispersion is modelled by the Negative Binomial distribution. (Fig. 3)


  <img width="217" alt="image" src="https://github.com/SarvSin/tbrisk_commission/assets/117599272/51e69042-0578-49e0-adf3-2cdeea8b8d7f">

                               Figure 2: (a) Poor Sanitation and TB risk, 2012-14; 

                               <img width="212" alt="image" src="https://github.com/SarvSin/tbrisk_commission/assets/117599272/033dcb68-7ea4-4c50-b8d1-a5b9fb670757">

                               Figure 2: (b) Timeliness and TB risk, 2012-14


Results
Firstly, to assess the significance of socio-economic covariates and a potential influence of spatial factors, data is purged of any temporal aspects. Original data is subset according to years, and the statistical method of reduction is applied to obtain a model with the highest explanatory power. Doing so for each year out of three yields the same set of highly significant socio-economic covariates, thus affirming the robustness of the model. These variables include Density, Unemployment, Poor Sanitation and Timeliness; their values are found to be consistently influential on TB risk. 

Higher dwelling density is found to have a positive impact on TB risk (Fig. 4(b)); this is understandable as tuberculosis is predominantly an airborne disease. Timeliness is the amount of time taken for a correct diagnosis to be made, and to be reported to the health system. Expectedly, efficiency in the medical sector is a positive determinant in reduction of TB risk (Fig. 2(b)). A higher number of unemployed people in a household contributes to an increased risk of TB (Fig. 4(a)). Unemployment is associated with limited financial resources for sustenance. With a reduced capacity to manage health and nutrition, the influence of unemployment on TB risk is expected as malnutrition severely affects the human immune system. Finally, the non-negative impact of poor sanitation on TB risk is self-evident (Fig. 2(a)); bad personal hygiene can have a significant effect on TB. 


                                       <img width="262" alt="image" src="https://github.com/SarvSin/tbrisk_commission/assets/117599272/977f979f-c33a-4792-bb96-d09add499485">

                                    Figure 4: Dispersion parameter differences across distributions


Although these covariates explained a portion of the variance in TB risk, analysing the model fit suggested that some other influential factor was missing from the model. Hence, spatial data was included in the assessment and was found to be highly significant. By including an interaction between the geographical coordinates of regions, the model fit improved and implied the importance of spatial factors in explaining a portion of TB risk besides socio-economic variables selected above. The validation metrics of these models for each year still implied room for improvement. Given the knowledge of specific significant socio-economic factors, and a spatial explanation for TB risk, the data was then pooled to analyse if any overall temporal component was influential.

  <img width="187" alt="image" src="https://github.com/SarvSin/tbrisk_commission/assets/117599272/d66b099d-2d3c-4750-b777-3cfc01e5490b">
          
                          Figure 3: (a) Unemployment and TB risk, 2012-14; 

                          <img width="192" alt="image" src="https://github.com/SarvSin/tbrisk_commission/assets/117599272/31f72b8e-9c7b-433e-986f-8ba5071c63e8">

                          Figure 3: (b) Dwelling density and TB risk, 2012-14

To begin, only the temporal nature of the data was analysed.  All non-spatial covariates were fit with variable Year as the factor smooth, and this model yielded highly significant components. Although an inclusion of time as a differential intercept did not prove to be significant, its association with other non-spatial covariates was consistently informative. This implied a potentially useful interaction of time with the spatial component of data. Thus, an interaction of coordinates with variable Year was tested in multiple methodological variations. 

Considering the aim to quantify risk only across 3 years (2012-2014) and to not extract any predictive value over a longer period, the inclusion of time as a random effect is considered to be redundant. The information given in this case, for both temporal and spatial components, is exhaustive. However, a model with time as a random effect is still fit in the case of expansion of the aim to assess the general influential power of these socio-economic, spatial, and temporal aspects. For this report, the model consists of Year as an interaction “factor-smooth” with other significant socio-economic variables, and as categorical variable for analysis of the spatio-temporal component. This component is found to be highly significant, further to significance of interaction of time with other covariates. Analysis of the nature of this influence reveals that areas in the eastern part of Brazil have a greater propensity for increased TB risk. Given the significance of timeliness, poor sanitation, dwelling density, and unemployment on risk and the prevalence of these socio-economic issues in this region, this observation is not surprising. Within the eastern region, central- areas are more vulnerable relative to north- and south-eastern areas. 


Conclusion
This report provides quantitative evidence on the relative importance of various socio-economic factors, and spatial and temporal influences on TB risk in Brazil. Regions in the eastern part of Brazil are most vulnerable to increased risk. The pattern of spread does not appear to have changed significantly (see Fig. 1, 5), though the area of spread in central-eastern Brazil seems to have concentrated through the years. Given the influence of poor sanitation, dwelling density, unemployment, and timeliness of diagnosis on TB risk, it is recommended that the hygiene, and organisation of medical facilities in these regions be given special attention. Although it is clear from Figures 2 and 3 that these aspects of socio-economy are improving with time, public services may also focus on improving the economy of regions at risk. Finally, it must be acknowledged that measurement error, remaining unexplained variance, and the limitation in temporal data renders the results of this report specific, and an incomplete description of influences on TB risk in Brazil over 2012-2014. 


  <img width="226" alt="image" src="https://github.com/SarvSin/tbrisk_commission/assets/117599272/4fa95e25-bfec-4ef1-b9c5-31dc0423b040">

                                                       Figure 5: Spatial distribution of TB risk, (a) 2012; 
                                                       
          <img width="224" alt="image" src="https://github.com/SarvSin/tbrisk_commission/assets/117599272/254a14ac-0c48-4bdb-b59c-125ce4b3aa28">
                                             
                                                       Figure 5: (b) 2014



