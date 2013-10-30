//
//  PessoaModel.h
//  MyTimer
//
//  Created by Gabriel Moraes on 18/10/13.
//  Copyright (c) 2013 Fenix. All rights reserved.
//

#import "JSONModel.h"

@interface PessoaModel : JSONModel

@property (nonatomic) NSUInteger idPessoa;
@property (strong, nonatomic) NSString* nome;
@property (strong, nonatomic) NSString* cpf;

@end
