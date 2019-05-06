//
//  DatabaseEncoder.m
//  Exercicio MapKit
//
//  Created by Rafagan Abreu on 22/03/14.
//  Copyright (c) 2014 Rafagan Abreu. All rights reserved.
//

#import "DatabaseEncoder.h"

@implementation DatabaseEncoder

static DatabaseEncoder* src;

+ (DatabaseEncoder *)getMe
{
    if(!src) src = [[super allocWithZone:nil]init];
    return src;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        encoders = [NSMutableDictionary new];
    }
    return self;
}

- (void)insertNewEncoderWithName:(NSString*)name andFactory:(id<FactoryMethodDataSource>)factory {
    [encoders setObject:factory forKey:name];
}

- (id)getObjectFromEncoder:(NSString*)name withParameters:(NSDictionary*)parameters
{
    //Pego o método fábrica relacionado ao encoder
    id<FactoryMethodDataSource> encoder = [encoders objectForKey:name];
    
    //Gero um objeto a partir da fábrica e dos parâmetros
    return [encoder generateObjectWithParameters:parameters];
}

- (id)getObjectFromEncoder:(NSString*)name withStringParameters:(NSString*)parameters
{
    //Pego o método fábrica relacionado ao encoder
    id<FactoryMethodDataSource> encoder = [encoders objectForKey:name];
    
    //Gero um objeto a partir da fábrica e dos parâmetros
    return [encoder generateObjectWithStringParameters:parameters];
}

@end
