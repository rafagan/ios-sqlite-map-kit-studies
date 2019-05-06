//
//  IdentificationManager.h
//  Exercicio MapKit
//
//  Created by Rafagan Abreu on 30/03/14.
//  Copyright (c) 2014 Rafagan Abreu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataSourceModel.h"
#import "IModel.h"

@interface EntityManager : NSObject
@property (nonatomic,readonly,strong) NSMutableDictionary* entityContainer;
@property (nonatomic,strong) NSString* persistanceName;

//Designated Initializer
- (instancetype)initWithName:(NSString*)name andDictionary:(NSMutableDictionary*)entityContainer;

- (void)addEntity:(id<IModel>)entity;
- (void)updateEntity:(id<IModel>)entity;
- (void)removeEntity:(NSNumber*)entityId;
- (id)getEntity:(NSNumber*)entityId usingModel:(id<IModel>)model;

- (void)saveChanges:(id<DataSourceModel>)persitenceChannel;

@end
