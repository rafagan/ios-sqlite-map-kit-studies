//
//  DatabaseDecoder.h
//  Exercicio MapKit
//
//  Created by Rafagan Abreu on 15/03/14.
//  Copyright (c) 2014 Rafagan Abreu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FactoryMethodDataSource.h"

// DECODIFICAR = objeto -> parametros

#define DECODER [DatabaseDecoder getMe]

@interface DatabaseDecoder : NSObject
{
@private NSMutableDictionary* decoders;
}

+ (DatabaseDecoder*)getMe;

- (void)insertNewDecoderWithName:(NSString*)name andFactory:(id<FactoryMethodDataSource>)factory;

- (NSDictionary*)getParametersFromDecoder:(NSString*)name withObject:(id)object;
- (NSString*)getStringParametersFromDecoder:(NSString*)name withObject:(id)object;

@end
