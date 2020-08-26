library(mgcv)
library(tidyverse)



get_uid_coef <- function(mod){
  uid_scores <- c()
  for (i in names(mod$coefficients)){
    if (grepl('uid', i)){
      uid_scores <- c(uid_scores, mod$coefficients[[i]])
    }
  }
  uid_scores
}

# set dir and load input data
setwd("~/projects/immunity/")
load("data/data_PRISM.Rdata")

# load cached models
load("output/fever/mod_fev_2.Rdata", verbose=T)
load("output/parasite/mod_pars_2.Rdata", verbose=T)
load("output/malaria/mod_mal_2.Rdata", verbose=T)


random_effects <- tibble(
  uid_f = levels(dat$uid_f),
  antidisease_re = get_uid_coef(mod_fev_2),
  antiparasite_re = get_uid_coef(mod_pars_2),
  antimalaria_re = get_uid_coef(mod_mal_2)
) %>% left_join(dat)

write_csv(random_effects, "../phage_display/data/cohort_meta/random_effects.csv")
