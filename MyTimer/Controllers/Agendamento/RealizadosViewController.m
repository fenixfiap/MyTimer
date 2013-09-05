//
//  RealizadosViewController.m
//  MyTimer
//
//  Created by Gabriel Moraes on 03/09/13.
//  Copyright (c) 2013 Fenix. All rights reserved.
//

#import "RealizadosViewController.h"

@implementation RealizadosViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self listaAgendamentos];
}

-(void)listaAgendamentos
{
    self.tbAgendamentos.userInteractionEnabled = NO;
    carregandoTela = [[CustomActivityIndicatorView alloc] initWithView:self.view];
    [self.view addSubview:carregandoTela];
    
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

-(BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (event.subtype == UIEventSubtypeMotionShake)
    {
        [self listaAgendamentos];
    }
    
    if ( [super respondsToSelector:@selector(motionEnded:withEvent:)] )
        [super motionEnded:motion withEvent:event];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

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
        [[NSUserDefaults standardUserDefaults] setValue:[fetchedObjects[0] valueForKey:@"login"] forKey:USER_INFO_ULTIMO_LOGADO];
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
    cell.textLabel.text = [NSString stringWithFormat:@"Serviço: %@ \nProfissional: %@",[agendamento valueForKeyPath:@"servico.nome"],[agendamento valueForKeyPath:@"funcionario.pessoa.nome"]];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Data: %@ \nStatus: %@",[agendamento valueForKey:@"data"],[agendamento valueForKey:@"statusFormatado"]];
    ;
    return cell;
}

#pragma mark - Métodos Request Delegate

- (void)requestFailed:(ASIHTTPRequest *)request{
    NSLog(@"Response %d ==> %@", request.responseStatusCode, [request responseString]);
    [UIView animateWithDuration:0.5
                     animations:^{carregandoTela.alpha = 0.0;}
                     completion:^(BOOL finished){ [carregandoTela removeFromSuperview]; }];
    self.tbAgendamentos.userInteractionEnabled = YES;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Erro de conexão:" message:@"Não foi possível se conectar com o serviço. Verique sua conexão e tente novamente." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    [alert show];
}

- (void)requestFinished:(ASIFormDataRequest *)request {
    NSLog(@"Response %d ==> %@", request.responseStatusCode, [request responseString]);
    [UIView animateWithDuration:0.5
                     animations:^{carregandoTela.alpha = 0.0;}
                     completion:^(BOOL finished){ [carregandoTela removeFromSuperview]; }];
    self.tbAgendamentos.userInteractionEnabled = YES;
    if (request.responseStatusCode == 200) {
        arrAgendamentos = (NSArray*)[request.responseData objectFromJSONData];
        [self.tbAgendamentos reloadData];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Erro:" message:@"Não foi possível se comunicar com o serviço." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

@end
