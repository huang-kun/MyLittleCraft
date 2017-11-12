//
//  MotionCameraExt.h
//  MyLittleCraft
//
//  Created by huangkun on 2017/11/12.
//  Copyright © 2017年 huangkun. All rights reserved.
//

#import <UIKit/UIDevice.h>
#import <CoreMotion/CMAccelerometer.h>

/// Calculate accelerometer data to new device orientation.
UIDeviceOrientation my_orientationForAccelerometerData(CMAccelerometerData *accelerometerData);
