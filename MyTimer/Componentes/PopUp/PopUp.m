//
//  PopUp.m
//  HeroiDaCidade
//
//  Created by William Gomes on 7/17/13.
//  Copyright (c) 2013 Call. All rights reserved.
//

#import "PopUp.h"

@implementation PopUp

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        
        UIView *vwTransparencia = [[UIView alloc] initWithFrame:frame];
        vwTransparencia.backgroundColor = [UIColor colorWithRed:14/255.0f green:74/255.0f blue:128/255.0f alpha:1];
        vwTransparencia.alpha = 0.6;
        [self addSubview:vwTransparencia];
        
        CGPoint ptCentralImgBackground = self.center;
        UIImage *imgBackground = [UIImage imageNamed:@"HDC_Box_PopUp.png"];
        UIImageView *imgviewBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width - 50, 300)];
        imgviewBackground.center = ptCentralImgBackground;
        imgviewBackground.image = imgBackground;
        [self insertSubview:imgviewBackground aboveSubview:vwTransparencia];
        
        CGPoint ptCentralLabel = self.center;
        ptCentralLabel.y =  ptCentralLabel.y + 15;
        self.txtMensagemExibicao = [[UITextView alloc] initWithFrame:CGRectMake(0,0,self.frame.size.width - 70, 100)];
        self.txtMensagemExibicao.backgroundColor = [UIColor clearColor];
        self.txtMensagemExibicao.font = [UIFont boldSystemFontOfSize:17];
        self.txtMensagemExibicao.textColor = [UIColor whiteColor];
        self.txtMensagemExibicao.center = ptCentralLabel;
        self.txtMensagemExibicao.editable = NO;
        [self insertSubview:self.txtMensagemExibicao aboveSubview:imgviewBackground];
        
//        CGPoint ptCentralBotao = self.center;
//        ptCentralBotao.y =  ptCentralBotao.y + 95;
//        UIButton *btnOk=[UIButton buttonWithType:UIButtonTypeCustom ];
//        [btnOk setFrame:CGRectMake(0, 0, 75, 44)];
//        [btnOk setBackgroundImage:[UIImage imageNamed:@"HDC_Bot_Branco.png"] forState:UIControlStateNormal];
//        [btnOk setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 50.0, 0.0)];
//        [btnOk setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)];
//        [btnOk setTitle:@"OK" forState:UIControlStateNormal];
//        [btnOk setTitleColor:[UIColor colorWithRed:14/255.0f green:74/255.0f blue:128/255.0f alpha:1] forState:UIControlStateNormal];
//        [btnOk addTarget:self action:@selector(FecharPopUp:) forControlEvents:UIControlEventTouchUpInside];
//        btnOk.center = ptCentralBotao;
//        [self insertSubview:btnOk aboveSubview:imgviewBackground];

    }
    return self;
}

-(void)setTipoAlert:(NSString *)TipoAlert comTitulo:(NSString*)Titulo{
    
    UIButton *btnOk=[UIButton buttonWithType:UIButtonTypeCustom ];
    [btnOk setFrame:CGRectMake(0, 0, 110, 44)];
    [btnOk setBackgroundImage:[UIImage imageNamed:@"HDC_Bot_Branco.png"] forState:UIControlStateNormal];
    [btnOk setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 50.0, 0.0)];
    [btnOk setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)];
    [btnOk setTitle:Titulo forState:UIControlStateNormal];
    [btnOk setTitleColor:[UIColor colorWithRed:14/255.0f green:74/255.0f blue:128/255.0f alpha:1] forState:UIControlStateNormal];
    [btnOk addTarget:self action:@selector(btnOk:) forControlEvents:UIControlEventTouchUpInside];
   
    
    
    if ([TipoAlert isEqualToString:POP_UP_OK]) {
        CGPoint ptCentralBotao = self.center;
        ptCentralBotao.y =  ptCentralBotao.y + 95;
        btnOk.center = ptCentralBotao;
    }
    else{
       
        CGPoint ptCentralBotao = self.center;
        ptCentralBotao.y =  ptCentralBotao.y + 95;
        ptCentralBotao.x =  ptCentralBotao.x + 60;
        btnOk.center = ptCentralBotao;
        
        CGPoint ptCentralBotaoCancelar = self.center;
        ptCentralBotaoCancelar.y =  ptCentralBotaoCancelar.y + 95;
         ptCentralBotaoCancelar.x =  ptCentralBotaoCancelar.x - 60;
        UIButton *btnCancelar=[UIButton buttonWithType:UIButtonTypeCustom ];
        [btnCancelar setFrame:CGRectMake(0, 0, 110, 44)];
        [btnCancelar setBackgroundImage:[UIImage imageNamed:@"HDC_Bot_Branco.png"] forState:UIControlStateNormal];
        [btnCancelar setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 50.0, 0.0)];
        [btnCancelar setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)];
        [btnCancelar setTitle:@"Cancelar" forState:UIControlStateNormal];
        [btnCancelar setTitleColor:[UIColor colorWithRed:14/255.0f green:74/255.0f blue:128/255.0f alpha:1] forState:UIControlStateNormal];
        [btnCancelar addTarget:self action:@selector(btnCancelar:) forControlEvents:UIControlEventTouchUpInside];
        btnCancelar.center = ptCentralBotaoCancelar;
        [self addSubview:btnCancelar];
    }
    
    
    [self addSubview:btnOk];
}

-(void)setImgIcone:(NSString *)vcTipoImagem{
    CGPoint ptCentralImgIcone = self.center;
    ptCentralImgIcone.y =  ptCentralImgIcone.y - 70;
    UIImage *imgIcone = [UIImage imageNamed:vcTipoImagem];
    UIImageView *imgviewIcone = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 65, 65)];
    imgviewIcone.image = imgIcone ;
    imgviewIcone.center = ptCentralImgIcone;
    [self insertSubview:imgviewIcone aboveSubview:self];

}

-(void)btnOk:(id)sender{
    
    if([delegate respondsToSelector:@selector(PopUpOK)])
    {
        [delegate PopUpOK];
    }
    [self removeFromSuperview];
}

-(void)btnCancelar:(id)sender{
    
    if([delegate respondsToSelector:@selector(PopUpCancelar)])
    {
        [delegate PopUpCancelar];
    }
    [self removeFromSuperview];
}

@end
