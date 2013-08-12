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

-(void)PopUpCancelar;
-(void)PopUpOK;

@end

@interface PopUp : UIView
{
    id<PopUpDelegate> delegate;
}

@property (nonatomic, retain) UITextView *txtMensagemExibicao;
@property(nonatomic,assign)id <PopUpDelegate> delegate;

-(void)setImgIcone:(NSString *)vcTipoImagem;
-(void)setTipoAlert:(NSString *)TipoAlert comTitulo:(NSString *)Titulo;

@end
