//
//  NovoViewController.m
//  MyTimer
//
//  Created by Gabriel Moraes on 12/08/13.
//  Copyright (c) 2013 Fenix. All rights reserved.
//

#import "NovoViewController.h"

@implementation NovoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    KeyboardToolbar* keyboard = [[KeyboardToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44) andNavigation:NO];
    keyboard.svTela = self.svTela;
    self.txtServico.inputAccessoryView = keyboard;
    self.txtData.inputAccessoryView = keyboard;
    self.txtDentista.inputAccessoryView = keyboard;
    self.txtHorario.inputAccessoryView = keyboard;
    
    [self listarServicos];
    
    self.txtData.inputView = [[CustomDatePicker alloc] initWithFrame:CGRectZero andTextField:self.txtData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alteraServico) name:UITextFieldTextDidEndEditingNotification object:self.txtServico];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alteraData) name:UITextFieldTextDidEndEditingNotification object:self.txtData];
    [self.scPreferencia addTarget:self action:@selector(alteraPreferencia) forControlEvents:UIControlEventValueChanged];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alteraDentista) name:UITextFieldTextDidEndEditingNotification object:self.txtDentista];
    
    initialY = self.txtHorario.frame.origin.y;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Métodos de Classe

- (IBAction)agendar:(UIButton *)sender {
    carregandoTela = [[CustomActivityIndicatorView alloc] initWithView:self.view];
    [self.view addSubview:carregandoTela];
    self.view.userInteractionEnabled = NO;
    if ([self validaCampos]) {
        NSManagedObjectContext *context = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).managedObjectContext;
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription
                                       entityForName:@"Usuario" inManagedObjectContext:context];
        [fetchRequest setEntity:entity];
        NSError *error;
        NSArray* fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
        NSString* cpf = [((NSManagedObject*)fetchedObjects[0]) valueForKey:@"cpf"];
        
        NSURL *url = [NSURL URLWithString:SERVICO_AGENDAR];
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        [request setRequestMethod:@"POST"];
        [request addPostValue:[NSString stringWithFormat:@"%@", self.txtServico.accessibilityValue] forKey:@"idServico"];
        [request addPostValue:cpf forKey:@"cpfCliente"];
        [request addPostValue:self.txtData.text forKey:@"data"];
        [request addPostValue:self.txtHorario.text forKey:@"horario"];
        if (self.scPreferencia.selectedSegmentIndex == 0) {
            [request addPostValue:[NSString stringWithFormat:@"%@", self.txtDentista.accessibilityValue] forKey:@"idFuncionario"];
        }
        else {
            [request addPostValue:[[dictMapHorariosFuncionarios objectForKey:self.txtHorario.text][0] valueForKey:@"id"] forKey:@"idFuncionario"];
        }
        [request addPostValue:self.scPreferencia.selectedSegmentIndex == 0? @"true" : @"false" forKey:@"preferencia"];
        [request setShowAccurateProgress:YES];
        [request setUploadProgressDelegate:self];
        [request setDelegate:self];
        [request setTimeOutSeconds:120];
        [request startAsynchronous];
    }
}

- (IBAction)cancelaNovo:(UIBarButtonItem *)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"Deseja realmente cancelar o agendamento?"
                                  delegate:self
                                  cancelButtonTitle:@"Cancelar"
                                  destructiveButtonTitle:@"Sim"
                                  otherButtonTitles: nil];
    [actionSheet showInView:self.view.window];
}

-(void) listarServicos
{
    carregandoTela = [[CustomActivityIndicatorView alloc] initWithView:self.view];
    [self.view addSubview:carregandoTela];
    NSURL *url = [NSURL URLWithString:SERVICO_LISTAR_SERVICOS];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setRequestMethod:@"GET"];
    [request setShowAccurateProgress:YES];
    [request setUploadProgressDelegate:self];
    [request setDelegate:self];
    [request startAsynchronous];
}


-(void) listarDentistas
{
    carregandoTela = [[CustomActivityIndicatorView alloc] initWithView:self.view];
    [self.view addSubview:carregandoTela];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:SERVICO_LISTAR_DENTISTAS, self.txtServico.accessibilityValue]];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setRequestMethod:@"GET"];
    [request setShowAccurateProgress:YES];
    [request setUploadProgressDelegate:self];
    [request setDelegate:self];
    [request startAsynchronous];
}

-(void) listarHorarios
{
    carregandoTela = [[CustomActivityIndicatorView alloc] initWithView:self.view];
    [self.view addSubview:carregandoTela];
    NSURL *url = [NSURL URLWithString:SERVICO_LISTAR_HORARIOS];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    [request addPostValue:self.txtData.text forKey:@"data"];
    [request addPostValue:self.txtServico.accessibilityValue forKey:@"idServico"];
    [request setShowAccurateProgress:YES];
    [request setUploadProgressDelegate:self];
    [request setDelegate:self];
    [request startAsynchronous];
}
-(void) listarHorariosDentista
{
    carregandoTela = [[CustomActivityIndicatorView alloc] initWithView:self.view];
    [self.view addSubview:carregandoTela];
    NSURL *url = [NSURL URLWithString:SERVICO_LISTAR_HORARIOS_DENTISTA];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    [request addPostValue:self.txtData.text forKey:@"data"];
    [request addPostValue:self.txtServico.accessibilityValue forKey:@"idServico"];
    [request addPostValue:self.txtDentista.accessibilityValue forKey:@"idFuncionario"];
    [request setShowAccurateProgress:YES];
    [request setUploadProgressDelegate:self];
    [request setDelegate:self];
    [request startAsynchronous];
}

-(void) alteraServico
{
    [dictConteudoDentistas removeAllObjects];
    [dictConteudoHorarios removeAllObjects];
    [dictMapHorariosFuncionarios removeAllObjects];
    self.txtDentista.hidden = NO;
    self.txtHorario.frame = CGRectMake(self.txtHorario.frame.origin.x, initialY, self.txtHorario.frame.size.width, self.txtHorario.frame.size.height);
    self.txtData.enabled = YES;
    self.scPreferencia.enabled = NO;
    self.txtDentista.enabled = NO;
    self.txtHorario.enabled = NO;
    self.txtData.text = @"";
    self.scPreferencia.selectedSegmentIndex = UISegmentedControlNoSegment;
    self.txtDentista.text = @"";
    self.txtHorario.text = @"";
}

-(void) alteraData
{
    if (![self.txtData.text isEqualToString:@""]) {
        
        self.txtDentista.hidden = NO;
        self.txtHorario.frame = CGRectMake(self.txtHorario.frame.origin.x, initialY, self.txtHorario.frame.size.width, self.txtHorario.frame.size.height);
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"dd/MM/yyyy";
        NSDate* dataSel = [formatter dateFromString:self.txtData.text];
        if([dataSel compare: [NSDate date]] != NSOrderedDescending)
        {
            self.scPreferencia.enabled = NO;
            self.txtDentista.enabled = NO;
            self.txtHorario.enabled = NO;
            self.txtData.text = @"";
            self.scPreferencia.selectedSegmentIndex = UISegmentedControlNoSegment;
            self.txtDentista.text = @"";
            self.txtHorario.text = @"";
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Verificar:" message:@"O agendamento precisa ser feito com um dia de antecedência" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
        else
        {
            self.scPreferencia.enabled = YES;
            self.txtDentista.enabled = NO;
            self.txtHorario.enabled = NO;
            self.scPreferencia.selectedSegmentIndex = UISegmentedControlNoSegment;
            self.txtDentista.text = @"";
            self.txtHorario.text = @"";
            [dictConteudoDentistas removeAllObjects];
            [dictConteudoHorarios removeAllObjects];
            [dictMapHorariosFuncionarios removeAllObjects];
        }
    }
}

-(void) alteraPreferencia
{
    [dictConteudoDentistas removeAllObjects];
    [dictConteudoHorarios removeAllObjects];
    [dictMapHorariosFuncionarios removeAllObjects];
    
    self.txtDentista.hidden = NO;
    self.txtHorario.frame = CGRectMake(self.txtHorario.frame.origin.x, initialY, self.txtHorario.frame.size.width, self.txtHorario.frame.size.height);
    if (self.scPreferencia.selectedSegmentIndex == 0)
    {
        [self listarDentistas];
    }
    else if (self.scPreferencia.selectedSegmentIndex == 1)
    {
        self.txtHorario.frame = CGRectMake(self.txtHorario.frame.origin.x, self.txtDentista.frame.origin.y, self.txtHorario.frame.size.width, self.txtHorario.frame.size.height);
        self.txtDentista.hidden = YES;
        self.txtDentista.enabled = NO;
        [self listarHorarios];
    } else {
        self.txtDentista.enabled = NO;
    }
    self.txtHorario.enabled = NO;
    self.txtDentista.text = @"";
    self.txtHorario.text = @"";
}

-(void) alteraDentista
{
    [dictConteudoHorarios removeAllObjects];
    [self listarHorariosDentista];
    self.txtHorario.text = @"";
}

-(BOOL)validaCampos
{
    NSMutableString *vcMensagemRetorno = [[NSMutableString alloc] init];
    
    if (self.txtServico.text.length == 0){
        [vcMensagemRetorno appendString:@"Serviço obrigatório \n\n"];
    }
    
    if (self.txtData.text.length == 0){
        [vcMensagemRetorno appendString:@"Data obrigatória \n\n"];
    }
    
    if (self.scPreferencia.selectedSegmentIndex == UISegmentedControlNoSegment) {
        [vcMensagemRetorno appendString:@"Preferência precisa ser informada \n\n"];
    }
    else if (self.scPreferencia.selectedSegmentIndex == 0)
    {
        if (self.txtDentista.text.length == 0){
            [vcMensagemRetorno appendString:@"Dentista obrigatório \n\n"];
        }
    }
    
    if (self.txtHorario.text.length == 0){
        [vcMensagemRetorno appendString:@"Horário obrigatório"];
    }
    
    if (vcMensagemRetorno.length > 0) {
        [self.view endEditing:YES];
        self.view.userInteractionEnabled = YES;
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

#pragma mark - Métodos AlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView.title isEqualToString:@"Sucesso:"] || [alertView.title isEqualToString:@"Erro de conexão:"]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - Métodos ActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - Métodos Request Delegate

- (void)requestFailed:(ASIHTTPRequest *)request{
    NSLog(@"Response %d ==> %@", request.responseStatusCode, [request responseString]);
    [UIView animateWithDuration:0.5
                     animations:^{carregandoTela.alpha = 0.0;}
                     completion:^(BOOL finished){ [carregandoTela removeFromSuperview]; }];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Erro de conexão:" message:@"Não foi possível se conectar com o serviço. Verique sua conexão e tente novamente." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    alert.delegate = self;
    [alert show];
}

- (void)requestFinished:(ASIFormDataRequest *)request {
    NSLog(@"Response %d ==> %@", request.responseStatusCode, [request responseString]);
    [UIView animateWithDuration:0.5
                     animations:^{carregandoTela.alpha = 0.0;}
                     completion:^(BOOL finished){ [carregandoTela removeFromSuperview]; }];
    NSString * servicoAtual = [NSString stringWithFormat:@"%@", request.url];
    
    if ([servicoAtual isEqualToString:SERVICO_LISTAR_SERVICOS]) {
        if (request.responseStatusCode == 200) {
            NSArray *arrRetorno = (NSArray*)[request.responseData objectFromJSONData];
            dictConteudoServicos = [[NSMutableDictionary alloc] init];
            for (NSDictionary* dictServico in arrRetorno) {
                [dictConteudoServicos setValue:[dictServico valueForKey:@"nome"] forKey:[dictServico valueForKey:@"id"]];
            }
            self.txtServico.inputView = [[CustomPicker alloc] initWithFrame:CGRectZero andTextField:self.txtServico andContent:dictConteudoServicos];
            self.txtServico.enabled = YES;
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Erro:" message:@"Não foi possível listar os serviços. Tente novamente mais tarde." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    else if ([servicoAtual isEqualToString:SERVICO_LISTAR_HORARIOS]) {
        if (request.responseStatusCode == 200) {
            NSDictionary *dictRetorno = (NSDictionary*)[request.responseData objectFromJSONData];
            NSArray* arrHorarios = [dictRetorno valueForKey:@"horarios"];
            if (![arrHorarios isKindOfClass:[NSNull class]]) {
                dictConteudoHorarios = [[NSMutableDictionary alloc] initWithObjects:arrHorarios forKeys:arrHorarios];
                self.txtHorario.inputView = [[CustomPicker alloc] initWithFrame:CGRectZero andTextField:self.txtHorario andContent:dictConteudoHorarios];
                self.txtHorario.enabled = YES;
                dictMapHorariosFuncionarios = [[NSMutableDictionary alloc] initWithDictionary:[dictRetorno valueForKey:@"horariosFuncionarios"]];
            }
            else {
                self.scPreferencia.selectedSegmentIndex = UISegmentedControlNoSegment;
                [self alteraPreferencia];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Verificar:" message:@"Não existe horários disponíveis para a data selecionada." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
        }
        else {
            self.scPreferencia.selectedSegmentIndex = UISegmentedControlNoSegment;
            [self alteraPreferencia];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Erro:" message:@"Não foi possível listar os horários. Tente novamente mais tarde." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    else if ([servicoAtual isEqualToString:[NSString stringWithFormat:SERVICO_LISTAR_DENTISTAS, self.txtServico.accessibilityValue]]) {
        if (request.responseStatusCode == 200) {
            NSArray *arrRetorno = (NSArray*)[request.responseData objectFromJSONData];
            dictConteudoDentistas = [[NSMutableDictionary alloc] init];
            for (NSDictionary* dictDentista in arrRetorno) {
                [dictConteudoDentistas setValue:[dictDentista valueForKeyPath:@"pessoa.nome"] forKey:[dictDentista valueForKeyPath:@"id"]];
            }
            self.txtDentista.inputView = [[CustomPicker alloc] initWithFrame:CGRectZero andTextField:self.txtDentista andContent:dictConteudoDentistas];
            self.txtDentista.enabled = YES;
        }
        else {
            self.scPreferencia.selectedSegmentIndex = UISegmentedControlNoSegment;
            [self alteraPreferencia];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Erro:" message:@"Não foi possível listar os dentistas. Tente novamente mais tarde." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    else if ([servicoAtual isEqualToString:SERVICO_LISTAR_HORARIOS_DENTISTA]) {
        if (request.responseStatusCode == 200) {
            NSArray* arrHorarios = (NSArray*)[request.responseData objectFromJSONData];
            dictConteudoHorarios = [[NSMutableDictionary alloc] initWithObjects:arrHorarios forKeys:arrHorarios];
            self.txtHorario.inputView = [[CustomPicker alloc] initWithFrame:CGRectZero andTextField:self.txtHorario andContent:dictConteudoHorarios];
            self.txtHorario.enabled = YES;
        }
        else {
            self.scPreferencia.selectedSegmentIndex = UISegmentedControlNoSegment;
            [self alteraPreferencia];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Verificar:" message:@"O dentista não possui horários disponíveis para a data selecionada." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    else if ([servicoAtual isEqualToString:SERVICO_AGENDAR]) {
        if (request.responseStatusCode == 200) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sucesso:" message:@"Agendamento realizado!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            alert.delegate = self;
            [alert show];
        }
        else {
            self.scPreferencia.selectedSegmentIndex = UISegmentedControlNoSegment;
            [self alteraPreferencia];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Erro:" message:@"Não foi possível realizar o agendamento. Tente novamente mais tarde." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            self.view.userInteractionEnabled = YES;
        }
    }

}

@end
