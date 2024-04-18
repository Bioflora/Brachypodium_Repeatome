rectMap=function(x,scale.by='row',col=1,xlab="",ylab=""){
  if (scale.by=='row'){
    x=(x)/apply(x,1,max)
  }
  if (scale.by=='column'){
    x=t(t(x)/apply(x,2,max))
  }
  nc=ncol(x)
  nr=nrow(x)
  coords=expand.grid(1:nr,1:nc)
  plot(coords[,1],coords[,2],type='n',axes=F,xlim=range(coords[,1])+c(-.5,.5),ylim=range(coords[,2])+c(-.5,.5),xlab=xlab,ylab=ylab)
  axis(1,at=1:nr,labels=rownames(x),lty=0,tick=FALSE,line=-1)
  axis(2,at=1:nc,labels=colnames(x),lty=0,tick=FALSE,las=2,line=-1)
  s=(c(x)^(1/2))/2  # to get it proportional
  rect(coords[,1]-s,coords[,2]-s,coords[,1]+s,coords[,2]+s,col=col)
  abline(v=0:(nr)+.5,h=0:(nc)+.5,lty=2)
  
  
}

pieScatter=function(x,y,prop,radius=1,col=NULL,...){
  plot(x,y,type='n',...)
  for (i in seq_along(x)){
    p=prop[[i]][prop[[i]]!=0]
    if (length(radius)==1){
      r=radius
    }else{
      r=radius[i]
    }
    floating.pie(x[i],y[i],p,col=col,radius=r)
  }
}