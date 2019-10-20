//
//  IssueCell.m
//  GTHRepoNavigator
//
//  Created by SindhujaSingh on 10/15/19.
//  Copyright © 2019 SindhujaSingh. All rights reserved.
//

#import "GTHIssueCell.h"

@implementation GTHIssueCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)prepareForReuse
{
    [super prepareForReuse];
    
    self.issueTitle.text = nil;
    self.issueNumber.text = nil;
    self.issueDescription.text = nil;
    self.issueStateImageView.image = nil;
    
    for(UIView *view in self.labelStack.arrangedSubviews) {
        [view removeFromSuperview];
    }
} 

@end
