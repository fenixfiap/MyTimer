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
    NSManagedObjectContext *context = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).managedObjectContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Usuario" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray* fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    NSString* cpf = [((NSManagedObject*)fetchedObjects[0]) valueForKey:@"cpf"];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:SERVICO_LISTAR_AGENDAMENTOS, cpf]];
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
        NSManagedObjectContext *context = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).managedObjectContext;
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription
                                       entityForName:@"Usuario" inManagedObjectContext:context];
        [fetchRequest setEntity:entity];
        NSError *error;
        NSArray* fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
        for (NSManagedObject* object in fetchedObjects) {
            [context deleteObject:object];
        }
        [context save:&error];
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
    NSDictionary* agendamento = [arrAgendamentos objectAtIndex:indexPath.row];
    @try {
        NSString* funcionario = [agendamento valueForKeyPath:@"funcionario.pessoa.nome"];
        cell.textLabel.text = [NSString stringWithFormat:@"Serviço: %@ \nProfissional: %@",[agendamento valueForKeyPath:@"servico.nome"], [funcionario isKindOfClass:NSNull.class] ? @"" : funcionario];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Data: %@ \nStatus: %@",[agendamento valueForKey:@"data"],[agendamento valueForKey:@"statusFormatado"]];
    }
    @catch (NSException *exception) {
        cell.textLabel.text = @"Você não possui agendamentos.";
        cell.detailTextLabel.text = @"";
    }
    return cell;
}

#pragma mark - Métodos Request Delegate

- (void)requestFailed:(ASIHTTPRequest *)request{
    NSLog(@"Response %d ==> %@", request.responseStatusCode, [request responseString]);
    [refresh endRefreshing];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Erro de conexão:" message:@"Não foi possível se conectar com o serviço. Verique sua conexão e tente novamente." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)requestFinished:(ASIFormDataRequest *)request {
    NSLog(@"Response %d ==> %@", request.responseStatusCode, [request responseString]);
    [refresh endRefreshing];
    if (request.responseStatusCode == 200) {
        arrAgendamentos = (NSArray*)[request.responseData objectFromJSONData];
        if (arrAgendamentos.count < 1)
            arrAgendamentos = [[NSArray alloc] initWithObjects:@"nil",nil];
        [self.tbAgendamentos reloadData];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Erro:" message:@"Não foi possível se comunicar com o serviço." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

@end
