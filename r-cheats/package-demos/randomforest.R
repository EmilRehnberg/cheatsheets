## ---- randomForest-pkg-mdsplot
set.seed(17)
irisUrf <- randomForest::randomForest(iris %>% dplyr::select(-Species))
randomForest::MDSplot(irisUrf, iris$Species) # Species sets the colors.

## ---- randomForest-pkg-mdsplot-w-factors-numericals
CO2 %>% randomForest::randomForest() %>% randomForest::MDSplot(CO2$Type)

CO2 %>% dplyr::select(-Treatment, -Type) %>% randomForest::randomForest() %>% randomForest::MDSplot(CO2$Type)

## ---- randomForest-pkg-mdsplot-factors-only
warpbreaks %>% dplyr::select(-breaks) %>% randomForest::randomForest() %>% randomForest::MDSplot(1:2)
