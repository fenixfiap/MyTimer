//
//  RealizadosViewController.h
//  MyTimer
//
//  Created by Gabriel Moraes on 03/09/13.
//  Copyright (c) 2013 Fenix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "JSONKit.h"
#import "Constantes.h"
#import "CustomActivityIndicatorView.h"

@interface RealizadosViewController : UIViewController <UIActionSheetDelegate, UITableViewDataSource>
{
    @private CustomActivityIndicatorView* carregandoTela;
    @private NSArray *arrAgendamentos;
}

@property (strong, nonatomic) IBOutlet UITableView *tbAgendamentos;

- (IBAction)btnSair:(UIBarButtonItem *)sender;

@end
