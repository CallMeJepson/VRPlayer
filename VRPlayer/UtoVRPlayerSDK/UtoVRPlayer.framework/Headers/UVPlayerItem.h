//
//  UVPlayerItem.h
//  UtoVRPlayer-OC
//
//  Created by xue on 12/10/15.
//  Copyright © 2015 http://www.utovr.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>


/**
 *  视频来源类型
 */
typedef NS_ENUM(NSUInteger, UVPlayerItemType) {
    /**
     *  MP4本地视频播放
     */
    UVPlayerItemTypeLocalVideo,
    /**
     *  MP4或者M3U8 在线播放
     */
    UVPlayerItemTypeOnline,
    /**
     *  M3U8直播
     */
    UVPlayerItemTypeLive
};

/**
 *  播放资源数据模型
 */
@interface UVPlayerItem : NSObject
/**
 *  type
 */
@property (nonatomic,assign,readonly) UVPlayerItemType type;
/**
 *  路径
 */
@property (nonatomic,copy,readonly) NSString *path;

/**
 *  通过指定文件来源类型，初始化一个全景视频文件模型实例
 *
 *  @param path 地址。本地、在线MP4文件地址，点播或者直播M3U8文件地址。
 *  @param type 视频类型
 *
 *  @return 
 */
-(instancetype)initWithPath:(NSString*)path type:(UVPlayerItemType)type;


@end
