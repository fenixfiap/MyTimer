//
//  CustomDatePicker.h
//  HeroiDaCidade
//
//  Created by Gabriel Moraes on 02/08/13.
//  Copyright (c) 2013 Call. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomDatePicker : UIDatePicker
{
    @private UITextField *txtAssociado;
    @private NSDateFormatter *formatter;
}

- (id)initWithFrame:(CGRect)frame andTextField:(UITextField *)txt;

@end
