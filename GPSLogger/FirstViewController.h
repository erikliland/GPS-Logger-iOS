#import <UIKit/UIKit.h>

@interface FirstViewController : UIViewController{
	// https://github.com/esripdx/GPS-Logger-iOS
	// http://mobisoftinfotech.com/resources/blog/iphone/ios-tutorial-custom-speedometer-control/
	UIImageView *needleImageView;
	float speedometerCurrentValue;
	float prevAngleFactor;
	float angle;
	NSTimer *speedometer_Timer;
	UILabel *speedometerReading;
	NSString *maxVal;
}

@property(nonatomic, retain) UIImageView *needleImageView;
@property(nonatomic,assign) float speedometerCurrentValue;
@property(nonatomic,assign) float prevAngleFactor;
@property(nonatomic,assign) float angle;
@property(nonatomic, retain) NSTimer *speedometer_Timer;
@property(nonatomic, retain) UILabel *speedometerReading;
@property(nonatomic,retain) NSString *maxVal;
@property(strong, nonatomic) IBOutlet UILabel *locationSpeedLabel;

//@property (strong, nonatomic, readonly) CLLocationManager *locationManager;

-(void) addMeterViewContents;
-(void) rotateIt:(float)angl;
-(void) rotateNeedle;
-(void) calculateDeviationAngle;

@end

