setwd("~/github/MT_flanker/exp2/results/")

rawData<-read.csv("processed.csv")

# clean up data...had to remove an additional 4 trial failures (total of 8,800 trials)
dataStep3<-subset(rawData,subset=accuracy==1) # remove errors

meanRT<-mean(dataStep3$rt)
sdRT<-sd(dataStep3$rt)
data<-subset(dataStep3,subset=rt<meanRT+3*sdRT & rt>200) # remove 3 SD outliers


dataLeftCongruent<-subset(data,congruity=="congruent" & targetSide=="left")
dataLeftIncongruent<-subset(data,congruity=="incongruent" & targetSide=="left")
dataRightCongruent<-subset(data,congruity=="congruent" & targetSide=="right")
dataRightIncongruent<-subset(data,congruity=="incongruent" & targetSide=="right")

SEmatrixLeftCongruent<-matrix(rep(0,22*101),nrow=22,ncol=101,byrow=TRUE)
SEmatrixLeftIncongruent<-matrix(rep(0,22*101),nrow=22,ncol=101,byrow=TRUE)
SEmatrixRightCongruent<-matrix(rep(0,22*101),nrow=22,ncol=101,byrow=TRUE)
SEmatrixRightIncongruent<-matrix(rep(0,22*101),nrow=22,ncol=101,byrow=TRUE)

for (i in 1:22){
  leftCongruent<-subset(dataLeftCongruent,subject_nr==i+100)
  leftIncongruent<-subset(dataLeftIncongruent,subject_nr==i+100)
  rightCongruent<-subset(dataRightCongruent,subject_nr==i+100)
  rightIncongruent<-subset(dataRightIncongruent,subject_nr==i+100)
  
  for (j in 1:101){
    SEmatrixLeftCongruent[i,j]<-mean(leftCongruent[,j+13])#/sqrt(length(leftCongruent[,j+20]))
    SEmatrixLeftIncongruent[i,j]<-mean(leftIncongruent[,j+13])#/sqrt(length(leftIncongruent[,j+20]))
    SEmatrixRightCongruent[i,j]<-mean(rightCongruent[,j+13])#/sqrt(length(rightCongruent[,j+20]))
    SEmatrixRightIncongruent[i,j]<-mean(rightIncongruent[,j+13])#/sqrt(length(rightIncongruent[,j+20]))
  }
}

xCoordsLeft=rep(0,202)
xCoordsRight=rep(0,202)
yCoordsLeft=rep(0,202)
yCoordsRight=rep(0,202)
SEleft=rep(0,202)
SEright=rep(0,202)
condition=rep(0,202)

for (i in 1:101){
  xCoordsLeft[i]=mean(dataLeftCongruent[,i+13])
  xCoordsRight[i]=-mean(dataRightCongruent[,i+13])
  yCoordsLeft[i]=mean(dataLeftCongruent[,i+114])
  yCoordsRight[i]=mean(dataRightCongruent[,i+114])
  SEleft[i]=sd(SEmatrixLeftCongruent[,i])/sqrt(22)
  SEright[i]=sd(SEmatrixRightCongruent[,i])/sqrt(22)
  condition[i]="congruent"
  
  xCoordsLeft[i+101]=mean(dataLeftIncongruent[,i+13])
  xCoordsRight[i+101]=-mean(dataRightIncongruent[,i+13])
  yCoordsLeft[i+101]=mean(dataLeftIncongruent[,i+114])
  yCoordsRight[i+101]=mean(dataRightIncongruent[,i+114])
  SEleft[i+101]=sd(SEmatrixLeftIncongruent[,i])/sqrt(22)
  SEright[i+101]=sd(SEmatrixRightIncongruent[,i])/sqrt(22)
  condition[i+101]="incongruent"
}


library("ggplot2")
trajectoryData=data.frame(yCoordsLeft,yCoordsRight,xCoordsLeft,xCoordsRight,SEleft,SEright,condition)
plot=ggplot(trajectoryData,aes())
pathLeft=geom_path(aes(x=yCoordsLeft,y=xCoordsLeft,linetype=condition),size=0.6)
ribbonLeft=geom_ribbon(aes(x=yCoordsLeft,ymin=xCoordsLeft-SEleft,ymax=xCoordsLeft+SEleft,linetype=condition),alpha=0.2)
pathRight=geom_path(aes(x=yCoordsRight,y=xCoordsRight,linetype=condition),size=0.6)
ribbonRight=geom_ribbon(aes(x=yCoordsRight,ymin=xCoordsRight-SEright,ymax=xCoordsRight+SEright,linetype=condition),alpha=0.2)
axisLabels=labs(y="x-coordinates",x="y-coordinates")
#theme(strip.text=element_text(face="bold",size=rel(1.5)))
legendFormat=theme(legend.title=element_text(face="bold",size=rel(1.5)),legend.text=element_text(size=rel(1.5)))
axisFormat=theme(axis.title=element_text(size=rel(1.4)))
legend=labs(linetype="Condition")+theme(legend.position=c(0.5,1))+theme(legend.background=element_rect(fill="white",colour="black"))
classic=theme_classic(20)+theme(axis.line.x=element_line(color="black",size=0.5,linetype="solid"),axis.line.y=element_line(color="black",size=0.5,linetype="solid"))

plot+pathLeft+ribbonLeft+pathRight+ribbonRight+axisLabels+axisFormat+legend+legendFormat+classic+coord_flip()+xlim(0,1.5)+ylim(-1,1)

# PERFORMANCE MEASURES
# RT
aggRT=aggregate(rt~subject_nr+congruity+targetSide,data=data,FUN="mean") # RT performance data aggregated by subject
RT.aov=aov(rt~congruity*targetSide+Error(as.factor(subject_nr)/(congruity*targetSide)),data=aggRT)
summary(RT.aov)
print(model.tables(RT.aov,"means"),digits=3)

# Init
aggInit=aggregate(init_time~subject_nr+congruity+targetSide,data=data,FUN="mean") # RT performance data aggregated by subject
Init.aov=aov(init_time~congruity*targetSide+Error(as.factor(subject_nr)/(congruity*targetSide)),data=aggInit)
summary(Init.aov)
print(model.tables(Init.aov,"means"),digits=3)

# MT
data$MT <- data$rt-data$init_time
aggMT=aggregate(MT~subject_nr+congruity+targetSide,data=data,FUN="mean") # RT performance data aggregated by subject
MT.aov=aov(MT~congruity*targetSide+Error(as.factor(subject_nr)/(congruity*targetSide)),data=aggMT)
summary(MT.aov)
print(model.tables(MT.aov,"means"),digits=3)
