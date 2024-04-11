Cluster Analysis of STEM Career Interest
================
Fatima
2024-04-11

## R Markdown

### **INTRODUCTION**

This project focuses on identifying the underlying clusters in students
career interests. Participants were ask to rate different STEM careers
on a Likert Scale and a hierarchical cluster analysis was run to find
optimal number of clusters. Hierarchical clustering is an alternate
method to k-mean cluster and it does not require specifying the expected
number of clusters.

### **R Packages Needed**

``` r
library(dplyr) 
```

    ## 
    ## Attaching package: 'dplyr'

    ## The following objects are masked from 'package:stats':
    ## 
    ##     filter, lag

    ## The following objects are masked from 'package:base':
    ## 
    ##     intersect, setdiff, setequal, union

``` r
library(tidyverse)  # data manipulation
```

    ## ── Attaching core tidyverse packages ──────────────────────── tidyverse 2.0.0 ──
    ## ✔ forcats   1.0.0     ✔ readr     2.1.4
    ## ✔ ggplot2   3.4.4     ✔ stringr   1.5.0
    ## ✔ lubridate 1.9.2     ✔ tibble    3.2.1
    ## ✔ purrr     1.0.1     ✔ tidyr     1.3.0

    ## ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
    ## ✖ dplyr::filter() masks stats::filter()
    ## ✖ dplyr::lag()    masks stats::lag()
    ## ℹ Use the ]8;;http://conflicted.r-lib.org/conflicted package]8;; to force all conflicts to become errors

``` r
library(cluster)    # clustering algorithms
library(factoextra) # clustering visualization
```

    ## Welcome! Want to learn more? See two factoextra-related books at https://goo.gl/ve3WBa

``` r
library(dendextend) # for comparing two dendrograms
```

    ## 
    ## ---------------------
    ## Welcome to dendextend version 1.17.1
    ## Type citation('dendextend') for how to cite the package.
    ## 
    ## Type browseVignettes(package = 'dendextend') for the package vignette.
    ## The github page is: https://github.com/talgalili/dendextend/
    ## 
    ## Suggestions and bug-reports can be submitted at: https://github.com/talgalili/dendextend/issues
    ## You may ask questions at stackoverflow, use the r and dendextend tags: 
    ##   https://stackoverflow.com/questions/tagged/dendextend
    ## 
    ##  To suppress this message use:  suppressPackageStartupMessages(library(dendextend))
    ## ---------------------
    ## 
    ## 
    ## Attaching package: 'dendextend'
    ## 
    ## The following object is masked from 'package:stats':
    ## 
    ##     cutree

``` r
library(data.table)
```

    ## 
    ## Attaching package: 'data.table'
    ## 
    ## The following object is masked from 'package:dendextend':
    ## 
    ##     set
    ## 
    ## The following objects are masked from 'package:lubridate':
    ## 
    ##     hour, isoweek, mday, minute, month, quarter, second, wday, week,
    ##     yday, year
    ## 
    ## The following object is masked from 'package:purrr':
    ## 
    ##     transpose
    ## 
    ## The following objects are masked from 'package:dplyr':
    ## 
    ##     between, first, last

### **Loading and Prepapring Data**

``` r
#load data, , row.names=1
career_data1<-read.csv("/Users/fatimaperwaizkhan/Documents/NSF Research Work/Results/careerdata_tp.csv", header = FALSE, sep=",")
career_data <- na.omit(career_data1)
#transpose data frame
career_data <- transpose(career_data1)
#career_data <- scale(career_data)
head(career_data)
```

    ##   V1 V2 V3 V4 V5 V6 V7 V8 V9 V10 V11
    ## 1  4  3  4  4  3  3  3  3  4   3   4
    ## 2  5  5  5  5  5  5  5  5  5   5   5
    ## 3  1  1  3  4  1  3  1  3  1   1   1
    ## 4  5  5  5  5  5  5  5  5  5   5   5
    ## 5  4  3  4  3  4  3  3  3  3   3   4
    ## 6  2  2  3  3  2  4  4  1  1   4   3

### **Agglomerative Hierarchical Clustering**

To perform agglomerative hierarchical clustering, first we will
calculate the dissimilarity matrix using one of the agglomeration method
(i.e. “complete”, “average”, “single”, “ward.D”). After which, we will
plot the dendrograms. If we are interested in finding the Agglomerative
coefficient, we can use the function agnes. Agglomerative coefficient
tells the amount of clustering found in our structure. Here we are
implementing all the agglomeration methods to see which one gives the
best results.

``` r
# Dissimilarity matrix
d <- dist(career_data, method = "euclidean")

# Hierarchical clustering using Complete Linkage
hc1 <- hclust(d, method = "complete" )

# Plot the obtained dendrogram
plot(hc1, cex = 0.6, hang = -1, main = 'Cluster Analysis of Careers (Hierarchical)')
```

![](Cluster-Analysis-markdown_files/figure-gfm/unnamed-chunk-3-1.png)<!-- -->

``` r
# Compute with agnes
hc2 <- agnes(career_data, method = "complete")
pltree(hc2, cex = 0.6, hang = -1, main = "Dendrogram of agnes") 
```

![](Cluster-Analysis-markdown_files/figure-gfm/unnamed-chunk-3-2.png)<!-- -->

``` r
# Agglomerative coefficient
hc2$ac
```

    ## [1] 0.8253707

``` r
# methods to assess
m <- c( "average", "single", "complete", "ward")
names(m) <- c( "average", "single", "complete", "ward")

# function to compute coefficient
ac <- function(x) {
  agnes(career_data, method = x)$ac
}

map_dbl(m, ac)
```

    ##   average    single  complete      ward 
    ## 0.7087935 0.5347851 0.8253707 0.9510261

``` r
hc3 <- agnes(career_data, method = "ward")
pltree(hc3, cex = 0.6, hang = -1, main = "Dendrogram of agnes") 
```

![](Cluster-Analysis-markdown_files/figure-gfm/unnamed-chunk-3-3.png)<!-- -->

``` r
hc3$ac
```

    ## [1] 0.9510261

``` r
# Cut tree into 2 groups
sub_grp <- cutree(hc3, k = 2)
# Number of members in each cluster
table(sub_grp)
```

    ## sub_grp
    ##   1   2 
    ## 120 149

``` r
career_data_mod <- career_data %>% mutate( cluster = sub_grp) 
fviz_cluster(list(data = career_data, cluster = sub_grp))
```

![](Cluster-Analysis-markdown_files/figure-gfm/unnamed-chunk-3-4.png)<!-- -->

### **Optimal Number of Clusters**

The next important thing to find is what is the optimal number of
clusters that your data shows. We utilize silhoutte and elbow method to
find that 2 clusters best define our data.

``` r
#finding optimal no. of clusters
#silhoutte method
fviz_nbclust(career_data, kmeans, method = "silhouette")
```

![](Cluster-Analysis-markdown_files/figure-gfm/unnamed-chunk-4-1.png)<!-- -->

``` r
#elbow method
fviz_nbclust(career_data, kmeans, method = "wss")
```

![](Cluster-Analysis-markdown_files/figure-gfm/unnamed-chunk-4-2.png)<!-- -->

``` r
# compute gap statistic
set.seed(123)
gap_stat <- clusGap(career_data, FUN = kmeans, nstart = 25,
                    K.max = 10, B = 50)
print(gap_stat, method = "firstmax")
```

    ## Clustering Gap statistic ["clusGap"] from call:
    ## clusGap(x = career_data, FUNcluster = kmeans, K.max = 10, B = 50, nstart = 25)
    ## B=50 simulated reference sets, k = 1..10; spaceH0="scaledPCA"
    ##  --> Number of clusters (method 'firstmax'): 10
    ##           logW   E.logW       gap      SE.sim
    ##  [1,] 5.884975 6.431811 0.5468364 0.008901783
    ##  [2,] 5.730939 6.310094 0.5791552 0.008657192
    ##  [3,] 5.653691 6.254982 0.6012907 0.008590468
    ##  [4,] 5.600770 6.213342 0.6125719 0.009121588
    ##  [5,] 5.560765 6.184029 0.6232640 0.009334478
    ##  [6,] 5.529344 6.158761 0.6294172 0.009292853
    ##  [7,] 5.488823 6.136807 0.6479847 0.009246102
    ##  [8,] 5.467177 6.117040 0.6498627 0.009708515
    ##  [9,] 5.448389 6.098776 0.6503863 0.009552505
    ## [10,] 5.425877 6.081757 0.6558802 0.009428453

``` r
fviz_gap_stat(gap_stat)
```

![](Cluster-Analysis-markdown_files/figure-gfm/unnamed-chunk-4-3.png)<!-- -->

``` r
#extra 
#Compute k-means clustering with k = 2
set.seed(123)
final <- kmeans(career_data, 2, nstart = 25)
print(final)
```

    ## K-means clustering with 2 clusters of sizes 120, 149
    ## 
    ## Cluster means:
    ##         V1       V2       V3       V4       V5       V6       V7       V8
    ## 1 3.858333 3.725000 3.783333 3.641667 3.666667 3.683333 3.875000 3.775000
    ## 2 2.436242 2.597315 2.906040 2.859060 2.583893 2.664430 2.624161 2.362416
    ##         V9      V10      V11
    ## 1 3.858333 3.766667 4.291667
    ## 2 2.214765 2.228188 2.791946
    ## 
    ## Clustering vector:
    ##   [1] 1 1 2 1 1 2 2 1 1 1 1 2 1 1 1 1 1 2 2 2 2 2 1 1 1 1 1 2 1 2 1 1 1 2 2 1 1
    ##  [38] 1 2 2 1 1 2 1 1 1 1 1 1 2 1 1 2 1 2 2 2 1 1 2 1 2 2 1 1 2 2 2 2 2 1 1 2 1
    ##  [75] 1 2 2 2 1 2 1 2 2 2 2 1 2 2 2 1 1 2 1 1 2 2 2 2 2 2 1 2 2 2 2 1 1 1 1 1 1
    ## [112] 2 2 2 2 1 1 2 2 2 2 2 1 2 1 2 1 2 2 1 1 1 2 1 1 1 2 1 2 1 2 2 2 2 2 1 2 2
    ## [149] 1 2 1 1 1 1 1 2 2 2 1 2 1 2 2 2 1 2 2 2 2 2 2 2 1 2 1 1 2 2 1 1 1 2 2 2 2
    ## [186] 2 2 2 1 2 1 2 2 2 2 2 2 1 1 2 2 2 2 1 2 2 1 1 2 2 2 2 2 1 2 2 2 2 1 2 1 2
    ## [223] 1 2 2 1 2 2 2 1 2 2 1 2 2 2 2 1 2 2 1 2 1 1 1 2 2 2 1 2 2 1 1 1 1 2 2 2 1
    ## [260] 2 1 1 1 1 1 1 2 1 2
    ## 
    ## Within cluster sum of squares by cluster:
    ## [1] 1250.008 1897.933
    ##  (between_SS / total_SS =  27.3 %)
    ## 
    ## Available components:
    ## 
    ## [1] "cluster"      "centers"      "totss"        "withinss"     "tot.withinss"
    ## [6] "betweenss"    "size"         "iter"         "ifault"

``` r
career_data %>%
  mutate(Cluster = final$cluster) %>%
  group_by(Cluster) %>%
  summarise_all("mean")
```

    ## # A tibble: 2 × 12
    ##   Cluster    V1    V2    V3    V4    V5    V6    V7    V8    V9   V10   V11
    ##     <int> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
    ## 1       1  3.86  3.72  3.78  3.64  3.67  3.68  3.88  3.78  3.86  3.77  4.29
    ## 2       2  2.44  2.60  2.91  2.86  2.58  2.66  2.62  2.36  2.21  2.23  2.79

``` r
# Ward's method
hc5 <- hclust(d, method = "ward.D2" )
plot(hc5, cex = 0.6)
rect.hclust(hc5, k = 2, border = 2:5)
```

![](Cluster-Analysis-markdown_files/figure-gfm/unnamed-chunk-5-1.png)<!-- -->

``` r
# Cut agnes() tree into 2 groups
hc_a <- agnes(career_data, method = "ward")
cutree(as.hclust(hc_a), k = 2)
```

    ##   [1] 1 1 2 1 1 2 2 1 1 2 1 2 1 1 2 1 1 1 2 2 2 2 1 1 1 1 1 2 1 2 2 1 1 2 2 1 1
    ##  [38] 1 2 1 1 1 2 1 1 1 1 1 1 2 1 1 1 2 2 2 2 1 1 1 1 2 1 1 1 2 2 2 2 2 1 1 1 2
    ##  [75] 1 2 2 2 1 2 1 1 2 2 2 1 2 2 2 1 1 2 1 1 2 2 2 1 2 2 2 2 1 2 2 2 1 1 1 1 2
    ## [112] 2 2 2 2 1 1 2 2 2 2 2 2 2 1 2 1 2 2 1 1 1 2 2 2 1 2 1 2 1 2 2 2 2 2 1 2 1
    ## [149] 1 1 1 1 2 1 1 2 2 2 1 2 1 2 2 2 1 2 2 2 2 2 2 2 1 2 2 2 2 2 1 1 1 2 2 2 2
    ## [186] 2 2 2 2 2 1 1 2 1 2 1 2 1 1 1 2 2 2 2 2 2 1 1 2 2 2 2 2 1 2 2 2 2 1 2 1 2
    ## [223] 2 2 2 1 2 2 2 1 2 2 1 1 2 2 2 1 2 2 1 2 2 1 1 2 2 2 1 2 2 1 2 1 1 2 1 2 1
    ## [260] 2 1 1 1 1 1 1 1 1 1

``` r
# Cut diana() tree into 4 groups
hc_d <- diana(career_data)
cutree(as.hclust(hc_d), k = 4)
```

    ##   [1] 1 1 2 1 1 3 2 1 1 1 1 2 1 1 1 1 1 3 1 3 2 2 1 1 1 1 1 1 4 2 1 1 4 1 1 1 4
    ##  [38] 4 1 4 1 1 3 1 1 1 1 1 1 3 4 1 3 1 1 2 3 1 1 4 1 1 1 4 1 1 3 3 1 1 1 1 3 1
    ##  [75] 4 1 2 1 1 2 4 1 2 3 3 1 2 3 2 4 1 2 1 1 2 1 1 3 2 2 1 1 3 2 2 1 1 1 4 4 1
    ## [112] 3 3 3 3 4 1 2 2 1 3 3 1 2 4 3 1 2 3 1 1 4 3 1 1 4 4 1 2 1 2 2 3 1 4 4 3 4
    ## [149] 1 3 1 1 1 1 4 1 3 1 4 1 1 3 1 1 1 1 3 3 3 2 2 1 4 2 1 1 3 2 4 1 1 3 1 3 2
    ## [186] 3 1 4 1 1 1 4 2 4 3 4 3 1 4 4 2 3 1 1 1 3 1 1 2 2 3 3 3 1 3 2 2 3 4 3 1 3
    ## [223] 1 3 2 4 2 4 1 1 3 1 1 4 2 4 1 1 3 3 4 2 1 1 1 3 1 2 1 3 3 1 1 1 1 3 4 2 4
    ## [260] 2 1 1 1 4 4 4 4 1 4
