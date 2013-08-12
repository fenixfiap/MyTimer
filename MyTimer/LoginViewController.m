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
        NSURL *url = [NSURL URLWithString: @"http://localhost:8080/mt-web/ws/mobile/login"];
        
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
        request.shouldPresentCredentialsBeforeChallenge = YES;
        [request addRequestHeader:@"Authorization" value:@"BASIC am9zZTpqb3Nl"];
        [request setRequestMethod:@"POST"];
        [request setShowAccurateProgress:YES];
        [request setUploadProgressDelegate:self];
        [request setDelegate:self];
        [request startAsynchronous];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request{
    NSLog(@"Response %d ==> %@", request.responseStatusCode, [request responseString]);
//    [CarregandoTela removeFromSuperview];
//    [self.view endEditing:YES];
//    
//    PopUp * popUpMensagem = [[PopUp alloc] initWithFrame:self.view.window.frame];
//    if (request.responseStatusCode == 0) {
//        [popUpMensagem setImgIcone:TIPO_IMAGEM_SEM_CONEXAO];
//        [popUpMensagem setTipoAlert:POP_UP_OK_CANCELAR comTitulo:@"Reconectar"];
//        popUpMensagem.delegate = self;
//        popUpMensagem.txtMensagemExibicao.text = @"Falha no login. Verifique sua conexão com a internet e tente novamente.";
//    }
//    else if (request.responseStatusCode == 401) {
//        [popUpMensagem setImgIcone:TIPO_IMAGEM_ERRO];
//        [popUpMensagem setTipoAlert:POP_UP_OK comTitulo:@"OK"];
//        popUpMensagem.txtMensagemExibicao.text = @"Usuário e/ou senha inválidos.";
//    }
//    
//    [self.view.window addSubview:popUpMensagem];
//    [popUpMensagem release];
    
}

- (void)requestFinished:(ASIFormDataRequest *)request {
    NSLog(@"Response %d ==> %@", request.responseStatusCode, [request responseString]);
//    [CarregandoTela removeFromSuperview];
//    [self.view endEditing:YES];
//    
//    NSDictionary *dicRetorno = [[NSDictionary alloc] initWithDictionary:((NSDictionary*)[request.responseData objectFromJSONData])];
//    
//    NSUserDefaults *pref =  [NSUserDefaults standardUserDefaults];
//    
//    [pref setObject:[dicRetorno objectForKey:@"tokenAcesso" ] forKey:USER_DEFAULT_TOKEN_USUARIO ];
//    
//    [pref setObject:[[dicRetorno objectForKey:@"usuario" ] valueForKey:@"id"] forKey:USER_DEFAULT_ID_USUARIO];
//    
//    [pref setObject:[[dicRetorno objectForKey:@"usuario" ] valueForKey:@"nome"] forKey:USER_DEFAULT_NOME_USUARIO];
//    
//    [pref setObject:[[dicRetorno objectForKey:@"usuario" ] valueForKey:@"login"] forKey:USER_DEFAULT_LOGIN_USUARIO];
//    
//    [pref setObject:[[dicRetorno objectForKey:@"usuario" ] valueForKey:@"idPessoa"] forKey:USER_DEFAULT_ID_PESSOA];
//    
//    [pref synchronize];
//    
//    [dicRetorno release];
//    
//    self.txtEmail.text = @"";
//    self.txtSenha.text = @"";
//    
//    [self performSegueWithIdentifier:@"sgLoga" sender:self];
    
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
