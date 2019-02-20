//
//  MainUser.m
//  BatchQRCode
//
//  Created by 方景琦 on 2017/6/29.
//  Copyright © 2017年 miracle. All rights reserved.
//

#import "MainUser.h"

@implementation MainUser

//重写以下几个方法(此处关系到归档和深拷贝的作用)
- (void)encodeWithCoder:(NSCoder*)aCoder {
    [self modelEncodeWithCoder:aCoder];
}

- (id)initWithCoder:(NSCoder*)aDecoder
{
    self = [super init];
    return [self modelInitWithCoder:aDecoder];
}

- (id)copyWithZone:(NSZone*)zone {
    return [self modelCopy];
}

- (NSUInteger)hash {
    return [self modelHash];
}

- (BOOL)isEqual:(id)object {
    return [self modelIsEqual:object];
}


@end

