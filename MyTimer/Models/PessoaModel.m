//
//  PessoaModel.m
//  MyTimer
//
//  Created by Gabriel Moraes on 18/10/13.
//  Copyright (c) 2013 Fenix. All rights reserved.
//

#import "PessoaModel.h"

@implementation PessoaModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id": @"idPessoa"}];
}

-(NSString*) nome
{
    return [_nome capitalizedString];
}

@end
