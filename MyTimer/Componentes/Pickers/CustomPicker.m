//
//  CustomPicker.m
//  MyTimer
//
//  Created by Fenix on 02/08/13.
//  Copyright (c) 2013 Fenix. All rights reserved.
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
    arrOrdenado = [[dictConteudo allValues] sortedArrayUsingSelector: @selector(caseInsensitiveCompare:)];
    NSString* selecionado = [arrOrdenado objectAtIndex:0];
    txtAssociado.text = selecionado;
    txtAssociado.accessibilityValue = [NSString stringWithFormat:@"%@", [dictConteudo allKeysForObject:selecionado][0]];
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
	return [dictConteudo count];
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	return [arrOrdenado objectAtIndex:row];

}
- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSString* selecionado = [arrOrdenado objectAtIndex:row];
    txtAssociado.text = selecionado;
    txtAssociado.accessibilityValue = [NSString stringWithFormat:@"%@", [dictConteudo allKeysForObject:selecionado][0]];
}

@end
