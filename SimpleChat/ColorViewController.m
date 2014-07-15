//
//  ColorViewController.m
//  SimpleChat
//
//  Created by Kim Seokjun on 5/11/14.
//  Copyright (c) 2014 redbear. All rights reserved.
//

#import "ColorViewController.h"

@interface ColorViewController ()
@property (strong, nonatomic) IBOutlet UILabel *titleRED;
@property (strong, nonatomic) IBOutlet UISlider *sliderRED;
@property (strong, nonatomic) IBOutlet UILabel *labelRED;

@property (strong, nonatomic) IBOutlet UILabel *titleGREEN;
@property (strong, nonatomic) IBOutlet UISlider *sliderGREEN;
@property (strong, nonatomic) IBOutlet UILabel *labelGREEN;

@property (strong, nonatomic) IBOutlet UILabel *titleBLUE;
@property (strong, nonatomic) IBOutlet UISlider *sliderBLUE;
@property (strong, nonatomic) IBOutlet UILabel *labelBLUE;

@property (strong, nonatomic) IBOutlet UILabel *labelOpposite;
@property (strong, nonatomic) IBOutlet UISwitch *switchOpposite;

@property (strong, nonatomic) NSString *mode;
@property (nonatomic) BOOL isBounce;

@property (strong, nonatomic) IBOutlet UIButton *buttonModeRgb;
@property (strong, nonatomic) IBOutlet UIButton *buttonModeRainbow;
@property (strong, nonatomic) IBOutlet UIButton *buttonModeRotate;
@property (strong, nonatomic) IBOutlet UIButton *buttonModeTheater;
@property (strong, nonatomic) IBOutlet UIButton *buttonModeTheaterRainbow;

@property (strong, nonatomic) IBOutlet UILabel *sampleColorBoard;
@end

@implementation ColorViewController

#define COLOR_WIPE @"1"
#define RAINBOW @"2"
#define ROTATE_SINGLE_PIXEL @"3"
#define ROTATE_SINGLE_PIXEL_BOUNCE @"4"
#define THEATER_CHASE @"5"
#define THEATER_CHASE_RAINBOW @"6"

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    bleShield = [[BLE alloc] init];
    [bleShield controlSetup];
    bleShield.delegate = self;
    
    int red = (int)self.sliderRED.value;
    int green = (int)self.sliderGREEN.value;
    int blue = (int)self.sliderBLUE.value;
    
    self.isBounce = false;
    
    // Initiate Label
    [self.labelRED setText:[NSString stringWithFormat:@"%d", red]];
    [self.labelGREEN setText:[NSString stringWithFormat:@"%d", green]];
    [self.labelBLUE setText:[NSString stringWithFormat:@"%d", blue]];
    
    UIColor *sampleColor = [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:1.0];
    [self.sampleColorBoard setBackgroundColor:sampleColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)modeButtonPressed:(UIButton *)sender
{
    int buttonTag = (int)sender.tag;
    
    [self setAllButtonsUnhighlighted];
    [sender setSelected:true];
    
    if ( self.labelOpposite.enabled ) {
        [self setOppositeControlEnable:false];
    }
    
    switch ( buttonTag ) {
        case 0:
            self.mode = COLOR_WIPE;
            [self setColorControlEnable:true];
            break;
            
        case 1:
            self.mode = RAINBOW;
            [self setColorControlEnable:false];
            break;
            
        case 2:
            self.mode = ROTATE_SINGLE_PIXEL;
            [self setColorControlEnable:true];
            [self setOppositeControlEnable:true];
            break;
            
        case 3:
            self.mode = THEATER_CHASE;
            [self setColorControlEnable:true];
            break;
            
        case 4:
            self.mode = THEATER_CHASE_RAINBOW;
            [self setColorControlEnable:false];
            break;
            
        default:
            break;
    }
}

- (void)setAllButtonsUnhighlighted
{
    [self.buttonModeRgb setSelected:false];
    [self.buttonModeRainbow setSelected:false];
    [self.buttonModeRotate setSelected:false];
    [self.buttonModeTheater setSelected:false];
    [self.buttonModeTheaterRainbow setSelected:false];
}

- (IBAction)switchButtonPressed:(UISwitch *)sender {
    self.isBounce = sender.isOn;
    
    if ( [self.mode isEqualToString:ROTATE_SINGLE_PIXEL] && self.isBounce ) {
        self.mode = ROTATE_SINGLE_PIXEL_BOUNCE;
    }
}

- (void)setColorControlEnable:(BOOL)isEnable
{
    [self.titleRED setEnabled:isEnable];
    [self.titleGREEN setEnabled:isEnable];
    [self.titleBLUE setEnabled:isEnable];
    
    [self.labelRED setEnabled:isEnable];
    [self.labelGREEN setEnabled:isEnable];
    [self.labelBLUE setEnabled:isEnable];
    
    [self.sliderRED setEnabled:isEnable];
    [self.sliderGREEN setEnabled:isEnable];
    [self.sliderBLUE setEnabled:isEnable];
}

- (void)setOppositeControlEnable:(BOOL)isEnable
{
    [self.labelOpposite setEnabled:isEnable];
    [self.switchOpposite setEnabled:isEnable];
}

- (IBAction)sliderValueChanged:(UISlider *)currentSlider {
    // TAG - 0: RED, 1: GREEN, 2: BLUE
    
    switch ( currentSlider.tag ) {
        case 0:
            [self.labelRED setText:[NSString stringWithFormat:@"%d", (int)currentSlider.value]];
            break;
            
        case 1:
            [self.labelGREEN setText:[NSString stringWithFormat:@"%d", (int)currentSlider.value]];
            break;
            
        case 2:
            [self.labelBLUE setText:[NSString stringWithFormat:@"%d", (int)currentSlider.value]];
            break;
            
        default:
            break;
    }
    
    int red = (int)self.sliderRED.value;
    int green = (int)self.sliderGREEN.value;
    int blue = (int)self.sliderBLUE.value;
    [self.sampleColorBoard setBackgroundColor:[UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:1.0]];
}

- (IBAction)lightOn:(id)sender {
    if ( !self.mode ) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR" message:@"You must choose at least one color mode" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    BOOL isNeedColorValues = !( [self.mode isEqualToString:RAINBOW] || [self.mode isEqualToString:THEATER_CHASE_RAINBOW] );

    NSString *modeData;
    
    if ( isNeedColorValues ) {
        int red = (int)self.sliderRED.value;
        int green = (int)self.sliderGREEN.value;
        int blue = (int)self.sliderBLUE.value;
        
        modeData = [NSString stringWithFormat:@"%@%d,%d,%d,", self.mode, red, green, blue];
    } else {
        modeData = self.mode;
    }
    
    NSLog(@"MODE: %@", modeData);
    
    if ( bleShield.activePeripheral.state == CBPeripheralStateConnected ) {
        [bleShield write:[modeData dataUsingEncoding:NSUTF8StringEncoding]];
    }
}

// BLE
- (IBAction)BLEShieldScan:(id)sender
{
    if (bleShield.activePeripheral)
        if(bleShield.activePeripheral.state == CBPeripheralStateConnected)
        {
            [[bleShield CM] cancelPeripheralConnection:[bleShield activePeripheral]];
            return;
        }
    
    if (bleShield.peripherals)
        bleShield.peripherals = nil;
    
    [bleShield findBLEPeripherals:3];
    
    [NSTimer scheduledTimerWithTimeInterval:(float)3.0 target:self selector:@selector(connectionTimer:) userInfo:nil repeats:NO];
    
    self.navigationItem.leftBarButtonItem.enabled = NO;
}


-(void) connectionTimer:(NSTimer *)timer
{
    if(bleShield.peripherals.count > 0)
    {
        [bleShield connectPeripheral:[bleShield.peripherals objectAtIndex:0]];
    }
    else
    {
        self.navigationItem.leftBarButtonItem.enabled = YES;
    }
}

-(void) bleDidReceiveData:(unsigned char *)data length:(int)length
{
    NSData *d = [NSData dataWithBytes:data length:length];
    NSString *s = [[NSString alloc] initWithData:d encoding:NSUTF8StringEncoding];
    NSLog(@"%@", s);
}

NSTimer *rssiTimer;

-(void) readRSSITimer:(NSTimer *)timer
{
    [bleShield readRSSI];
}

- (void) bleDidDisconnect
{
    NSLog(@"bleDidDisconnect");
    
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
    [self.navigationItem.leftBarButtonItem setTitle:@"Connect"];
    self.navigationItem.leftBarButtonItem.enabled = YES;
    
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

-(void) bleDidConnect
{
    [self.navigationItem.rightBarButtonItem setEnabled:YES];
    self.navigationItem.leftBarButtonItem.enabled = YES;
    [self.navigationItem.leftBarButtonItem setTitle:@"Disconnect"];
    
    NSLog(@"bleDidConnect");
}


@end
