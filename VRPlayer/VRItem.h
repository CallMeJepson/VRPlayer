//
//  InteractionItem.h
//  CNTVPandaChannel
//
//  Created by fenggaowei on 15/12/24.
//  Copyright © 2015年 brilliance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//互动模型
@interface VRItem : NSObject

@property (nonatomic, strong) NSString *image;

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSString *url;

@property (nonatomic, strong) NSString *order;

@property (nonatomic, assign) CGFloat itemHeight;

@property (nonatomic, assign) BOOL isVrSource;

+ (CGFloat)itemHeight;

@end
