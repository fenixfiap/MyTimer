//
//  ServicoModel.h
//  MyTimer
//
//  Created by Gabriel Moraes on 18/10/13.
//  Copyright (c) 2013 Fenix. All rights reserved.
//

#import "JSONModel.h"

@interface ServicoModel : JSONModel

@property (nonatomic) NSUInteger idServico;
@property (strong, nonatomic) NSString* nome;
@property (nonatomic) double preco;

@end
