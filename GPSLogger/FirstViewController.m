#import "FirstViewController.h"
#import "GLManager.h"


static NSString *const GLTripTrackingEnabledDefaultsName = @"GLTripTrackingEnabledDefaults";

@interface FirstViewController ()

@property (strong, nonatomic) NSTimer *viewRefreshTimer;

@end

@implementation FirstViewController

@synthesize needleImageView;
@synthesize speedometerCurrentValue;
@synthesize prevAngleFactor;
@synthesize angle;
@synthesize speedometer_Timer;
@synthesize speedometerReading;
@synthesize maxVal;

NSArray *intervalMap;
NSArray *intervalMapStrings;

- (void)viewDidLoad {
    [super viewDidLoad];
    intervalMap = @[@1, @5, @10, @15, @30, @60, @120, @300, @600, @1800, @-1];
    intervalMapStrings = @[@"1s", @"5s", @"10s", @"15s", @"30s", @"1m", @"2m", @"5m", @"10m", @"30m", @"off"];
	
	[[GLManager sharedManager] startAllUpdates];
	
	[self addMeterViewContents];
	
	[super viewDidLoad];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)viewWillAppear:(BOOL)animated {

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(newDataReceived)
                                                 name:GLNewDataNotification
                                               object:nil];

	/* TA VARE PÅ
    self.viewRefreshTimer = [NSTimer scheduledTimerWithTimeInterval:0.2
                                                             target:self
                                                           selector:@selector(refreshView)
                                                           userInfo:nil
														repeats:YES];
*/
}

- (void)viewDidDisappear:(BOOL)animated {
    [self.viewRefreshTimer invalidate];
	NSLog(@"GPS skal være stengt ned");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillUnload {
    [self.viewRefreshTimer invalidate];
	NSLog(@"Stenger ned GPS");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dealloc {
    NSLog(@"view is deallocd");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Tracking Interface

- (void)newDataReceived {
	[self refreshView];
}

- (void)refreshView {
    CLLocation *location = [GLManager sharedManager].lastLocation;
    //self.locationLabel.text = [NSString stringWithFormat:@"%.5f\n%.5f", location.coordinate.latitude, location.coordinate.longitude];
    //self.locationAltitudeLabel.text = [NSString stringWithFormat:@"+/-%dm %dm", (int)round(location.horizontalAccuracy), (int)round(location.altitude)];
    int speed = (int)(round(location.speed*2.23694));
    if(speed < 0) speed = 0;
    self.locationSpeedLabel.text = [NSString stringWithFormat:@"%d", speed];
	self.speedometerReading.text = [NSString stringWithFormat:@"%d", speed];
	self.speedometerCurrentValue = (float)speed;
	[self calculateDeviationAngle];
	[self rotateNeedle];
}

#pragma mark -
#pragma mark Speedometer Graphics

-(void) addMeterViewContents{
	//UIImageView *backgroundImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 460)];
	//backgroundImageView.image = [UIImage imageNamed:@"main_bg.png"];
	//[self.view addSubview:backgroundImageView];
	
	UIImageView *meterImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 40, 286, 315)];
	meterImageView.image = [UIImage imageNamed:@"meter.png"];
	[self.view addSubview:meterImageView];
	
	//Needle
	UIImageView *imgNeedle = [[UIImageView alloc]initWithFrame:CGRectMake(143, 155, 22, 84)];
	imgNeedle.image = [UIImage imageNamed:@"arrow.png"];
	self.needleImageView = imgNeedle;
	[self.view addSubview: imgNeedle];
	
	//Needle dot
	UIImageView *meterImageViewDot = [[UIImageView alloc]initWithFrame:CGRectMake(131.5, 175, 45, 44)];
	meterImageViewDot.image = [UIImage imageNamed:@"center_wheel.png"];
	[self.view addSubview:meterImageViewDot];

	//Speedometer Reading
	UILabel *tempReading = [[UILabel alloc] initWithFrame:CGRectMake(125, 250, 60, 30)];
	self.speedometerReading = tempReading;
	self.speedometerReading.textAlignment = NSTextAlignmentCenter;
	self.speedometerReading.backgroundColor = [UIColor blackColor];
	self.speedometerReading.text = @"0";
	self.speedometerReading.textColor = [UIColor colorWithRed:144/255.f green:146/255.f blue:38/255.f alpha:1.0];
	[self.view addSubview:self.speedometerReading];
	
	//Set max value
	self.maxVal = @"100";
	
	//Set needle pointer initially at zero
	[self rotateIt:-118.4];
	
	//Set previous angle
	self.prevAngleFactor = -118.4;
	
	//Set speedometer value
}

-(void) calculateDeviationAngle{
	if ([self.maxVal floatValue]>0) {
		self.angle = ((self.speedometerCurrentValue * 237.4)/[self.maxVal floatValue])-118.4;
	}else{
		self.angle = 0;
	}
	
	if (self.angle <= -118.4) {
		self.angle = -118.4;
	}
	if (self.angle>=119) {
		self.angle = 119;
	}
}

-(void) rotateNeedle{
	if (fabsf(self.angle - self.prevAngleFactor) > 180) {
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.5f];
		[self rotateIt:self.angle/3];
		[UIView commitAnimations];
		
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.5f];
		[self rotateIt:(self.angle*2)/3];
		[UIView commitAnimations];
	}
	
	self.prevAngleFactor = self.angle;
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.5f];
	[self.needleImageView setTransform:CGAffineTransformMakeRotation((M_PI/180)*self.angle)];
	[UIView commitAnimations];
}

-(void) rotateIt:(float)angl{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.01f];
	[self.needleImageView setTransform:CGAffineTransformMakeRotation((M_PI/180)*angl)];
	[UIView commitAnimations];
}

@end
