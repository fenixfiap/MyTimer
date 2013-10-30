//
//  AgendamentoModel.h
//  MyTimer
//
//  Created by Gabriel Moraes on 18/10/13.
//  Copyright (c) 2013 Fenix. All rights reserved.
//

#import "JSONModel.h"
#import "ClienteModel.h"
#import "FuncionarioModel.h"
#import "ServicoModel.h"

@interface AgendamentoModel : JSONModel

@property (nonatomic) NSUInteger idAgendamento;
@property (strong, nonatomic) ClienteModel* cliente;
@property (strong, nonatomic) FuncionarioModel* funcionario;
@property (strong, nonatomic) ServicoModel* servico;
@property (strong, nonatomic) NSString* data;
@property (strong, nonatomic) NSString* horaInicio;
@property (nonatomic) char status;
@property (nonatomic, getter = isSemAgendamento) BOOL semAgendamento;
@property (strong, nonatomic) NSString* statusFormatado;

@end
