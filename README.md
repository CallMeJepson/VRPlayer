# VRPlayer

简介

UtoVR Player是一款全景视频播放器。它支持360度空间全景视频的播放。观看者通过与播放器的交互，可以体验到身临其境的视觉效果。UtoVR Player SDK可以帮助你在自己的应用中，快速实现全景视频的播放效果。

功能：

1，支持视频格式：h264编码的mp4等视频文件；

2，支持播放普通全景视频（2：1）；

3，支持2K高清、4K超高清（本地）的全景视频播放；

4，支持点播（mp4、HLS）、直播（HLS格式）播放全景视频；

5，支持手指的上、下、左、右的滑动，放大、缩小全景视频的操作；

6，支持陀螺仪的上、下、左、右控制全景视频的操作；

7，支持单屏/双屏（VR模式）的操作；

8，支持全屏、非全屏的操作；

9，支持视频的播放、暂停、以及时间进度条的控制；

开发步骤：

1、将lib目录下的UtoVRPlayerSDK拖拽至工程目录中

2、添加依赖框架
  * GLKit.framework
  * CoreMotion.framework
  * libz.tbd

3、设置编译器选项
  在TARGETS-->Build Settings-->Linking-->Other Linker Flags添加 -all_load -ObjC
4、添加引用
  #import <UtoVRPlayer/UtoVRPlayer.h>

5、在新发布的iOS9系统上围绕用户数据的安全性和体验新增了一些安全特性，同时也影响了应用的实现以及集成方式。如果你要播放在线HTTP视频，需要做如下处理： 在info.plist的NSAppTransportSecurity下新增NSAllowsArbitraryLoads并设置为YES，指定所有HTTP连接都可正常请求。
<key>NSAppTransportSecurity</key>
    <dict>
        <key>NSAllowsArbitraryLoads</key>
        <true/>
    </dict>


使用步骤

1、实例化播放器
self.player = [[UVPlayer alloc] initWithConfiguration:nil];

2、将播放界面添加到父视图并设置大小
[self.view addSubview:self.player.playerView];
self.player.playerView.frame = self.view.bounds;

3、添加播放资源到播放器
UVPlayerItem *local4k = [[UVPlayerItem alloc] initWithPath:[[NSBundle mainBundle] pathForResource:@"4k" ofType:@"mp4"] type:UVPlayerItemTypeLocalVideo];
[self.player appendItem:local4k];

4、资源释放.退出播放器时释放播放器资源
[self.player prepareToRelease];

更多详情：http://www.utovr.com/sdk/
