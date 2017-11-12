//
//  MotionCameraExt.m
//  MyLittleCraft
//
//  Created by huangkun on 2017/11/12.
//  Copyright © 2017年 huangkun. All rights reserved.
//

#import "MotionCameraExt.h"
#import <CoreGraphics/CGBase.h>

CG_INLINE bool my_angleInRange(CGFloat angle, CGFloat expected, CGFloat deviation) {
    return angle > expected - deviation && angle < expected + deviation;
}

UIDeviceOrientation my_orientationForAccelerometerData(CMAccelerometerData *accelerometerData) {
    CMAcceleration acceleration = accelerometerData.acceleration;
    
    CGFloat xx = acceleration.x;
    CGFloat yy = -acceleration.y;
    CGFloat zz = acceleration.z;
    
    CGFloat faceUpZ = 180.0;
    CGFloat faceDownZ = 0.0;
    
    // This range value makes face up and down not as same as system defined.
    // The bigger value makes it less precise, but acceptable.
    CGFloat flatRange = 22.5;
    
    CGFloat angle1 = 90 - atan2(zz, xx) * 180 / M_PI;
    CGFloat angle2 = 90 - atan2(zz, yy) * 180 / M_PI;
    
    // face up
    if (my_angleInRange(angle1, faceUpZ, flatRange) &&
        my_angleInRange(angle2, faceUpZ, flatRange)) {
        return UIDeviceOrientationFaceUp;
    }
    
    // face down
    if (my_angleInRange(angle1, faceDownZ, flatRange) &&
        my_angleInRange(angle2, faceDownZ, flatRange)) {
        return UIDeviceOrientationFaceDown;
    }
    
    // Reference:
    // https://github.com/danielebogo/DBCamera/blob/master/DBCamera/Objects/DBMotionManager.m
    
    CGFloat angle = M_PI / 2.0f - atan2(yy, xx);
    if (angle > M_PI) {
        angle -= 2 * M_PI;
    }
    
    UIDeviceOrientation orientation = UIDeviceOrientationUnknown;
    
    if ((angle > -M_PI_4) && (angle < M_PI_4)) {
        orientation = UIDeviceOrientationPortrait;
    } else if ((angle < -M_PI_4) && (angle > -3 * M_PI_4)) {
        orientation = UIDeviceOrientationLandscapeLeft;
    } else if ((angle > M_PI_4) && (angle < 3 * M_PI_4)) {
        orientation = UIDeviceOrientationLandscapeRight;
    } else {
        orientation = UIDeviceOrientationPortraitUpsideDown;
    }
    
    return orientation;
}
