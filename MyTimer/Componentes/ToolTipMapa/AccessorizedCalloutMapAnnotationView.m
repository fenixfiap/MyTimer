//
//  AccessorizedCalloutMapAnnotationView.m
//  CustomPin
//
//  Created by William Gomes on 8/6/13.
//  Copyright (c) 2013 Call. All rights reserved.
//

#import "AccessorizedCalloutMapAnnotationView.h"


@implementation AccessorizedCalloutMapAnnotationView

@synthesize accessory = _accessory;

- (id) initWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
	if (self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier]) {
        
		self.accessory = [UIButton buttonWithType:UIButtonTypeCustom];
        self.accessory.frame = CGRectMake(self.frame.origin.x  + 235,self.frame.origin.y + 40,25,25);
        [self.accessory setImage:[UIImage imageNamed:@"HDC_seta.png"] forState:UIControlStateNormal];
		self.accessory.exclusiveTouch = YES;
		self.accessory.enabled = YES;
		[self.accessory addTarget: self
						   action: @selector(calloutAccessoryTapped)
				 forControlEvents: UIControlEventTouchUpInside | UIControlEventTouchCancel];
		[self addSubview:self.accessory];
        
	}
    
	return self;
}

- (void) calloutAccessoryTapped {
    
    if ([self.mapView.delegate respondsToSelector:@selector(mapView:annotationView:calloutAccessoryControlTapped:)]) {
		[self.mapView.delegate mapView:self.mapView
						annotationView:self
		 calloutAccessoryControlTapped:self.accessory];
	}
}

@end
