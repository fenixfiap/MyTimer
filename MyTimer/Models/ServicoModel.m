//
//  ServicoModel.m
//  MyTimer
//
//  Created by Gabriel Moraes on 18/10/13.
//  Copyright (c) 2013 Fenix. All rights reserved.
//

#import "ServicoModel.h"

@implementation ServicoModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id": @"idServico"}];
}

-(NSString*) nome
{
    return [_nome capitalizedString];
}

@end
