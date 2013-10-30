//
//  CustomPicker.h
//  MyTimer
//
//  Created by Fenix on 02/08/13.
//  Copyright (c) 2013 Fenix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomPicker : UIPickerView <UIPickerViewDataSource, UIPickerViewDelegate>
{
    @private UITextField *txtAssociado;
    @private NSDictionary *dictConteudo;
    @private NSArray * arrOrdenado;
}

- (id)initWithFrame:(CGRect)frame andTextField:(UITextField *)txt andContent:(NSDictionary *)content;

@end
