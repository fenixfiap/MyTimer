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
    NSError *error;
    [context save:&error];
}

-(NSArray*) listAll
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:self.entity];
    NSError *error;
    return [context executeFetchRequest:fetchRequest error:&error];
}

-(void) saveUser:(NSDictionary*)userData
{
    NSManagedObject *usuario = [NSEntityDescription insertNewObjectForEntityForName:self.entity.name inManagedObjectContext:context];
    [usuario setValue:[userData valueForKey:@"id"] forKey:@"idCliente"];
    [usuario setValue:[userData valueForKeyPath:@"pessoa.id"] forKey:@"idPessoa"];
    [usuario setValue:[userData valueForKeyPath:@"pessoa.nome"] forKey:@"nome"];
    [usuario setValue:[userData valueForKeyPath:@"pessoa.cpf"] forKey:@"cpf"];
    NSError *error;
    if (![context save:&error])
    {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
}

@end
