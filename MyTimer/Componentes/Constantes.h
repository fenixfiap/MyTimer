//
//  Constantes.h
//  MyTimer
//
//  Created by Fenix on 03/09/13.
//  Copyright (c) 2013 Fenix. All rights reserved.
//

#ifndef MyTimer_Constantes_h
#define MyTimer_Constantes_h

#define USER_INFO_ULTIMO_LOGADO @"ultimoUsuarioLogado"

#define ENDERECO_PORTA @":8080"
#define ENDERECO_CAMINHO @"/mt-web/ws/mobile"
#define ENDERECO_SERVICOS [[@"http://localhost" stringByAppendingString: ENDERECO_PORTA] stringByAppendingString: ENDERECO_CAMINHO]

#define SERVICO_LOGAR [ENDERECO_SERVICOS stringByAppendingString: @"/login"]
#define SERVICO_LISTAR_AGENDAMENTOS [ENDERECO_SERVICOS stringByAppendingString: @"/agendamentos/%@"]
#define SERVICO_LISTAR_SERVICOS [ENDERECO_SERVICOS stringByAppendingString: @"/servicos"]
#define SERVICO_LISTAR_HORARIOS [ENDERECO_SERVICOS stringByAppendingString: @"/horarios"]
#define SERVICO_LISTAR_HORARIOS_FUNCIONARIO [ENDERECO_SERVICOS stringByAppendingString: @"/horariosFuncionario"]
#define SERVICO_LISTAR_FUNCIONARIOS [ENDERECO_SERVICOS stringByAppendingString: @"/prestadores/%@"]
#define SERVICO_AGENDAR [ENDERECO_SERVICOS stringByAppendingString: @"/agendar"]


#endif