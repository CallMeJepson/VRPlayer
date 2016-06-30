//
//  InteractionItem.m
//  CNTVPandaChannel
//
//  Created by fenggaowei on 15/12/24.
//  Copyright © 2015年 brilliance. All rights reserved.
//

#import "VRItem.h"

#define DeviceWidth  [UIScreen mainScreen].bounds.size.width
#define GlobalSpaceWidth 8.0

@implementation VRItem

+ (CGFloat)itemHeight {
    return 1+30+(DeviceWidth-GlobalSpaceWidth*2)/16.0*9+1+GlobalSpaceWidth;
}

@end
