#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

static NSString *const GLNewDataNotification = @"GLNewDataNotification";

@interface GLManager : NSObject <CLLocationManagerDelegate>

+ (GLManager *)sharedManager;

@property (strong, nonatomic, readonly) CLLocationManager *locationManager;
@property (strong, nonatomic, readonly) CLLocation *lastLocation;

- (void)startAllUpdates;
- (void)stopAllUpdates;
@end
