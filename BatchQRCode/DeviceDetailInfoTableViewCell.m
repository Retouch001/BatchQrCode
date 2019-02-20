//
//  DeviceDetailInfoTableViewCell.m
//  BatchQRCode
//
//  Created by 方景琦 on 2017/7/3.
//  Copyright © 2017年 miracle. All rights reserved.
//

#import "DeviceDetailInfoTableViewCell.h"

@implementation DeviceDetailInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
#if TARGET_INTERFACE_BUILDER
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    [bundle loadNibNamed:@"DeviceDetailInfoTableViewCell" owner:self options:nil];
#else 
    [[NSBundle mainBundle] loadNibNamed:@"DeviceDetailInfoTableViewCell" owner:self options:nil];
#endif
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
