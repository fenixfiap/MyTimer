//
//  RealizadosViewController.m
//  MyTimer
//
//  Created by Fenix on 03/09/13.
//  Copyright (c) 2013 Fenix. All rights reserved.
//

#import "RealizadosViewController.h"

@implementation RealizadosViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    refresh = [[UIRefreshControl alloc]init];
    refresh.tintColor = [UIColor colorWithRed:237.0f/255.0f green:177.0f/255.0f blue:33.0f/255.0f alpha:1.0f];
    [refresh addTarget:self action:@selector(listaAgendamentos) forControlEvents:UIControlEventValueChanged];
    [self.tbAgendamentos addSubview:refresh];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [refresh beginRefreshing];
    
    [self listaAgendamentos];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Métodos de Classe

- (IBAction)btnSair:(UIBarButtonItem *)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"Deseja realmente sair?"
                                  delegate:self
                                  cancelButtonTitle:@"Cancelar"
                                  destructiveButtonTitle:@"Sair"
                                  otherButtonTitles: nil];
    [actionSheet showInView:self.view.window];
}

-(void)listaAgendamentos
{
    CRUD* crud = [[CRUD alloc] initWithEntity:@"Usuario"];
    ClienteModel* usuarioLogado = [crud getLogado];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:SERVICO_LISTAR_AGENDAMENTOS, usuarioLogado.pessoa.cpf]];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setRequestMethod:@"GET"];
    [request setShowAccurateProgress:YES];
    [request setUploadProgressDelegate:self];
    [request setDelegate:self];
    [request startAsynchronous];
}

#pragma mark - Métodos ActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        CRUD* crud = [[CRUD alloc] initWithEntity:@"Usuario"];
        [crud removeAll];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - Métodos TableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrAgendamentos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    @try {
        AgendamentoModel* agendamento = [arrAgendamentos objectAtIndex:indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"Serviço: %@ \nProfissional: %@",agendamento.servico.nome, [agendamento.funcionario.pessoa.nome isKindOfClass:NSNull.class] ? @"" : agendamento.funcionario.pessoa.nome];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Data: %@ Horário: %@ \nStatus: %@",agendamento.data, agendamento.horaInicio, agendamento.statusFormatado];
    }
    @catch (NSException *exception) {
        cell.textLabel.text = @"Você não possui agendamentos.";
        cell.detailTextLabel.text = @"";
    }
    return cell;
}

#pragma mark - Métodos Request Delegate

- (void)requestFailed:(ASIHTTPRequest *)request{
    NSLog(@"Response %d ==> %@", request.responseStatusCode, request.responseString);
    [refresh endRefreshing];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Erro de conexão:" message:@"Não foi possível se conectar com o serviço. Verique sua conexão e tente novamente." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)requestFinished:(ASIFormDataRequest *)request {
    NSLog(@"Response %d ==> %@", request.responseStatusCode, request.responseString);
    [refresh endRefreshing];
    if (request.responseStatusCode == 200) {
        arrAgendamentos = [AgendamentoModel arrayOfModelsFromDictionaries:request.responseData.toJSON];
        [self.tbAgendamentos reloadData];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Erro:" message:@"Não foi possível se comunicar com o serviço." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

@end
