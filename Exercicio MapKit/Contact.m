//
//  Contact.m
//  Exercicio MapKit
//
//  Created by Rafagan Abreu on 06/02/14.
//  Copyright (c) 2014 Rafagan Abreu. All rights reserved.
//

#import "Contact.h"
#import "DataSourceManager.h"

@interface Contact ()
{
    
}
@end

@implementation Contact

@synthesize ID;

- (instancetype)init
{
    self = [super init];
    if (self) {

    }
    return self;
}

+ (instancetype)createContactWithString:(NSString *)data usingSeparator:(NSString*)separator
{
    Contact* contact = [Contact new];
    NSArray* values = [data componentsSeparatedByString:separator];
    
    contact.ID = (NSNumber*)values[0];
    contact.name = (NSString*)values[1];
    contact.address = (NSString*)values[2];
    contact.phone = (NSString*)values[3];
    contact.cellphone = (NSString*)values[4];
    contact.job = (NSString*)values[5];
    
    return contact;
}

-(NSString *)getParametersAsStringWithSeparator:(NSString*)separator
{
    NSArray* parameters = @[ID,_name,_address,_phone,_cellphone,_job];
    NSString* result = [NSString stringWithFormat:@"%@",ID];
    
    for (NSUInteger i=1; i<parameters.count; i++) {
        result = [NSString stringWithFormat:@"%@%@%@",result,separator,[parameters objectAtIndex:i]];
    }
    
    return result;
}

- (id)transformToSerializableValue
{
    return [self getParametersAsStringWithSeparator:GLOBAL_SEPARATOR];
}

- (id)transformFromSerializedValue:(id)serializedValue
{
    return [Contact createContactWithString:serializedValue usingSeparator:GLOBAL_SEPARATOR];
}

@end
