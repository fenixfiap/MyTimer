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
    
    self.txtServico.inputView = [[CustomPicker alloc] initWithFrame:CGRectZero andTextField:self.txtServico andContent:[NSDictionary dictionaryWithObjectsAndKeys: @"LIMPEZA", @"1", @"CONSULTA", @"2", @"OBTURAÇÃO", @"3", nil]];
    self.txtData.inputView = [[CustomDatePicker alloc] initWithFrame:CGRectZero andTextField:self.txtData];
    self.txtDentista.inputView = [[CustomPicker alloc] initWithFrame:CGRectZero andTextField:self.txtDentista andContent:[NSDictionary dictionaryWithObjectsAndKeys: @"JOÃO BARROS", @"1", @"MARIA LUIZA", @"2", nil]];
    self.txtHorario.inputView = [[CustomPicker alloc] initWithFrame:CGRectZero andTextField:self.txtHorario andContent:[NSDictionary dictionaryWithObjectsAndKeys: @"09:00", @"1", @"09:30", @"2", @"10:00", @"3", nil]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alteraServico) name:UITextFieldTextDidEndEditingNotification object:self.txtServico];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alteraData) name:UITextFieldTextDidEndEditingNotification object:self.txtData];
    [self.scPreferencia addTarget:self action:@selector(alteraPreferencia) forControlEvents:UIControlEventValueChanged];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alteraDentista) name:UITextFieldTextDidEndEditingNotification object:self.txtDentista];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alteraHorario) name:UITextFieldTextDidEndEditingNotification object:self.txtHorario];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Métodos de Classe

- (IBAction)agendar:(UIButton *)sender {
    carregandoTela = [[CustomActivityIndicatorView alloc] initWithView:self.view];
    [self.view addSubview:carregandoTela];
    [self validaCampos];
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

-(void) alteraServico
{
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
        }
    }
}

-(void) alteraPreferencia
{
    if (self.scPreferencia.selectedSegmentIndex == 0)
        self.txtDentista.enabled = YES;
    else
        self.txtDentista.enabled = NO;
    
    self.txtHorario.enabled = YES;
    self.txtDentista.text = @"";
    self.txtHorario.text = @"";
}

-(void) alteraDentista
{
    self.txtHorario.enabled = YES;
    self.txtHorario.text = @"";
}

-(void) alteraHorario
{
    if (self.scPreferencia.selectedSegmentIndex == 1)
    {
        
    }
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

#pragma mark - Métodos ActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
