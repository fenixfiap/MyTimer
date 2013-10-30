//
//  Usuario.h
//  MyTimer
//
//  Created by Gabriel Moraes on 30/10/13.
//  Copyright (c) 2013 Fenix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "JSONModel.h"

@interface Usuario : NSManagedObject

@property (nonatomic, retain) NSString * cpf;
@property (nonatomic, retain) NSNumber * idCliente;
@property (nonatomic, retain) NSNumber * idPessoa;
@property (nonatomic, retain) NSString * nome;

@end
