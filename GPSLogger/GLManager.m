#import "GLManager.h"

@interface GLManager()

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *lastLocation;

@end

@implementation GLManager

+ (GLManager *)sharedManager {
    static GLManager *_instance = nil;
	
    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc] init];
		}
    }
    return _instance;
}

#pragma mark - GLManager control (public)
- (void)startAllUpdates {
	[self.locationManager requestWhenInUseAuthorization];
	[self.locationManager startUpdatingLocation];
}
- (void)stopAllUpdates {
	[self.locationManager stopUpdatingLocation];
}

#pragma mark - Properties
- (CLLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
		_locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.distanceFilter = 1;
        _locationManager.allowsBackgroundLocationUpdates = NO;
		_locationManager.pausesLocationUpdatesAutomatically = YES;
		_locationManager.activityType = CLActivityTypeAutomotiveNavigation;
    }
    return _locationManager;
}

#pragma mark - CLLocationManager Delegate Methods
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
	self.lastLocation = (CLLocation *)locations[0];
	[[NSNotificationCenter defaultCenter] postNotificationName:GLNewDataNotification object:self];
}
 
@end