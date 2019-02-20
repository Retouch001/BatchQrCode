//
//  LoginViewController.m
//  BatchQRCode
//
//  Created by 方景琦 on 2017/6/22.
//  Copyright © 2017年 miracle. All rights reserved.
//

#import "LoginViewController.h"
#import "HyLoginButton.h"
#import "HyTransitions.h"

#import "RootViewController.h"

#import "TJHApiManager.h"

#import "BatchQrNetworkingManager.h"

#import "MainUserManager.h"
#import <LocalAuthentication/LocalAuthentication.h>

#import "LXFileManager.h"

#import "FXBlurView.h"
#import "GCD.h"
@interface LoginViewController ()<UIViewControllerTransitioningDelegate>
@property (weak, nonatomic) IBOutlet UITextField *usernameTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;

@property (weak, nonatomic) IBOutlet HyLoginButton *loginBtn;

@property (weak, nonatomic) IBOutlet FXBlurView *blurView;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MainUser *user = [LXFileManager getObjectByFileName:MAIN_USER];
    if (user) {
        MAINUSERINSTANCE.user = user;
        
        [self evaluateAuthenticate];
    }
    
    self.blurView.blurRadius = 25;
    self.blurView.tintColor = [UIColor blackColor];
    self.blurView.dynamic = NO;
}


-(void)viewWillAppear:(BOOL)animated{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}


- (IBAction)LoginAction:(HyLoginButton *)button {
    WS(weakSelf);
    
    [NETWORKINGMANAGER loginWithParaId:self.usernameTF.text paraPsw:self.passwordTF.text success:^(NSDictionary *dic) {
        
        if ([dic[@"resultcode"] isEqualToString:@"SYS000"]) {
            
            MainUser *user = [MainUser modelWithDictionary:dic[@"info"]];
            
            MAINUSERINSTANCE.user = user;
            
            [LXFileManager saveObject:user byFileName:MAIN_USER];

            [button succeedAnimationWithCompletion:^{
                [weakSelf didPresentControllerButtonTouch];
            }];
        }else{
            [button failedAnimationWithCompletion:nil];
        }
    } errorresult:^(NSError *error) {
        [button failedAnimationWithCompletion:nil];
    }];
    
}


- (IBAction)showSelectServerAction:(id)sender {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:(@"请选择当前运行的环境")preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alertVC addAction:[UIAlertAction actionWithTitle:(@"客户环境")style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        TJHAPIMANAGER.appServiceBaseIP = appServiceDistribution;
        
        [[NSUserDefaults standardUserDefaults] setInteger:IBREEZEEServiceDistribution forKey:APPSERVICEFIELDCODE];
    }]];
    
    [alertVC addAction:[UIAlertAction actionWithTitle:(@"开发环境")style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        TJHAPIMANAGER.appServiceBaseIP = appServiceDevelopment;
        
        [[NSUserDefaults standardUserDefaults] setInteger:IBREEZEEServiceDevelopment forKey:APPSERVICEFIELDCODE];
        
    }]];
    
    [alertVC addAction:[UIAlertAction actionWithTitle:(@"仿真环境")style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        TJHAPIMANAGER.appServiceBaseIP = appServiceDistribution_AD_HOC;
        [[NSUserDefaults standardUserDefaults] setInteger:IBREEZEEServiceDistribution_AD_HOC forKey:APPSERVICEFIELDCODE];
        
    }]];
    
    [alertVC addAction:[UIAlertAction actionWithTitle:(@"测试环境")style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        TJHAPIMANAGER.appServiceBaseIP = appServiceTest;
        
        [[NSUserDefaults standardUserDefaults] setInteger:IBREEZEEServiceTest forKey:APPSERVICEFIELDCODE];
        
    }]];
    
    
    [alertVC addAction:[UIAlertAction actionWithTitle:(@"浩伟环境")style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        TJHAPIMANAGER.appServiceBaseIP = appServiceHAOWEI;
        [[NSUserDefaults standardUserDefaults] setInteger:IBREEZEEServiceHAOWEI forKey:APPSERVICEFIELDCODE];
        
    }]];
    
    [alertVC addAction:[UIAlertAction actionWithTitle:(@"琦哥环境")style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        TJHAPIMANAGER.appServiceBaseIP = appServiceFangjinqi;
        [[NSUserDefaults standardUserDefaults] setInteger:IBREEZEEServiceFANGJINQI forKey:APPSERVICEFIELDCODE];
        
    }]];
    
    [alertVC addAction:[UIAlertAction actionWithTitle:(@"马佩环境")style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        TJHAPIMANAGER.appServiceBaseIP = appServiceMAPEI;
        [[NSUserDefaults standardUserDefaults] setInteger:IBREEZEEServiceMAPEI forKey:APPSERVICEFIELDCODE];
        
    }]];
    
    
    [alertVC addAction:[UIAlertAction actionWithTitle:(@"取消")style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    
    
    [self presentViewController:alertVC animated:YES completion:nil];

}




- (void)PresentViewController:(HyLoginButton *)button {
}

- (void)didPresentControllerButtonTouch {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    
    UINavigationController *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"MainNavVC"];
    navigationController.transitioningDelegate = self;
    
    [self presentViewController:navigationController animated:YES completion:nil];
}



- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source {
    return [[HyTransitions alloc]initWithTransitionDuration:0.4f StartingAlpha:0.5f isPush:true];
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [[HyTransitions alloc]initWithTransitionDuration:0.4f StartingAlpha:0.8f isPush:false];
}






- (void)evaluateAuthenticate{
    //创建LAContext
    LAContext* context = [[LAContext alloc] init];
    NSError* error = nil;
    NSString* result = @"通过Home键验证已有手机指纹";
    
    //首先使用canEvaluatePolicy 判断设备支持状态
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        WS(weakSelf);
        //支持指纹验证
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:result reply:^(BOOL success, NSError *error) {
            if (success) {
                //验证成功，主线程处理UI
                [GCDQueue executeInMainQueue:^{
                    [weakSelf didPresentControllerButtonTouch];
                }];
            }
            else
            {
                NSLog(@"%@",error.localizedDescription);
                switch (error.code) {
                    case LAErrorSystemCancel:
                    {
                        //系统取消授权，如其他APP切入
                        break;
                    }
                    case LAErrorUserCancel:
                    {
                        //用户取消验证Touch ID
                        break;
                    }
                    case LAErrorAuthenticationFailed:
                    {
                        //授权失败
                        break;
                    }
                    case LAErrorPasscodeNotSet:
                    {
                        //系统未设置密码
                        break;
                    }
                    case LAErrorTouchIDNotAvailable:
                    {
                        //设备Touch ID不可用，例如未打开
                        break;
                    }
                    case LAErrorTouchIDNotEnrolled:
                    {
                        //设备Touch ID不可用，用户未录入
                        break;
                    }
                    case LAErrorUserFallback:
                    {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            //用户选择输入密码，切换主线程处理
                            
                        }];
                        break;
                    }
                    default:
                    {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            //其他情况，切换主线程处理
                        }];
                        break;
                    }
                }
            }
        }];
    }
    else
    {
        //不支持指纹识别，LOG出错误详情
        NSLog(@"不支持指纹识别");
        
        switch (error.code) {
            case LAErrorTouchIDNotEnrolled:
            {
                NSLog(@"TouchID is not enrolled");
                break;
            }
            case LAErrorPasscodeNotSet:
            {
                NSLog(@"A passcode has not been set");
                break;
            }
            default:
            {
                NSLog(@"TouchID not available");
                break;
            }
        }
        
        NSLog(@"%@",error.localizedDescription);
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
