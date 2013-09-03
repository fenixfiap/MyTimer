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

@interface LoginViewController : UIViewController
{
    @private KeyboardToolbar* keyboard;
    @private CustomActivityIndicatorView* carregandoTela;
}
@property (retain, nonatomic) IBOutlet UITextField *txtLogin;
@property (retain, nonatomic) IBOutlet UITextField *txtSenha;
@property (retain, nonatomic) IBOutlet UIScrollView *svTela;

- (IBAction)autentica:(UIButton *)sender;

@end
