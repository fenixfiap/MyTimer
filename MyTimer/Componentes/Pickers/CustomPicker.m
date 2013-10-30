//
//  CustomPicker.m
//  MyTimer
//
//  Created by Fenix on 02/08/13.
//  Copyright (c) 2013 Fenix. All rights reserved.
//

#import "CustomPicker.h"

@implementation CustomPicker

- (id)initWithFrame:(CGRect)frame andTextField:(UITextField *)txt andContent:(NSArray *)content{
	self = [super initWithFrame:frame];
    self.delegate = self;
    self.showsSelectionIndicator = YES;
    
    txtAssociado = txt;
    arrConteudo = content;
    return self;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    [self verificaObjeto:[arrConteudo objectAtIndex:0]];
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
	return [arrConteudo count];
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    [self verificaObjeto:[arrConteudo objectAtIndex:row]];
	return txtAssociado.text;

}
- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    [self verificaObjeto:[arrConteudo objectAtIndex:row]];
}

-(void) verificaObjeto:(id)objeto
{
    NSString* tituloSelecionado;
    NSString* idSelecionado;
    if ([objeto isKindOfClass:[ServicoModel class]]) {
        idSelecionado = [NSString stringWithFormat:@"%d",((ServicoModel*)objeto).idServico];
        tituloSelecionado = ((ServicoModel*)objeto).nome;
    }
    else if([objeto isKindOfClass:[FuncionarioModel class]])
    {
        idSelecionado = [NSString stringWithFormat:@"%d",((FuncionarioModel*)objeto).idFuncionario];
        tituloSelecionado = ((FuncionarioModel*)objeto).pessoa.nome;
    }
    else {
        idSelecionado = objeto;
        tituloSelecionado = objeto;
    }
    txtAssociado.text = tituloSelecionado;
    txtAssociado.accessibilityValue = idSelecionado;
}

@end
