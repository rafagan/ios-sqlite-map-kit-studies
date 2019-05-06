//
//  IdentificationManager.m
//  Exercicio MapKit
//
//  Created by Rafagan Abreu on 30/03/14.
//  Copyright (c) 2014 Rafagan Abreu. All rights reserved.
//

#import "EntityManager.h"
#import "PropertyListCRUD.h"
#import "Contact.h"

@interface EntityManager ()
{
    NSString* idNumberName, *idDisperseArrayName;
}

@property (nonatomic,strong) NSNumber* idGenerator;
@property (nonatomic,strong) NSMutableDictionary* idConfig;
@property (nonatomic,strong) NSMutableArray* dispersePositions;
@end

static id<DataSourceModel> idPersistenceConfig = nil;

@implementation EntityManager

- (instancetype)initWithName:(NSString *)name andDictionary:(NSMutableDictionary *)dicionary
{
    self = [super init];
    if (self) {
        _entityContainer = dicionary;
        
        if(idPersistenceConfig == nil)
            idPersistenceConfig = [[PropertyListCRUD alloc]initWithName:@"idPersistance"];
        _idConfig = [idPersistenceConfig readAllData];
        
        _persistanceName = name;
        idDisperseArrayName = [NSString stringWithFormat:@"%@_array",name];
        idNumberName = [NSString stringWithFormat:@"%@_number",name];
        
        //Criação das configurações internas
        if(_idConfig == nil) {
            _idGenerator = @(0);
            _dispersePositions = [NSMutableArray new];
            _idConfig = [NSMutableDictionary new];
            
            [_idConfig setObject:_idGenerator forKey:idNumberName];
            [_idConfig setObject:[NSArray arrayWithArray:_dispersePositions] forKey:idDisperseArrayName];
            [idPersistenceConfig createDataWithContent:_idConfig];
        } else {
            _idGenerator = [_idConfig objectForKey:idNumberName];
            _dispersePositions = [_idConfig objectForKey:idDisperseArrayName];
        }
    }
    
    return self;
}

- (void)addEntity:(id<IModel>)entity
{
    if(_dispersePositions.count > 0) {
        entity.ID = [_dispersePositions objectAtIndex:0];
        [_dispersePositions removeObject:entity.ID];
    } else {
        entity.ID = [_idConfig objectForKey:idNumberName];
        [_idConfig setObject:@(entity.ID.unsignedIntegerValue + 1) forKey:idNumberName];
    }

    [_entityContainer setObject:[entity transformToSerializableValue] forKey:entity.ID];
}

- (void)updateEntity:(id<IModel>)entity
{
    [_entityContainer setObject:[entity transformToSerializableValue] forKey:entity.ID];
}

- (void)removeEntity:(id<IModel>)entityID
{
    [_entityContainer removeObjectForKey:entityID];
    [_dispersePositions addObject:entityID];
}

- (id)getEntity:(NSNumber*)entityId usingModel:(id<IModel>)model
{
    if(_entityContainer.count == 0)
        return nil;
    
    id entityData = [_entityContainer objectForKey:entityId];
    while (entityData == nil) {
        entityId = @(entityId.unsignedIntValue + 1);
        entityData = [_entityContainer objectForKey:entityId];
    }
    
    if([entityData isKindOfClass:[NSString class]])
        return [model transformFromSerializedValue:entityData];
    else if([entityData isKindOfClass:[model class]])
        return entityData;
    
    @throw([NSException exceptionWithName:@"Entidade desconhecida" reason:@"Uma entidade desconhecida foi encontrada em -getEntity:usingModel: da classe EntityManager" userInfo:nil]);
    return nil;
}

- (void)saveChanges:(id<DataSourceModel>)persitenceChannel
{
    [_idConfig setObject:[NSArray arrayWithArray:_dispersePositions] forKey:idDisperseArrayName];
    [idPersistenceConfig createDataWithContent:_idConfig];
    
    //Aqui vem a manipulação direta da base de dados
    //Estudar as melhores possibilidades
    [persitenceChannel createDataWithContent:_entityContainer];
}

@end