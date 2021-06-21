# Visilation with R
library(pheatmap)
# file write in ；
data<-read.table("data.xls",header = T,sep = "\t")
#grouping informaton
annotation<-data.frame(Type=as.vector(df[,1]))
#change row names；
rownames(data)<-data[,1]
# Draw a heatmap
pheatmap(data[,-1],cellheight = 15,cellwidth = 8.5,border_color = NA,angle_col = 45,fontsize = 5, color = colorRampPalette(colors = c("#e0e5df","#ececea","#b5c4b1"))(100))