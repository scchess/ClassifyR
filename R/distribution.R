setGeneric("distribution", function(result, ...)
           {standardGeneric("distribution")})

setMethod("distribution", "ClassifyResult", 
          function(result, type = c("features", "samples"), summary = c("density", "frequency"),
                   plot = TRUE, xMax = NULL, ...)
{
  if(plot == TRUE && !requireNamespace("ggplot2", quietly = TRUE))
    stop("The package 'ggplot2' could not be found. Please install it.")            
            
  type <- match.arg(type)
  summary <- match.arg(summary)
  if(is.null(xMax))
  {
    if(type == "features")
      xMax <- max(table(unlist(features(result))))
    else
      xMax <- 1
  }
  
  if(type == "samples")
  {
    allPredictions <- do.call(rbind, predictions(result))
    errors <- by(allPredictions, allPredictions[, "sample"], function(samplePredicitons)
             {
                sampleClass <- rep(actualClasses(result)[samplePredicitons[1, 1]], nrow(samplePredicitons))
                confusion <- table(samplePredicitons[, 2], sampleClass)
                (confusion[upper.tri(confusion)] + confusion[lower.tri(confusion)]) /
                (sum(diag(confusion)) + confusion[upper.tri(confusion)] + confusion[lower.tri(confusion)])
             }) # Sample error rate.
    scores <- rep(NA, length(sampleNames(result)))
    scores[as.numeric(names(errors))] <- errors
    names(scores) <- sampleNames(result)
  } else {
    allFeatures <- unlist(features(result))
    scores <- table(allFeatures)
    names(scores) <- featureNames(result)[as.numeric(names(scores))]
  }
  
  plotData <- data.frame(scores = as.numeric(scores))
  
  if(plot == TRUE)
  {
    if(type == "samples")
    {
      titleText <- "Distribution of Predicted Class Error for Samples"
      xText <- "Sample Error"
    } else {
      titleText <- "Distribution of Selection of Features"
      xText <- "Times Selected"
    }
    
    if(!missing(...))
      extras <- list(...)
    else
      extras <- list()
    if(summary == "density")
    {
       extras[["mapping"]] <- ggplot2::aes(y = ..density..)
    }
    
    print(ggplot2::ggplot(plotData, ggplot2::aes(x = scores)) + do.call(ggplot2::geom_histogram, extras) + ggplot2::xlim(0, xMax) +
          ggplot2::xlab(xText) + ggplot2::ylab("Count") + ggplot2::ggtitle(titleText))
  }
  
  if(type == "features")
    if(summary == "frequency") 
      scores <- scores / sum(scores)
  
  scores
})