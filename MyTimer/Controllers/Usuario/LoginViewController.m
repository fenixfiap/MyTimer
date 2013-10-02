//
//  LoginViewController.m
//  MyTimer
//
//  Created by Fenix on 11/07/13.
//  Copyright (c) 2013  Fenix. All rights reserved.
//

#import "LoginViewController.h"

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    KeyboardToolbar* keyboard = [[KeyboardToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44) andNavigation:YES];
    keyboard.svTela = self.svTela;
    
    self.txtLogin.inputAccessoryView = keyboard;
    self.txtSenha.inputAccessoryView = keyboard;
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSManagedObjectContext *context = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).managedObjectContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Usuario" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray* fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects.count > 0)
    {
        self.btnEntrar.hidden = YES;
        self.txtLogin.hidden = YES;
        self.txtSenha.hidden = YES;
        self.lblUsuario.hidden = NO;
        self.btnContinuar.hidden = NO;
        self.lblUsuario.text = [NSString stringWithFormat:@"Bem vindo, %@", [((NSManagedObject*)fetchedObjects[0]) valueForKey:@"nome"]];
    }
    else
    {
        self.btnEntrar.hidden = NO;
        self.txtLogin.hidden = NO;
        self.txtSenha.hidden = NO;
        self.lblUsuario.hidden = YES;
        self.btnContinuar.hidden = YES;
        self.txtSenha.text = @"";
        
        NSString* login = [[NSUserDefaults standardUserDefaults] valueForKey:USER_INFO_ULTIMO_LOGADO];
        if (login)
            self.txtLogin.text = login;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Métodos de Classe

- (IBAction)autentica:(UIButton *)sender {
    [self.view endEditing:YES];
    carregandoTela = [[CustomActivityIndicatorView alloc] initWithView:self.view];
    [self.view addSubview:carregandoTela];
    if ([self validaCampos]) {
        NSURL *url = [NSURL URLWithString:SERVICO_LOGAR];
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
        request.shouldPresentCredentialsBeforeChallenge = YES;
        [request addBasicAuthenticationHeaderWithUsername:self.txtLogin.text andPassword:self.txtSenha.text];
        request.defaultResponseEncoding = NSUTF8StringEncoding;
        [request setRequestMethod:@"POST"];
        [request setShowAccurateProgress:YES];
        [request setUploadProgressDelegate:self];
        [request setDelegate:self];
        [request startAsynchronous];
    }
}

- (IBAction)continua:(UIButton *)sender {
    [self performSegueWithIdentifier:@"sgLoga" sender:self];
}

-(BOOL)validaCampos
{
    NSMutableString *vcMensagemRetorno = [[NSMutableString alloc] init];
    
    if ([self.txtLogin.text isEqualToString:@""]){
        [vcMensagemRetorno appendString:@"Login obrigatório \n\n"];
    }
    
    if ([self.txtSenha.text length] == 0){
        [vcMensagemRetorno appendString:@"Senha obrigatória"];
    }
    
    if (vcMensagemRetorno.length > 0) {
        [self.view endEditing:YES];
        [UIView animateWithDuration:0.5
                         animations:^{carregandoTela.alpha = 0.0;}
                         completion:^(BOOL finished){ [carregandoTela removeFromSuperview]; }];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Verificar:" message:vcMensagemRetorno delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    else {
        return YES;
    }
}

#pragma mark - Métodos Request Delegate

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"Response %d ==> %@", request.responseStatusCode, [request responseString]);
    [carregandoTela removeFromSuperview];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Erro de conexão:" message:@"Não foi possível se conectar com o serviço. Verique sua conexão e tente novamente." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)requestFinished:(ASIFormDataRequest *)request
{
    NSLog(@"Response %d ==> %@", request.responseStatusCode, [request responseString]);
    [carregandoTela removeFromSuperview];
    
    if (request.responseStatusCode == 200)
    {
        NSDictionary *dicRetorno = [[NSDictionary alloc] initWithDictionary:((NSDictionary*)[request.responseData objectFromJSONData])];
        
        NSManagedObjectContext *context = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).managedObjectContext;
        NSManagedObject *usuario = [NSEntityDescription
                                           insertNewObjectForEntityForName:@"Usuario"
                                    inManagedObjectContext:context];
        [usuario setValue:[dicRetorno valueForKey:@"id"] forKey:@"idCliente"];
        [usuario setValue:[dicRetorno valueForKeyPath:@"pessoa.id"] forKey:@"idPessoa"];
        [usuario setValue:[dicRetorno valueForKeyPath:@"pessoa.nome"] forKey:@"nome"];
        [usuario setValue:[dicRetorno valueForKeyPath:@"pessoa.cpf"] forKey:@"cpf"];
        NSError *error;
        if (![context save:&error])
        {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
        
        [[NSUserDefaults standardUserDefaults] setValue:self.txtLogin.text forKey:USER_INFO_ULTIMO_LOGADO];
        [self performSegueWithIdentifier:@"sgLoga" sender:self];
    }
    else if (request.responseStatusCode == 500)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Erro de login:" message:@"Usuário inativo. Entre em contato com a administração." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Erro de login:" message:@"Usuário e/ou senha inválidos." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

@end
