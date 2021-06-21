
library(ggplot2)
library(reshape2)
library(grid)
corlor=c("#E41A1C","#1E90FF","#4DAF4A","#984EA3","#FF7F00","#FFFF33","#A65628","#F781BF"
         ,"#999999","#A6CEE3","#1F78B4","#B2DF8A","#33A02C","#FB9A99","#E31A1C","#FDBF6F"
         , "#CAB2D6","#6A3D9A","#FFFF99","#B15928","#66C2A5","#FC8D62","#8DA0CB","#E78AC3"
         ,"#A6D854","#FFD92F","#E5C494","#B3B3B3")

da1=read.table("/home/majorbio2/metagenome/data/eggNOG.cog.xls",sep="\t",comment.char = "",head=T,check.names = F)
rownames(da1) <-da1[,1]
da2=read.table("/home/majorbio2/metagenome/data/eggNOG.function.xls",sep="\t",comment.char = "",head=T,check.names = F)
rownames(da2) <-da2[,1]



##############################
data2=da2[,2:(ncol(da2)-1)]
rowsum <-sapply(1:nrow(data2),function(x) sum(data2[x,]))
data2<-data2[order(rowsum,decreasing=TRUE),]

labes=da2[rownames(data2),c(1,ncol(da2))]
labes=sapply(1:nrow(labes),function(x) paste(labes[x,1],":",labes[x,2]))

datm2=melt(t(data2),measure.vars=colnames(data2))
colnames(datm2)=c("x","y","z")

plot2=ggplot(datm2, aes(factor(y,levels=rownames(data2)), z,fill=factor(y,levels=rownames(data2))))+ 
  geom_boxplot(outlier.colour = "gray10", outlier.size = 0.7,size=0.5)+
  #scale_fill_brewer(palette="Set1",type="qual")
  scale_fill_manual(values=corlor,labels=labes)+
  theme(axis.text.x = element_text(hjust = 1, colour = "gray10",size=12),
        panel.background=element_rect(color="transparent"),
        legend.text = element_text( size = 8),
        legend.key.size=unit(0.7,"cm"),
        text=element_text(size=17))+
  xlab("Function Class")+ylab("Gene abundance")+labs(fill=" ")

da2_col=as.matrix(corlor[1:nrow(data2)])
rownames(da2_col)=rownames(data2)


######### group corlor  #######

data1=da1[,2:(ncol(da1)-1)]
top=50
if(top==0 || top > nrow(data1)){
  top=nrow(data1)
}
rowsum <-sapply(1:nrow(data1),function(x) sum(data1[x,]))
data1<-data1[order(rowsum,decreasing=TRUE),][1:top,]

groupc = read.table("/root/database/info/NOG.funccat.txt",sep="\t")
rownames(groupc) <-groupc[,1]
da1_group=groupc[rownames(data1),]
da1_group=as.vector(sapply(da1_group[,2],function(x) substr(x,1,1)))

da1_col=as.vector(da2_col[da1_group,])

datm1=melt(t(data1),measure.vars=colnames(data1))

colnames(datm1)=c("x","y","z")

plot1=ggplot(datm1, aes(factor(y,levels=rownames(data1)), z,fill=factor(y,levels=rownames(data1))))+ 
  geom_boxplot(outlier.colour = "gray10", outlier.size = 0.7,size=0.5)+
  #scale_fill_brewer(palette="Set1",type="qual")
  scale_fill_manual(values=da1_col)+
  theme(axis.text.x = element_text(angle = 70, hjust = 1, colour = "gray10",size=10),
      panel.background=element_rect(color="transparent"),
      legend.position="none",
      text=element_text(size=17))+
  xlab("COG")+ylab("Gene abundance")


pdf("cog.box.pdf",width=12,height=14)
grid.newpage()
pushViewport(viewport(layout=grid.layout(2,1,heights=c(3,3))))

print(plot2, vp=viewport(layout.pos.row=1,layout.pos.col=1))
print(plot1, vp=viewport(layout.pos.row=2,layout.pos.col=1))

dev.off()
	
	
