//
//  LoginViewController.h
//  MyTimer
//
//  Created by Gabriel Moraes on 11/07/13.
//  Copyright (c) 2013 Fenix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KeyboardToolbar.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "JSONKit.h"
#import "CustomActivityIndicatorView.h"
#import "Constantes.h"
#import "AppDelegate.h"

@interface LoginViewController : UIViewController
{
    @private CustomActivityIndicatorView* carregandoTela;
}

@property (retain, nonatomic) IBOutlet UITextField *txtLogin;
@property (retain, nonatomic) IBOutlet UITextField *txtSenha;
@property (retain, nonatomic) IBOutlet UIScrollView *svTela;
@property (strong, nonatomic) IBOutlet UIButton *btnEntrar;
@property (strong, nonatomic) IBOutlet UIButton *btnContinuar;
@property (strong, nonatomic) IBOutlet UILabel *lblUsuario;

- (IBAction)autentica:(UIButton *)sender;
- (IBAction)continua:(UIButton *)sender;

@end
