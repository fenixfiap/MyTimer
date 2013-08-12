//
//  AgendamentoViewController.h
//  MyTimer
//
//  Created by Gabriel Moraes on 12/08/13.
//  Copyright (c) 2013 Fenix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KeyboardToolbar.h"

@interface AgendamentoViewController : UIViewController
{
    KeyboardToolbar* keyboard;
}

@property (retain, nonatomic) IBOutlet UIScrollView *svTela;

@end
