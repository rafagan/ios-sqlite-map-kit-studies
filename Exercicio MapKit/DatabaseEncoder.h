//
//  DatabaseEncoder.h
//  Exercicio MapKit
//
//  Created by Rafagan Abreu on 22/03/14.
//  Copyright (c) 2014 Rafagan Abreu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FactoryMethodDataSource.h"

#define ENCODER [DatabaseEncoder getMe]

// CODIFICAR = parametros -> objeto

@interface DatabaseEncoder : NSObject
{
@private NSMutableDictionary* encoders;
}

+ (DatabaseEncoder*)getMe;

- (void)insertNewEncoderWithName:(NSString*)name andFactory:(id<FactoryMethodDataSource>)factory;
- (id)getObjectFromEncoder:(NSString*)name withParameters:(NSDictionary*)parameters;

@end
