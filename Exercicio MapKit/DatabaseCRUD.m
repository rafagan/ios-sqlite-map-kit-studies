//
//  DatabaseCRUD
//  Exercício Mapkit
//
//  Created by André Traleski de Campos on 12/10/13.
//  Copyright (c) 2013 André Traleski de Campos. All rights reserved.
//

#import "DatabaseCRUD.h"
#import "DatabaseDecoder.h"
#import "DatabaseEncoder.h"
#import "ClassReflectionHelper.h"

@interface DatabaseCRUD ()
{
    BOOL initialized;
    NSArray* columns;
    NSString* columnsStringProperties;
}

@end

@implementation DatabaseCRUD

- (id)initWithName:(NSString *)name
{
    self = [super init];
    if (self) {
        _databaseName = @"RaMapDb"; //Para manter a compatibilidade com pList, suporto apenas 1 banco
        _tableName = name;
        
        NSString *docsDir;
        NSString *dbNameExt = [NSString stringWithFormat:@"%@.db",_databaseName];
        NSArray *dirPaths;
        BOOL BDExist;
        
        //Pega o diretório de documentos
        dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        docsDir = dirPaths[0];
        
        //Cria o endereçamento correto para o diretório do banco de dados
        _databasePath = [[NSString alloc] initWithString:[docsDir stringByAppendingPathComponent:dbNameExt]];
        
        const char *dbpath = [_databasePath UTF8String];
        
        //Tenta criar conexão com o banco
        if (sqlite3_open(dbpath, &_systemDatabase) == SQLITE_OK) {
            
            //Verifica a existência do banco de dados
            NSFileManager *filemgr = [NSFileManager defaultManager];
            BDExist = [filemgr fileExistsAtPath:_databasePath];
            
            if (BDExist == NO)
                NSLog(@"BD criado com sucesso");
            else
                NSLog(@"BD aberto com sucesso");
            
            sqlite3_close(_systemDatabase);
        } else {
            NSLog(@"Falha ao criar/abrir o BD");
        }
        
        initialized = NO;
    }
    return self;
}

- (NSMutableDictionary *)readAllData
{
    const char *dbpath = [_databasePath UTF8String];
    if(sqlite3_open(dbpath, &_systemDatabase) != SQLITE_OK) return nil;
    const char *query_dbexists_stmt = [[NSString stringWithFormat:@"SELECT CASE WHEN tbl_name = '%@' THEN 1 ELSE 0 END FROM sqlite_master WHERE tbl_name = '%@' AND type = 'table'", _tableName,_tableName] UTF8String];
    sqlite3_stmt *statement;
    BOOL dbExists = NO;
    
    if( sqlite3_prepare_v2(_systemDatabase, query_dbexists_stmt, -1, &statement, NULL) == SQLITE_OK )
    {
        //Loop through all the returned rows (should be just one)
        while( sqlite3_step(statement) == SQLITE_ROW )
        {
            int test = sqlite3_column_int(statement, 0);
            dbExists = sqlite3_column_int(statement, 0);
        }
    }
    
    sqlite3_close(_systemDatabase);
    
    if(!dbExists) return nil;
    
    NSMutableDictionary *data = [NSMutableDictionary new];
    if (sqlite3_open(dbpath, &_systemDatabase) == SQLITE_OK) {
        //Primeiro pegamos todos os dados da tabela
        const char *query_stmt = [[NSString stringWithFormat:@"SELECT * FROM %@", _tableName] UTF8String];
        
        if (sqlite3_prepare_v2(_systemDatabase, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
            //Vamos percorrer cada instância da tabela
            while (sqlite3_step(statement) == SQLITE_ROW) {
                //A primeira coluna sempre é o ID da instância
                NSMutableDictionary* parameters = [NSMutableDictionary new];
                NSNumber* myId = [NSNumber numberWithUnsignedInteger:(NSUInteger)sqlite3_column_int(statement, 0)];
                [parameters setObject:myId forKey:@"ID"];
                
                //Os demais dados são os parâmetros
                for (int i = 1; i < sqlite3_column_count(statement); i++) {
                    //O nome do parâmetro será o nome da coluna da tabela
                    NSString* name = [NSString stringWithFormat:@"%s",sqlite3_column_name(statement, i)];
                    sqlite3_value* data = sqlite3_column_value(statement, i);
                    id result;
                    
                    switch (sqlite3_value_type(data)) {
                        case SQLITE_INTEGER:
                            result = [NSNumber numberWithInt:sqlite3_value_int(data)];
                            break;
                        case SQLITE_FLOAT:
                            result = [NSNumber numberWithDouble:sqlite3_value_double(data)];
                            break;
                        case SQLITE_BLOB:
                            result = (__bridge id)(data);
                            break;
                        case SQLITE_TEXT:
                            result = [NSString stringWithUTF8String:(const char*)(sqlite3_value_text(data))];
                            break;
                        case SQLITE_NULL:
                            result = nil;
                            break;
                        default:
                            break;
                    }
                    
                    [parameters setObject:result forKey:name];
                }
                
                //Criamos um objeto da classe a partir do decoder da tabela (que é o nome da classe)
                //Passamos os parâmetros necessários para a criação desse objeto
                //Mas também precisamos definí-lo pelo ID, para que esse se distinga das demais instâncias da tabela
                [data setObject:[ENCODER getObjectFromEncoder:_tableName withParameters:parameters] forKey:myId];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(_systemDatabase);
    }
    return data;
}

//A key vem em forma de string
//O valor vem em forma de: NSArray, NSMutableArray ou NSString
//Futuras implementações aceitarão suporte a NSCoder e a passagem direta do objeto
//CUIDADO: O banco armazenará apenas dados referentes às propriedades. Tudo que for privado ou global será perdido
- (void)createDataWithContent:(NSMutableDictionary *)content
{
    /* ESTUDAR MANEIRAS DE REALIZAR UMA COMPARAÇÃO PARA VER SE UM ATRIBUTO FOI CRIADO OU REMOVIDO */
    
    const char *dbpath = [_databasePath UTF8String];
    if(sqlite3_open(dbpath, &_systemDatabase) != SQLITE_OK) return;
    const char *query_dbexists_stmt = [[NSString stringWithFormat:@"SELECT CASE WHEN tbl_name = '%@' THEN 1 ELSE 0 END FROM sqlite_master WHERE tbl_name = '%@' AND type = 'table'", _tableName,_tableName] UTF8String];
    sqlite3_stmt *statement;
    BOOL dbExists = NO;
    
    if( sqlite3_prepare_v2(_systemDatabase, query_dbexists_stmt, -1, &statement, NULL) == SQLITE_OK )
    {
        //Loop through all the returned rows (should be just one)
        while( sqlite3_step(statement) == SQLITE_ROW )
        {
            int test = sqlite3_column_int(statement, 0);
            dbExists = sqlite3_column_int(statement, 0);
        }
    }
    
    sqlite3_close(_systemDatabase);
    
    //Lazy instantiation da tabela no banco
    if (!dbExists) {
        //Faz uma varredura das classes e pega a classe corespondente à tabela pelo nome
        Class class = NSClassFromString(_tableName);
        //Pega cada uma das propriedades da classe para criar as colunas
        columns = [ClassReflectionHelper getPropertyNamesOfClass:[class class]];
        
        //Concatena por meio de vírgula cada um dos nomes das colunas
        
        int i=0;
        for (__strong NSString* propertyName in columns) {
            propertyName = [propertyName lowercaseString];
            if(i++ == 0)
                columnsStringProperties = [NSString stringWithFormat:@"%@",propertyName];
            else
                columnsStringProperties = [NSString stringWithFormat:@"%@,%@",columnsStringProperties,propertyName];
        }
        
        //Criação da tabela
        [self clearData];
    }
    
    for(id key in content) {
        BOOL state;
        NSString* valuesString = @"";
        char *errMsg = NULL;
        
        id valueDataStructure = [content objectForKey:key];
        
        //Suporta como value strings e arrays, precisamos tratá-los adequadamente aqui
        if([valueDataStructure isKindOfClass:[NSString class]]){
            valuesString = [valueDataStructure stringByReplacingOccurrencesOfString:@"=" withString:@"\',\'"];
            valuesString = [NSString stringWithFormat:@"\'%@\'",valuesString];
        }
        else if([valueDataStructure isKindOfClass:[NSArray class]] || [valueDataStructure isKindOfClass:[NSMutableArray class]]) {
            valuesString = [NSString stringWithFormat:@"%@",[valueDataStructure objectAtIndex:0]];
            for (id param in valueDataStructure) {
                valuesString = [NSString stringWithFormat:@"%@",param];
            }
        }
        
        //ESTUDAR A POSSIBILIDADE DA UTILIZAÇÃO DE NSCODER AQUI!
        
        if (sqlite3_open(dbpath, &_systemDatabase) == SQLITE_OK && ![valuesString isEqualToString:@""]) {
            const char *insert_stmt = [[NSString stringWithFormat:@"INSERT INTO %@ (%@) VALUES (%@)",_tableName,columnsStringProperties,valuesString] UTF8String];
            
            int result = sqlite3_exec(_systemDatabase, insert_stmt, NULL, NULL, &errMsg);
            state = (result == SQLITE_OK);
            sqlite3_close(_systemDatabase);
        } else {
            state = NO;
        }
        
        if(!state) {
            printf("%s\n",errMsg ? errMsg : "Erro desconhecido");
        }
    }
}

- (void)clearData {
    char *errMsg;
    const char *dbpath = [_databasePath UTF8String];
    
    if(sqlite3_open(dbpath, &_systemDatabase) != SQLITE_OK) return;
    
    //Remove o que já existia
    NSString* drop_stmt = [NSString stringWithFormat:
                           @"DROP TABLE IF EXISTS %@",_tableName];
    sqlite3_exec(_systemDatabase, [drop_stmt UTF8String], NULL, NULL, &errMsg);
    
    //Cria denovo
    NSString* createParams = @"";
    for (NSString* str in [columnsStringProperties componentsSeparatedByString:@","]) {
        BOOL isId = [str hasPrefix:@"id"];
        createParams = [NSString stringWithFormat:@"%@%@%@ %@ NOT NULL",createParams,isId ? @"" : @",",str,isId ? @"INTEGER PRIMARY KEY" : @"BLOB"];
    }
    
    NSString *sql_stmt = [NSString stringWithFormat:
                          @"CREATE TABLE %@ (%@)",_tableName,createParams];
    
    int result = sqlite3_exec(_systemDatabase, [sql_stmt UTF8String], NULL, NULL, &errMsg);
    
    if (result != SQLITE_OK) {
        errMsg = errMsg ? errMsg : "desconhecido";
        NSLog(@"Falha ao criar as tabelas do banco. Erro: %s",errMsg);
    } else {
        NSLog(@"Tabelas abertas/criadas com sucesso");
        initialized = YES;
    }
    
    sqlite3_close(_systemDatabase);
}

- (void)deleteDataWithKeys:(NSArray*)keys
{
    if(keys == nil) {
        [self clearData];
        return;
    }
    
    char *errMsg;
    const char *dbpath = [_databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &_systemDatabase) == SQLITE_OK) {
        
        for (NSNumber* key in keys) {
            NSString *sql_stmt = [NSString stringWithFormat:
                                  @"DELETE FROM %@ WHERE id = %lu",_tableName, (unsigned long)key.unsignedIntegerValue];
            if (sqlite3_exec(_systemDatabase, [sql_stmt UTF8String], NULL, NULL, &errMsg) != SQLITE_OK)
                NSLog(@"Falha ao deletar o dado %lu. Erro: %@",key.unsignedIntegerValue, [NSString stringWithUTF8String:errMsg]);
        }
        
        sqlite3_close(_systemDatabase);
    }
}

- (void)updateDataWithContent:(NSMutableDictionary *)newContent
{
    
}

@end
