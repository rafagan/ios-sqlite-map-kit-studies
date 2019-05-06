//
//  IModel.h
//  Exercicio MapKit
//
//  Created by Rafagan Abreu on 30/03/14.
//  Copyright (c) 2014 Rafagan Abreu. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IModel <NSObject>
@property (nonatomic,strong) NSNumber* ID;

- (id)transformToSerializableValue;
- (id)transformFromSerializedValue:(id)serializedValue;

@end