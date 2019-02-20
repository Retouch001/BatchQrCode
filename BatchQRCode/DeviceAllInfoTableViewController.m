//
//  DeviceAllInfoTableViewController.m
//  BatchQRCode
//
//  Created by 方景琦 on 2017/6/28.
//  Copyright © 2017年 miracle. All rights reserved.
//

#import "DeviceAllInfoTableViewController.h"

@interface DeviceAllInfoTableViewController ()


@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *serverAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *portIDLabel;
@property (weak, nonatomic) IBOutlet UILabel *bedIDLabel;
@property (weak, nonatomic) IBOutlet UILabel *bindUserLabel;
@property (weak, nonatomic) IBOutlet UILabel *relatedUserLabel;
@property (weak, nonatomic) IBOutlet UILabel *deviceTypeLabel;

@property (weak, nonatomic) IBOutlet UILabel *organizationLabel;


@end

@implementation DeviceAllInfoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self updateUIWithModel:_model];
    
    self.tableView.tableFooterView = [UIView new];
}

- (IBAction)dismissAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)updateUIWithModel:(DeviceAllInfoModel *)model{
    
    self.titleLabel.text = model.mac;
    self.serverAddressLabel.text = [model.serverName substringWithRange:NSMakeRange(0, model.serverName.length-4)];
    self.portIDLabel.text = model.port;
    
    self.bedIDLabel.text = model.bedBind;
    self.bindUserLabel.text = model.bindUser;
        
    self.relatedUserLabel.text = model.usedUser;

    self.organizationLabel.text = model.organization;
    self.deviceTypeLabel.text = [model.deviceType uppercaseString];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
