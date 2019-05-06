//
//  DataSourceManager.h
//  Exercicio MapKit
//
//  Created by Rafagan Abreu on 11/02/14.
//  Copyright (c) 2014 Rafagan Abreu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Contact.h"

#define DATA_SRC [DataSourceManager getMe]
#define GLOBAL_SEPARATOR @"="

@interface DataSourceManager : NSObject

@property (nonatomic,readonly,strong) NSMutableDictionary* contacts;
@property (nonatomic) NSInteger contactChoose;

+ (DataSourceManager*)getMe;

- (NSString*)getGlobalSeparator;

- (void)loadContacts;
- (void)saveContacts;

- (void)addContact:(Contact*)contact;
- (void)editContact:(Contact*)contact;
- (void)removeContact:(NSNumber*)index;
- (Contact*)getContact:(NSNumber*)index;


@end
