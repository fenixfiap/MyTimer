//
//  CustomPicker.h
//  MyTimer
//
//  Created by Fenix on 02/08/13.
//  Copyright (c) 2013 Fenix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AgendamentoModel.h"

@interface CustomPicker : UIPickerView <UIPickerViewDataSource, UIPickerViewDelegate>
{
    UITextField* txtAssociado;
    NSArray*  arrConteudo;
}

- (id)initWithFrame:(CGRect)frame andTextField:(UITextField *)txt andContent:(NSArray *)content;

@end
