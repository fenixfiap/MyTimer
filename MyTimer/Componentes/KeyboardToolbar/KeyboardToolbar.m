//
//  KeyboardToolbar.m
//  MyTimer
//
//  Created by Fenix on 7/22/13.
//  Copyright (c) 2013 Fenix. All rights reserved.
//

#import "KeyboardToolbar.h"


@implementation KeyboardToolbar

@synthesize svTela;

-(id)initWithFrame:(CGRect)frame andNavigation:(BOOL)isNav{
    
    if ((self = [super initWithFrame:frame])) {
        
        UIBarButtonItem *btEspacamento = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:(UIBarButtonSystemItemFlexibleSpace) target:nil action:nil];
        
        UIBarButtonItem *btEscondeTeclado = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:(UIBarButtonSystemItemDone) target:self action:@selector(btnDoneEscondeTeclado:)];
        
        if (isNav) {
            UIBarButtonItem *btAnterior = [[UIBarButtonItem alloc] initWithTitle:@"Anterior"
                                                                           style:UIBarButtonItemStyleBordered
                                                                          target:self
                                                                          action:@selector(FocoCampoAnterior:)];
            UIBarButtonItem *btProximo = [[UIBarButtonItem alloc] initWithTitle:@"Próximo"
                                                                          style:UIBarButtonItemStyleBordered
                                                                         target:self
                                                                         action:@selector(FocoCampoProximo:)];
            
            [self setItems:[NSArray arrayWithObjects:btAnterior, btProximo, btEspacamento,btEscondeTeclado, nil]];
        }
        else {
            [self setItems:[NSArray arrayWithObjects: btEspacamento,btEscondeTeclado, nil]];
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(FocoCampoAtual:)
                                                     name:UITextFieldTextDidBeginEditingNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(FocoCampoAtual:)
                                                     name:UITextViewTextDidBeginEditingNotification
                                                   object:nil];
        
        
        
    }
    
    return self;
}

-(void)setSvTela:(UIScrollView *)_svTela{
    svTela = _svTela;
    gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
}
- (void)hideKeyboard:(NSNotification*)notification
{
    [UIView animateWithDuration:0.3
                          delay:0
                        options: UIViewAnimationOptionTransitionNone
                     animations:^{
                         [self.svTela setContentSize:CGSizeMake(tamanhoOriginal.width,tamanhoOriginal.height)];
                     }
                     completion:^(BOOL finished){
                         //NSLog(@"Done!");
                     }];
    [svTela removeGestureRecognizer:gestureRecognizer];
}
- (void)hideKeyboard
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification object:nil];
    [svTela endEditing:YES];
    
    [UIView animateWithDuration:0.3
                          delay:0
                        options: UIViewAnimationOptionTransitionNone
                     animations:^{
                         [self.svTela setContentSize:CGSizeMake(tamanhoOriginal.width,tamanhoOriginal.height)];
                     }
                     completion:^(BOOL finished){
                         //NSLog(@"Done!");
                     }];
    [svTela removeGestureRecognizer:gestureRecognizer];
    
}

- (void)FocoCampoAtual:(NSNotification *)notification
{
    CampoFocoAtual = notification.object;
    
    if (!tamanhoOriginal.height > 0) {
        if (!self.svTela.contentSize.height > 0) {
            tamanhoOriginal = self.svTela.frame.size;
        }
        else {
            tamanhoOriginal = self.svTela.contentSize;
        }
    }
    
    [self.svTela setContentSize:CGSizeMake(tamanhoOriginal.width,tamanhoOriginal.height+260)];
    
    CGPoint pt;
    CGRect rc = [CampoFocoAtual bounds];
    rc = [CampoFocoAtual convertRect:rc toView:self.svTela];
    pt = rc.origin;
    pt.x = 0;
    pt.y -= 60;
    [self.svTela setContentOffset:pt animated:YES];
    
    [svTela addGestureRecognizer:gestureRecognizer];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                                                                             selector:@selector(hideKeyboard:)
                                                                                                 name:UIKeyboardWillHideNotification
                                                                                               object:nil];
}

-(void) FocoCampoAnterior:(id)sender{
    
    id AnteriorCampo = [self.svTela viewWithTag:[CampoFocoAtual tag] - 1];
    
    if ([AnteriorCampo tag ] > 0) {
        
        if (AnteriorCampo != nil && ([AnteriorCampo isKindOfClass:[UITextField class]] ||  [AnteriorCampo isKindOfClass:[UITextView class]]) ) {
            
            [AnteriorCampo becomeFirstResponder];
        }
    }
}

-(void) FocoCampoProximo:(id)sender{
    
   id ProximoCampo = [self.svTela viewWithTag:[CampoFocoAtual tag] + 1];
    
    if (ProximoCampo != nil && ([ProximoCampo isKindOfClass:[UITextField class]] ||  [ProximoCampo isKindOfClass:[UITextView class]]) ) {
        
        [ProximoCampo becomeFirstResponder];
    }
}

-(void) btnDoneEscondeTeclado:(id)sender{
    
    [svTela endEditing:YES];
    
    //if([delegate respondsToSelector:@selector(onDoneClick)])
    //{
    //    [delegate onDoneClick];
    //}
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
