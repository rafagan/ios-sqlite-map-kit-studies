//
//  MapViewController.m
//  Exercicio MapKit
//
//  Created by Rafagan Abreu on 06/02/14.
//  Copyright (c) 2014 Rafagan Abreu. All rights reserved.
//

#import "MapViewController.h"
#import "Contact.h"
#import "DataSourceManager.h"
#import "ClassReflectionHelper.h"

@interface MapViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation MapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;
    
    if(DATA_SRC.contactChoose >= 0)
        [self makePathUsingContact:[DATA_SRC getContact:@(DATA_SRC.contactChoose)]];
}

- (IBAction)onTouchZoom:(id)sender {
    MKUserLocation *userLocation = self.mapView.userLocation;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.location.coordinate, 2000, 2000);
    [self.mapView setRegion:region animated:YES];
}

- (IBAction)onTouchChangeMapView:(id)sender {
    if (self.mapView.mapType == MKMapTypeStandard)
        self.mapView.mapType = MKMapTypeHybrid;
    else
        self.mapView.mapType = MKMapTypeStandard;
}

- (void)makePathUsingContact:(Contact*)contact
{
    [self makePathUsingAddress:contact.address];
}

- (void)makePathUsingAddress:(NSString*)address
{
    [self.mapView removeAnnotations:[self.mapView annotations]];
    
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = address;
    request.region = self.mapView.region;
    
    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
    
    //Uma expressão em bloco é utilizada para que a thread não seja congelada.
    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        if (response.mapItems.count == 0) {
            [self alertUnableToFindAddress];
        } else {
            for (MKMapItem *item in response.mapItems) {
                MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
                annotation.coordinate = item.placemark.coordinate;
                annotation.title = item.name;
                annotation.subtitle = [NSString stringWithFormat:@"%@, %@", item.placemark.thoroughfare, item.placemark.subThoroughfare];
                [self.mapView addAnnotation:annotation];
                
                [self findRouteWithDestination:item];
            }
        }
    }];
}

- (void)alertServerBusy
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Erro ao calcular a rota"
                                                    message:@"Verifique se a rota escolhida é válida e tente novamente"
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)alertUnableToFindAddress
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Não foi possivel encontrar o endereço especificado"
                                                    message:@"Verifique as informações de seu contato ou se seu dispositivo encontra-se conectado à internet"
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)findRouteWithDestination:(MKMapItem*)destination
{
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    
    request.source = [MKMapItem mapItemForCurrentLocation];
    
    request.destination = destination;
    request.requestsAlternateRoutes = NO;
    MKDirections *directions =
    [[MKDirections alloc] initWithRequest:request];
    
    [directions calculateDirectionsWithCompletionHandler:
     ^(MKDirectionsResponse *response, NSError *error) {
         if (error) {
             [self alertServerBusy];
         } else {
             [self showRoute:response];
         }
     }];
}

-(void)showRoute:(MKDirectionsResponse *)response
{
    for (MKRoute *route in response.routes) {
        [self.mapView
         addOverlay:route.polyline level:MKOverlayLevelAboveRoads];
    }
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id < MKOverlay >)overlay
{
    MKPolylineRenderer *renderer =
    [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    renderer.strokeColor = [UIColor blueColor];
    renderer.lineWidth = 5.0;
    
    return renderer;
}
@end
