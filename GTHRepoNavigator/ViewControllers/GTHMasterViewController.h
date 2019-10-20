//
//  MasterViewController.h
//  GTHRepoNavigator
//
//  Created by SindhujaSingh on 10/15/19.
//  Copyright © 2019 SindhujaSingh. All rights reserved.
//

#import <UIKit/UIKit.h>

//#import "GTHFoundation.h"

@class GTHDetailViewController;

@interface GTHMasterViewController : UITableViewController

///Secondary view controller of split view
@property (strong, nonatomic) GTHDetailViewController *detailViewController;

@end

