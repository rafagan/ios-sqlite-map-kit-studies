//
//  DataSourceModel.h
//  Exercicio MapKit
//
//  Created by Rafagan Abreu on 15/03/14.
//  Copyright (c) 2014 Rafagan Abreu. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DataSourceModel <NSObject>

// Designated Initializer
- (instancetype)initWithName:(NSString*)name;

// Adiciona novos dados à persistência (CREATE)
- (void)createDataWithContent:(NSMutableDictionary*)newContent;

// Carrega todos os dados da persistência (READ ALL)
- (NSMutableDictionary*)readAllData;

// Modifica os dados da persistência (UPDATE)
- (void)updateDataWithContent:(NSMutableDictionary*)newContent;

// Remove dados da persistência (DELETE)
// Se as keys forem nulas, remove todo o conteúdo
- (void)deleteDataWithKeys:(NSArray*)keys;

// Remove todos os dados da persistência
- (void)clearData;

@end
