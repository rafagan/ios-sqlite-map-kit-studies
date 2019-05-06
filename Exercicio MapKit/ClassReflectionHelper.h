//
//  ClassReflectionHelper.h
//  Exercicio MapKit
//
//  Created by Rafagan Abreu on 22/03/14.
//  Copyright (c) 2014 Rafagan Abreu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClassReflectionHelper : NSObject

+ (NSArray*)getPropertyNamesOfClass:(Class)objectClass;
+ (NSDictionary*)getPropertyNamesAndTypesOfClass:(Class)objectClass;

@end
