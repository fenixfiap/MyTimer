//
//  AppDelegate.h
//  MyTimer
//
//  Created by Gabriel Moraes on 04/09/13.
//  Copyright (c) 2013 Fenix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RealizadosViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
