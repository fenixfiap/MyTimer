//
//  CustomPin.h
//  CustomPin
//
//  Created by William Gomes on 8/2/13.
//  Copyright (c) 2013 Call. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <MapKit/MapKit.h>
#import "Annotation.h"
#import <MapKit/MapKit.h>

@interface AnnotationView : MKAnnotationView
{
    MKMapView *_mapView;
}

@property (nonatomic, retain) MKMapView *mapView;

@end
