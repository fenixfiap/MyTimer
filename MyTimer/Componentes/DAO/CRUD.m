//
//  CRUD.m
//  MyTimer
//
//  Created by Gabriel Moraes on 10/10/13.
//  Copyright (c) 2013 Fenix. All rights reserved.
//

#import "CRUD.h"

@implementation CRUD

-(id) initWithEntity:(NSString*) entityName
{
    if (self = [super init])
    {
        context = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).managedObjectContext;
        _entity = [NSEntityDescription
                   entityForName:entityName inManagedObjectContext:context];
    }
    return self;
}

-(void) removeAll
{
    NSArray* fetchedObjects = [self listAll];
    for (NSManagedObject* object in fetchedObjects) {
        [context deleteObject:object];
    }
    NSError* error;
    [context save:&error];
}

-(NSArray*) listAll
{
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:self.entity];
    NSError* error;
    return [context executeFetchRequest:fetchRequest error:&error];
}

-(ClienteModel*) getLogado
{
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:self.entity];
    NSError* error;
    NSArray* objetos = [context executeFetchRequest:fetchRequest error:&error];
    ClienteModel* cliente;
    if (objetos.count > 0) {
        NSManagedObject* usuario = [objetos objectAtIndex:0];
        cliente = [[ClienteModel alloc] init];
        cliente.idCliente = [[usuario valueForKey:@"idCliente"] integerValue];
        cliente.pessoa = [[PessoaModel alloc] init];
        cliente.pessoa.idPessoa = [[usuario valueForKey:@"idPessoa"] integerValue];
        cliente.pessoa.nome = [usuario valueForKey:@"nome"];
        cliente.pessoa.cpf = [usuario valueForKey:@"cpf"];
    }
    return cliente;
}


-(void) saveUser:(ClienteModel*)cliente
{
    NSManagedObject* usuario = [NSEntityDescription insertNewObjectForEntityForName:self.entity.name inManagedObjectContext:context];
    [usuario setValue:[NSNumber numberWithInt:cliente.idCliente] forKey:@"idCliente"];
    [usuario setValue:[NSNumber numberWithInt:cliente.pessoa.idPessoa] forKey:@"idPessoa"];
    [usuario setValue:cliente.pessoa.nome forKey:@"nome"];
    [usuario setValue:cliente.pessoa.cpf forKey:@"cpf"];
    NSError* error;
    if (![context save:&error])
    {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
}

@end
