//Github: https://gist.github.com/garmstro/29ef8de111ba69453ac6

import CoreLocation

class Bearing {
    /**
    Calculate initial compass bearing between two locations
    
    - parameter fromLocation: Source Location
    - parameter toLocation: Destination Location
    
    - returns: bearing (CLLocationDirection)
    */
   static func bearingFromLocation(fromLocation: CLLocationCoordinate2D, toLocation: CLLocationCoordinate2D) -> CLLocationDirection {
    
    var bearing: CLLocationDirection
    
    let fromLat = degreesToRadians(fromLocation.latitude)
    let fromLon = degreesToRadians(fromLocation.longitude)
    let toLat = degreesToRadians(toLocation.latitude)
    let toLon = degreesToRadians(toLocation.longitude)
    
    let y = sin(toLon - fromLon) * cos(toLat)
    let x = cos(fromLat) * sin(toLat) - sin(fromLat) * cos(toLat) * cos(toLon - fromLon)
    bearing = radiansToDegrees( atan2(y, x) ) as CLLocationDirection
    
    //bearing = (bearing + 360.0) % 360.0
    return bearing
   }
   
   /**
    Calculate final bearing between two locations
    
    - parameter fromLocation: Source Location
    - parameter toLocation: Destination Location
    
    - returns: bearing (CLLocationDirection)
    */
   static func finalBearingFromLocation(fromLocation: CLLocationCoordinate2D, toLocation: CLLocationCoordinate2D) -> CLLocationDirection {
    
    let fromLat = degreesToRadians(fromLocation.latitude)
    let fromLon = degreesToRadians(fromLocation.longitude)
    let toLat = degreesToRadians(toLocation.latitude)
    let toLon = degreesToRadians(toLocation.longitude)
    
    let y = sin(fromLon - toLon) * cos(fromLat)
    let x = cos(toLat) * sin(fromLat) - sin(toLat) * cos(fromLat) * cos(fromLon - toLon)
    
    return radiansToDegrees( atan2(y, x) )
    
    //bearing = (bearing + 180.0) % 360.0
    
   }
    
    private static func radiansToDegrees(_ radians: Double) -> Double {
        return radians * 180.0 / M_PI
    }
    
    private static func degreesToRadians(_ degrees: Double) -> Double {
        return degrees * M_PI / 180.0
    }
}

