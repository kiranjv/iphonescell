//
//  LocationUtils.m
//  safecell
//
//  Created by shail on 07/05/10.
//  Copyright 2010 ChaiONE. All rights reserved.
//

#import "LocationUtils.h"

@implementation LocationUtils

// Calculate distance between 2 coordinates using in kliometers (km) Haversine Formula
// See http://www.movable-type.co.uk/scripts/latlong.html and
// See http://www.jaimerios.com/?p=39
+(double) distanceFrom: (CLLocationCoordinate2D) from to: (CLLocationCoordinate2D) to {
	
	// Get the difference between our two points
   // then convert the difference into radians
	double nDLat = (to.latitude - from.latitude) * (M_PI/180);
	double nDLon = (to.longitude - from.longitude) * (M_PI/180);
	
	// Latitudes in radians
	double nLat1 = from.latitude * (M_PI/180);
	double nLat2 = to.latitude * (M_PI/180);
		
	double nRadius = 6371; // Earth's radius in Kilometers
		
	double nA = pow ( sin(nDLat/2), 2 ) + cos(nLat1) * cos(nLat2) * pow ( sin(nDLon/2), 2 );
	
	double nC = 2 * atan2( sqrt(nA), sqrt( 1 - nA ));
	double nD = nRadius * nC;
	//NSLog(@"nd in Location Utilities = %f",nD);
	return nD; // Return our calculated distance
}

@end
