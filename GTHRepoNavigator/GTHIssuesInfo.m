//
//  IssuesInfo.m
//  GTHRepoNavigator
//
//  Created by SindhujaSingh on 10/15/19.
//  Copyright © 2019 SindhujaSingh. All rights reserved.
//

#import "GTHIssuesInfo.h"

@implementation GTHIssuesInfo

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        if (![[dict objectForKey:@"state"] isEqual: [NSNull null]]) {
            self.issueState = [NSString stringWithString:[dict valueForKey:@"state"]];
        }
        
        if (![[dict objectForKey:@"number"] isEqual: [NSNull null]]) {
            self.issueNumber = (NSNumber *)[dict valueForKey:@"number"];
        }
        
        if (![[dict objectForKey:@"user"] isEqual: [NSNull null]]) {
            NSString *user = [NSString stringWithString:[[dict objectForKey:@"user"] valueForKey:@"login"]];
            
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
            
            NSDate *date = [dateFormat dateFromString:[dict valueForKey:@"created_at"]];
            NSDate *startDate = date;
            NSDate *endDate = [NSDate date];
            
            NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            
            NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
            
            NSDateComponents *components = [gregorian components:unitFlags fromDate:startDate  toDate:endDate options:0];
            NSInteger year = [components year];
            NSInteger months = [components month];
            NSInteger days = [components day];
            NSString *description = [NSString stringWithFormat:@"Opened by %@, %ld years %ld months %ld days ago.",user,(long)year,(long)months,(long)days];
            self.issueDescription =  [NSString stringWithString:description];
            
        }
    
        if (![[dict objectForKey:@"title"] isEqual: [NSNull null]]) {
            self.issueTitle = [NSString stringWithString:[dict valueForKey:@"title"]];
        }
        
        //NSArray *labelsForIssue = [NSArray arrayWithObjects:[dict objectForKey:@"labels"], nil];
        if ([[dict objectForKey:@"labels"] count] != 0){
            self.labels = [dict objectForKey:@"labels"];
        }
//        if (![[dict objectForKey:@"labels"] isEqual: [NSNull null]]) {
//            self.issueState = [NSString stringWithString:[dict valueForKey:@"state"]];
//        }
    }
    return self;
}

+ (GTHIssuesInfo *)creatFromDictionary: (NSDictionary *)dict {
    GTHIssuesInfo *info = [[GTHIssuesInfo alloc] initWithDictionary:dict];
    return info;
}

@end
