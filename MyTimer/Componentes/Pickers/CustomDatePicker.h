//
//  CustomDatePicker.h
//  MyTimer
//
//  Created by Fenix on 02/08/13.
//  Copyright (c) 2013 Fenix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomDatePicker : UIDatePicker
{
    UITextField* txtAssociado;
    NSDateFormatter* formatter;
}

- (id)initWithFrame:(CGRect)frame andTextField:(UITextField *)txt;

@end
