//
//  CustomDatePicker.m
//  MyTimer
//
//  Created by Gabriel Moraes on 02/08/13.
//  Copyright (c) 2013 Fenix. All rights reserved.
//

#import "CustomDatePicker.h"

@implementation CustomDatePicker

- (id)initWithFrame:(CGRect)frame andTextField:(UITextField *)txt{
	self = [super initWithFrame:frame];
    
    txtAssociado = txt;
    
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/yyyy"];
    [self addTarget:self action:@selector(update)forControlEvents:UIControlEventValueChanged];
    
    self.datePickerMode = UIDatePickerModeDate;
    
    return self;
}

- (void) update
{
    txtAssociado.text = [formatter stringFromDate:self.date];
}

@end
