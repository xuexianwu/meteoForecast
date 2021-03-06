getPoint <- function(point, vars='swflx',
                     day=Sys.Date(), run='00',
                     service='meteogalicia'){
    
    service <- match.arg(service, c('meteogalicia', 'openmeteo',
                                    'gfs', 'nam', 'rap'))
    ## Extract longitude-latitude
    if (is(point, 'SpatialPoints')) {
        if (!isLonLat(point)) {
            if (require(rgdal, quietly=TRUE)) 
            point <- spTransform(point, CRS('+proj=longlat +ellps=WGS84'))
            else stop('`rgdal` is needed if `point` is projected.')
        }
        lat <- coordinates(point)[2]
        lon <- coordinates(point)[1]
    } else { ## point is a numeric of length 2
        lat <- point[2]
        lon <- point[1]
    }
    ## Which function to use?
    fun <- switch(service,
                  meteogalicia = 'pointMG',
                  openmeteo = 'pointOM',
                  gfs = 'pointGFS',
                  nam = 'pointNAM',
                  rap = 'pointRAP')
    ## Ok, use it.
    z <- do.call(fun, list(lon = lon, lat = lat,
                           vars = vars,
                           day = as.Date(day),
                           run = run))
}
