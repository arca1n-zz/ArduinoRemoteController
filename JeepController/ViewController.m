//
//  ViewController.m
//  JeepController
//
//  Created by Alok Rao on 12/22/16.
//  Copyright © 2016 Alok. All rights reserved.
//

#import "ViewController.h"
#import "MessageDefinitions.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface ViewController ()

@property (nonatomic, strong) BLE *bleManager;

@property (nonatomic, weak) IBOutlet UIButton *bleConnectButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bleManager = [[BLE alloc] init];
    [self.bleManager controlSetup];
    self.bleManager.delegate = self;
    
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma Mark Button handlers

-(IBAction)handleHeadlightTapped:(UIButton*)sender {
    JCLightMessage message;
    message.command = COMMAND_ID_LIGHT;
    message.lightID = LIHeadlamp;
    //message.state = LightStateFlicker;
    
    if(sender.selected) {
        message.state = LightStateOff;
        sender.selected = NO;
    }else {
        message.state = LightStateOn;
        sender.selected = YES;
    }
    
    Byte *buffer = (Byte*)&message;
    
    if ([self.bleManager isConnected]) {
        NSData *data = [NSData dataWithBytes:buffer length:sizeof(JCLightMessage)];
        [self.bleManager write:data];
        NSLog(@"Data Size : %d, Data %@", data.length, data);
    }
}

- (IBAction)handleScanForPeripherals:(id)sender
{
    if (self.bleManager.activePeripheral)
        if(self.bleManager.activePeripheral.state == CBPeripheralStateConnected)
        {
            [[self.bleManager CM] cancelPeripheralConnection:[self.bleManager activePeripheral]];
            //[btnConnect setTitle:@"Connect" forState:UIControlStateNormal];
            return;
        }
    
    if (self.bleManager.peripherals)
        self.bleManager.peripherals = nil;
    
    [self.bleConnectButton setEnabled:false];
    [self.bleManager findBLEPeripherals:2];
    
    [NSTimer scheduledTimerWithTimeInterval:(float)2.0 target:self selector:@selector(connectionTimer:) userInfo:nil repeats:NO];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

#pragma Mark BLEDelegate

- (void)bleDidConnect {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)bleDidDisconnect {
    
}

- (void)bleDidUpdateRSSI:(NSNumber *)rssi {
    
}

- (void)bleDidReceiveData:(unsigned char *)data length:(int)length {
    
}

#pragma BLE Work



-(void) connectionTimer:(NSTimer *)timer
{
    [self.bleConnectButton setEnabled:true];
    [self.bleConnectButton setTitle:@"Disconnect" forState:UIControlStateNormal];
    
    if (self.bleManager.peripherals.count > 0)
    {
        [self.bleManager connectPeripheral:[self.bleManager.peripherals objectAtIndex:0]];
    }
    else
    {
        [self.bleConnectButton setTitle:@"Connect" forState:UIControlStateNormal];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
}



@end
