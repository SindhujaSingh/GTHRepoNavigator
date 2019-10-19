//
//  DetailViewController.m
//  GTHRepoNavigator
//
//  Created by SindhujaSingh on 10/15/19.
//  Copyright © 2019 SindhujaSingh. All rights reserved.
//

#import "GTHDetailViewController.h"
#import "GTHIssueCell.h"
#import "GTHIssuesInfo.h"

@interface GTHDetailViewController ()

@property (strong, nonatomic) NSMutableArray *openIssues;
@property (strong, nonatomic) NSMutableArray *closedIssues;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (strong, nonatomic) NSArray *issues;

// Action called when segmented control switch selection changes.
- (IBAction)switchIssues:(UISegmentedControl *)sender;

@end

@implementation GTHDetailViewController

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.repoInfo) {
        self.title = self.repoInfo.name;
    }
    //TODO: - This need to go somewhere else.
    //Creating NSURL object to send HTTP request to get all the issues for selected repository.
    NSString *url = [NSString stringWithFormat:@"https://api.github.com/repos/%@/issues?state=all",self.repoInfo.name];
    NSURL *URL = [NSURL URLWithString:url];
    [self fetchIssuesWithURL:URL];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
   // [self configureView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Managing the detail item

- (void)setRepoInfo:(GTHRepositoryInfo *)repoInfo {
    if (_repoInfo != repoInfo) {
        _repoInfo = repoInfo;
        
        // Update the view.
        [self configureView];
    }
}


- (void) fetchIssuesWithURL:(NSURL *)url {
    // TODO: - May be call this from a separate framework.
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:2.0];
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      if (error != nil || [(NSHTTPURLResponse *)response statusCode] != 200) {
                                          NSLog(@"Error: %@",error);
                                          UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error while fetchign issues" message:error.description preferredStyle:UIAlertControllerStyleAlert];
                                          UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                              return;
                                          }];
                                          [alert addAction:ok];
                                          [self presentViewController:alert animated:true completion:^{
                                              return;
                                          }];
                                          
                                      } else {
                                          // ...
                                          //Arrays initialization..
                                          self.openIssues = [[NSMutableArray alloc] init];
                                          self.closedIssues = [[NSMutableArray alloc] init];
                                          
                                          //Json parsing using NSJSONSerialization to convert in to fondation objects.
                                          NSArray *issues = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                          
                                          for (NSDictionary *issue in issues) {
                                              
                                              //Creating IssuesInfo model from dictionary object from a issue.
                                              GTHIssuesInfo *issueInfo = [GTHIssuesInfo creatFromDictionary:issue];
                                              
                                              if([[issueInfo issueState] isEqualToString:@"open"]){
                                                  
                                                  //Adding IssuesInfo object to array of open issues.
                                                  [self.openIssues addObject:issueInfo];
                                              } else if ([[issueInfo issueState] isEqualToString:@"closed"]){
                                                  
                                                  //Adding IssuesInfo object to array of closed issues.
                                                  [self.closedIssues addObject:issueInfo];
                                              }
                                          }
                                          NSLog(@"%@", self.openIssues);
                                          NSLog(@"%@", self.closedIssues);
                                          
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              [self.tableView reloadData];
                                          });
                                      }
                                  }];
    
    [task resume];
}


- (IBAction)switchIssues:(UISegmentedControl *)sender {
    [self.tableView reloadData];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.segmentedControl.selectedSegmentIndex == 0) {
        return self.openIssues.count;
    } else {
        return self.closedIssues.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIImage *statusImage;
    
    GTHIssueCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    if (self.segmentedControl.selectedSegmentIndex == 0) {
        self.issues = self.openIssues;
    } else {
        self.issues = self.closedIssues;
    }
    GTHIssuesInfo *info = self.issues[indexPath.row];
    NSArray *array = [NSArray arrayWithArray:info.labels];
    //NSDictionary *dict = [[NSDictionary alloc] initWithDictionary:<#(nonnull NSDictionary *)#>];
    if([[info issueState] isEqualToString:@"open"]) {
        statusImage = [[UIImage imageNamed:@"starFilled"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    } else {
        statusImage = [[UIImage imageNamed:@"starHollow"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    
    //Setting values for table cell from IssueInfoInfo object.
    cell.issueStateImageView.image = statusImage;
    //cell.starImageView.tintColor = [UIColor purpleColor];
    cell.issueNumber.text = [NSString stringWithFormat:@"#%@",[info.issueNumber stringValue]];
    cell.issueDescription.text = info.issueDescription;
    cell.issueTitle.text = info.issueTitle;
    if ([array count] !=0) {
        for (NSDictionary *dict in array) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
            [button setTitle:[dict valueForKey:@"name"] forState:UIControlStateNormal];
            [button setBackgroundColor:[self colorWithHexString:[dict valueForKey:@"color"]]];
            //button.layer.cornerRadius =[button.layer frame].size.height * 0.20;
//            if (cell.labelStack.arrangedSubviews) {
//                for (UIView *view in cell.labelStack.arrangedSubviews) {
//                    [cell.labelStack removeArrangedSubview:view];
//                }
//            }
            [cell.labelStack addArrangedSubview:button];
        }
    }
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (UIColor *)colorWithHexString:(NSString *)colorString
{
    colorString = [colorString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    
    if (colorString.length == 3)
        colorString = [NSString stringWithFormat:@"%c%c%c%c%c%c",
                       [colorString characterAtIndex:0], [colorString characterAtIndex:0],
                       [colorString characterAtIndex:1], [colorString characterAtIndex:1],
                       [colorString characterAtIndex:2], [colorString characterAtIndex:2]];
    
    if (colorString.length == 6)
    {
        int r, g, b;
        sscanf([colorString UTF8String], "%2x%2x%2x", &r, &g, &b);
        return [UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:1.0];
    }
    return nil;
}

@end
