//
//  ClienteModel.m
//  MyTimer
//
//  Created by Gabriel Moraes on 18/10/13.
//  Copyright (c) 2013 Fenix. All rights reserved.
//

#import "ClienteModel.h"

@implementation ClienteModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id": @"idCliente"}];
}

@end
