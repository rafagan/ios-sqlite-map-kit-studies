//
//  DatabaseDecoder.m
//  Exercicio MapKit
//
//  Created by Rafagan Abreu on 15/03/14.
//  Copyright (c) 2014 Rafagan Abreu. All rights reserved.
//

#import "DatabaseDecoder.h"

@implementation DatabaseDecoder

static DatabaseDecoder* src;

+ (DatabaseDecoder *)getMe
{
    if(!src) src = [[super allocWithZone:nil]init];
    return src;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        decoders = [NSMutableDictionary new];
    }
    return self;
}

- (void)insertNewDecoderWithName:(NSString *)name andFactory:(id<FactoryMethodDataSource>)factory
{
    [decoders setObject:factory forKey:name];
}

- (NSDictionary*)getParametersFromDecoder:(NSString*)name withObject:(id)object
{
    //Pego o método fábrica relacionado ao decoder
    id<FactoryMethodDataSource> decoder = [decoders objectForKey:name];
    
    //Gero um objeto a partir da fábrica e dos parâmetros
    return [decoder generateParametersWithObject:object];
}

- (NSString *)getStringParametersFromDecoder:(NSString *)name withObject:(id)object
{
    //Pego o método fábrica relacionado ao decoder
    id<FactoryMethodDataSource> decoder = [decoders objectForKey:name];
    
    //Gero um objeto a partir da fábrica e dos parâmetros
    return [decoder generateStringParametersWithObject:object];
}

@end
