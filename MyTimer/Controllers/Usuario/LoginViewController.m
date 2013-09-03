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

- (IBAction)autentica:(UIButton *)sender {
    [self.view endEditing:YES];
    [UIView animateWithDuration:0.5
                     animations:^{carregandoTela.alpha = 0.0;}
                     completion:^(BOOL finished){ [carregandoTela removeFromSuperview]; }];
    if ([self validaCampos]) {
        NSURL *url = [NSURL URLWithString:SERVICO_LOGAR];
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
        request.shouldPresentCredentialsBeforeChallenge = YES;
        [request addBasicAuthenticationHeaderWithUsername:self.txtLogin.text andPassword:self.txtSenha.text];
        [request setRequestMethod:@"POST"];
        [request setShowAccurateProgress:YES];
        [request setUploadProgressDelegate:self];
        [request setDelegate:self];
        [request startAsynchronous];
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
        return YES;
    }
}

#pragma mark - Métodos Request Delegate

- (void)requestFailed:(ASIHTTPRequest *)request{
    NSLog(@"Response %d ==> %@", request.responseStatusCode, [request responseString]);
    [carregandoTela removeFromSuperview];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Erro de conexão:" message:@"Não foi possível se conectar com o serviço. Verique sua conexão e tente novamente." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)requestFinished:(ASIFormDataRequest *)request {
    NSLog(@"Response %d ==> %@", request.responseStatusCode, [request responseString]);
    [carregandoTela removeFromSuperview];
    
    if (request.responseStatusCode == 200) {
        NSDictionary *dicRetorno = [[NSDictionary alloc] initWithDictionary:((NSDictionary*)[request.responseData objectFromJSONData])];
        
        [self performSegueWithIdentifier:@"sgLoga" sender:self];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Erro de login:" message:@"Usuário e/ou senha inválidos." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

@end
