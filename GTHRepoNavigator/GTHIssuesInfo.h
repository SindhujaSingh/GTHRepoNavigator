//
//  IssuesInfo.h
//  GTHRepoNavigator
//
//  Created by SindhujaSingh on 10/15/19.
//  Copyright © 2019 SindhujaSingh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GTHIssuesInfo : NSObject

@property (strong, nonatomic) NSString *issueState;
@property (strong, nonatomic) NSString *issueTitle;
@property (strong, nonatomic) NSNumber *issueNumber;
@property (strong, nonatomic) NSString *issueDescription;
@property (strong, nonatomic) NSArray *labels;


+ (GTHIssuesInfo *)creatFromDictionary: (NSDictionary *)dict;

@end
