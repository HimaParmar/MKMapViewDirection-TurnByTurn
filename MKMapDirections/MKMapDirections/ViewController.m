#import "ViewController.h"

@interface ViewController ()<MKMapViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _routeMap.delegate = self;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)btnGetDirectionsClicked:(id)sender {
    
    // Set Source and Destination
    
    MKPlacemark *placemarkSrc = [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake(42.876987, -95.710991) addressDictionary:nil];
    MKPlacemark *placemarkDest = [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake(42.490161, -95.184772) addressDictionary:nil];
    
    MKMapItem *mapItemSrc = [[MKMapItem alloc] initWithPlacemark:placemarkSrc];
    MKMapItem *mapItemDest = [[MKMapItem alloc] initWithPlacemark:placemarkDest];
    
    // Drop Pins for Source and Destination
    
    MKPointAnnotation *annotationSrc = [[MKPointAnnotation alloc] init];
    [annotationSrc setCoordinate:placemarkSrc.coordinate];
    [annotationSrc setTitle:@"Source"]; //You can set the subtitle too
    [_routeMap addAnnotation:annotationSrc];
    
    MKPointAnnotation *annotationDest = [[MKPointAnnotation alloc] init];
    [annotationDest setCoordinate:placemarkDest.coordinate];
    [annotationDest setTitle:@"Destination"]; //You can set the subtitle too
    [_routeMap addAnnotation:annotationDest];
    
    // Set Region
    
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.8;
    span.longitudeDelta = 0.8;
    CLLocationCoordinate2D location;
    location.latitude = placemarkSrc.coordinate.latitude;
    location.longitude = placemarkSrc.coordinate.longitude;
    region.span = span;
    region.center = location;
    [_routeMap setRegion:region animated:YES];
    
    
    // Make request for directions
    
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    
    request.source = mapItemSrc;
    request.destination = mapItemDest;
    request.requestsAlternateRoutes = NO;
    
    MKDirections *directions =
    [[MKDirections alloc] initWithRequest:request];
    
    [directions calculateDirectionsWithCompletionHandler:
     ^(MKDirectionsResponse *response, NSError *error) {
         if (error) {
             // Handle Error
         } else {
             NSLog(@"Response : %@",response);
             [self showRoute:response];
         }
     }];
}

- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>) annotation
{
    MKPinAnnotationView *annView=[[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"pin"];
    annView.pinTintColor = [UIColor redColor];
    return annView;
}

-(void)showRoute:(MKDirectionsResponse *)response
{
    for (MKRoute *route in response.routes)
    {
        [_routeMap
         addOverlay:route.polyline level:MKOverlayLevelAboveRoads];
        
        for (MKRouteStep *step in route.steps)
        {
            NSLog(@"%@", step.instructions);
            _txtMapRoutes.text = [NSString stringWithFormat:@"%@ \n %@",_txtMapRoutes.text,step.instructions];
        }
    }
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id < MKOverlay >)overlay
{
    MKPolylineRenderer *renderer =
    [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    renderer.strokeColor = [UIColor colorWithRed:80/255.0 green:141/255.0 blue:172/255.0 alpha:1.0];
    renderer.lineWidth = 5.0;
    return renderer;
}

@end
