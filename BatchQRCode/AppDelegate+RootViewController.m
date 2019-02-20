//
//  AppDelegate+RootViewController.m
//  BatchQRCode
//
//  Created by 方景琦 on 2017/7/3.
//  Copyright © 2017年 miracle. All rights reserved.
//

#import "AppDelegate+RootViewController.h"
#import "LXFileManager.h"
#import "MainUser.h"
#import "MainUserManager.h"

@implementation AppDelegate (RootViewController)

-(void)setRootViewController{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

    
    MainUser *user = [LXFileManager getObjectByFileName:MAIN_USER];
    if (user) {
        
        MAINUSERINSTANCE.user = user;
        
        UINavigationController *rootVC = [storyboard instantiateViewControllerWithIdentifier:@"MainNavVC"];
        
        self.window.rootViewController = rootVC;
        

    }else{
        UIViewController *rootLoginVC = [storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
        self.window.rootViewController = rootLoginVC;
        
    }

}

@end
