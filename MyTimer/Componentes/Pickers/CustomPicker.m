//
//  CustomPicker.m
//  HeroiDaCidade
//
//  Created by Gabriel Moraes on 02/08/13.
//  Copyright (c) 2013 Call. All rights reserved.
//

#import "CustomPicker.h"

@implementation CustomPicker

- (id)initWithFrame:(CGRect)frame andTextField:(UITextField *)txt andContent:(NSDictionary *)content{
	self = [super initWithFrame:frame];
    self.delegate = self;
    self.showsSelectionIndicator = YES;
    
    txtAssociado = txt;
    dictConteudo = content;
    return self;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    txtAssociado.text = [[dictConteudo allValues] objectAtIndex:0];
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
	return [dictConteudo count];
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	return [[dictConteudo allValues] objectAtIndex:row];

}
- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    txtAssociado.text = [[dictConteudo allValues] objectAtIndex:row];
}

@end
