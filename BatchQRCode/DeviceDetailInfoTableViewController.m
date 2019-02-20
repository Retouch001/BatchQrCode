//
//  DeviceDetailInfoTableViewController.m
//  BatchQRCode
//
//  Created by 方景琦 on 2017/6/19.
//  Copyright © 2017年 miracle. All rights reserved.
//

#import "DeviceDetailInfoTableViewController.h"
#import "StockOutRecordModel.h"
#import "StringAttributeHelper.h"


@interface DeviceDetailInfoTableViewController ()


@end


NSString *const cellIdentify1  = @"cell1";

@implementation DeviceDetailInfoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设备列表";
    
    self.tableView.tableFooterView = [UIView new];
    
    //self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    
    //[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentify1];
    
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
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify1];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentify1];
    }
    
    StockOutRecordModel *recordModel = self.dataArray[indexPath.row];
    
    cell.textLabel.text = recordModel.mac;
    cell.detailTextLabel.text = recordModel.stockOutDate;
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12.f];
    
    cell.imageView.image = [UIImage imageNamed:@"gps"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    
    if (recordModel.result) {
        NSString *fullStirng = [NSString stringWithFormat:@"%@(%@)",recordModel.mac,recordModel.result];
        NSMutableAttributedString *richString = [[NSMutableAttributedString alloc] initWithString:fullStirng];
        {
            FontAttribute *fontAttribute = [FontAttribute new];
            fontAttribute.font           = [UIFont systemFontOfSize:14.f];
            fontAttribute.effectRange    = NSMakeRange(0, richString.length);
            [richString addStringAttribute:fontAttribute];
        }
        {
            FontAttribute *fontAttribute = [FontAttribute new];
            fontAttribute.font           = [UIFont systemFontOfSize:12.f];
            fontAttribute.effectRange    = NSMakeRange(12, fullStirng.length-12);
            [richString addStringAttribute:fontAttribute];
        }
        
        
        
        
        {
            ForegroundColorAttribute *foregroundColorAttribute = [ForegroundColorAttribute new];
            foregroundColorAttribute.color                     = [[UIColor redColor] colorWithAlphaComponent:0.65f];
            foregroundColorAttribute.effectRange               = NSMakeRange(0, richString.length);
            [richString addStringAttribute:foregroundColorAttribute];
        }
        
//        {
//            ForegroundColorAttribute *foregroundColorAttribute = [ForegroundColorAttribute new];
//            foregroundColorAttribute.color                     = [kColorBase colorWithAlphaComponent:0.65f];
//            foregroundColorAttribute.effectRange               = NSMakeRange(16, 1);
//            [richString addStringAttribute:foregroundColorAttribute];
//        }
        
        cell.textLabel.attributedText = richString;
  
    }

    
    
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
