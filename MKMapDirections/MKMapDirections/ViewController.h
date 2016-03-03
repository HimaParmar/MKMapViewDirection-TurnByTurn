#import <UIKit/UIKit.h>
@import MapKit;


@interface ViewController : UIViewController
@property (strong, nonatomic) IBOutlet MKMapView *routeMap;
@property (strong, nonatomic) IBOutlet UITextView *txtMapRoutes;

@end

