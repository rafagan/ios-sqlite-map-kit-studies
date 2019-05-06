//
//  FactoryMethodDataSource.h
//  Exercicio MapKit
//
//  Created by Rafagan Abreu on 15/03/14.
//  Copyright (c) 2014 Rafagan Abreu. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FactoryMethodDataSource <NSObject>

- (id)generateObjectWithParameters:(NSDictionary*)parameters;
- (id)generateObjectWithStringParameters:(NSString*)parameters;
- (NSDictionary*)generateParametersWithObject:(id)object;
- (NSString*)generateStringParametersWithObject:(id)object;

@end
