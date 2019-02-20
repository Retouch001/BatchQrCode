//
//  RootViewController.m
//  BatchQRCode
//
//  Created by 方景琦 on 2017/6/19.
//  Copyright © 2017年 miracle. All rights reserved.
//

#import "RootViewController.h"

#import "LWQRCodeViewController.h"
#import "DeviceDetailInfoTableViewController.h"
#import "DeviceStockOutTableViewCell.h"

#import "OrganizationModel.h"

#import "BatchQrNetworkingManager.h"

#import <POP.h>

#import "GCD.h"

@interface RootViewController ()<UITableViewDelegate,UITableViewDataSource>{
    YYCache *cache;
}

@property(nonatomic,strong)NSMutableArray *dataArray;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic,strong)NSArray <OrganizationModel *>*organizationArray;


@end

NSString *const cellIdentify  = @"cell";


@implementation RootViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    cache = [YYCache cacheWithName:CACHENAME];
    
    [self.tableView registerNib:[UINib nibWithNibName:[DeviceStockOutTableViewCell className] bundle:nil] forCellReuseIdentifier:cellIdentify];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

}



-(void)viewWillAppear:(BOOL)animated{
    WS(weakSelf);
    [cache.diskCache objectForKey:CACHEKEY withBlock:^(NSString * _Nonnull key, id<NSCoding>  _Nonnull object) {
        if (object) {
            weakSelf.dataArray = (NSMutableArray *)object;
            
            [GCDQueue executeInMainQueue:^{
                [weakSelf.tableView reloadData];
                
                NSUInteger totalNumber = 0;
                for (NSMutableArray *array in _dataArray) {
                    totalNumber += array.count;
                }
                weakSelf.title = [NSString stringWithFormat:@"记录(%lu)",totalNumber];
            }];
        }
    }];
    
    

    
    
}



- (IBAction)startScanQRAcion:(UIButton *)sender {
    
    WS(weakSelf);
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animation];
    scaleAnimation.property = [POPAnimatableProperty propertyWithName:kPOPViewScaleXY];//宽高改变
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.3, 1.3)];//1.3倍
    [sender pop_addAnimation:scaleAnimation forKey:@"scaleAnimationKey"];//执行动画
    scaleAnimation.completionBlock = ^(POPAnimation *animation,BOOL finish) { //动画回调
        POPSpringAnimation *scaleAnimation = [POPSpringAnimation animation];
        scaleAnimation.springBounciness = 16;    // value between 0-20
        scaleAnimation.springSpeed = 14;     // value between 0-20
        scaleAnimation.property = [POPAnimatableProperty propertyWithName:kPOPViewScaleXY];
        scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.0, 1.0)];
        [sender pop_addAnimation:scaleAnimation forKey:@"scaleAnimationKey"];
        
        [weakSelf getAllOrganization];
    };
}


-(void)getAllOrganization{
    WS(weakSelf);
    [SVProgressHUD showWithStatus:@"正在获取组织机构..."];
    [NETWORKINGMANAGER getAllOrganizationForDistributionSuccess:^(NSDictionary *dic) {
        weakSelf.organizationArray = [NSArray modelArrayWithClass:[OrganizationModel class] json:dic[@"orgList"]];
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"机构选择" message:@"所有可分配的机构" preferredStyle:UIAlertControllerStyleActionSheet];
        for (int i = 0 ; i<weakSelf.organizationArray.count; i++) {
            OrganizationModel *model = weakSelf.organizationArray[i];
            [alertVC addAction:[UIAlertAction actionWithTitle:model.name style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                LWQRCodeViewController *deviceInfoVC = [storyboard instantiateViewControllerWithIdentifier:@"QRVC"];
                deviceInfoVC.isRelateToOrg = YES;
                deviceInfoVC.orgModel = model;
                [weakSelf.navigationController pushViewController:deviceInfoVC animated:YES];
            }]];
        }
        
        [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        
        [weakSelf presentViewController:alertVC animated:YES completion:nil];
        
    } errorresult:^(NSError *error) {
        
    }];

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 88;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DeviceStockOutTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify forIndexPath:indexPath];
    
    NSArray *array = self.dataArray[indexPath.row];
        
    
    [cell loadContentUIWithModel:array];
    
    
    if (indexPath.row % 2) {
        cell.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.05f];        
    } else {
        cell.backgroundColor = [UIColor whiteColor];
    }

    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DeviceDetailInfoTableViewController *deviceInfoVC = [[DeviceDetailInfoTableViewController alloc] init];
    
    NSMutableArray *array = self.dataArray[indexPath.row];
    
    deviceInfoVC.dataArray = array;
    
    [self.navigationController pushViewController:deviceInfoVC animated:YES];
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WS(weakSelf);
    // 添加一个删除按钮
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        // 1. 更新数据
        [self.dataArray removeObjectAtIndex:indexPath.row];
        
        [cache setObject:weakSelf.dataArray forKey:CACHEKEY withBlock:^{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // 2. 更新UI
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                [tableView reloadSectionIndexTitles];
                NSUInteger totalNumber = 0;
                for (NSMutableArray *array in weakSelf.dataArray) {
                    totalNumber += array.count;
                }
                weakSelf.title = [NSString stringWithFormat:@"记录(%lu)",totalNumber];
            });
            
        }];
    }];
    
    deleteRowAction.backgroundColor = UIColorFromHexValue(0xD83938);
    
    return @[deleteRowAction];
    
}



- (IBAction)deleteAllData:(id)sender {
    dispatch_queue_t queue = dispatch_get_main_queue();
    WS(weakSelf);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"警告" message:@"此操作将删除你本地保存的所有数据且不可恢复,请慎重选择" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        [cache removeAllObjectsWithProgressBlock:^(int removedCount, int totalCount) {
            dispatch_async(queue, ^{
                [SVProgressHUD showProgress:removedCount status:@"正在删除中..."];
            });
        } endBlock:^(BOOL error) {
            dispatch_async(queue, ^{
                weakSelf.dataArray = [NSMutableArray array];
                [weakSelf.tableView reloadData];
                [SVProgressHUD showSuccessWithStatus:@"完成"];
                NSUInteger totalNumber = 0;
                for (NSMutableArray *array in _dataArray) {
                    totalNumber += array.count;
                }
                weakSelf.title = [NSString stringWithFormat:@"记录(%lu)",totalNumber];
            });
        }];
        
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:action];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
