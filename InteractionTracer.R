# clears workspace:  
rm(list=ls()) 

# sets working directories:
setwd("/Path/to/files/")
library(R2jags)
library(ggplot2)

#Record of Cop's Violent Altercations are in rows, 
# columns are equal to communities in which altercations
# occured. 

#Version 1. Each individual cop, each individual community.
y <- t(matrix(c(list(0,1,5,3,0), 
                   list(2,3,6,2,1),
                   list(1,1,4,3,2)), 
                 nrow=5, ncol=3)
          )

PD <- 3 #sum(sub1$fpos)
CITY <- 5 #sum(sub1$hits)
N <- c(20, 30, 15)

data <- list("PD", "CITY", 'y', 'N')

myinits <- list(list('theta'=matrix(runif(1,0,1),5,3)),
                list('theta'=matrix(runif(1,0,1),5,3)),
                list('theta'=matrix(runif(1,0,1),5,3))
)

parameters <- c('theta')

samples <- jags(data, inits=myinits, parameters,
                model.file ="badApples.txt", n.chains=3, n.iter=1000, 
                n.burnin=1, n.thin=1, DIC=T)



#######Version 2: ####### 
#Each individual cop, each individual community, 
# infer interactions per community.
y <- t(matrix(c(list(0,1,5,3,0), 
                list(2,3,6,2,1),
                list(1,1,4,3,2)), 
              nrow=5, ncol=3)
)

PD <- 3 #sum(sub1$fpos)
CITY <- 5 #sum(sub1$hits)
nmax <- 100

data <- list("PD", "CITY", 'y', 'nmax')

myinits <- list(list('theta'=matrix(runif(1,0,1),5,3), 'N'=rep(nmax,3)),
                list('theta'=matrix(runif(1,0,1),5,3), 'N'=rep(nmax,3)),
                list('theta'=matrix(runif(1,0,1),5,3), 'N'=rep(nmax,3))
)

parameters <- c('theta', 'N')

samples <- jags(data, inits=myinits, parameters,
                model.file ="badApples-UnkN.txt", n.chains=3, n.iter=1000, 
                n.burnin=1, n.thin=1, DIC=T)


#######Version 3: ####### 
#Each individual cop, each individual community, 
# infer interactions per community, assume there
# is a base rate of violent assaults in the dept
# that is the aggregate of all communities.
y <- t(matrix(c(list(0,1,5,3,0), 
                list(2,3,6,2,1),
                list(1,1,4,3,2)), 
              nrow=5, ncol=3)
)

PD <- 3 #sum(sub1$fpos)
CITY <- 5 #sum(sub1$hits)
nmax <- 100

data <- list("PD", "CITY", 'y', 'nmax')

myinits <- list(list('theta'=matrix(runif(1,0,1),5,3), 'N'=rep(nmax,3), 'sigma'=rep(runif(1,0,1),3), 'delta'=runif(1,0,1)),
                list('theta'=matrix(runif(1,0,1),5,3), 'N'=rep(nmax,3), 'sigma'=rep(runif(1,0,1),3), 'delta'=runif(1,0,1)),
                list('theta'=matrix(runif(1,0,1),5,3), 'N'=rep(nmax,3), 'sigma'=rep(runif(1,0,1),3), 'delta'=runif(1,0,1))
)

parameters <- c('theta', 'N', 'delta')

samples <- jags(data, inits=myinits, parameters,
                model.file ="AggregatePDArrests-BadCops.txt", n.chains=3, n.iter=1000, 
                n.burnin=1, n.thin=1, DIC=T)

#######Version 4: ####### 
#Each individual cop, each individual community, 
# infer interactions per community, assume there
# is a base rate of violent assaults in the dept
# that is different per communities.
y <- t(matrix(c(list(0,1,8,3,0), 
                list(2,3,9,2,1),
                list(1,1,6,3,2)), 
              nrow=5, ncol=3)
)

PD <- 3 #sum(sub1$fpos)
CITY <- 5 #sum(sub1$hits)
nmax <- 40

data <- list("PD", "CITY", 'y', 'nmax')

myinits <- list(list('theta'=matrix(runif(1,0,1),5,3), 'N'=rep(nmax,5), 'sigma'=matrix(runif(1,0,1),3,5), 'bias'=rep(runif(1,0,1),5), 'alpha'=rep(runif(1,0,1),3)),
                list('theta'=matrix(runif(1,0,1),5,3), 'N'=rep(nmax,5), 'sigma'=matrix(runif(1,0,1),3,5), 'bias'=rep(runif(1,0,1),5),'alpha'=rep(runif(1,0,1),3)),
                list('theta'=matrix(runif(1,0,1),5,3), 'N'=rep(nmax,5), 'sigma'=matrix(runif(1,0,1),3,5), 'bias'=rep(runif(1,0,1),5),'alpha'=rep(runif(1,0,1),3))
)

parameters <- c('theta', 'bias', 'sigma', 'N', 'alpha')

samples <- jags(data, inits=myinits, parameters,
                model.file ="badPDxCom-UnkN.txt", n.chains=3, n.iter=10000, 
                n.burnin=1000, n.thin=1, DIC=T)



#plotbody <-ggplot(subdata, aes(cop2Theta3, cop2N3)) + geom_point() + theme_classic() + ggtitle('Posterior Predictive Plot')
#ggExtra::ggMarginal(plotbody,type="densigram")


#######Version 5: ####### 
#Each individual cop, each individual community, 
# with known N interactions with comm, assume there
# is a base rate of violent assaults in the dept
# that is different per communities.
y <- t(matrix(c(list(0,1,8,3,0), 
                list(0,3,9,0,1),
                list(1,1,6,3,2)), 
              nrow=5, ncol=3)
)

N <- t(matrix(c(list(3,4,13,6,10), 
                list(10,10,11,10,10),
                list(3,4,12,10,10)), 
              nrow=5, ncol=3)
)

PD <- 3 #sum(sub1$fpos)
CITY <- 5 #sum(sub1$hits)
nmax <- 100

data <- list("PD", "CITY", 'y', 'N')

myinits <- list(list('theta'=matrix(runif(1,0,1),5,3), 'sigma'=matrix(runif(1,0,1),3,5), 'delta'=rep(runif(1,0,1),5)),
                list('theta'=matrix(runif(1,0,1),5,3), 'sigma'=matrix(runif(1,0,1),3,5), 'delta'=rep(runif(1,0,1),5)),
                list('theta'=matrix(runif(1,0,1),5,3), 'sigma'=matrix(runif(1,0,1),3,5), 'delta'=rep(runif(1,0,1),5))
)

myinits <- list(list('theta'=matrix(runif(1,0,1),5,3), 'alpha'=rep(runif(1,0,1),3), 'delta'=rep(runif(1,0,1),5)),
                list('theta'=matrix(runif(1,0,1),5,3), 'alpha'=rep(runif(1,0,1),3), 'delta'=rep(runif(1,0,1),5)),
                list('theta'=matrix(runif(1,0,1),5,3), 'alpha'=rep(runif(1,0,1),3), 'delta'=rep(runif(1,0,1),5))
)

parameters <- c('theta', 'N', 'delta', 'sigma', 'alpha')

samples <- jags(data, inits=myinits, parameters,
                model.file ="badPDxCom-KnownN.txt", n.chains=3, n.iter=10000, 
                n.burnin=5000, n.thin=1, DIC=T)


