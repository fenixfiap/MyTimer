//
//  RealizadosViewController.h
//  MyTimer
//
//  Created by Fenix on 03/09/13.
//  Copyright (c) 2013 Fenix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "Constantes.h"
#import "CRUD.h"
#import "AgendamentoModel.h"
#import "NSData+JSON.h"

@interface RealizadosViewController : UIViewController <UIActionSheetDelegate, UITableViewDataSource>
{
    NSArray* arrAgendamentos;
    UIRefreshControl* refresh;
}

@property (strong, nonatomic) IBOutlet UITableView* tbAgendamentos;

- (IBAction)btnSair:(UIBarButtonItem *)sender;

@end
