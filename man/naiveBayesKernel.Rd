\name{naiveBayesKernel}
\alias{naiveBayesKernel}
\alias{naiveBayesKernel,matrix-method}
\alias{naiveBayesKernel,ExpressionSet-method}
\title{Classification Using A Bayes Classifier with Kernel Density Estimates}
\description{
  Kernel density estimates are fitted to the training data and a naive Bayes classifier
  is used to classify samples in the test data. 
}
\usage{
  \S4method{naiveBayesKernel}{matrix}(expression, classes, ...)
  \S4method{naiveBayesKernel}{ExpressionSet}(expression, test,
            weighted = c("both", "unweighted", "weighted"), minDifference = 0, verbose = 3)
}
\arguments{
  \item{expression}{Either a \code{\link{matrix}} or \code{\link{ExpressionSet}} containing
                    the training data. For a matrix, the rows are features, and the columns
                    are samples.}
  \item{classes}{A vector of class labels.}
  \item{...}{Unused variables from the \code{\link{matrix}} method passed to the
             \code{\link{ExpressionSet}} method.}            
  \item{test}{Either a \code{\link{matrix}} or \code{\link{ExpressionSet}} containing
                    the test data.}
  \item{weighted}{In weighted mode, the difference in densities is summed over all features.
                  If unweighted mode, each features's vote is worth the same. To save
                  computational time, both can be calculated simultaneously.}
  \item{minDifference}{The minimum difference in densities for a feature to be allowed
                       to vote. Can be a vector of cutoffs.}                      
  \item{verbose}{A number between 0 and 3 for the amount of progress messages to give.
                 A higher number will produce more messages.}
}
\details{
  If \code{weighted} is \code{TRUE}, then a sample's predicted class is the class with
  the largest sum of density estimates, scaled for the number of samples in
  the training data of each class. Otherwise, when \code{weighted} is \code{FALSE},
  each feature has an equal vote, and votes for the class with the largest density,
  scaled for class sizes in the training set.
}
\value{
  A vector of class predictions, as long as the number of samples in the test data,
  or lists of factors, if both weighted and unweighted voting or a range of \code{minDifference}
  values was provided.
}
\author{Dario Strbenac, John Ormerod}
\examples{
  trainMatrix <- matrix(rnorm(1000, 8, 2), ncol = 10)
  trainMatrix[1:30, 1:5] <- trainMatrix[1:30, 1:5] + 5 # Make first 30 genes D.E.
  testMatrix <- matrix(rnorm(1000, 8, 2), ncol = 10)
  testMatrix[1:30, 6:10] <- testMatrix[1:30, 6:10] + 5 # Make first 30 genes D.E.
  classes <- factor(rep(c("Poor", "Good"), each = 5))
  naiveBayesKernel(trainMatrix, classes, testMatrix)
}