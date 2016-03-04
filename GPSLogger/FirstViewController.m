#import "FirstViewController.h"
#import "GLManager.h"

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)
#define totalAngle 237.4

@interface FirstViewController ()

@property (strong, nonatomic) NSTimer *viewRefreshTimer;

@property(nonatomic,retain) UIImageView *needleImageView;
@property(nonatomic,assign) float speedometerCurrentValue;
@property(nonatomic,assign) float angle;
@property(nonatomic,retain) NSTimer *speedometer_Timer;
@property(nonatomic,retain) UILabel *speedometerReading;
@property(nonatomic,retain) NSString *maxVal;
@end

@implementation FirstViewController

- (void)viewDidLoad {
	[[GLManager sharedManager] startAllUpdates];
	[self addMeterViewContents];
	[super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newDataReceived) name:GLNewDataNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    //[self.viewRefreshTimer invalidate];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillUnload {
    //[self.viewRefreshTimer invalidate];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - GPS interface

- (void)newDataReceived {
	CLLocation *location = [GLManager sharedManager].lastLocation;
	float speed = round(location.speed*3.6);
	if(speed < 0) speed = 0;
	self.locationSpeedLabel.text = [NSString stringWithFormat:@"%d", (int)speed];
	self.speedometerReading.text = [NSString stringWithFormat:@"%d", (int)speed];
	self.speedometerCurrentValue = speed;
	[self updateSpeedometerNeedle];
}

#pragma mark -
#pragma mark Speedometer Graphics

-(void) addMeterViewContents{
	UIImageView *meterImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 40, 286, 315)];
	meterImageView.image = [UIImage imageNamed:@"meter.png"];
	[self.view addSubview:meterImageView];
	
	//Needle dot
	UIImageView *meterImageViewDot = [[UIImageView alloc]initWithFrame:CGRectMake(131.5, 175, 45, 44)];
	meterImageViewDot.image = [UIImage imageNamed:@"center_wheel.png"];
	[self.view addSubview:meterImageViewDot];

	
	//Needle
	UIImageView *imgNeedle = [[UIImageView alloc]initWithFrame:CGRectMake(143, 155, 22, 84)];
	imgNeedle.layer.anchorPoint = CGPointMake(0.5, 1);
	imgNeedle.image = [UIImage imageNamed:@"arrow.png"];
	imgNeedle.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(-118.5));
	self.needleImageView = imgNeedle;
	[self.view addSubview: imgNeedle];
	
	
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

}

-(void) updateSpeedometerNeedle{
	if ([self.maxVal floatValue]>0) {
		self.angle = ((self.speedometerCurrentValue * totalAngle)/[self.maxVal floatValue])-(totalAngle/2);
	}else{
		self.angle = 0;
	}
	
	if (self.angle < -(totalAngle/2)) {
		self.angle = -totalAngle/2;
	}
	if (self.angle > (totalAngle/2)) {
		self.angle = totalAngle/2;
	}
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.5f];
	[self.needleImageView setTransform:CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(self.angle))];
	[UIView commitAnimations];
}

@end
