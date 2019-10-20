//
//  IssueCell.h
//  GTHRepoNavigator
//
//  Created by SindhujaSingh on 10/15/19.
//  Copyright © 2019 SindhujaSingh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GTHIssueCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *issueTitle;
@property (weak, nonatomic) IBOutlet UIImageView *issueStateImageView;
@property (weak, nonatomic) IBOutlet UILabel *issueNumber;
@property (weak, nonatomic) IBOutlet UILabel *issueDescription;
@property (weak, nonatomic) IBOutlet UIStackView *labelStack;

@end
