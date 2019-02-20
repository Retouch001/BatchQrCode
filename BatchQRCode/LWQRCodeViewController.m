//
//  LWQRCodeViewController.m
//  LWProjectFramework
//
//  Created by bhczmacmini on 16/12/28.
//  Copyright © 2016年 LW. All rights reserved.
//

#import "LWQRCodeViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "LWQRCodeBackgroundView.h"
#import "LWQRCodeScanView.h"
#import "BatchQrNetworkingManager.h"

#import "FailDeviceModel.h"
#import "DeviceAllInfoModel.h"

#import "DeviceAllInfoTableViewController.h"

#import <UIView+WZLBadge.h>

#import "CurrentAllDevicesTableViewController.h"

#import "StockOutRecordModel.h"

#define ASLocalizedString(key)  NSLocalizedString(key, nil)


#define ScanY 180           //扫描区域y
#define ScanWidth 250       //扫描区域宽度
#define ScanHeight 250      //扫描区域高度

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;




@interface LWQRCodeViewController ()<AVCaptureMetadataOutputObjectsDelegate,UIAlertViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>{
    YYCache *cache;
}

@property(nonatomic,strong)AVCaptureDevice *device;//创建相机
@property(nonatomic,strong)AVCaptureDeviceInput *input;//创建输入设备
@property(nonatomic,strong)AVCaptureMetadataOutput *output;//创建输出设备
@property(nonatomic,strong)AVCaptureSession *session;//创建捕捉类
@property(strong,nonatomic)AVCaptureVideoPreviewLayer *preview;//视觉输出预览层
@property(strong,nonatomic)LWQRCodeScanView *scanView;
@property (weak, nonatomic) IBOutlet UIButton *scanedTotalNumberBtn;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneBarBtn;

@property(nonatomic,strong)NSMutableArray *dataArray;

@property(nonatomic,copy)NSString *currentMacString;

@end

@implementation LWQRCodeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    cache = [YYCache cacheWithName:CACHENAME];

    
    self.dataArray = [NSMutableArray array];
    
    [self capture];
    [self UI];
}


-(void)awakeFromNib{
    [super awakeFromNib];
}

- (void)dealloc
{
    self.device = nil;
    [self.session stopRunning];
    self.session = nil;
    self.input = nil;
    self.output = nil;
    self.preview = nil;
    [self.scanView stopAnimaion];
    self.scanView = nil;
}

#pragma mark - 初始化UI
- (void)UI
{
    if (!_isRelateToOrg) {
        self.doneBarBtn.enabled = NO;
        self.doneBarBtn.tintColor = [UIColor clearColor];
    }
    
    self.view.backgroundColor = [UIColor blackColor];
    
    //扫描区域
    CGRect scanFrame = CGRectMake((SCREEN_WIDTH-ScanWidth)/2, ScanY, ScanWidth, ScanHeight);
    
    // 创建view,用来辅助展示扫描的区域
    self.scanView = [[LWQRCodeScanView alloc] initWithFrame:scanFrame];
    [self.view addSubview:self.scanView];
    
    //扫描区域外的背景
    LWQRCodeBackgroundView *qrcodeBackgroundView = [[LWQRCodeBackgroundView alloc] initWithFrame:self.view.bounds];
    qrcodeBackgroundView.scanFrame = scanFrame;
    //[self.view addSubview:qrcodeBackgroundView];
    [self.view insertSubview:qrcodeBackgroundView atIndex:1];

    //提示文字
    UILabel *label = [UILabel new];
    label.text = ASLocalizedString(@"将二维码放入框内,即可自动扫描");
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = UIColorFromHexValue(0xFF4920);
    label.frame = CGRectMake(0, CGRectGetMaxY(self.scanView.frame)+10, SCREEN_WIDTH, 20);
    [self.view addSubview:label];
}

- (IBAction)doneAction:(id)sender {
    [self devicesRelateOrganizationAction];
}

-(void)devicesRelateOrganizationAction{
    if (self.dataArray.count>0) {
        [self.session stopRunning];
        [self.scanView stopAnimaion];
        
        NSString *string = [NSString stringWithFormat:@"您本次共扫描%lu个设备,按确定键将本批次设备录入到 %@ 机构下。",(unsigned long)self.dataArray.count,self.orgModel.name];
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:string preferredStyle:UIAlertControllerStyleAlert];
        
        WS(weakSelf);
        
        [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:YES completion:nil];
            
        }]];

        
        [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSString *string;
            for (int i = 0; i<weakSelf.dataArray.count; i++) {
                StockOutRecordModel *recordModel = weakSelf.dataArray[i];                
                if (i == 0) {
                    string = recordModel.mac;
                }else{
                    string = [string stringByAppendingString:[NSString stringWithFormat:@"@%@",recordModel.mac]];
                }
            }
            
            [SVProgressHUD showWithStatus:@"正在写入中..."];
            [NETWORKINGMANAGER devicesRelateOtherOrganizationWithMacString:string organizationID:weakSelf.orgModel.organization_id success:^(NSDictionary *dic) {
                
                NSArray *failArray = [NSArray modelArrayWithClass:[FailDeviceModel class] json:dic[@"results"]];
                
                for (int i = 0; i<_dataArray.count; i++) {
                    StockOutRecordModel *recordModel = _dataArray[i];
                    
                    for (int j = 0; j<failArray.count; j++) {
                        FailDeviceModel *failModel = failArray[j];
                        
                        if ([recordModel.mac isEqualToString:failModel.mac]) {
                            if (failModel.deviceExist) {
                                recordModel.result = @"设备正在使用中";
                            }else{
                                recordModel.result = @"设备在服务器无记录";
                            }
                        }
                    }
                }
                
                
                NSMutableArray *totalArray = [NSMutableArray array];
                NSMutableArray *tempArray = (NSMutableArray *)[cache objectForKey:CACHEKEY];
                
                if (tempArray) {
                    totalArray = tempArray;
                }
                [totalArray insertObject:_dataArray atIndex:0];
                
                [cache.diskCache setObject:totalArray forKey:CACHEKEY];
                
                if (failArray.count>0) {
                    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"本次入库共有%ld条设备入库失败,详情请在记录中查看",failArray.count] preferredStyle:UIAlertControllerStyleAlert];
                    
                    [alertVC addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                        [weakSelf.navigationController popViewControllerAnimated:YES];
                        
                    }]];
                    
                    [weakSelf presentViewController:alertVC animated:YES completion:nil];

                }else{
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }
                
                
            } errorresult:^(NSError *error) {
                
            }];
        }]];
        
        [self presentViewController:alertVC animated:YES completion:nil];
    }else{
    }
}

-(void)getDeviceDetailInformationWithMac:(NSString *)mac{
    [self.session stopRunning];
    [self.scanView stopAnimaion];
    
    WS(weakSelf);
    [SVProgressHUD showWithStatus:@"正在获取设备信息..."];
    [NETWORKINGMANAGER getDeviceDetailInfoInDataBaseWithDevicesString:mac success:^(NSDictionary *dic) {
        
        NSArray *array = dic[@"tips"];
        NSDictionary *dict = array.firstObject;
        
        DeviceAllInfoModel *model = [DeviceAllInfoModel modelWithDictionary:dict];
        
        if (!model.exist) {
            [SVProgressHUD showInfoWithStatus:@"该设备没有记录到服务器"];
        }else{
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            DeviceAllInfoTableViewController *VC = [storyboard instantiateViewControllerWithIdentifier:@"DeviceInfoVC"];
            VC.model = model;
            [weakSelf presentViewController:VC animated:YES completion:nil];
        }
    } errorresult:^(NSError *error) {
        
    }];
}

- (IBAction)showCurrentDevicesListAction:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    CurrentAllDevicesTableViewController *devicesVC = [storyboard instantiateViewControllerWithIdentifier:@"CurrentDevicesVC"];
    devicesVC.dataArray = self.dataArray;    
    [self.navigationController pushViewController:devicesVC animated:YES];
}


#pragma mark - 菜单按钮点击事件
- (IBAction)flashlightAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    Class capture = NSClassFromString(@"AVCaptureDevice");
    if (capture != nil) {
        if ([self.device hasTorch] && [self.device hasFlash]) {
            [self.device lockForConfiguration:nil];
            
            button.selected = !button.selected;
            if (button.selected) {
                [self.device setTorchMode:AVCaptureTorchModeOn];
                [self.device setFlashMode:AVCaptureFlashModeOn];
            } else {
                [self.device setTorchMode:AVCaptureTorchModeOff];
                [self.device setFlashMode:AVCaptureFlashModeOff];
            }
            [self.device unlockForConfiguration];
        }
    }
}

- (IBAction)albumAction:(id)sender {
    UIImagePickerController *imagrPicker = [[UIImagePickerController alloc]init];
    imagrPicker.delegate = self;
    imagrPicker.allowsEditing = YES;
    //将来源设置为相册
    imagrPicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
    [self presentViewController:imagrPicker animated:YES completion:nil];
}


#pragma mark - 从相册选择识别二维码
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //获取选中的照片
    UIImage *image = info[UIImagePickerControllerEditedImage];
    
    if (!image) {
        image = info[UIImagePickerControllerOriginalImage];
    }
    //初始化  将类型设置为二维码
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:nil];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        //设置数组，放置识别完之后的数据
        NSArray *features = [detector featuresInImage:[CIImage imageWithData:UIImagePNGRepresentation(image)]];
        //判断是否有数据（即是否是二维码）
        if (features.count >= 1) {
            //取第一个元素就是二维码所存放的文本信息
            CIQRCodeFeature *feature = features[0];
            NSString *scannedResult = feature.messageString;
            
            self.block(scannedResult);
            
            [self.navigationController popViewControllerAnimated:YES];

        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"扫描结果"
                                                            message:@"不是二维码图片"
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"确定", nil];
            [self.view addSubview:alert];
            [alert show];
        }
    }];
    
}

#pragma mark - 初始化扫描设备
- (void)capture
{
    //如果是模拟器返回（模拟器获取不到摄像头）
    if (TARGET_IPHONE_SIMULATOR) {
        return;
    }
    
    // 下面的是比较重要的,也是最容易出现崩溃的原因,就是我们的输出流的类型
    // 1.这里可以设置多种输出类型,这里必须要保证session层包括输出流
    // 2.必须要当前项目访问相机权限必须通过,所以最好在程序进入当前页面的时候进行一次权限访问的判断
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authStatus ==AVAuthorizationStatusRestricted|| authStatus ==AVAuthorizationStatusDenied){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请在iPhone的“设置”-“隐私”-“相机”功能中，找到“iBreezee应用”打开相机访问权限" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    //初始化基础"引擎"Device
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //初始化输入流 Input,并添加Device
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    //初始化输出流Output
    self.output = [[AVCaptureMetadataOutput alloc] init];
    
    //设置输出流的相关属性
    // 确定输出流的代理和所在的线程,这里代理遵循的就是上面我们在准备工作中提到的第一个代理,至于线程的选择,建议选在主线程,这样方便当前页面对数据的捕获.
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    //设置扫描区域的大小 rectOfInterest  默认值是CGRectMake(0, 0, 1, 1) 按比例设置
    self.output.rectOfInterest = CGRectMake(ScanY/SCREEN_HEIGHT,((SCREEN_WIDTH-ScanWidth)/2)/SCREEN_WIDTH,ScanHeight/SCREEN_HEIGHT,ScanWidth/SCREEN_WIDTH);
    
    /*
     // AVCaptureSession 预设适用于高分辨率照片质量的输出
     AVF_EXPORT NSString *const AVCaptureSessionPresetPhoto NS_AVAILABLE(10_7, 4_0) __TVOS_PROHIBITED;
     // AVCaptureSession 预设适用于高分辨率照片质量的输出
     AVF_EXPORT NSString *const AVCaptureSessionPresetHigh NS_AVAILABLE(10_7, 4_0) __TVOS_PROHIBITED;
     // AVCaptureSession 预设适用于中等质量的输出。 实现的输出适合于在无线网络共享的视频和音频比特率。
     AVF_EXPORT NSString *const AVCaptureSessionPresetMedium NS_AVAILABLE(10_7, 4_0) __TVOS_PROHIBITED;
     // AVCaptureSession 预设适用于低质量的输出。为了实现的输出视频和音频比特率适合共享 3G。
     AVF_EXPORT NSString *const AVCaptureSessionPresetLow NS_AVAILABLE(10_7, 4_0) __TVOS_PROHIBITED;
     */
    
    // 初始化session
    self.session = [[AVCaptureSession alloc]init];
    // 设置session类型,AVCaptureSessionPresetHigh 是 sessionPreset 的默认值。
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    
    //将输入流和输出流添加到session中
    // 添加输入流
    if ([_session canAddInput:self.input]) {
        [_session addInput:self.input];
    }
    // 添加输出流
    if ([_session canAddOutput:self.output]) {
        [_session addOutput:self.output];
        
        //扫描格式
        NSMutableArray *metadataObjectTypes = [NSMutableArray array];
        [metadataObjectTypes addObjectsFromArray:@[
                                                   AVMetadataObjectTypeQRCode,
                                                   AVMetadataObjectTypeEAN13Code,
                                                   AVMetadataObjectTypeEAN8Code,
                                                   AVMetadataObjectTypeCode128Code,
                                                   AVMetadataObjectTypeCode39Code,
                                                   AVMetadataObjectTypeCode93Code,
                                                   AVMetadataObjectTypeCode39Mod43Code,
                                                   AVMetadataObjectTypePDF417Code,
                                                   AVMetadataObjectTypeAztecCode,
                                                   AVMetadataObjectTypeUPCECode,
                                                   ]];
        
        // >= ios 8
        if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1) {
            [metadataObjectTypes addObjectsFromArray:@[AVMetadataObjectTypeInterleaved2of5Code,
                                                       AVMetadataObjectTypeITF14Code,
                                                       AVMetadataObjectTypeDataMatrixCode]];
        }
        //设置扫描格式
        self.output.metadataObjectTypes= metadataObjectTypes;
    }
    
    
    //设置输出展示平台AVCaptureVideoPreviewLayer
    // 初始化
    self.preview =[AVCaptureVideoPreviewLayer layerWithSession:_session];
    // 设置Video Gravity,顾名思义就是视频播放时的拉伸方式,默认是AVLayerVideoGravityResizeAspect
    // AVLayerVideoGravityResizeAspect 保持视频的宽高比并使播放内容自动适应播放窗口的大小。
    // AVLayerVideoGravityResizeAspectFill 和前者类似，但它是以播放内容填充而不是适应播放窗口的大小。最后一个值会拉伸播放内容以适应播放窗口.
    // 因为考虑到全屏显示以及设备自适应,这里我们采用fill填充
    self.preview.videoGravity =AVLayerVideoGravityResizeAspectFill;
    // 设置展示平台的frame
    self.preview.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    // 因为 AVCaptureVideoPreviewLayer是继承CALayer,所以添加到当前view的layer层
    [self.view.layer insertSublayer:self.preview atIndex:0];
    
    //开始
    [self.session startRunning];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];

    NSDictionary * dict=[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;


    [self.session startRunning];
    [self.scanView startAnimaion];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];

    NSDictionary * dict=[NSDictionary dictionaryWithObject:[UIColor blackColor] forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;

    
    [self.session stopRunning];
    [self.scanView stopAnimaion];
}


#pragma mark - AVCaptureMetadataOutputObjectsDelegate
#pragma mark - 扫描结果处理
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    //扫描成功播放音效
    [self playSoundEffect:@"Qcodesound.caf"];
    //[self systemSound];
    [self systemVibrate];
    
    // 判断扫描结果的数据是否存在
    if ([metadataObjects count] >0){
        // 如果存在数据,停止扫描(批量配置无需停止)
        [self.session stopRunning];
        [self.scanView stopAnimaion];
        
        
        // AVMetadataMachineReadableCodeObject是AVMetadataObject的具体子类定义的特性检测一维或二维条形码。
        // AVMetadataMachineReadableCodeObject代表一个单一的照片中发现机器可读的代码。这是一个不可变对象描述条码的特性和载荷。
        // 在支持的平台上,AVCaptureMetadataOutput输出检测机器可读的代码对象的数组
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
    
        // 获取扫描到的信息
        NSString *stringValue = metadataObject.stringValue;
        
        
        //NSLog(@"----------%@",stringValue);
        
        if (stringValue.length>12&&[stringValue containsString:@"&"]) {
            NSArray *array = [stringValue componentsSeparatedByString:@"&"];
            NSString *string = array.lastObject;
            if (string.length == 12) {
                stringValue = string;
            }else{
                [SVProgressHUD showErrorWithStatus:@"不识别此二维码"];
                return;
            }
        }else{
            [SVProgressHUD showErrorWithStatus:@"不识别此二维码"];
            return;
        }
        
        
        if (!_isRelateToOrg) {
            [self getDeviceDetailInformationWithMac:stringValue];
            return;
        }else{
            //单次定时器
            double delayInSeconds = 1.0;
            
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            WS(weakSelf);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [weakSelf.session startRunning];
                [weakSelf.scanView startAnimaion];
            });
        }
        
        
        
        BOOL sameDevice = NO;
        for (StockOutRecordModel *model in self.dataArray) {
            if ([model.mac isEqualToString:stringValue]) {
                sameDevice = YES;
            }
        }
        if (sameDevice) {
            [SVProgressHUD showErrorWithStatus:@"重复Mac,忽略本次扫描"];
            return;
        }
        
        
        StockOutRecordModel *recordModel = [[StockOutRecordModel alloc] init];
        recordModel.organizationName = self.orgModel.name;
        recordModel.stockOutDate = [[NSDate date] stringWithFormat:@"MM-dd HH:mm"];
        recordModel.mac = stringValue;
        
        [self.dataArray addObject:recordModel];
        
        self.scanedTotalNumberBtn.hidden = NO;
        [self.scanedTotalNumberBtn showBadgeWithStyle:WBadgeStyleNumber value:self.dataArray.count animationType:WBadgeAnimTypeBounce];
        
    }
}






#pragma mark - - - 扫描提示声
/** 播放音效文件 */
- (void)playSoundEffect:(NSString *)name{
    // 获取音效
    NSString *audioFile = [[NSBundle mainBundle] pathForResource:name ofType:nil];
    NSURL *fileUrl = [NSURL fileURLWithPath:audioFile];
    
    // 1、获得系统声音ID
    SystemSoundID soundID = 0;
    
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(fileUrl), &soundID);
    
    // 如果需要在播放完之后执行某些操作，可以调用如下方法注册一个播放完成回调函数
    AudioServicesAddSystemSoundCompletion(soundID, NULL, NULL, soundCompleteCallback, NULL);
    
    // 2、播放音频
    AudioServicesPlaySystemSound(soundID); // 播放音效
}

/**
 *  播放完成回调函数
 *
 *  @param soundID    系统声音ID
 *  @param clientData 回调时传递的数据
 */
void soundCompleteCallback(SystemSoundID soundID, void *clientData){
    //NSLog(@"播放完成...");
}



#pragma mark- 震动、声音效果

#define SOUNDID  1109  //1012 -iphone   1152 ipad  1109 ipad
-(void)systemVibrate
{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

-(void)systemSound
{
    AudioServicesPlaySystemSound(SOUNDID);
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
