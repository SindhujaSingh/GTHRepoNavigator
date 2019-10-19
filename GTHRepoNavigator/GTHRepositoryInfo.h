//
//  RepositoryInfo.h
//  GTHRepoNavigator
//
//  Created by SindhujaSingh on 10/15/19.
//  Copyright © 2019 SindhujaSingh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GTHRepositoryInfo : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *repoDescription;
@property (strong, nonatomic) NSNumber *numberOfStars;
@property (strong, nonatomic) NSString *languageName;

+ (GTHRepositoryInfo *)creatFromDictionary: (NSDictionary *)dict;

@end
