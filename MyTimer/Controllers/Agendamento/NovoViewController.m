//
//  NovoViewController.m
//  MyTimer
//
//  Created by Fenix on 12/08/13.
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
    self.txtFuncionario.inputAccessoryView = keyboard;
    self.txtHorario.inputAccessoryView = keyboard;
    
    [self listarServicos];
    
    self.txtData.inputView = [[CustomDatePicker alloc] initWithFrame:CGRectZero andTextField:self.txtData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alteraServico) name:UITextFieldTextDidEndEditingNotification object:self.txtServico];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alteraData) name:UITextFieldTextDidEndEditingNotification object:self.txtData];
    [self.scPreferencia addTarget:self action:@selector(alteraPreferencia) forControlEvents:UIControlEventValueChanged];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alteraFuncionario) name:UITextFieldTextDidEndEditingNotification object:self.txtFuncionario];
    
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
        CRUD* crud = [[CRUD alloc] initWithEntity:@"Usuario"];
        ClienteModel* usuarioLogado = [crud getLogado];
        NSURL* url = [NSURL URLWithString:SERVICO_AGENDAR];
        ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL:url];
        [request setRequestMethod:@"POST"];
        [request addPostValue:[NSString stringWithFormat:@"%@", self.txtServico.accessibilityValue] forKey:@"idServico"];
        [request addPostValue:usuarioLogado.pessoa.cpf forKey:@"cpfCliente"];
        [request addPostValue:self.txtData.text forKey:@"data"];
        [request addPostValue:self.txtHorario.text forKey:@"horario"];
        if (self.scPreferencia.selectedSegmentIndex == 0) {
            [request addPostValue:[NSString stringWithFormat:@"%@", self.txtFuncionario.accessibilityValue] forKey:@"idFuncionario"];
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
    UIActionSheet* actionSheet = [[UIActionSheet alloc]
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
    NSURL* url = [NSURL URLWithString:SERVICO_LISTAR_SERVICOS];
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:url];
    [request setRequestMethod:@"GET"];
    [request setShowAccurateProgress:YES];
    [request setUploadProgressDelegate:self];
    [request setDelegate:self];
    [request startAsynchronous];
}


-(void) listarFuncionarios
{
    carregandoTela = [[CustomActivityIndicatorView alloc] initWithView:self.view];
    [self.view addSubview:carregandoTela];
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:SERVICO_LISTAR_FUNCIONARIOS, self.txtServico.accessibilityValue]];
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:url];
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
    NSURL* url = [NSURL URLWithString:SERVICO_LISTAR_HORARIOS];
    ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    [request addPostValue:self.txtData.text forKey:@"data"];
    [request addPostValue:self.txtServico.accessibilityValue forKey:@"idServico"];
    [request setShowAccurateProgress:YES];
    [request setUploadProgressDelegate:self];
    [request setDelegate:self];
    [request startAsynchronous];
}
-(void) listarHorariosFuncionario
{
    carregandoTela = [[CustomActivityIndicatorView alloc] initWithView:self.view];
    [self.view addSubview:carregandoTela];
    NSURL* url = [NSURL URLWithString:SERVICO_LISTAR_HORARIOS_FUNCIONARIO];
    ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    [request addPostValue:self.txtData.text forKey:@"data"];
    [request addPostValue:self.txtServico.accessibilityValue forKey:@"idServico"];
    [request addPostValue:self.txtFuncionario.accessibilityValue forKey:@"idFuncionario"];
    [request setShowAccurateProgress:YES];
    [request setUploadProgressDelegate:self];
    [request setDelegate:self];
    [request startAsynchronous];
}

-(void) alteraServico
{
    [dictMapHorariosFuncionarios removeAllObjects];
    self.txtFuncionario.hidden = NO;
    self.txtHorario.frame = CGRectMake(self.txtHorario.frame.origin.x, initialY, self.txtHorario.frame.size.width, self.txtHorario.frame.size.height);
    self.txtData.enabled = YES;
    self.scPreferencia.enabled = NO;
    self.txtFuncionario.enabled = NO;
    self.txtHorario.enabled = NO;
    self.txtData.text = @"";
    self.scPreferencia.selectedSegmentIndex = UISegmentedControlNoSegment;
    self.txtFuncionario.text = @"";
    self.txtHorario.text = @"";
}

-(void) alteraData
{
    if (![self.txtData.text isEqualToString:@""]) {
        
        self.txtFuncionario.hidden = NO;
        self.txtHorario.frame = CGRectMake(self.txtHorario.frame.origin.x, initialY, self.txtHorario.frame.size.width, self.txtHorario.frame.size.height);
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"dd/MM/yyyy";
        NSDate* dataSel = [formatter dateFromString:self.txtData.text];
        if([dataSel compare: [NSDate date]] != NSOrderedDescending)
        {
            self.scPreferencia.enabled = NO;
            self.txtFuncionario.enabled = NO;
            self.txtHorario.enabled = NO;
            self.txtData.text = @"";
            self.scPreferencia.selectedSegmentIndex = UISegmentedControlNoSegment;
            self.txtFuncionario.text = @"";
            self.txtHorario.text = @"";
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Verificar:" message:@"O agendamento precisa ser feito com um dia de antecedência" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
        else
        {
            self.scPreferencia.enabled = YES;
            self.txtFuncionario.enabled = NO;
            self.txtHorario.enabled = NO;
            self.scPreferencia.selectedSegmentIndex = UISegmentedControlNoSegment;
            self.txtFuncionario.text = @"";
            self.txtHorario.text = @"";
            [dictMapHorariosFuncionarios removeAllObjects];
        }
    }
}

-(void) alteraPreferencia
{
    [dictMapHorariosFuncionarios removeAllObjects];
    
    self.txtFuncionario.hidden = NO;
    self.txtHorario.frame = CGRectMake(self.txtHorario.frame.origin.x, initialY, self.txtHorario.frame.size.width, self.txtHorario.frame.size.height);
    if (self.scPreferencia.selectedSegmentIndex == 0)
    {
        [self listarFuncionarios];
    }
    else if (self.scPreferencia.selectedSegmentIndex == 1)
    {
        self.txtHorario.frame = CGRectMake(self.txtHorario.frame.origin.x, self.txtFuncionario.frame.origin.y, self.txtHorario.frame.size.width, self.txtHorario.frame.size.height);
        self.txtFuncionario.hidden = YES;
        self.txtFuncionario.enabled = NO;
        [self listarHorarios];
    } else {
        self.txtFuncionario.enabled = NO;
    }
    self.txtHorario.enabled = NO;
    self.txtFuncionario.text = @"";
    self.txtHorario.text = @"";
}

-(void) alteraFuncionario
{
    [self listarHorariosFuncionario];
    self.txtHorario.text = @"";
}

-(BOOL)validaCampos
{
    NSMutableString* vcMensagemRetorno = [[NSMutableString alloc] init];
    
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
        if (self.txtFuncionario.text.length == 0){
            [vcMensagemRetorno appendString:@"Funcionário obrigatório \n\n"];
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
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Verificar:" message:vcMensagemRetorno delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
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
    NSLog(@"Response %d ==> %@", request.responseStatusCode, request.responseString);
    [UIView animateWithDuration:0.5
                     animations:^{carregandoTela.alpha = 0.0;}
                     completion:^(BOOL finished){ [carregandoTela removeFromSuperview]; }];
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Erro de conexão:" message:@"Não foi possível se conectar com o serviço. Verique sua conexão e tente novamente." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    alert.delegate = self;
    [alert show];
}

- (void)requestFinished:(ASIHTTPRequest *)request {
    NSLog(@"Response %d ==> %@", request.responseStatusCode, request.responseString);
    [UIView animateWithDuration:0.5
                     animations:^{carregandoTela.alpha = 0.0;}
                     completion:^(BOOL finished){ [carregandoTela removeFromSuperview]; }];
    NSString* servicoAtual = [NSString stringWithFormat:@"%@", request.url];
    
    if ([servicoAtual isEqualToString:SERVICO_LISTAR_SERVICOS]) {
        if (request.responseStatusCode == 200) {
            self.txtServico.inputView = [[CustomPicker alloc] initWithFrame:CGRectZero andTextField:self.txtServico andContent:[ServicoModel arrayOfModelsFromDictionaries:request.responseData.toJSON]];
            self.txtServico.enabled = YES;
        }
        else {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Erro:" message:@"Não foi possível listar os serviços. Tente novamente mais tarde." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    else if ([servicoAtual isEqualToString:SERVICO_LISTAR_HORARIOS]) {
        if (request.responseStatusCode == 200) {
            NSDictionary* dictRetorno = (NSDictionary*)request.responseData.toJSON;
            NSArray* arrHorarios = [dictRetorno valueForKey:@"horarios"];
            if (![arrHorarios isKindOfClass:[NSNull class]]) {
                self.txtHorario.inputView = [[CustomPicker alloc] initWithFrame:CGRectZero andTextField:self.txtHorario andContent:arrHorarios];
                self.txtHorario.enabled = YES;
                dictMapHorariosFuncionarios = [[NSMutableDictionary alloc] initWithDictionary:[dictRetorno valueForKey:@"horariosFuncionarios"]];
            }
            else {
                self.scPreferencia.selectedSegmentIndex = UISegmentedControlNoSegment;
                [self alteraPreferencia];
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Verificar:" message:@"Não existe horários disponíveis para a data selecionada." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
        }
        else {
            self.scPreferencia.selectedSegmentIndex = UISegmentedControlNoSegment;
            [self alteraPreferencia];
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Erro:" message:@"Não foi possível listar os horários. Tente novamente mais tarde." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    else if ([servicoAtual isEqualToString:[NSString stringWithFormat:SERVICO_LISTAR_FUNCIONARIOS, self.txtServico.accessibilityValue]]) {
        if (request.responseStatusCode == 200) {
            self.txtFuncionario.inputView = [[CustomPicker alloc] initWithFrame:CGRectZero andTextField:self.txtFuncionario andContent:[FuncionarioModel arrayOfModelsFromDictionaries:request.responseData.toJSON]];
            self.txtFuncionario.enabled = YES;
        }
        else {
            self.scPreferencia.selectedSegmentIndex = UISegmentedControlNoSegment;
            [self alteraPreferencia];
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Erro:" message:@"Não foi possível listar os profissionais. Tente novamente mais tarde." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    else if ([servicoAtual isEqualToString:SERVICO_LISTAR_HORARIOS_FUNCIONARIO]) {
        if (request.responseStatusCode == 200) {
            self.txtHorario.inputView = [[CustomPicker alloc] initWithFrame:CGRectZero andTextField:self.txtHorario andContent:request.responseData.toJSON];
            self.txtHorario.enabled = YES;
        }
        else {
            self.scPreferencia.selectedSegmentIndex = UISegmentedControlNoSegment;
            [self alteraPreferencia];
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Verificar:" message:@"O profissional não possui horários disponíveis para a data selecionada." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    else if ([servicoAtual isEqualToString:SERVICO_AGENDAR]) {
        if (request.responseStatusCode == 200) {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Sucesso:" message:@"Agendamento realizado!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            alert.delegate = self;
            [alert show];
        }
        else {
            self.scPreferencia.selectedSegmentIndex = UISegmentedControlNoSegment;
            [self alteraPreferencia];
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Erro:" message:@"Não foi possível realizar o agendamento. Tente novamente mais tarde." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            self.view.userInteractionEnabled = YES;
        }
    }

}

@end
