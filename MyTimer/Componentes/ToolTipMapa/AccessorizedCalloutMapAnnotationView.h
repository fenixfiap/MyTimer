//
//  AccessorizedCalloutMapAnnotationView.h
//  CustomPin
//
//  Created by William Gomes on 8/6/13.
//  Copyright (c) 2013 Call. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "AnnotationView.h"

@interface AccessorizedCalloutMapAnnotationView : AnnotationView
{
        UIButton *_accessory;
}

@property (nonatomic, strong) UIButton *accessory;

@end
