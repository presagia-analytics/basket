#library(testthat)
library(basket)
#library(igraph)
#library(foreach)


data(vemu_wide)

baskets <- 1:6

vemu_wide <- vemu_wide[baskets,]

# Full Bayes
exactRes <- mem_full_bayes_exact(responses = vemu_wide$responders, 
                     size = vemu_wide$evaluable,
                     name = vemu_wide$baskets, p0=rep(0.15, length(basket)))



print(exactRes$call)

print(exactRes$basketwise$PEP)
print(exactRes$basketwise$MAP)
print(exactRes$basketwise$CDF)
print(exactRes$basketwise$HPD)
print(exactRes$basketwise$ESS)
print(exactRes$basketwise$mean_est)
print(exactRes$basketwise$median_est)


print(exactRes$clusterwise$cluster)
print(exactRes$clusterwise$CDF)
print(exactRes$clusterwise$HPD)
print(exactRes$clusterwise$ESS)
print(exactRes$clusterwise$mean_est)
print(exactRes$clusterwise$median_est)



OCTable(exactRes$basketwise)
OCTable(exactRes$clusterwise)


exactResNew <- updateResult(exactRes, 0.25)

OCTable(exactRes$basketwise)
OCTable(exactResNew$basketwise)

OCTable(exactRes$clusterwise)
OCTable(exactResNew$clusterwise)





#rm(list=ls())
## Vectors of Observed number of Responses (X) and Patients (N)
Data <- dget("../inst/code-from-brian/MHAlgorithm/Vemu-data.txt") 

MHResult1 <- mem_full_bayes_mcmc(responses=Data$X, size=Data$N, 
                                 name=c("NSCLC ","CRC.v ","CRC.vc","  BD  ","ED.LH "," ATC  "),
                                 p0 = c(0.15, 0.15, 0.15, 0.2, 0.15, 0.15), Initial = NA)



print(MHResult1$call)

print(MHResult1$basketwise$PEP)
print(MHResult1$basketwise$MAP)
print(MHResult1$basketwise$CDF)
print(MHResult1$basketwise$HPD)
print(MHResult1$basketwise$ESS)
print(MHResult1$basketwise$ESS2)
print(MHResult1$basketwise$mean_est)
print(MHResult1$basketwise$median_est)


print(MHResult1$clusterwise$cluster)
print(MHResult1$clusterwise$CDF)
print(MHResult1$clusterwise$HPD)
print(MHResult1$clusterwise$ESS)
print(MHResult1$clusterwise$ESS2)
print(MHResult1$clusterwise$mean_est)
print(MHResult1$clusterwise$median_est)

OCTable(MHResult1$basketwise)
OCTable(MHResult1$clusterwise)

res<-exactRes
p0<-0.25
updateResult<-function(res, p0, alternative="greater")
{
  
  if (length(p0) == 1) {
    p0 <- rep(p0, length(res$basketwise$responses))
  }
  ret <- res
  #basket
  ret$basketwise$p0 <- p0
  ret$basketwise$alternative <- alternative
  
  
  if (grepl("exact", res$call[1]))
  {
    
    
  }else{
    MODEL <- ret$basketwise
    ret$basketwise$CDF <- mem.PostProb(MODEL, fit = ret$basketwise)
    
    #cluster
    retB <- ret$basketwise
    sampleC <- ret$clusterwise$samples
    numClusters <- length(ret$clusterwise$name)
    p0Test <- unique(retB$p0)
    allCDF <- matrix(0, 0, 2)
    for (kk in 1:length(p0Test))
    {
      if (retB$alternative == "greater") {
        res1 <- unlist(lapply(
          1:numClusters,
          FUN = function(j, x, t) {
            return(sum(x[[j]] > t) / length(x[[j]]))
          },
          x = sampleC,
          t = p0Test[kk]
        ))
      } else{
        res1 <- unlist(lapply(
          1:numClusters,
          FUN = function(j, x, t) {
            return(sum(x[[j]] > t) / length(x[[j]]))
          },
          x = sampleC,
          t = p0Test[kk]
        ))
      }
      allCDF <- rbind(allCDF, res1)
    }
    colnames(allCDF) <- ret$clusterwise$name
    rownames(allCDF) <- p0Test
    ret$clusterwise$CDF <- allCDF
  }
  return(ret)
}

MHResult1New <- updateResult(MHResult1, 0.1)

OCTable(MHResult1$basketwise)
OCTable(MHResult1New$basketwise)

OCTable(MHResult1$clusterwise)
OCTable(MHResult1New$clusterwise)


result <- cluster_PEP(responses=Data$X, size=Data$N, 
            name=c("NSCLC ","CRC.v ","CRC.vc","  BD  ","ED.LH "," ATC  "),
            models=MHResult1$models, pweights=MHResult1$pweights, p0 = 0.15,
            PEP=MHResult1$PEP)

print(result$clusters)
print(result$HPD)
print(result$CDF)

print(result$mean_est)
print(result$median_est)
print(result$ESS)
print(result$ESS2)
plot(density(result$samples[,1]))
plot(density(result$samples[,2]))



#rm(list=ls())

#source("pep.r")

trial_sizes <- rep(15, 6)

# The response rates for the baskets.
resp_rate <- 0.15
# The trials: a column of the number of responses, a column of the
# the size of each trial.
trials <- data.frame(responses = c(1,4, 5,0, 1, 6),
                    size = trial_sizes
                    )

MHResult2 <- mem_full_bayes_mcmc(trials$responses, trials$size,
                                 name=c(" D1 "," D2 "," D3 "," D4 "," D5 "," D6 ")) 


result <- cluster_PEP(responses = trials$responses, size = trials$size,
                      name=c(" D1 "," D2 "," D3 "," D4 "," D5 "," D6 "),
                      models=MHResult2$models, pweights=MHResult2$pweights, p0 = 0.15,
                      PEP=MHResult2$PEP)
print(trials)
print(result$clusters)
print(result$HPD)
print(result$mean_est)
print(result$median_est)
print(result$ESS)
print(result$ESS2)
plot(density(result$samples[,1]))


