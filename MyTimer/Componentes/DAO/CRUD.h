//
//  CRUD.h
//  MyTimer
//
//  Created by Gabriel Moraes on 10/10/13.
//  Copyright (c) 2013 Fenix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "ClienteModel.h"

@interface CRUD : NSObject
{
    NSManagedObjectContext* context;
}

@property (strong, nonatomic, readonly) NSEntityDescription* entity;

-(id) initWithEntity:(NSString*) entityName;
-(void) removeAll;
-(ClienteModel*) getLogado;
-(void) saveUser:(ClienteModel*) userData;

@end
