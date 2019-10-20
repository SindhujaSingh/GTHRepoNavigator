//
//  DetailViewController.h
//  GTHRepoNavigator
//
//  Created by SindhujaSingh on 10/15/19.
//  Copyright © 2019 SindhujaSingh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTHRepositoryInfo.h"

@interface GTHRepoIssuesViewController : UIViewController

///Object to hold data to display for a repository.
@property (strong, nonatomic) GTHRepositoryInfo *repoInfo;

@end

