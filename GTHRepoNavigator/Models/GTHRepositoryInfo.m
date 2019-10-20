//
//  RepositoryInfo.m
//  GTHRepoNavigator
//
//  Created by SindhujaSingh on 10/15/19.
//  Copyright © 2019 SindhujaSingh. All rights reserved.
//

#import "GTHRepositoryInfo.h"

@implementation GTHRepositoryInfo

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        if (![[dict objectForKey:@"full_name"] isEqual: [NSNull null]]) {
            self.name = [NSString stringWithString:[dict valueForKey:@"full_name"]];
        }
        
        if (![[dict objectForKey:@"stargazers_count"] isEqual: [NSNull null]]) {
            self.numberOfStars = (NSNumber *)[dict valueForKey:@"stargazers_count"];
        }
        
        if (![[dict objectForKey:@"description"] isEqual: [NSNull null]]) {
            self.repoDescription = [NSString stringWithString:[dict valueForKey:@"description"]];
        }
        
        if (![[dict objectForKey:@"language"] isEqual: [NSNull null]]) {
            self.languageName = [NSString stringWithString:[dict valueForKey:@"language"]];
        }
    }
    return self;
}

+ (GTHRepositoryInfo *)creatFromDictionary: (NSDictionary *)dict {
    GTHRepositoryInfo *info = [[GTHRepositoryInfo alloc] initWithDictionary:dict];
    return info;
}

@end
