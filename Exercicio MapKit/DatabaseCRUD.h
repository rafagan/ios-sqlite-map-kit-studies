//
//  DataSourceFactory.h
//  alarme
//
//  Created by André Traleski de Campos on 12/10/13.
//  Copyright (c) 2013 André Traleski de Campos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "DataSourceModel.h"
#import "DatabaseModel.h"

@interface DatabaseCRUD : NSObject <DataSourceModel>

@property (nonatomic,strong) NSString *databaseName;
@property (nonatomic,strong) NSString *tableName;
@property (strong, nonatomic) NSString *databasePath;
@property (nonatomic) sqlite3 *systemDatabase;

// Sintaxe para gravação no banco:
// keys: id da persistência em string (ao passar um valor negativo, gera automaticamente)
// values: O conteúdo a ser gravado, contendo inclusive o ID. Esse dados
// serão codificados para o banco de acordo com o DECODER definido para o nome da tabela
//  - Duas abordagens possíveis:
        // a)Receber uma NSString, com cada atributo separado por vírgula
        // b)Receber um NSArray com cada parâmetro do Contato em ordem
- (void)createDataWithContent:(NSMutableDictionary *)content;

@end
