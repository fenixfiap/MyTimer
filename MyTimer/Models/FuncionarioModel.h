//
//  FuncionarioModel.h
//  MyTimer
//
//  Created by Gabriel Moraes on 18/10/13.
//  Copyright (c) 2013 Fenix. All rights reserved.
//

#import "JSONModel.h"
#import "PessoaModel.h"

@interface FuncionarioModel : JSONModel

@property (nonatomic) NSUInteger idFuncionario;
@property (strong, nonatomic) PessoaModel* pessoa;

@end
