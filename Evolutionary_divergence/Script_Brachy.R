
library(igraph)

getwd()

#CL1.ncol -> Retand
#CL2.ncol -> Ikeros
#CL3.ncol -> Tekay
#CL4.ncol -> MuDR_Mutator
#CL5.ncol -> Ogre
#CL6.ncol -> Ale
#CL7.ncol -> Ivana
#CL8.ncol -> EnSpm_CACTA
#CL9.ncol -> TAR
#CL10.ncol-> SIRE
#CL11.ncol-> 5S_rDNA
#CL12.ncol-> satellite



lineages = c('Retand','Ikeros','Tekay','MuDR_Mutator','Ogre','Ale','Ivana','EnSpm_CACTA','TAR','SIRE','5S_rDNA','satellite')
ord=c(1,2,3,4,5,6,7,8,9,10,11,12)


fs= dir("./output_sortOutHitsort_script",pattern="ncol$",full.names=TRUE)
#fs= dir("./p",pattern="ncol$",full.names=TRUE)


for (ncolfile in fs){
  cmd = paste("cat ",ncolfile ," | ./analyze_hitsort_brachy.py ",
              ncolfile,".species_counts ",
              sep='')
  print(cmd)
  system(cmd,intern=TRUE)
  print("done\n--------------------------------------------------------------\n")
}



NC=dir("./output_sortOutHitsort_script",pattern="species_counts$",full.names=TRUE)


i=1
dflo=read.table(NC[i], header=TRUE, row.names=1)

groups=list(
  gl1=c("AA","AC","AD","AB","AE","AF","AG","AH","AI","AK","AL","AM","AN","AO","AP","AQ","AS","AT","AR","AU","AV","AW","AX","AY","AZ","BA","BC","BD","BE","BF","BG","BH","BI","BJ","BL","BP","BX","BY","MB","MD","MC","DA","SA","HA"))


group=groups[['gl1']]

homo_heterohits =function(df,group){
  dfpart=df[,group]
  spec=substring(rownames(dfpart),1,2)
  dfpart=dfpart[spec %in% group,]
  #recalculate
  spec=substring(rownames(dfpart),1,2)
  #homo hits
  homohits=rowSums(outer(spec,colnames(dfpart),FUN="==")*dfpart)
  heterohits= rowSums(dfpart)-homohits
  ## normalize to counts!!
  spec_counts = table(spec)
  other_counts = nrow(dfpart) - table(spec)
  
  norm_homo = homohits/spec_counts[spec]
  norm_hetero = heterohits/other_counts[spec]
  return (cbind(norm_homo,norm_hetero))
}


norm_counts=list()
for (i in 1:12){
  print(i)
  norm_counts[[i]] = list()
  df=read.table(NC[i], header=TRUE, row.names=1)
  for (g in seq_along(groups)){
    norm_counts[[i]][[g]] = homo_heterohits(df,groups[[g]])	
  }
}


shown_groups = c(1,2,3,4,5,6,7,8,9,10,11,12)
#plotting:
png("./output_sortOutHitsort_script/histogram_Brachy_divergence.png", width=4000,height=2500,pointsize=40)
par(mar=c(0,1,1,2),xaxs='i')
layout(
  cbind(rep(0,7),matrix(c(rep(0,6), 1:30,rep(0,6)),ncol=6,byrow = TRUE)),
  height=c(.2,rep(1,5),0.2),
  width=c(.1,rep(1,6))
  
)
for (g in seq_along(groups)){
  for (i in shown_groups){
    # log(intraspecific/interspecific)
    main=ifelse(g==1,lineages[i],"")
    hist(log10(norm_counts[[i]][[g]][,1]/norm_counts[[i]][[g]][,2]),
         xlim=c(-2,5),breaks=seq(-100,100,.1),col='1',
         xlab="",main=main,
         ylab = ''
         ,axes = FALSE)
    axis(2,lwd=7)
    abline(v=0,col='grey',lwd=5)
    if (g == 5){
      axis(1,lwd=7,line = 0, at=seq(-4,12,1))
    }
  }
}
dev.off()

png("./output_sortOutHitsort_script/histogram_Brachy_divergence.png", width=600*3.5,height=9*600,pointsize=60)
par(mar=c(0,5,1,2),xaxs='i',cex.axis=1.3)
layout(
  matrix(c(0,1:12,0),ncol=1,byrow = TRUE),
  height=c(.2,rep(1,12),0.5),
  width=c(.1,rep(1,6))
)
ord=c(1,2,3,4,5,6,7,8,9,10,11,12)
for (i in ord){
  # log(intraspecific/interspecific)
  main=lineages[i]
  hist(log10(norm_counts[[i]][[1]][,1]/norm_counts[[i]][[1]][,2]),
       xlim=c(-2,5),breaks=seq(-100,100,.1),col='1',
       xlab="",main='',
       ylab = ''
       ,axes = FALSE)
  axis(2,lwd=12,cex=1.3)
  abline(v=0,col='grey',lwd=5)
  #if(main!="Satellite"){
    mtext(main,cex=1.5,line=-2, adj=0.9)
  }
#}
#mtext(main,cex=1.5,line=-2, adj=.6)
par(cex.axis=2)
par(mgp = c(4,2,0))
axis(1,lwd=10,at=seq(-4,12,1))
dev.off()



