//
//  ViewController.m
//  VRPlayer
//
//  Created by SunShine on 16/6/22.
//  Copyright © 2016年 JP. All rights reserved.
//

#import "ViewController.h"
#import "VRPlayerViewController.h"
#import <UtoVRPlayer/UtoVRPlayer.h>
#import "VRItem.h"
#import "AFHTTPSessionManager.h"
#import "MJExtension.h"

static NSString *VRInteractionNetApi = @"http://www.ipanda.com/kehuduan/PAGE14501767715521482/vR/index.json";

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_tableView;
}
@property (nonatomic, strong) NSArray *videoArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"VR全景视频";
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [self requestData];
}

- (void)requestData {
    [[AFHTTPSessionManager manager] GET:VRInteractionNetApi parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSArray *array = [responseObject valueForKey:@"VRinteractive"];
        self.videoArray = [VRItem mj_objectArrayWithKeyValuesArray:array];
        [_tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error:%@",error);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.videoArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    VRItem *item=[self.videoArray objectAtIndex:indexPath.row] ;
    static NSString *indentify=@"indentify";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentify];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentify];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:14.0];
    cell.textLabel.text = item.title;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    VRItem *vrItem = [self.videoArray objectAtIndex:indexPath.row];
    
    VRPlayerViewController *playerVC = [[VRPlayerViewController alloc] init];
    playerVC.vrTitle = vrItem.title;
    
    NSMutableArray *items = [NSMutableArray array];
    
    UVPlayerItem *item = [[UVPlayerItem alloc] initWithPath:vrItem.url type:UVPlayerItemTypeOnline];
    [items addObject:item];
    
    [playerVC.itemsToPlay addObjectsFromArray:items];
    
    playerVC.player.viewStyle = UVPlayerViewStyleDefault;
    playerVC.player.playMode = UVPlayerPlayModeLoop;
    
    [self.navigationController pushViewController:playerVC animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
