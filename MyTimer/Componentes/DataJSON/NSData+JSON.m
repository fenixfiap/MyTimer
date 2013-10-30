//
//  NSData+JSON.m
//  MyTimer
//
//  Created by Gabriel Moraes on 30/10/13.
//  Copyright (c) 2013 Fenix. All rights reserved.
//

#import "NSData+JSON.h"

@implementation NSData (JSON)

- (id) toJSON
{
    NSError* error;
    return [NSJSONSerialization JSONObjectWithData:self options:kNilOptions error:&error];
}

@end
