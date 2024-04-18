####Correlation of repeat type content with genome size
##========================================================
library(pander)
library(stringr)
library(reshape)
library(ggplot2)
library(plotrix)
library(QuantPsyc)
library(yhat) 
library(car)
#opts_chunk$set(echo=FALSE, results='hide', cache=FALSE)  

source("funcionesNovak.R")

####Import your data into R

proportion<-read.table("./input_Contribution_script.csv",sep=";",as.is=TRUE,skip=2,header=FALSE,row.names=1)
genome_size<-read.table("./input_Contribution_script.csv",sep=";",nrows=1,header=TRUE)[,-c(1)] ##### [,-c(1)] keep header and firts row,and remove first column
colnames(proportion)=colnames(genome_size)
genome_size=unlist(genome_size)


###Multiple Linear Regression
###--------------------------
#{r multiple_lm, results='markup', echo=FALSE}

proportions3<-cbind(t(proportion),genome_size) # transpose and bind proportion and genome size 

colnames(proportions3)=make.names(colnames(proportions3))   # to make valid names

proportions3=as.data.frame(proportions3)

sel_col = c("genome_size" ,"rDNA","satellite","mobile_element","Class_I","LTR","Ty1_copia","Ale",
               #"Alesia",
            "Angela","Bianca","Ikeros","Ivana","SIRE","TAR","Tork","Ty3_gypsy","Athila","Ogre","Retand",
            "CRM","Tekay","Reina","pararetrovirus","LINE","EnSpm_CACTA","hAT","MuDR_Mutator","PIF_Harbinger",
            "Helitron","Unclassified_repeat_conflicting","Unclassified","All")

pr_used = proportions3[,sel_col]

fit2=lm(genome_size ~rDNA+satellite+mobile_element+Class_I+LTR+Ty1_copia+Ale+
          #Alesia+
          Angela+Bianca+Ikeros+Ivana+SIRE+TAR+Tork+Ty3_gypsy+Athila+Ogre+Retand+
          CRM+Tekay+Reina+pararetrovirus+LINE+EnSpm_CACTA+hAT+MuDR_Mutator+PIF_Harbinger+
          Helitron+Unclassified_repeat_conflicting+Unclassified+All,data=proportions3)

summary(fit2)

pandoc.p("beta coefficients:")
beta.coef=(lm.beta(fit2))
VIF=vif(fit2) # VARIANCE INFLATION FACTOR VIF = 1/(1-Ri^2)

# there are aliased coefficients in the model
# So, check using:
cor(proportions3)
# Alesia and Ty3_gypsy have 1 correlation, so I removed Alesia and repeat process


R2 = cor(pr_used$genome_size, pr_used[,-1])^2

# Calculate dRepet/dGenome size

dGenome=apply(expand.grid(proportions3$genome_size, proportions3$genome_size),1,function(x)x[1]-x[2])
dAllRepeats=apply(expand.grid(rowSums(proportions3[,-33]), rowSums(proportions3[,-33])),1,function(x)x[1]-x[2])
median(dAllRepeats/dGenome/10, na.rm = TRUE)
cor.test(rowSums(proportions3[,-33]),proportions3$genome_size)

nn= expand.grid(rownames(proportions3),rownames(proportions3)) ###data frame from all combinations
pd_list=list()
diff_range = list()
diff_median = diff_mean=numeric()


# script

for (i in names(proportions3[-33])){
  dRepeat = apply(expand.grid(proportions3[,i], proportions3[,i]),1,function(x)x[1]-x[2]) ### function (var2-var1)
  pd_list[[i]] = perc_diff = 100*dRepeat/(dGenome)
  diff_range[[i]] =signif( quantile(perc_diff, na.rm=TRUE, probs = c(0,.1,.25,.5,.75,.9,1)),3)
  diff_mean[i] = signif(mean(perc_diff, na.rm = TRUE),3)
  diff_median[i] = signif(median(perc_diff, na.rm = TRUE),3)
  plot(dRepeat,dGenome,main=i,pch=19,col="#00000040",cex=0.7)
}

hist(pd_list[[1]],breaks=100)
plot(diff_mean)
R2_brachy = cor(proportions3$genome_size, proportions3[,-33])^2

#cor test
p.val=apply(proportions3[,-33],2,function(x)cor.test(x,proportions3$genome_size)$p.value)

df2=data.frame(repeat_type=colnames(proportions3[,-33]),R2_brachy=signif(c(R2_brachy),3),p.value=signif(p.val,3),"contribution"=diff_median)
df2 = df2[order(df2$p.value),]
write.csv(df2, "output_Average_contribution_pairwise_differences_GenomeSizes_Brachy.csv")

diff_ranges = do.call(rbind,diff_range)
diff_ranges = diff_ranges[order(diff_ranges[,5], decreasing = TRUE),]

pandoc.p("quantiles of dRepeat/dGenome (%)")
print(as.data.frame(diff_ranges))
write.csv(df2, "output_quantiles_dRepeat_Brachy.csv")
