//
//  AgendamentoModel.m
//  MyTimer
//
//  Created by Gabriel Moraes on 18/10/13.
//  Copyright (c) 2013 Fenix. All rights reserved.
//

#import "AgendamentoModel.h"

@implementation AgendamentoModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id": @"idAgendamento"}];
}

-(NSString*) statusFormatado
{
    return [_statusFormatado capitalizedString];
}

@end
