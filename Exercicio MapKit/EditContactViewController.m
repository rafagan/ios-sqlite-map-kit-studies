//
//  EditContactViewController.m
//  Exercicio MapKit
//
//  Created by Rafagan Abreu on 15/02/14.
//  Copyright (c) 2014 Rafagan Abreu. All rights reserved.
//

#import "EditContactViewController.h"
#import "DataSourceManager.h"
#import "Contact.h"

@interface EditContactViewController ()
{
    Contact* current;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
@property (weak, nonatomic) IBOutlet UITextField *nameTextEdit;
@property (weak, nonatomic) IBOutlet UITextField *addressTextEdit;
@property (weak, nonatomic) IBOutlet UITextField *workTextEdit;
@property (weak, nonatomic) IBOutlet UITextField *tellTextEdit;
@property (weak, nonatomic) IBOutlet UITextField *cellTextEdit;
@property (weak, nonatomic) IBOutlet UIImageView *photo;
@end

@implementation EditContactViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	[_scroll setScrollEnabled:YES];
    [_scroll setContentSize:CGSizeMake(200, 1020)];
    
    if(DATA_SRC.contactChoose >= 0) {
        current = [DATA_SRC getContact:@(DATA_SRC.contactChoose)];
        
        _nameTextEdit.text = current.name;
        _addressTextEdit.text = current.address;
        _workTextEdit.text = current.job;
        _tellTextEdit.text = current.phone;
        _cellTextEdit.text = current.cellphone;
    } else {
        current = [Contact new];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)onTouchSave:(id)sender {
    current.name = _nameTextEdit.text;
    current.address = _addressTextEdit.text;
    current.job = _workTextEdit.text;
    current.phone = _tellTextEdit.text;
    current.cellphone = _cellTextEdit.text;
    
    //Editar contato
    if(DATA_SRC.contactChoose >= 0) {
        [DATA_SRC editContact:current];
    } else { //Novo contato
        [DATA_SRC addContact:current];
    }
    
    DATA_SRC.contactChoose = -1;
    [DATA_SRC saveContacts];
}
@end
