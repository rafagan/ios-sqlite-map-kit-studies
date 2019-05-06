//
//  ViewController.m
//  Exercicio MapKit
//
//  Created by Rafagan Abreu on 08/02/14.
//  Copyright (c) 2014 Rafagan Abreu. All rights reserved.
//

/*
    b) Ao clicar na célula, mostrar no mapa
    d) Adição e remoção de elementos da tabela
    e) Edição dos dados da TableView - Criação com UINavigation
    f) Exibição dos dados do contato na TableView
 */


#import "ContactViewController.h"
#import "DataSourceManager.h"
#import "ContactCell.h"
#import "MainViewController.h"

@interface ContactViewController ()
@end

@implementation ContactViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return DATA_SRC.contacts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CustomCell";
    ContactCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    Contact* c = [DATA_SRC getContact:@(indexPath.row)];

    cell.name.text = c.name;
    cell.address.text = c.address;
    cell.traceRouteButton.tag = indexPath.row;
    
    return cell;
}

// Lógica dos botões de edição da TableView
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [DATA_SRC removeContact:@(indexPath.row)];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [DATA_SRC saveContacts];
    }
}

- (IBAction)onTouchRouteButton:(UIButton*)sender {
    DATA_SRC.contactChoose = sender.tag;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
    [vc setModalPresentationStyle:UIModalPresentationFullScreen];
    [vc setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - Navigation

// Esse método é chamado sempre que o Controller será modificado após clicar em uma célula
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"Contact Edit"] || [segue.identifier isEqualToString:@"Trace Route"]) {
        DATA_SRC.contactChoose = [self.tableView indexPathForSelectedRow].row;
    } else if([segue.identifier isEqualToString:@"Contact Add"]) {
        DATA_SRC.contactChoose = -1;
    }
}

@end
