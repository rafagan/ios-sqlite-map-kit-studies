//
//  ClassReflectionHelper.m
//  Exercicio MapKit
//
//  Created by Rafagan Abreu on 22/03/14.
//  Copyright (c) 2014 Rafagan Abreu. All rights reserved.
//

#import "ClassReflectionHelper.h"
#import <objc/runtime.h>

@interface ClassReflectionHelper ()

@end

@implementation ClassReflectionHelper

+ (NSArray *)getPropertyNamesOfClass:(Class)objectClass
{
    //Copia as informações das propriedades da classe e o número de propriedades
    unsigned int numberOfProperties = 0;
    objc_property_t *properties = class_copyPropertyList([objectClass class], &numberOfProperties);
    NSMutableArray* propertyNames = [NSMutableArray new];
    
    for (NSUInteger i = 0; i < numberOfProperties; i++)
    {
        objc_property_t property = properties[i];
        NSString *name = [[NSString alloc] initWithUTF8String:property_getName(property)];
        [propertyNames addObject:name];
    }
    free(properties);
    
    return propertyNames;
}

+ (NSDictionary*)getPropertyNamesAndTypesOfClass:(Class)objectClass
{
    unsigned int count;
    objc_property_t* props = class_copyPropertyList(objectClass, &count);
    for (int i = 0; i < count; i++) {
        //Pega a lista de todas as propriedades
        objc_property_t property = props[i];
        
        //Pega o nome da propriedade
        const char * name = property_getName(property);
        NSString *propertyName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
        
        //Pega as informações do tipo da propriedade
        const char * type = property_getAttributes(property);
        NSString * typeString = [NSString stringWithUTF8String:type];
        
        //Separa a informação do nome do tipo da propriedade
        NSArray * attributes = [typeString componentsSeparatedByString:@","];
        NSString * typeAttribute = [attributes objectAtIndex:0];
        NSString * propertyType = [typeAttribute substringFromIndex:1];
        const char * rawPropertyType = [propertyType UTF8String];
        
        if (strcmp(rawPropertyType, @encode(float)) == 0) {
            NSLog(@"Float detected");
        } else if (strcmp(rawPropertyType, @encode(int)) == 0) {
            NSLog(@"Int detected");
        } else if (strcmp(rawPropertyType, @encode(id)) == 0) {
            NSLog(@"Id detected");
        } else {
            // According to Apples Documentation you can determine the corresponding encoding values
            NSLog(@"No encode type detected");
        }
        
        if ([typeAttribute hasPrefix:@"T@"] && [typeAttribute length] > 1) {
            NSString * typeClassName = [typeAttribute substringWithRange:NSMakeRange(3, [typeAttribute length]-4)];  //turns @"NSDate" into NSDate
            Class typeClass = NSClassFromString(typeClassName);
            if (typeClass != nil) {
                // Here is the corresponding class even for nil values
            }
        }
        
    }
    free(props);
    
    return nil;
}

// Pegar o valor das propriedades também

+ (void)typeEncodingTest
{
    //http://nshipster.com/type-encodings/
    
    NSLog(@"int        : %s", @encode(int));
    NSLog(@"float      : %s", @encode(float));
    NSLog(@"float *    : %s", @encode(float*));
    NSLog(@"char       : %s", @encode(char));
    NSLog(@"char *     : %s", @encode(char *));
    NSLog(@"BOOL       : %s", @encode(BOOL));
    NSLog(@"void       : %s", @encode(void));
    NSLog(@"void *     : %s", @encode(void *));
    
    NSLog(@"NSObject * : %s", @encode(NSObject *));
    NSLog(@"NSObject   : %s", @encode(NSObject));
    NSLog(@"[NSObject] : %s", @encode(typeof([NSObject class])));
    NSLog(@"NSError ** : %s", @encode(typeof(NSError **)));
    
    int intArray[5] = {1, 2, 3, 4, 5};
    NSLog(@"int[]      : %s", @encode(typeof(intArray)));
    
    float floatArray[3] = {0.1f, 0.2f, 0.3f};
    NSLog(@"float[]    : %s", @encode(typeof(floatArray)));
    
    typedef struct _struct {
        short a;
        long long b;
        unsigned long long c;
    } Struct;
    NSLog(@"struct     : %s", @encode(typeof(Struct)));
}

@end
