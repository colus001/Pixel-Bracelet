//
//  ColorViewController.h
//  SimpleChat
//
//  Created by Kim Seokjun on 5/11/14.
//  Copyright (c) 2014 redbear. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLE.h"

@interface ColorViewController : UIViewController <BLEDelegate>
{
    BLE *bleShield;
}

@end
