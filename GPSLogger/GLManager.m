#import "GLManager.h"

@interface GLManager()

@property (strong, nonatomic) CLLocationManager *locationManager;
@property BOOL trackingEnabled;
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
    [self enableTracking];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:GLTrackingStateDefaultsName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)stopAllUpdates {
    [self disableTracking];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:GLTrackingStateDefaultsName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - GLManager control (private)
- (void)enableTracking {
    self.trackingEnabled = YES;
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];
    //[self.locationManager startUpdatingHeading];
    //[self.locationManager startMonitoringVisits];
}
- (void)disableTracking {
    self.trackingEnabled = NO;
	[self.locationManager stopUpdatingLocation];
    //[self.locationManager stopMonitoringVisits];
    //[self.locationManager stopUpdatingHeading];
    //[self.locationManager stopMonitoringSignificantLocationChanges];
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
    [[NSNotificationCenter defaultCenter] postNotificationName:GLNewDataNotification object:self];
    self.lastLocation = (CLLocation *)locations[0];
    
    NSLog(@"Received %d locations", (int)locations.count);
}
#pragma mark - AppDelegate Methods
- (void)applicationDidEnterBackground {
    //[self logAction:@"did_enter_background"];
}
- (void)applicationWillTerminate {
    //[self logAction:@"will_terminate"];
}
- (void)applicationWillResignActive {
    //[self logAction:@"will_resign_active"];
}
@end