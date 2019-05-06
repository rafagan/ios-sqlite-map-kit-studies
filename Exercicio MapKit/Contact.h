//
//  Contact.h
//  Exercicio MapKit
//
//  Created by Rafagan Abreu on 06/02/14.
//  Copyright (c) 2014 Rafagan Abreu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ContactFactory.h"
#import "IModel.h"

static const char* CONTACT_TABLE_NAME = "Contact";

@interface Contact : NSObject<IModel>

//Reescrevendo propriedade da classe pai para fins de organização do reflection
@property (nonatomic,strong) NSNumber* ID;

@property (nonatomic,strong) NSString* name;
@property (nonatomic,strong) NSString* address;
@property (nonatomic,strong) NSString* phone;
@property (nonatomic,strong) NSString* cellphone;
@property (nonatomic,strong) NSString* job;
//@property (nonatomic,strong) NSData* image;


+ (instancetype)createContactWithString:(NSString *)data usingSeparator:(NSString*)separator;
-(NSString *)getParametersAsStringWithSeparator:(NSString*)separator;

@end
