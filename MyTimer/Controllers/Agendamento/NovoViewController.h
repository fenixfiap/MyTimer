//
//  NovoViewController.h
//  MyTimer
//
//  Created by Gabriel Moraes on 12/08/13.
//  Copyright (c) 2013 Fenix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KeyboardToolbar.h"
#import "CustomActivityIndicatorView.h"
#import "CustomPicker.h"
#import "CustomDatePicker.h"

@interface NovoViewController : UIViewController <UIActionSheetDelegate>
{
    @private CustomActivityIndicatorView* carregandoTela;
}

@property (strong, nonatomic) IBOutlet UIScrollView *svTela;
@property (strong, nonatomic) IBOutlet UITextField *txtServico;
@property (strong, nonatomic) IBOutlet UITextField *txtData;
@property (strong, nonatomic) IBOutlet UISegmentedControl *scPreferencia;
@property (strong, nonatomic) IBOutlet UITextField *txtDentista;
@property (strong, nonatomic) IBOutlet UITextField *txtHorario;

- (IBAction)agendar:(UIButton *)sender;
- (IBAction)cancelaNovo:(UIBarButtonItem *)sender;

@end
