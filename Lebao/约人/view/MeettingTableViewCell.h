//
//  MeettingTableViewCell.h
//  Lebao
//
//  Created by adnim on 16/9/9.
//  Copyright © 2016年 David. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeetingCellLayout.h"

@protocol MeettingTableViewDelegate <NSObject>
//约见按钮
- (void)tableViewCellDidSeleteMeetingBtn:(UIButton *)btn andIndexPath:(NSIndexPath *)indexPath;

@end
@interface MeettingTableViewCell : UITableViewCell
@property(nonatomic,strong)MeetingCellLayout *cellLayout;
@property(nonatomic,strong)NSIndexPath *indexPath;
@property(nonatomic,weak)id <MeettingTableViewDelegate > delegate;
@end
