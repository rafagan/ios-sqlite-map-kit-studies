//
//  ContactFactory.m
//  Exercicio MapKit
//
//  Created by Rafagan Abreu on 17/03/14.
//  Copyright (c) 2014 Rafagan Abreu. All rights reserved.
//

#import "ContactFactory.h"
#import "Contact.h"
#import <objc/runtime.h>
#import "ClassReflectionHelper.h"
#import "DataSourceManager.h"

@implementation ContactFactory

// Pega a classe Contact e gera um objeto com os parâmetros do dicionario
// CODIFICAR = parametros -> objeto
- (id)generateObjectWithParameters:(NSDictionary *)parameters
{
    Contact* instance = [Contact new];
    
    [parameters enumerateKeysAndObjectsUsingBlock: ^(id key, id obj, BOOL *stop) {
        [instance setValue:obj forKey:key];
    }];
    
    return instance;
}

// Decodificar = objeto -> parametros
- (NSDictionary *)generateParametersWithObject:(id)object
{
    Contact* instance = object;
    NSMutableDictionary* result = [NSMutableDictionary new];
    NSArray* names = [ClassReflectionHelper getPropertyNamesOfClass:[Contact class]];
    
    for (NSUInteger i = 0; i < names.count; i++)
    {
        id value = [instance valueForKey:names[i]];
        [result setObject:value forKey:names[i]];
    }
    
    return result;
}

- (id)generateObjectWithStringParameters:(NSString *)parameters
{
    Contact* instance = [Contact createContactWithString:parameters usingSeparator:GLOBAL_SEPARATOR];
    
    return instance;
}

- (NSString *)generateStringParametersWithObject:(id)object
{
    Contact* instance = object;
    
    return [instance getParametersAsStringWithSeparator:GLOBAL_SEPARATOR];
}


@end
