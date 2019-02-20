//
//  MainTableViewController.m
//  BatchQRCode
//
//  Created by 方景琦 on 2017/6/23.
//  Copyright © 2017年 miracle. All rights reserved.
//

#import "MainTableViewController.h"

#import "MainUserManager.h"
#import "TJHApiManager.h"

#import "UINavigationBar+Awesome.h"

#define NAVBAR_CHANGE_POINT 50


@interface MainTableViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *mainUserIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *mainUserUserNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *mainUserPhoneLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;

@end

@implementation MainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorColor = [UIColor clearColor];
    
    [self updateUI];

    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
    NSDictionary * dict=[NSDictionary dictionaryWithObject:[UIColor blackColor] forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar lt_reset];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    UIColor * color = [UIColor colorWithHexString:@"F4F6F7"];
    
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > NAVBAR_CHANGE_POINT) {
        CGFloat alpha = MIN(1, 1 - ((NAVBAR_CHANGE_POINT + 64 - offsetY) / 64));
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:alpha]];
        if (alpha == 1) {
            [self.navigationController.navigationBar lt_reset];
        }
        self.title = @"工具";
        
    } else {
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:0]];
        self.title = @"";
    }
    
    
    CGFloat width = self.view.frame.size.width; // 图片宽度
    
    CGFloat yOffset = scrollView.contentOffset.y;  // 偏移的y值
    
    if (yOffset < 0) {
        
        CGFloat totalOffset = 230 + ABS(yOffset);
        
        CGFloat f = totalOffset / 230;
        
        self.headerImageView.frame =  CGRectMake(- (width * f - width) / 2, yOffset, width * f, totalOffset); //拉伸后的图片的frame应该是同比例缩放。
        
    }
}



- (IBAction)wifiCofigAction:(id)sender {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"选择配置模式" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"AP配置模式" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"一键配置模式" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertVC animated:YES completion:nil];
}



-(void)updateUI{
    self.mainUserUserNameLabel.text = MAINUSERINSTANCE.user.username;
    
    NSString *phoneNumber = MAINUSERINSTANCE.user.phone;
    
    if (phoneNumber.length == 11) {
        self.mainUserPhoneLabel.text = [NSString stringWithFormat:@"%@****%@",[phoneNumber substringWithRange:NSMakeRange(0, 3)],[phoneNumber substringWithRange:NSMakeRange(phoneNumber.length-4, 4)]];
    }else{
        self.mainUserPhoneLabel.text = @"";
    }    
    [self.mainUserIconImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",TJHAPIMANAGER.API__USER_ICON_BASE_URL,MAINUSERINSTANCE.user.user_id]] placeholder:[UIImage imageNamed:@"头像"] options:YYWebImageOptionIgnoreDiskCache completion:nil];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//#pragma mark - Table view data source
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
//    return 0;
//}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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
