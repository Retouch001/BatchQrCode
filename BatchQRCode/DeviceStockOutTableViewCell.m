//
//  DeviceStockOutTableViewCell.m
//  BatchQRCode
//
//  Created by 方景琦 on 2017/7/3.
//  Copyright © 2017年 miracle. All rights reserved.
//

#import "DeviceStockOutTableViewCell.h"
#import <POP.h>
#import "StockOutRecordModel.h"
#import "StringAttributeHelper.h"


@interface DeviceStockOutTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *organizationNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;


@end

@implementation DeviceStockOutTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupCell];
}



-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    }
    return self;
}


-(void)loadContentUIWithModel:(NSArray *)array{
    StockOutRecordModel *firstModel = array.firstObject;
    
    self.organizationNameLabel.text = firstModel.organizationName;
    self.dateLabel.text = firstModel.stockOutDate;
    //self.contentLabel.text = [NSString stringWithFormat:@"%@等,共 %lu 条设备",firstModel.mac,array.count];
    
    
    NSString *fullStirng = [NSString stringWithFormat:@"%@等,共 %lu 条设备",firstModel.mac,array.count];
    NSMutableAttributedString *richString = [[NSMutableAttributedString alloc] initWithString:fullStirng];
    {
        FontAttribute *fontAttribute = [FontAttribute new];
        fontAttribute.font           = [UIFont systemFontOfSize:14.f];
        fontAttribute.effectRange    = NSMakeRange(0, richString.length);
        [richString addStringAttribute:fontAttribute];
    }
    
    {
        FontAttribute *fontAttribute = [FontAttribute new];
        fontAttribute.font           = [UIFont systemFontOfSize:20.f];
        fontAttribute.effectRange    = NSMakeRange(16, 1);
        [richString addStringAttribute:fontAttribute];
    }
    
    
    
    
    {
        ForegroundColorAttribute *foregroundColorAttribute = [ForegroundColorAttribute new];
        foregroundColorAttribute.color                     = [[UIColor darkGrayColor] colorWithAlphaComponent:0.65f];
        foregroundColorAttribute.effectRange               = NSMakeRange(0, richString.length);
        [richString addStringAttribute:foregroundColorAttribute];
    }
    
    {
        ForegroundColorAttribute *foregroundColorAttribute = [ForegroundColorAttribute new];
        foregroundColorAttribute.color                     = [kColorBase colorWithAlphaComponent:0.65f];
        foregroundColorAttribute.effectRange               = NSMakeRange(16, 1);
        [richString addStringAttribute:foregroundColorAttribute];
    }
    
    self.contentLabel.attributedText = richString;
    //    cell.titlelabel.attributedText = richString;
    
    
    

}


- (void)setupCell {
    
    self.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}



- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    
    [super setHighlighted:highlighted animated:animated];
    
    if (self.highlighted) {
        
        POPBasicAnimation *scaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewScaleXY];
        scaleAnimation.duration           = 0.1f;
        scaleAnimation.toValue            = [NSValue valueWithCGPoint:CGPointMake(0.95, 0.95)];
        [self.organizationNameLabel pop_addAnimation:scaleAnimation forKey:@"scaleAnimation"];
        
    } else {
        
        POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
        scaleAnimation.toValue             = [NSValue valueWithCGPoint:CGPointMake(1, 1)];
        scaleAnimation.velocity            = [NSValue valueWithCGPoint:CGPointMake(2, 2)];
        scaleAnimation.springBounciness    = 20.f;
        [self.organizationNameLabel pop_addAnimation:scaleAnimation forKey:@"scaleAnimation"];
    }
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
