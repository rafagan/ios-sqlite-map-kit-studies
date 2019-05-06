//
//  PropertyListCRUD.m
//  Exercicio pList
//
//  Created by Rafagan Abreu on 23/01/14.
//  Copyright (c) 2014 Rafagan Abreu. All rights reserved.
//

#import "PropertyListCRUD.h"

@interface PropertyListCRUD ()
@end

@implementation PropertyListCRUD

- (instancetype)initWithName:(NSString *)name
{
    self = [super init];
    if (self) {
        _pListName = name;
        NSString* fileType = @"plist";
        
        //Pega todos os caminhos de diretório para armazenamento de arquivos disponíveis
        NSArray *directoryPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        
        //Pega o primeiro diretório válido
        _validDirectoryPath = directoryPaths[0];
        
        //Diretório válido para o pList
        _validDirectoryPath = [_validDirectoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",_pListName,fileType]];
        
        //Se não existir um caminho válido para o diretório, cria a partir do MainBundle (espaço de memória temporário do app)
        if(![[NSFileManager defaultManager] fileExistsAtPath:_validDirectoryPath]) {
            id tmp = [[NSBundle mainBundle] pathForResource:_pListName ofType:fileType];
            if(tmp != nil) _validDirectoryPath = tmp;
        }
    }
    return self;
}

- (NSMutableDictionary *)readAllData
{
    //Também é possível capturar o NSData por meio do NSFileManager e depois converter o raw em Dictionary
    NSMutableDictionary* data = [NSMutableDictionary dictionaryWithContentsOfFile:_validDirectoryPath];
    return data;
}

- (void)createDataWithContent:(NSMutableDictionary *)content
{
    //Também é possível criar um NSData do dicionário e convertê-lo em Property List XML 1.0
    NSMutableDictionary *data = [NSMutableDictionary dictionaryWithDictionary:content];
    
    //pLists só suportam salvamento de dicionários com keys do tipo NSString
    for (id key in content) {
        if(![key isKindOfClass:[NSString class]]){
            [data removeObjectForKey:key];
            [data setObject:[content objectForKey:key] forKey:[NSString stringWithFormat:@"%@",key]];
        }
    }
    
    [data writeToFile:_validDirectoryPath atomically:YES];
}

- (void)updateDataWithContent:(NSMutableDictionary *)newContent
{
    NSMutableDictionary* data = [self readAllData];
    if(newContent != nil) [data addEntriesFromDictionary:newContent];
    [self createDataWithContent:data];
}

- (void)deleteDataWithKeys:(NSArray*)keys
{
    if(keys == nil) {
        [self clearData];
        return;
    }
    
    NSMutableArray* validKeys = [NSMutableArray arrayWithArray:keys];
    
    //pLists só suportam salvamento de dicionários com keys do tipo NSString
    for (id key in keys) {
        if(![key isKindOfClass:[NSString class]]){
            [validKeys removeObject:key];
            [validKeys addObject:[NSString stringWithFormat:@"%@",key]];
        }
    }
    
    NSMutableDictionary* data = [self readAllData];
    [data removeObjectsForKeys:keys];
    [self createDataWithContent:data];
}

- (void)clearData
{
    [self createDataWithContent:[NSMutableDictionary new]];
}

@end
