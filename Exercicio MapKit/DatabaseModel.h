//
//  DataBaseModel.h
//  Exercicio MapKit
//
//  Created by Rafagan Abreu on 17/03/14.
//  Copyright (c) 2014 Rafagan Abreu. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DatabaseModel <NSObject>

// Carrega dados em específico (READ)
// Este comando é útil para realizar SELECTs simples no banco
- (NSMutableDictionary*)loadAllDataWithParameters:(NSDictionary*)parameters;

// Adiciona novos dados à persistência (CREATE)
// É útil para trabalharmos com queries manuais
- (void)insertDataWithQuery:(NSString*)newContent;

// Remove dados da persistência (DELETE)
// Se o parâmetro for nulo, remove todo o conteúdo
- (void)removeDataWithQuery:(NSString*)query;

// Modifica os dados da persistência (UPDATE)
- (void)updateDataWithParameters:(NSDictionary*)parameters;
- (void)updateDataWithQuery:(NSString*)query;

// Executa uma query qualquer.
// O retorno é variável.
- (id)executeQuery:(NSString*)query;


@end
