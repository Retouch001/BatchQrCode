//
//  LWQRCodeViewController.h
//  LWProjectFramework
//
//  Created by bhczmacmini on 16/12/28.
//  Copyright © 2016年 LW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrganizationModel.h"


@interface LWQRCodeViewController : UIViewController


@property(nonatomic,copy)void(^block)(NSString *codeString);

@property(nonatomic,assign)BOOL isRelateToOrg;

@property(nonatomic,strong)OrganizationModel *orgModel;


@end
