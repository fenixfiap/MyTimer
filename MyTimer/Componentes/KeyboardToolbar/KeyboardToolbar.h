//
//  KeyboardToolbar.h
//  MyTimer
//
//  Created by Fenix on 7/22/13.
//  Copyright (c) 2013 Fenix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface KeyboardToolbar : UIToolbar
{
     id CampoFocoAtual;
    UITapGestureRecognizer* gestureRecognizer;
    CGSize tamanhoOriginal;
}

@property (nonatomic,strong) UIScrollView* svTela;

-(id)initWithFrame:(CGRect)frame andNavigation:(BOOL)isNav;

@end
