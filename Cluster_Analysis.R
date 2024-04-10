library(dplyr)           

#Cluster Analysis
library(tidyverse)  # data manipulation
library(cluster)    # clustering algorithms
library(factoextra) # clustering visualization
library(dendextend) # for comparing two dendrograms
library(data.table)
#load data, , row.names=1
career_data1<-read.csv("/Users/fatimaperwaizkhan/Documents/NSF Research Work/Results/careerdata_tp.csv", header = FALSE, sep=",")
career_data <- na.omit(career_data1)
#transpose data frame
career_data <- transpose(career_data1)
# <- data.frame(career = c("physics","Environmental Work", "Biology & Zoology", "Veterinary Work", "Mathematics",	"Medicine",	"Computer Science",	"Medical Science",	"Chemistry",	"Energy",	"Engineering"), career_datatp)

#career_data <- scale(career_data)
head(career_data)

# Dissimilarity matrix
d <- dist(career_data, method = "euclidean")

# Hierarchical clustering using Complete Linkage
hc1 <- hclust(d, method = "complete" )

# Plot the obtained dendrogram
plot(hc1, cex = 0.6, hang = -1, main = 'Cluster Analysis of Careers (Hierarchical)')

# Compute with agnes
hc2 <- agnes(career_data, method = "complete")
pltree(hc2, cex = 0.6, hang = -1, main = "Dendrogram of agnes") 
# Agglomerative coefficient
hc2$ac

# methods to assess
m <- c( "average", "single", "complete", "ward")
names(m) <- c( "average", "single", "complete", "ward")

# function to compute coefficient
ac <- function(x) {
  agnes(career_data, method = x)$ac
}

map_dbl(m, ac)

hc3 <- agnes(career_data, method = "ward")
pltree(hc3, cex = 0.6, hang = -1, main = "Dendrogram of agnes") 
hc3$ac
# Cut tree into 2 groups
sub_grp <- cutree(hc3, k = 2)

# Number of members in each cluster
table(sub_grp)
career_data_mod <- career_data %>% mutate( cluster = sub_grp) 
fviz_cluster(list(data = career_data, cluster = sub_grp))

#finding optimal no. of clusters
#silhoutte method
fviz_nbclust(career_data, kmeans, method = "silhouette")
#elbow method
fviz_nbclust(career_data, kmeans, method = "wss")
# compute gap statistic
set.seed(123)
gap_stat <- clusGap(career_data, FUN = kmeans, nstart = 25,
                    K.max = 10, B = 50)
print(gap_stat, method = "firstmax")
fviz_gap_stat(gap_stat)

#extra 
#Compute k-means clustering with k = 2
set.seed(123)
final <- kmeans(career_data, 2, nstart = 25)
print(final)

career_data %>%
  mutate(Cluster = final$cluster) %>%
  group_by(Cluster) %>%
  summarise_all("mean")

# Ward's method
hc5 <- hclust(d, method = "ward.D2" )
plot(hc5, cex = 0.6)
rect.hclust(hc5, k = 2, border = 2:5)

# Cut agnes() tree into 2 groups
hc_a <- agnes(career_data, method = "ward")
cutree(as.hclust(hc_a), k = 2)

# Cut diana() tree into 4 groups
hc_d <- diana(career_data)
cutree(as.hclust(hc_d), k = 4)


