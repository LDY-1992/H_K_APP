//
//  GosMessageCenterTableViewController.h
//  GOpenSource_AppKit
//
//  Created by Tom on 2016/12/21.
//  Copyright © 2016年 Gizwits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GosMessageCenterTableViewController : UITableViewController

+ (void)markTableViewCell:(UITableViewCell *)cell label:(UILabel *)label hasUnreadMessage:(BOOL)isRead;

@end
