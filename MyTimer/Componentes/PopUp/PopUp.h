//
//  PopUp.h
//  HeroiDaCidade
//
//  Created by Gabriel Moraes on 18/07/13.
//  Copyright (c) 2013 Call. All rights reserved.
//

#ifndef HeroiDaCidade_PopUp_h
#define HeroiDaCidade_PopUp_h

#define POP_UP_OK @"1"
#define POP_UP_OK_CANCELAR @"2"

#define TIPO_IMAGEM_ERRO @"HDC_erro.jpg"
#define TIPO_IMAGEM_SUCESSO @"HDC_sucesso.jpg"
#define TIPO_IMAGEM_ALERTA @"HDC_alerta.jpg"
#define TIPO_IMAGEM_SEM_CONEXAO @"HDC_semconexao_2.png"

#endif

#import <Foundation/Foundation.h>

@protocol PopUpDelegate <NSObject>

-(void)popUpCancelar;
-(void)popUpOK;

@end

@interface PopUp : UIView
{
    id<PopUpDelegate> __weak delegate;
}

@property (nonatomic, strong) UITextView *txtMensagemExibicao;
@property(nonatomic,weak)id <PopUpDelegate> delegate;

-(void)setImgIcone:(NSString *)vcTipoImagem;
-(void)setTipoAlert:(NSString *)TipoAlert comTitulo:(NSString *)Titulo;

@end
