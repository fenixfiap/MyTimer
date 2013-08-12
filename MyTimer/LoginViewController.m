//
//  LoginViewController.m
//  MyTimer
//
//  Created by Gabriel Moraes on 11/07/13.
//  Copyright (c) 2013  Fenix. All rights reserved.
//

#import "LoginViewController.h"

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    keyboard = [[KeyboardToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    keyboard.svTela = self.svTela;
    
    self.txtLogin.inputAccessoryView = keyboard;
    self.txtSenha.inputAccessoryView = keyboard;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [keyboard release];
    [_txtLogin release];
    [_txtSenha release];
    [_svTela release];
    [super dealloc];
}

- (IBAction)autentica:(UIButton *)sender {
    if ([self validaCampos]) {
        [self.view endEditing:YES];
        [self performSegueWithIdentifier: @"sgAgendamento" sender: self];
    }
}

-(BOOL)validaCampos{
    NSMutableString *vcMensagemRetorno = [[NSMutableString alloc] init];
    
    if ([self.txtLogin.text isEqualToString:@""]){
        [vcMensagemRetorno appendString:@"Login obrigatório \n\n"];
    }
    
    if ([self.txtSenha.text length] == 0){
        [vcMensagemRetorno appendString:@"Senha obrigatória"];
    }
    
    if (vcMensagemRetorno.length > 0) {
        [self.view endEditing:YES];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Verificar:" message:vcMensagemRetorno delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        return NO;
    }
    else {
        [vcMensagemRetorno release];
        return YES;
    }
}

@end
