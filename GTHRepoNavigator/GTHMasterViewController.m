//
//  MasterViewController.m
//  GTHRepoNavigator
//
//  Created by SindhujaSingh on 10/15/19.
//  Copyright © 2019 SindhujaSingh. All rights reserved.
//

#import "GTHMasterViewController.h"
#import "GTHDetailViewController.h"
#import "GTHRepositoryInfoCell.h"
#import "GTHRepositoryInfo.h"

@interface GTHMasterViewController ()

/*List of repositories*/
@property (strong, nonatomic) NSMutableArray *repos;

@end

@implementation GTHMasterViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.detailViewController = (GTHDetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    //Creating NSURL object to send HTTP request to get all repository for given org.
    NSURL *URL = [NSURL URLWithString:@"https://api.github.com/orgs/intuit/repos"];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          UIActivityIndicatorView *activityIndicator;
                                          activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                                      
                                          //Reloading data in table view after fecthing all the repository info.
                                         activityIndicator.hidden = NO;
                                          [activityIndicator sizeToFit];
                                          [activityIndicator startAnimating];
                                          [self.view bringSubviewToFront:activityIndicator];
//                                      });
                                          NSLog(@"Status code: %ld", [(NSHTTPURLResponse *)response statusCode]);
                                      if (error != nil || [(NSHTTPURLResponse *)response statusCode] != 200) {
                                          NSLog(@"Error: %@",error);
                                          
                                          UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error while fetching repositories.." message:error.description preferredStyle:UIAlertControllerStyleAlert];
                                          
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
                                          self.repos = [[NSMutableArray alloc] init];
                                          
                                          //Json parsing using NSJSONSerialization to convert in to fondation objects.
                                          NSArray *arrayOfRepos = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                          for (NSDictionary *repo in arrayOfRepos) {
                                              
                                              //Creating RepositoryInfo model from dictionary object of a repository.
                                              GTHRepositoryInfo *repoInfo = [GTHRepositoryInfo creatFromDictionary:repo];
                                              
                                              //Adding RepositoryInfo object to array of repositories.
                                              [self.repos addObject:repoInfo];
                                          }
                                          NSLog(@"%@", self.repos);
                                          [activityIndicator stopAnimating];
//                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              //Reloading data in table view after fecthing all the repository info.
                                              [self.tableView reloadData];
//                                          });
                                      }
                                          });
                                  }];
    [task resume];
}

- (void)viewWillAppear:(BOOL)animated {
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        GTHRepositoryInfo *info = self.repos[indexPath.row];
        //Creating secondary view in split view controller to show selected repository info.
        GTHDetailViewController *controller = (GTHDetailViewController *)[[segue destinationViewController] topViewController];
        [controller setRepoInfo:info];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.repos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GTHRepositoryInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
   
    GTHRepositoryInfo *info = self.repos[indexPath.row];
    //Setting values for table cell from RepositoryInfo object.
    cell.name.text = info.name;
    UIImage *starImage = [[UIImage imageNamed:@"starFilled"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    cell.starImageView.image = starImage;
    cell.starImageView.tintColor = [UIColor purpleColor];
    cell.star.text = [info.numberOfStars stringValue];
    cell.detailDescription.text = info.repoDescription;
    UIImage *circleImage = [[UIImage imageNamed:@"circle"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    cell.languageImageView.image = circleImage;
    NSDictionary *colorDict = [self JSONFromFile];
    NSString *color = [ colorDict objectForKey:info.languageName];
    //[cell.languageImageView s
    cell.languageImageView.tintColor = [self colorWithHexString:color];
    //cell.languageImageView.backgroundColor = [self colorWithHexString:color];
    cell.language.text = info.languageName;
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (NSDictionary *)JSONFromFile
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"color" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
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
