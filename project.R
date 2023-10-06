library(mgcv)
# Loading the data in and summarising
load('/Users/sarveshwarisingh/Desktop/506 things/datasets_project.RData')
summary(TBdata)
head(TBdata)
str(TBdata)

# To take into account the differing population density within regions, an offset on the log of population will be applied
# Creating a new column for the same
TBdata$logpop <- log(TBdata$Population)
# Although the Region variable will not be used, the integer classification is changed to a more appropriate factor classification
TBdata$Region <- as.factor(TBdata$Region)

# To test the relative importance of socio-economic variables, the temporal component of the dataset will be made redundant 
# To do this, subsets of dataframe are obtained for each year

# Year 2012
library(dplyr)
dat2012 <- TBdata%>%
  filter(Year==2012)
dat2012

# First model on all socio-economic variables, with an offset to obtain rate per unit population
pois_2012 <- gam(TB~offset(logpop)+s(Indigenous)+s(Illiteracy)+s(Urbanisation)+s(Density)+s(Poverty)+s(Poor_Sanitation)+s(Unemployment)+s(Timeliness), data=dat2012, method="REML", family=poisson(link="log"))
gam.check(pois_2012)
summary(pois_2012)
# Effective degrees of freedom and significance of smooths suggest nonlinear
# partial relationships. However, the QQ plot does not look good, there is also a fanning effect in residual vs predictor plot

# To account for overdispersion, quasipoisson and negative binomial are used
# trying NB
pois_2012.q <- gam(TB~offset(logpop)+s(Indigenous)+s(Illiteracy)+s(Urbanisation)+s(Density)+s(Poverty)+s(Poor_Sanitation)+s(Unemployment)+s(Timeliness), data=dat2012, method="REML", family=nb(link="log"))
gam.check(pois_2012.q)
summary(pois_2012.q)
# The residual vs predictor plot now displays a random scatter and distribution of residuals is now approximately normal
# Clearly the negative binomial distribution is suitable for model-fitting
# Now that overdispersion has been considered, accurate significance for socio-economic variables is obtained

# Since Indigenous, Illiteracy, Urbanisation and Unemployemnt are linearly distributed - 
pois_2012.s <- gam(TB~offset(logpop)+Indigenous+Illiteracy+Urbanisation+s(Density)+s(Poverty)+s(Poor_Sanitation)+Unemployment+s(Timeliness), data=dat2012, method="REML", family=nb(link="log"))
gam.check(pois_2012.s)
summary(pois_2012.s)
plot(pois_2012.s)

# Illiteracy, Urbanisation, and Poverty smooth are not significant 
# They are removed 
pois_2012.s2 <- gam(TB~offset(logpop)+s(Density)+s(Poor_Sanitation)+Unemployment+s(Timeliness), data=dat2012, method="REML", family=nb(link="log"))
gam.check(pois_2012.s2)
summary(pois_2012.s2)
plot(pois_2012.s2)
# All remaining smooths and parameters are up to at least 10% significant

# The AIC reveals that this model is better than the full model (all socio-economic variables)
AIC(pois_2012.q, pois_2012.s2)

# This analysis will be repeated for all years to check if the same variables remain significant in explaining variance

# However before this, since the QQ plot is not perfect, the spatial component will be considered
pois_2012.s3 <- gam(TB~offset(logpop)+s(Density)+s(Poor_Sanitation)+Unemployment+s(Timeliness)+s(lat, lon, id="a"), data=dat2012, method="REML", family=nb(link="log"))
gam.check(pois_2012.s3)
summary(pois_2012.s3)
plot(pois_2012.s3)
# The smooth for spatial interaction is highly significant, although the QQ plot still shows a small right-skew pattern

# The AIC reveals that model including spatial component is significantly better than the model without
AIC(pois_2012.s2, pois_2012.s3)


# The same analysis is now performed for 2013 

# Year 2013
library(dplyr)
dat2013 <- TBdata%>%
  filter(Year==2013)
dat2013

# Again beginning with the full model
pois_2013 <- gam(TB~offset(logpop)+s(Indigenous)+s(Illiteracy)+s(Urbanisation)+s(Density)+s(Poverty)+s(Poor_Sanitation)+s(Unemployment)+s(Timeliness), data=dat2013, method="REML", family=poisson(link="log"))
gam.check(pois_2013)
summary(pois_2013)
# Effective degrees of freedom and significance of smooths suggest nonlinear
# partial relationships. However, the QQ plot does not look good, and there is also a fanning effect

# Since the Negative Binomial model worked better than quasipoisson for 2012, an NB distribution is utilised
pois_2013.q <- gam(TB~offset(logpop)+s(Indigenous)+s(Illiteracy)+s(Urbanisation)+s(Density)+s(Poverty)+s(Poor_Sanitation)+s(Unemployment)+s(Timeliness), data=dat2013, method="REML", family=nb(link="log"))
gam.check(pois_2013.q)
summary(pois_2013.q)
# Again, the fanning effect in residuals vs predictor plot has disappeared and QQ plot looks much better
# The overdispersion has been accounted for

# Since Illiteracy, Urbanisation and Poverty are linearly distributed -
pois_2013.s <- gam(TB~offset(logpop)+s(Indigenous)+Illiteracy+Urbanisation+s(Density)+Poverty+s(Poor_Sanitation)+s(Unemployment)+s(Timeliness), data=dat2013, method="REML", family=nb(link="log"))
gam.check(pois_2013.s)
summary(pois_2013.s)

# Indigenous, Illiteracy, Urbanisation and Poverty are found to be insignificant hence they are removed one by one
# First Poverty is removed 
pois_2013.s2 <- gam(TB~offset(logpop)+s(Indigenous)+Illiteracy+Urbanisation+s(Density)+s(Poor_Sanitation)+s(Unemployment)+s(Timeliness), data=dat2013, method="REML", family=nb(link="log"))
gam.check(pois_2013.s2)
summary(pois_2013.s2)

# Illiteracy is removed next
pois_2013.s3 <- gam(TB~offset(logpop)+s(Indigenous)+Urbanisation+s(Density)+s(Poor_Sanitation)+s(Unemployment)+s(Timeliness), data=dat2013, method="REML", family=nb(link="log"))
gam.check(pois_2013.s3)
summary(pois_2013.s3)

# Indigenous is removed, and following this on the same model insignificant Urbanisation is removed as well
pois_2013.s4 <- gam(TB~offset(logpop)+s(Density)+s(Poor_Sanitation)+s(Unemployment)+s(Timeliness), data=dat2013, method="REML", family=nb(link="log"))
gam.check(pois_2013.s4)
summary(pois_2013.s4)

# The same variables are eventually found to be significant as 2012, with Unemployment distributed linearly
# This implies robustness in information regarding impact of socio-economic variables on TB spread


# Since the QQ plot remains imperfect, the spatial component is included to explain some deviance
pois_2013.s5 <- gam(TB~offset(logpop)+s(Density)+s(Poor_Sanitation)+s(Unemployment)+s(Timeliness)+s(lat, lon, id="a"), data=dat2013, method="REML", family=nb(link="log"))
gam.check(pois_2013.s5)
summary(pois_2013.s5)

# AIC reveals that model with spatial component is significantly better than the model without
AIC(pois_2013.s5, pois_2013.s4)

# The same analysis is performed for 2014 and significant socio-economic variables are found to be the same

# Finally, given the knowledge of significant socio-economic variables, the interaction of spatial component is tested 
pois_all_ti <- gam(TB~offset(logpop)+s(Density)+s(Poor_Sanitation)+s(Unemployment)+s(Timeliness)+ti(lon,lat)+s(lon)+s(lat), data=TBdata, method="REML", family=nb(link="log"))
gam.check(pois_all_ti)
summary(pois_all_ti)
anova(pois_all_ti)
# Clearly, the interaction is significant. Hence an interaction smooth will be included in the model. Since the scales are same, using a smooth/tensor with same sp is appropriate

# Pooled dataset including spatial component to improve the accuracy of coefficients
pois_all <- gam(TB~offset(logpop)+s(Density, k=20)+s(Poor_Sanitation, k=20)+s(Unemployment, k=20)+s(Timeliness, k=20)+te(lon,lat, id="a"), data=TBdata, method="REML", family=nb(link="log"))
gam.check(pois_all)
summary(pois_all)
# All smooths including spatial component are highly significant

# AIC gives that this model is marginally better than the model with separate interaction and lat, lon variables
AIC(pois_all, pois_all_ti)

# However the QQ plot still does not look good. Time will be factored into the analysis and tested for significance
# Because the aim is to study TB spread over just 3 years, time variable is exhaustive and Random effects are not 
# necessary 

# Including Year as a categorical variable
TBdata$Year <- as.factor(TBdata$Year)
pois_all_cat <- gam(TB~offset(logpop)+Year+s(Density, by=Year)+s(Poor_Sanitation, by=Year)+s(Unemployment, by=Year)+s(Timeliness, by=Year)+s(lon,lat, by=Year, id="a"), data=TBdata, method="REML", family=nb(link="log"))
gam.check(pois_all_cat)
summary(pois_all_cat)
plot(pois_all_cat)

AIC(pois_all, pois_all_cat)

# VS Including Year as a tensor interaction; the number of unique values in variable is too low
pois_all_ti <- gam(TB~offset(logpop)+Year+s(Density, by=Year)+s(Poor_Sanitation, by=Year)+s(Unemployment, by=Year)+s(Timeliness, by=Year)+ti(lon, lat, as.integer(Year), k=c(40, 3),d=c(2,1)), data=TBdata, method="REML", family=nb(link="log"))
gam.check(pois_all_ti)
summary(pois_all_ti)
plot(pois_all_ti)
# The REML score is very high by comparison to previous and next models

# VS including Year as a factor smooth for socio-economic variables, and category for spatial interaction
nb_all_cat <- gam(TB~offset(logpop)+Year+s(Density, Year, bs="fs")+s(Poor_Sanitation, Year, bs="fs")+s(Unemployment, Year, bs="fs")+s(Timeliness, Year, bs="fs")+s(lon,lat, by=Year, id="a"), data=TBdata, method="REML", family=nb(link="log"))
gam.check(nb_all_cat)
plot(nb_all_cat)
summary(nb_all_cat)

# According to AIC, the best model is nb_all_cat
AIC(nb_all_cat, pois_all_cat, pois_all_ti)


# Fitting a QP model with spatio-temporal components
pois_all_cat_te <- gam(TB~offset(logpop)+Year+s(Density, Year, bs="fs")+s(Poor_Sanitation, Year, bs="fs")+s(Unemployment, Year, bs="fs")+s(Timeliness, Year, bs="fs")+s(lon,lat, by=Year, id="a"), data=TBdata, method="REML", family=quasipoisson(link="log"))
gam.check(pois_all_cat_te)
summary(pois_all_cat_te)
plot(pois_all_cat_te)

# Fitting a model using poisson instead of negative binomial for the rootogram
pois_all.test <- gam(TB~offset(logpop)+Year+s(Density, Year, bs="fs")+s(Poor_Sanitation, Year, bs="fs")+s(Unemployment, Year, bs="fs")+s(Timeliness, Year, bs="fs")+s(lon,lat, by=Year, id="a"), data=TBdata, method="REML", family=poisson(link="log"))
gam.check(pois_all)
summary(pois_all)

# Checking respective rootograms
library(countreg)
library(ggplot2)

root_pois <- rootogram(pois_all.test, style = "hanging", plot = FALSE)
root_nb   <- rootogram(nb_all_cat_te, style = "hanging", plot = FALSE)
autoplot(root_pois)
autoplot(root_nb)

# Table for dispersion parameters
library(gt)
sum(residuals(pois_all.test, type = "pearson")^2) / df.residual(pois_all.test)
sum(residuals(nb_all_cat_te, type = "pearson")^2) / df.residual(nb_all_cat_te)
sum(residuals(pois_all_cat_te, type = "pearson")^2) / df.residual(pois_all_cat_te)

# Creating a dataframe to create a table
dispersion <- data.frame(Distribution = c("Poisson", "Negative Binomial", "Quasipoisson"), 
                         Dispersion_Parameter = c(sum(residuals(pois_all.test, type = "pearson")^2) / df.residual(pois_all.test)
, 
sum(residuals(nb_all_cat_te, type = "pearson")^2) / df.residual(nb_all_cat_te)
                         ,
sum(residuals(pois_all_cat_te, type = "pearson")^2) / df.residual(pois_all_cat_te)
                         ))
dispersion_table <- gt(dispersion)%>%
  tab_header(
    title = "Overdispersion and distribution choice"
  )%>%
  cols_label(
    Distribution = "Distribution", 
    Dispersion_Parameter = "Dispersion Parameter"
  )%>%
  fmt_number(
    columns = Dispersion_Parameter, 
    decimals = 2
  )%>%
  tab_style(
    style = cell_text(weight = "bold"), 
    locations = cells_column_labels(columns = everything())
  )%>%
  cols_align(
    align = "center",
    columns = Dispersion_Parameter
  )


# Clearly, the Negative Binomial model is the best fitting model of the three - poisson, quasipoisson, and NB

# Finally, some overdispersion remains in the case of negative binomial but this is much reduced from
# the case when poisson/quasipoisson is used. This model is finalised. 

# Temporal factors
nb.2 <- gam(TB~offset(logpop)+s(Density, Year, bs="fs")+s(Poor_Sanitation,Year, bs="fs")+s(Unemployment,Year, bs="fs")+s(Timeliness,Year, bs="fs"),data=TBdata, method="REML", family=nb(link="log"))
nb.2
gam.check(nb.2)
summary(nb.2)
plot(nb.2)

nb.3 <- gam(TB~offset(logpop)+s(Indigenous)+s(Illiteracy)+s(Urbanisation)+s(Density)+s(Poverty)+s(Poor_Sanitation)+s(Unemployment)+s(Timeliness)+Year,data=TBdata, method="REML", family=nb(link="log"))
nb.3
gam.check(nb.3)
summary(nb.3)
plot(nb.3)

class(year)

# AIC gives that although significant, temporal component alone is not sufficient to explain enough deviance
AIC(nb.2, nb_all_cat)
summary(nb_all_cat)

###### VISUALISATION #######
library(mgcv)
nb_all_cat <- gam(TB~offset(logpop)+Year+s(Density, Year, bs="fs")+s(Poor_Sanitation, Year, bs="fs")+s(Unemployment, Year, bs="fs")+s(Timeliness, Year, bs="fs")+s(lon,lat, by=Year, id="a"), data=TBdata, method="REML", family=nb(link="log"))

vis.gam(nb_all_cat, view=c("Poor_Sanitation", "Year"), plot.type="persp", theta=130, color="cm")
vis.gam(nb_all_cat, view=c("Density", "Year"), plot.type="persp", theta=220, phi=20,color="cm")
vis.gam(nb_all_cat, view=c("Unemployment", "Year"), plot.type="persp", theta=200,color="cm")
vis.gam(nb_all_cat, view=c("Timeliness", "Year"), plot.type="persp", theta=200,color="cm")
plot(nb_all_cat, scheme=3)

# Model comparison
AIC(nb_all_cat_te, pois_all.test)


# MIXED MODEL (GAMM)
install.packages("gamm4")
library(gamm4)
library(mgcv)

# Year as a random effect with basis function = "re"
nb.4 <- gam(TB~offset(logpop)+s(Density)+s(Poor_Sanitation)+s(Unemployment)+s(Timeliness)+s(lon, lat, id="a")+s(Year, bs="re"),data=TBdata, method="REML", family=nb(link="log"))
nb.4
gam.check(nb.4)
anova(nb.4)
summary(nb.4)
plot(nb.4)
?gamm4

# gamm is not designed to use extended families
nb.1 <- gamm(TB~offset(logpop)+s(Density)+s(Poor_Sanitation)+s(Unemployment)+s(Timeliness)+s(lon, lat, id="a"),data=TBdata, method="REML", random=list(Year=~1), family=nb(link="log"))
nb.1
gam.check(nb.4)
anova(nb.4)

# Plotting maps of Brazil
# Loading packages
library(fields)
library(maps)
library(sp)

# PLotting map of cases
plot.map(TBdata$TB[TBdata$Year==2014],n.levels=7,main="TB counts for 2014")
plot.map(TBdata$Timeliness[TBdata$Year==2014],n.levels=7,main="TB counts for 2014")
