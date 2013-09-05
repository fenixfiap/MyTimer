//
//  CustomActivityIndicatorView.m
//  CustomLoad
//
//  Created by William Gomes on 8/7/13.
//  Copyright (c) 2013 Call. All rights reserved.
//

#import "CustomActivityIndicatorView.h"


@implementation CustomActivityIndicatorView

- (id)initWithView:(UIView *)view{
  
    self = [super init];
    
    
    self.alpha = 0;
    UIView *vwContainerLoading = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    vwContainerLoading.center = view.center;
    vwContainerLoading.backgroundColor = [UIColor grayColor];
    vwContainerLoading.alpha = 0.6;
    vwContainerLoading.layer.cornerRadius = 10;
    vwContainerLoading.layer.masksToBounds = YES;
    
    HZActivityIndicatorView *activityIndicator = [[HZActivityIndicatorView alloc] init];
    activityIndicator.backgroundColor = [UIColor clearColor];
    activityIndicator.opaque = YES;
    activityIndicator.steps = 10;
    activityIndicator.finSize = CGSizeMake(5, 20);
    activityIndicator.indicatorRadius = 10;
    activityIndicator.stepDuration = 0.120;
    activityIndicator.color = [UIColor whiteColor];
    activityIndicator.cornerRadii = CGSizeMake(10, 10);
    activityIndicator.center = view.center;
    [activityIndicator startAnimating];
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         self.alpha = 1;
                         
                        [self addSubview:vwContainerLoading];
                        [self addSubview:activityIndicator];
                     }
                     completion:nil];
    
   
    
    return self;
}

@end
