//
//  NovoViewController.h
//  MyTimer
//
//  Created by Fenix on 12/08/13.
//  Copyright (c) 2013 Fenix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KeyboardToolbar.h"
#import "AppDelegate.h"
#import "CustomActivityIndicatorView.h"
#import "CustomPicker.h"
#import "CustomDatePicker.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "Constantes.h"
#import "CRUD.h"
#import "NSData+JSON.h"

@interface NovoViewController : UIViewController <UIActionSheetDelegate, UIAlertViewDelegate>
{
    CustomActivityIndicatorView* carregandoTela;
    NSMutableDictionary* dictMapHorariosFuncionarios;
    float initialY;
}

@property (strong, nonatomic) IBOutlet UIScrollView* svTela;
@property (strong, nonatomic) IBOutlet UITextField* txtServico;
@property (strong, nonatomic) IBOutlet UITextField* txtData;
@property (strong, nonatomic) IBOutlet UISegmentedControl* scPreferencia;
@property (strong, nonatomic) IBOutlet UITextField* txtFuncionario;
@property (strong, nonatomic) IBOutlet UITextField* txtHorario;
@property (strong, nonatomic) IBOutlet UIButton* btnSalvar;

- (IBAction)agendar:(UIButton *)sender;
- (IBAction)cancelaNovo:(UIBarButtonItem *)sender;

@end
