//
//  UVPlayer.h
//  UtoVRPlayer-OC
//
//  Created by xue on 12/10/15.
//  Copyright © 2015 http://www.utovr.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "UVPlayerItem.h"
#define UVPlayerErrorDomain @"com.utovr.UVPlayerError"

#pragma mark - 播放器配置项

/**
 *  播放器初始FOV
 */
extern NSString *const UVPlayerDefaultFOVKey;
/**
 *  播放器初始水平角度
 */
extern NSString *const UVPlayerDefaultPanKey;
/**
 *  播放器初始竖直角度
 */
extern NSString *const UVPlayerDefaultTiltKey;

@protocol UVPlayerDelegate;

/**
 *  播放器界面样式
 */
typedef NS_ENUM(NSInteger,UVPlayerViewStyle) {
    /**
     *  默认样式
     */
    UVPlayerViewStyleDefault,
    /**
     *  无
     */
    UVPlayerViewStyleNone
};

/**
 *  播放模式
 */
typedef NS_ENUM(NSInteger, UVPlayerPlayMode) {
    /**
     *  循环播放
     */
    UVPlayerPlayModeLoop,
    /**
     *  顺序播放
     */
    UVPlayerPlayModeSerial
};

/**
 *  播放器。
 */
@interface UVPlayer : NSObject

#pragma mark - Initialation

/**
 *  指定初始化构造器。
 *
 *  @param configuration 播放器初始配置信息。
 *  
 *  - UVPlayerDefaultFOVKey 设置水平初始化FOV
 *
 *  - UVPlayerDefaultPanKey 设置水平初始角度。向右为正方向。
 *
 *  - UVPlayerDefaultTiltKey 设置竖直初始角度。范围为-90~90。向下为正
 *
 *  @return 播放界面实例
 */
-(instancetype)initWithConfiguration:(NSDictionary*)configuration;

#pragma mark - 播放器配置
/**
 *  代理
 */
@property (nonatomic,assign) id<UVPlayerDelegate> delegate;

/**
 *  播放模式
 */
@property (nonatomic,assign) UVPlayerPlayMode playMode;

/**
 *  播放器界面样式
 */
@property (nonatomic,assign) UVPlayerViewStyle viewStyle;

/**
 *  获取版本信息
 *
 *  @return 版本信息
 */
-(NSString*)getVersion;

/**
 *  调试模式。输出更多Log信息
 */
@property (nonatomic,assign) BOOL debugMode;

#pragma mark - 视频资源控制。资源文件会被添加进播放器的播放队列，播放器的播放队列不为空时，自动顺序播放
/**
 *  当前正在播放的UVPlayerItem
 */
@property (nonatomic,readonly) UVPlayerItem *currentItem;
/**
 *  添加视频集合
 *
 *  @param items UVPlayerItem类型集合
 */
-(void)appendItems:(NSArray*)items;
/**
 *  添加单个视频
 *
 *  @param item UVPlayerItem
 */
-(void)appendItem:(UVPlayerItem*)item;


#pragma mark - 播放控制。获取当前时间、时长、暂停、播放等

/**
 *  正在播放视频的播放时间。
 */
@property (nonatomic,assign) CMTime currentTime;

/**
 *  正在播放视频的总时长
 */
@property (nonatomic,readonly) CMTime duration;
/**
 *  开始播放
 */
-(void)play;
/**
 *  暂停播放
 */
-(void)pause;
/**
 *  播放下一个
 */
-(void)advanceToNextItem;
/**
 *  重播。重播最后一个视频
 */
-(void)replayLast;
/**
 *  清空播放列表
 */
-(void)clearItems;
/**
 *  进度跳转
 *
 *  @param progress 要跳转的位置。传入参数为目的时间占总体时长的百分比
 */
-(void)seekToProgress:(float)progress;
/**
 *  恢复初始视角
 */
-(void)resetPerspective;

-(void)setPreferredPeakBitRate:(double)rate;
#pragma mark - 功能开关
/**
 *  开启/关闭陀螺仪。设置YES/NO开启或关闭。注意在UVPlayerDelegate代理方法中接收开启、关闭结果
 */
@property (nonatomic,assign) BOOL gyroscopeEnabled;
/**
 *  同上，开启/关闭双屏功能
 */
@property (nonatomic,assign) BOOL duralScreenEnabled;


#pragma mark - UI
/**
 *  播放器视图，播放器的关键属性；显示视频，具有基本的手势、陀螺仪等交互能力。根据style属性展示不同的样式。
 *  UVPlayerViewStyleDefault为默认样式
 *  UVPlayerViewStyleNone适合于自定义样式。
 */
@property (nonatomic,strong) UIView *playerView;

/**
 *  隐藏缓冲动画。播放网络视频缓冲不足时展示的动画。如果需要自己定义缓冲动画，先设置为true隐藏SDK提供的默认动画
 */
@property (nonatomic,assign) BOOL cachingViewHidden;

/**
 *  时间格式化器。将Double类型的时间展示成0:00:00样式的字符串
 */
@property (nonatomic,readonly) NSDateComponentsFormatter *defaultTimeFormatter;

#pragma mark - UVPlayerViewStyleDefault模式
/**
 *  设置竖屏返回按钮的回调事件
 *
 *  @param target 对象
 *  @param sel    方法
 *
 *  @warning 仅在style == UVPlayerViewStyleDefault模式下有效
 */
-(void)setPortraitBackButtonTarget:(id)target selector:(SEL)sel;
/**
 * 设置横屏时的标题
 *
 *  @param title 标题
 *
 *  @warning 仅在style == UVPlayerViewStyleDefault模式下有效
 */
-(void)setTitleText:(NSString*)title;
/**
 * 可以设置横屏返回按钮的回调事件。
 *
 *  @param target 对象
 *  @param sel    方法
 *
 *  @warning 仅在style == UVPlayerViewStyleDefault模式下有效
 */
-(void)setHorizontalBackButtonTarget:(id)target selector:(SEL)sel;

/**
 *  设置顶部工具栏右侧bar button items
 *
 *  @warning 仅在style == UVPlayerViewStyleDefault模式下有效
 */
@property (nonatomic,strong) NSArray *rightBarButtonItems;
/**
 * 在overlayView上边添加更多自己的控件
 *
 *  @warning 仅在style == UVPlayerViewStyleDefault模式下有效
 */
@property (nonatomic,strong) UIView *overlayView;

#pragma mark - prepareToRelease
/**
 *  释放资源。
 *
 *  @warning 退出播放器前，确保调用此方法。
 */
-(void)prepareToRelease;

@end

#pragma mark - UVPlayerDelegate， 协议中每个方法都是可选的
/**
 *  播放器代理协议。描述了一个UVPlayerItem从开始添加到结束播放的整个过程。
 */
@protocol UVPlayerDelegate <NSObject>
@optional

#pragma mark - 资源添加。使用appendItems/appendItem方法向播放器添加了播放资源后，通过这些方法检查是否添加成功
/**
 *  成功添加一个播放资源
 *
 *  @param player 播放器
 *  @param item   成功添加的资源
 */
-(void)player:(UVPlayer*)player didAddItem:(UVPlayerItem*)item;
/**
 *  添加播放资源失败
 *
 *  @param player 播放器
 *  @param item   添加失败的资源
 *  @param error  错误描述
 */
-(void)player:(UVPlayer*)player failedToAddItem:(UVPlayerItem*)item error:(NSError*)error;

#pragma mark - 视频播放开始。播放器播放到每一个视频时，先调用willBeginPlayItem，然后didBeginPlayItem或者playItemFailed
/**
 *  播放器无法确定以何种方式渲染当前视频，在willBeginPlayItem之前，如果播放器无法确定当前播放内容的渲染类型比如：renderType == UVPlayerItemRenderTypeD3Unkown的情况，会触发该方法。代理应实现这个方法向播放器提供正确的播放类型。如:item.renderType = UVPlayerItemRenderTypePanoVideo通知播放器以全景视频的方式去渲染当前播放内容
 *
 *  @param player 播放器
 *  @param item   要播放的视频
 *
 * @warning 播放器在播放通过UVPlayerItem的初始化方法
 *
 * @code 
 *  -(instancetype)initWithPath:(NSString*)path resourceType:(UVPlayerItemResourceType)type;
 * @endcode
 *
 * 实例化的对象时，是不会触发该方法的，播放器以2:1全景视频的尺寸来渲染当前视频，仅在需要时实现这个方法。
 */

-(void)player:(UVPlayer*)player tryingToPlayItemWithAmbigousRenderType:(UVPlayerItem*)item;
/**
 *  将要开始播放一个视频。
 *
 *  @param player 播放器
 *  @param item   要播放的视频。为nil时无内容
 */
-(void)player:(UVPlayer*)player willBeginPlayItem:(UVPlayerItem*)item;
/**
 *  视频播放开始。当前播放任务顺利开始
 *
 *  @param player 播放器
 *  @param item   播放的视频
 */
-(void)player:(UVPlayer*)player didBeginPlayItem:(UVPlayerItem*)item;
/**
 *  播放视频失败。当前播放任务失败
 *
 *  @param player 播放器
 *  @param item   播放的视频
 *  @param error  错误信息
 */
-(void)player:(UVPlayer*)player playItemFailed:(UVPlayerItem*)item error:(NSError*)error;

#pragma mark - 播放、缓存进度。需要查看当前的播放进度和缓存进度时，实现这些方法
/**
 *  缓存进度更新。
 *  @note 缓存进度的更新信息是由一个区间来描述，即当前缓存的起始时间和当前缓存的时长，单位是相对于当前视频的总时长的。实际缓存到的位置为startSeconds + duration
 *  @param player       播放器
 *  @param startSeconds 起始时间
 *  @param duration      时长
 */
-(void)player:(UVPlayer*)player didCache:(Float64)startSeconds duration:(Float64)duration;
/**
 *  播放进度更新。
 *
 *  @param player  播放器
 *  @param newTime 当前播放时间
 */
-(void)player:(UVPlayer*)player playingTimeDidChanged:(Float64)newTime;

#pragma mark - 播放状态变化。这些方法主要用于播放器界面的同步控制
/**
 *  获取到总时长
 *
 *  @param player   播放器
 *  @param duration 总时长。
 */
-(void)player:(UVPlayer*)player didGetDuration:(Float64)duration;

/**
 *  播放器状态变化。
 *  @note 播放状态跟播放速率和当前缓存状态有关。只有当播放速率不为0并且有足够的缓存数据时播放器才会正常播放
 *
 *  该方法主要用来同步播放器界面信息。如可以使用
 *  @code
        float rate = [dict[@"rate"] floatValue];
        BOOL bufferFull = [dict[@"bufferFull"] boolValue];
        BOOL playing = rate != 0 && bufferFull;
        self.playBtn.selected = playing;
    @endcode
    来合理调整播放/暂停按钮的selected属性
 *
 *  avalibaleItem 播放器是否有可播放内容
 *
 *  @param player 播放器
 *  @param dict   {"rate":"float","bufferFull":"Bool","avalibaleItem":"Bool"}
 */
-(void)player:(UVPlayer*)player playingStatusDidChanged:(NSDictionary*)dict;

/**
 *  播放完一个视频
 *
 *  @param player 播放器
 *  @param item   视频
 */
-(void)player:(UVPlayer*)player finishedPlayingItem:(UVPlayerItem*)item;
/**
 *  播放任务完成。按照设定的播放模式播放完了所有视频时触发
 *
 *  @param player
 */
-(void)playerFinished:(UVPlayer *)player;

#pragma mark - 功能开关。如果开启/关闭了陀螺就或者双屏显示功能，通过这些方法查看是否成功开启/关闭。这些方法主要用来同步播放界面控件的状态。

/**
 *  陀螺仪器打开状态。使用此方法来更新界面陀螺仪打开状态。下同
 *
 *  @param success 是否成功
 */
-(void)player:(UVPlayer *)player openGyroscopeSuccess:(BOOL)success;
/**
 *  陀螺仪功能关闭
 *
 *  @param player
 */
-(void)playerGysoscopeClosed:(UVPlayer *)player;

/**
 *  是否开启了双屏显示功能
 *
 *  @param player  视图
 *  @param dural 双屏功能是否打开
 */
-(void)player:(UVPlayer *)player switchToDuralScreenMode:(BOOL)dural;

#pragma mark - 手势相关
/**
 *  水平滑动。用户是否在播放器上进行了水平滑动的操作，下同。
 */
-(void)playerPanedHorizontal;
/**
 *  竖直滑动
 */
-(void)playerPanedVertical;

/**
 *  缩放
 *
 *  @param player
 *  @param value
 */
-(void)player:(UVPlayer*)player zoomed:(float)value;

/**
 *  单击事件
 *
 *  @param player 播放器
 */
-(void)playerSingleClicked:(UVPlayer*)player;
@end

