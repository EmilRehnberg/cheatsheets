## ---- cluster-pkg-votes-data
data(votes.repub, package = "cluster")
votes.repub

## ---- cluster-pkg-agriculture-data
data(agriculture, package = "cluster")
agriculture

## ---- cluster-pkg-flower-data
data(flower, package = "cluster")
flower

## ---- cluster-pkg-daisy-euclidean-distance-demo
(agriculture
  %>% cluster::daisy(metric = "euclidean", stand = FALSE)
  %T>% print
  %>% as.matrix
  %>% .[, "DK"]
 )

## ---- cluster-pkg-daisy-gower-demo
agriculture %>% cluster::daisy(metric = "gower") # %>% hclust %>% plot

## ---- cluster-pkg-daisy-flower-demo
flower %>%
  cluster::daisy(type = list(asymm = "V3")) %>%
  summary
flower %>%
  cluster::daisy(type = list(asymm = c("V1", "V3")
                    , ordratio = "V7")) %>%
  summary

## ---- cluster-pkg-daisy-flower-hclust-demo
flower %>% cluster::daisy(type = list(asymm = 3)) %>% hclust %>% plot

## ---- cluster-pkg-agnes-example
par(mfrow = c(2, 1))
(votes.repub
  %>% cluster::agnes(metric = "manhattan", stand = TRUE)
  %T>% print
  %>% plot
 )
