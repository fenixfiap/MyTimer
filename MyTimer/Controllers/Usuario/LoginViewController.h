//
//  LoginViewController.h
//  MyTimer
//
//  Created by Fenix on 11/07/13.
//  Copyright (c) 2013 Fenix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KeyboardToolbar.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "CustomActivityIndicatorView.h"
#import "Constantes.h"
#import "AppDelegate.h"
#import "CRUD.h"
#import "ClienteModel.h"
#import "NSData+JSON.h"

@interface LoginViewController : UIViewController
{
    CustomActivityIndicatorView* carregandoTela;
}

@property (retain, nonatomic) IBOutlet UITextField* txtLogin;
@property (retain, nonatomic) IBOutlet UITextField* txtSenha;
@property (retain, nonatomic) IBOutlet UIScrollView* svTela;
@property (strong, nonatomic) IBOutlet UIButton* btnEntrar;
@property (strong, nonatomic) IBOutlet UIButton* btnContinuar;
@property (strong, nonatomic) IBOutlet UILabel* lblUsuario;

- (IBAction)autentica:(UIButton *)sender;
- (IBAction)continua:(UIButton *)sender;

@end
