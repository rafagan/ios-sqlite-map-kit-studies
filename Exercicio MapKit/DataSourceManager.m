//
//  DataSourceManager.m
//  Exercicio MapKit
//
//  Created by Rafagan Abreu on 11/02/14.
//  Copyright (c) 2014 Rafagan Abreu. All rights reserved.
//

#import "DataSourceManager.h"
#import "PropertyListCRUD.h"
#import "DatabaseCRUD.h"
#import "EntityManager.h"

/*
    Objetivos:
        a) Gerenciar o acesso ao dado
        b) Gerenciar a leitura do dado
        c) Abstrair a utilização da base de dados
 */


@interface DataSourceManager ()
@property (nonatomic,readwrite,strong,setter = setContacts:) NSMutableDictionary* contacts;
@property (nonatomic,strong) id<DataSourceModel> persistenceContacts;
@property (nonatomic,strong) EntityManager* contactsManager;
@end

@implementation DataSourceManager

static DataSourceManager* src;

+ (DataSourceManager *)getMe
{
    if(!src) src = [[super allocWithZone:nil]init];
    return src;
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    return src;
}

- (void)setContacts:(NSMutableDictionary *)contacts
{
    if (contacts == nil) {
        _contacts = nil;
        return;
    }
    
    NSMutableDictionary* tmp = [NSMutableDictionary dictionaryWithDictionary:contacts];
    for (id key in tmp) {
        if([key isKindOfClass:[NSString class]]){
            [contacts removeObjectForKey:key];
            [contacts setObject:[tmp objectForKey:key] forKey:@([key unsignedIntValue])];
        }
    }
    
    _contacts = contacts;
}

- (NSString *)getGlobalSeparator
{
    return GLOBAL_SEPARATOR;
}

- (void)populateWithDummyDataIfEmpty
{
    if(_contacts == nil) {
        _contacts = [NSMutableDictionary new];
        _contactsManager = [[EntityManager alloc] initWithName:[NSString stringWithUTF8String:CONTACT_TABLE_NAME] andDictionary:_contacts];
        
        Contact* contact = [Contact new];
        contact.name = @"Meu Nome";
        contact.address = @"Campo Largo";
        contact.phone = @"3292-4444";
        contact.cellphone = @"9214-4999";
        contact.job = @"Meu Trabalho";
        
        [self addContact:contact];
        [self saveContacts];
    } else {
        _contactsManager = [[EntityManager alloc] initWithName:[NSString stringWithUTF8String:CONTACT_TABLE_NAME] andDictionary:_contacts];
    }
}

- (void)loadContacts
{
    _contactChoose = -1;
    
    //Pega os dados da persistência utilizando pList
    self.persistenceContacts = [[DatabaseCRUD alloc]initWithName:@"Contact"];
    
    //Pega um dicionário com todos os dados da persistência
    self.contacts = [_persistenceContacts readAllData];
    
    //Cria dados dummy caso não exista nenhum registro
    [self populateWithDummyDataIfEmpty];
}

- (void)saveContacts
{
    [_contactsManager saveChanges:self.persistenceContacts];
}

- (void)addContact:(Contact*)contact
{
    [_contactsManager addEntity:contact];
}

- (void)editContact:(Contact *)contact
{
    [_contactsManager updateEntity:contact];
}

- (Contact *)getContact:(NSNumber*)index
{
    return [_contactsManager getEntity:index usingModel:[Contact new]];
}

- (void)removeContact:(NSNumber*)index
{
    [_contactsManager removeEntity:index];
}

@end
