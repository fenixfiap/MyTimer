//
//  CustomPicker.h
//  HeroiDaCidade
//
//  Created by Gabriel Moraes on 02/08/13.
//  Copyright (c) 2013 Call. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomPicker : UIPickerView <UIPickerViewDataSource, UIPickerViewDelegate>
{
    @private UITextField *txtAssociado;
@private NSDictionary *dictConteudo;
}

- (id)initWithFrame:(CGRect)frame andTextField:(UITextField *)txt andContent:(NSDictionary *)content;

@end
