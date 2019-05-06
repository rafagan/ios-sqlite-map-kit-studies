//
//  PropertyListCRUD.h
//  Exercicio pList
//
//  Created by Rafagan Abreu on 23/01/14.
//  Copyright (c) 2014 Rafagan Abreu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataSourceModel.h"

@interface PropertyListCRUD : NSObject <DataSourceModel>

@property (nonatomic,strong) NSString *pListName;
@property (nonatomic,strong) NSString *validDirectoryPath;


// Salva o dicionário em forma de pList
// Cuidado, pois este método sobrescreve as informações anteriores
// Caso deseje apenas atualizar os dados da pList, utilizar o update
- (void)createDataWithContent:(NSMutableDictionary*)newContent;

// Modifica os dados da persistência (UPDATE)
// O importante das pLists neste caso é que este método não sobrescreve os dados anteriores da pList
// Ou seja, o que não existia será criado, e o que já existia será atualizado
- (void)updateDataWithContent:(NSMutableDictionary*)newContent;

@end