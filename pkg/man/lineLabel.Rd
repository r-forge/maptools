\name{lineLabel}
\alias{lineLabel}
\alias{sp.lineLabel}
\alias{sp.lineLabel-methods}
\alias{sp.lineLabel,Lines-method}
\alias{sp.lineLabel,SpatialLines-method}

\title{
Label placement with spplot and lattice.
}
\description{
     Use optimization routines to find good locations for point labels
     without overlaps.
}
\usage{
lineLabel(line, label,
                     spar=.6, position = c('above', 'below'),
                     col = add.text$col,
                     alpha = add.text$alpha,
                     cex = add.text$cex,
                     lineheight = add.text$lineheight,
                     font = add.text$font,
                     fontfamily = add.text$fontfamily,
                     fontface = add.text$fontface,
                     lty = add.line$lty,
                     lwd = add.line$lwd, 
                     col.line = add.line$col,
                     identifier = 'lineLabel',
                     ...)
sp.lineLabel(object, labels, ...)
}
\arguments{
  \item{line}{a \code{Lines} or \code{SpatialLines} object.}
  \item{object}{A \code{SpatialLines} object.}
  \item{label, labels}{a string or expression to be printed following
    the path of \code{line}. Its \code{names} should match the values
    of the \code{ID} slot of the lines to label. If \code{label} is
    missing, the \code{ID} slot is used instead.
  }
  \item{spar}{smoothing parameter. With values near zero, the label
    will closely follow the line. Default value is .6. See smooth.spline for details.}
  \item{position}{character string ('above' or 'below') to define where
    the text must be placed.}
  \item{col, alpha, cex, lineheight, font, fontfamily,
  fontface}{graphical arguments for the text. See gpar for details.}

  \item{lty, lwd, col.line}{graphical parameters for the line. See gpar for details.}
  \item{identifier}{A character string to identify the grob to be created.}
  \item{...}{other arguments}
}


\author{
Oscar Perpinan Lamigueiro.
}

\details{
The label location code is adapted from
\code{\link[lattice]{panel.levelplot}}. The part of the line where the text is
placed is resampled with \code{\link[stats]{smooth.spline}}.}

\seealso{
  \code{\link[sp]{spplot}}
%  \code{\link{sp.pointLabel}}
  \code{\link{pointLabel}}
  \code{\link[lattice]{panel.levelplot}}
  \code{\link[stats]{smooth.spline}}
}
\examples{
data(meuse.grid)
coordinates(meuse.grid) = ~x+y
proj4string(meuse.grid) <- CRS("+init=epsg:28992")
gridded(meuse.grid) = TRUE

data(meuse)
coordinates(meuse) = ~x+y
data(meuse.riv)
meuse.sl <- SpatialLines(list(Lines(list(Line(meuse.riv)), "1")))

ids <- sapply(meuse.sl@lines, function(l)l@ID)
labs <- 'Meuse River'
names(labs) <- ids

library(RColorBrewer)
myCols <- adjustcolor(colorRampPalette(brewer.pal(n=9, 'Reds'))(100), .85)

sl1 <- list('sp.lineLabel', meuse.sl, label=labs,
            position='below',
            spar=.2,
            col='darkblue', cex=1,
            fontfamily='Palatino',
            fontface=2)

spplot(meuse.grid["dist"],
       col.regions=myCols, 
       sp.layout = sl1)

}
