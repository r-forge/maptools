\name{ppp-class}
\docType{class}
\alias{ppp-class}
\alias{owin-class}
\alias{coerce,ppp,SpatialPoints-method}
\alias{coerce,ppp,SpatialPointsDataFrame-method}
\alias{coerce,ppp,SpatialGridDataFrame-method}
\alias{as.SpatialPointsDataFrame.ppp}
\alias{as.SpatialGridDataFrame.ppp}
\alias{as.SpatialPoints.ppp}

\title{Virtual class "ppp" }
\description{ Virtual class definition for "ppp" to allow S4-style coercion }
\section{Objects from the Class}{A virtual Class: No objects may be created from it.}
\section{Methods}{
  \describe{
    \item{coerce}{\code{signature(from = "ppp", to = "SpatialPoints")}: coerce
	ppp object into SpatialPoints object }
    \item{coerce}{\code{signature(from = "ppp", to = "SpatialPointsDataFrame")}: 
	coerce marked ppp object into SpatialPointsDataFrame object }
    \item{coerce}{\code{signature(from = "ppp", to = "SpatialGridDataFrame")}: 
	coerce a mask window in a ppp object into a SpatialGridDataFrame object }
  }
}
\author{ Edzer J. Pebesma }
\keyword{classes}
