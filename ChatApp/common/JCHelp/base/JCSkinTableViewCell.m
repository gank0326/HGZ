//
//  SLSkinTableViewCell.m
//  Shanliao
//
//  Created by gsw on 14/12/9.
//  Copyright (c) 2014年 6rooms. All rights reserved.
//

#import "JCSkinTableViewCell.h"

#import "EventBus.h"

@implementation JCSkinTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        [self connect:@selector(changeSkin) from:[EventBus shared] with:@selector(changeSkin)];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma --mark skin beign
- (NSString *)skinKey {
    return NSStringFromClass(self.class);
}

- (void)changeSkin {
    [self applySkin:[[JCSkinManager shared] getSkin:[self skinKey]]];
}

- (void)applySkin:(NSDictionary *)properties {
}

#pragma --mark skin end


- (void)dealloc {
    [[CMSignals sharedSingleton] removeObserverBindOnSender:self];
//    DEBUG_LOG(([NSString stringWithFormat:@"%@ dealloc", [self class]]));
}

@end
