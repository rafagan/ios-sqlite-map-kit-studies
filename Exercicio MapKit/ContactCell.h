//
//  ContactCell.h
//  Exercicio MapKit
//
//  Created by Rafagan Abreu on 15/02/14.
//  Copyright (c) 2014 Rafagan Abreu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UIButton *traceRouteButton;

@end
