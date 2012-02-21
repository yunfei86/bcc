scratchOne <- commandArgs()
inFileArg1 <- scratchOne[6]
inFileArg2 <- scratchOne[7]

library(ggplot2)

cat(inFileArg1,inFileArg2,"\n")

cat("upstream file:", inFileArg1, "\n")
cat("downstream file:", inFileArg2, "\n")

a1=read.table(inFileArg1,header=FALSE) #up
a2=read.table(inFileArg2,header=FALSE) #down


up=as.data.frame(colSums(a1[5:ncol(a1)]))
up$location=rep("upstream",ncol(a1)-4)
up$coordinate=factor(seq(1,ncol(a1)-4))
names(up)[1]="count"
rownames(up)=seq(1,ncol(a1)-4)

down=as.data.frame(colSums(a2[5:ncol(a1)]))
down$location=rep("downstream",ncol(a1)-4)
down$coordinate=factor(seq(1,ncol(a1)-4))
names(down)[1]="count"
rownames(down)=seq(1,ncol(a1)-4)

data=rbind(up,down)

q=qplot(coordinate,count,data=data, geom = "histogram",facets=location ~ .,binwidth=0.01)+opts(panel.grid.major = theme_blank(),panel.grid.minor = theme_blank())

ggsave("coverage.pdf",plot=q)


###########
#2
a11=a1[a1$V3=="+",] #up
a12=a1[a1$V3=="-",] #up
a21=a2[a2$V3=="+",] #down
a22=a2[a2$V3=="-",] #down

up1=as.data.frame(colSums(a11[5:ncol(a11)]))
up1$location=rep("upstream+",ncol(a11)-4)
up1$coordinate=factor(seq(1,ncol(a11)-4))
names(up1)[1]="count"
rownames(up1)=seq(1,ncol(a11)-4)

up2=as.data.frame(colSums(a12[5:ncol(a12)]))
up2$location=rep("upstream-",ncol(a12)-4)
up2$coordinate=factor(seq(1,ncol(a12)-4))
names(up2)[1]="count"
rownames(up2)=seq(1,ncol(a12)-4)

down1=as.data.frame(colSums(a21[5:ncol(a21)]))
down1$location=rep("downstream+",ncol(a21)-4)
down1$coordinate=factor(seq(1,ncol(a21)-4))
names(down1)[1]="count"
rownames(down1)=seq(1,ncol(a21)-4)

down2=as.data.frame(colSums(a22[5:ncol(a22)]))
down2$location=rep("downstream-",ncol(a22)-4)
down2$coordinate=factor(seq(1,ncol(a22)-4))
names(down2)[1]="count"
rownames(down2)=seq(1,ncol(a22)-4)

data2=rbind(up1,up2,down1,down2)
q=qplot(coordinate,count,data=data2, geom = "histogram",facets=location ~ .,binwidth=0.01)+opts(
panel.grid.major = theme_blank(),panel.grid.minor = theme_blank())

ggsave("coverage_strand.pdf",plot=q)


hit11=data.matrix(a11[,5:1004])
rownames(hit11)=a11[,2]
colnames(hit11)=seq(1:1000)
#pdf(file="heatmap_up+.pdf", height=5, width=5)
#heatmap(hit11)
#dev.off()

hit12=data.matrix(a12[,5:1004])
rownames(hit12)=a12[,2]
colnames(hit12)=seq(1:1000)
#pdf(file="heatmap_up-.pdf", height=5, width=5)
#heatmap(hit12)
#dev.off()

hit21=data.matrix(a21[,5:1004])
rownames(hit21)=a21[,2]
colnames(hit21)=seq(1:1000)
#pdf(file="heatmap_down+.pdf", height=5, width=5)
#heatmap(hit21)
#dev.off()

hit22=data.matrix(a22[,5:1004])
rownames(hit22)=a22[,2]
colnames(hit22)=seq(1:1000)
#pdf(file="heatmap_down-.pdf", height=5, width=5)
#heatmap(hit22)
#dev.off()



###############
#test top100
#a=up[1:100,]
#a$coordinate=factor(seq(1,100))
#b=down[1:100,]
#b$coordinate=factor(seq(1,100))
#data=rbind(a[1:100,],b[1:100,])

#q=qplot(coordinate,count,data=data, geom = "histogram",facets=location ~ .,binwidth=0.01)+opts(panel.grid.major = theme_blank(),panel.grid.minor = theme_blank(),axis.text.x = theme_text(angle = -30,size=3,colour = "#757575"))

#ggsave("test2.pdf",plot=q)
