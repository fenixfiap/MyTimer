//
//  CustomAnnotation.m
//  CustomPin
//
//  Created by William Gomes on 8/2/13.
//  Copyright (c) 2013 Call. All rights reserved.
//

#import "Annotation.h"


@implementation Annotation

@synthesize coordinate;
@synthesize title;
@synthesize subtitle;
@synthesize urlImagemPin;
@synthesize idPin;


- (id)initWithLocation:(CLLocationCoordinate2D)coord {
    self = [super init];
    if (self) {
        coordinate = coord;
    }
    return self;
}

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate {
    coordinate = newCoordinate;
}

@end