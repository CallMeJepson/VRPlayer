//
//  VRPlayerViewController.m
//  VRPlayer
//
//  Created by SunShine on 16/6/22.
//  Copyright © 2016年 JP. All rights reserved.
//

#import "VRPlayerViewController.h"

@interface VRPlayerViewController ()<UVPlayerDelegate>

@end

@implementation VRPlayerViewController

#pragma mark - Getters
- (UVPlayer *)player {
    if (_player == nil) {
        _player = [[UVPlayer alloc] initWithConfiguration:nil];
        _player.delegate = self;
    }
    return _player;
}

- (NSMutableArray *)itemsToPlay {
    if (_itemsToPlay == nil) {
        _itemsToPlay = [[NSMutableArray alloc]init];
    }
    return _itemsToPlay;
}

#pragma mark - Life cycles
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //将播放视图添加到当前界面
    [self.view addSubview:self.player.playerView];
    
    if (self.player.viewStyle == UVPlayerViewStyleDefault) {
        //默认界面。设置竖屏返回按钮动作
        [self.player setPortraitBackButtonTarget:self selector:@selector(back:)];
    }
    
    //把要播放的内容添加到播放器
    [self.player appendItems:self.itemsToPlay];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    //调整frame。你可以使用任何其它布局方式保证播放视图是你期望的大小
//    CGRect frame;
//    if (self.traitCollection.verticalSizeClass == UIUserInterfaceSizeClassCompact) {
//        frame = CGRectMake(0, 20, self.view.bounds.size.width, self.view.bounds.size.height - 20);
//    } else {
//        frame = CGRectMake(0, 64 + 44, self.view.bounds.size.width, self.view.bounds.size.height - 64 - 44 -44);
//    }
//    self.player.playerView.frame = frame;
    
    CGRect frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    self.player.playerView.frame = frame;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    //退出时不要忘记调用prepareToRelease
    [self.player prepareToRelease];
}

- (void)back:(UIButton*)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - PanoPlayerDelegate
- (void)player:(UVPlayer *)player willBeginPlayItem:(UVPlayerItem *)item {
    if (player.viewStyle == UVPlayerViewStyleDefault) {
        //设置横屏显示的title为当前播放资源的路径。你可以设置为其它的任何内容
        if (self.vrTitle.length) {
            [player setTitleText:self.vrTitle];
        }else {
            [player setTitleText:item.path];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end