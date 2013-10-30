//
//  FuncionarioModel.m
//  MyTimer
//
//  Created by Gabriel Moraes on 18/10/13.
//  Copyright (c) 2013 Fenix. All rights reserved.
//

#import "FuncionarioModel.h"

@implementation FuncionarioModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id": @"idFuncionario"}];
}

@end
