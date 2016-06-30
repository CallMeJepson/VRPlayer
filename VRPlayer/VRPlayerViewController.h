//
//  VRPlayerViewController.h
//  VRPlayer
//
//  Created by SunShine on 16/6/22.
//  Copyright © 2016年 JP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UtoVRPlayer/UtoVRPlayer.h>

@interface VRPlayerViewController : UIViewController

@property (nonatomic,strong) UVPlayer *player;
@property (nonatomic,strong) NSMutableArray *itemsToPlay;
@property (nonatomic, copy) NSString *vrTitle;

@end
