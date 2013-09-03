//
//  Pessoa.h
//  MyTimer
//
//  Created by Gabriel Moraes on 03/09/13.
//  Copyright (c) 2013 Fenix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Pessoa : NSObject

@property long idPessoa;
@property (nonatomic, strong) NSString* nome;
@property (nonatomic, strong) NSDate* dataNascimento;
@property (nonatomic, strong) NSString* login;
@property (nonatomic, strong) NSString* senha;
@property (nonatomic, strong) NSString* cpf;

//private Long idContato;
//private String telefone;
//private String email;

//private Long idEndereco;
//private TipoLogradouroEnum tipoLogradouro;
//private String nome;
//private String numero;
//private String bairro;
//private MunicipioModel municipio;
//private String cep;
//private String complemento;

@end
