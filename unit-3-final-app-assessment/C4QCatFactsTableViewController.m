//
//  C4QCatsTableViewController.m
//  unit-3-final-assessment
//
//  Created by Michael Kavouras on 12/17/15.
//  Copyright © 2015 Michael Kavouras. All rights reserved.
//

#import "C4QCatFactsTableViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "CatTableViewCell.h"
#import "C4QCatFactsDetailViewController.h"

#define CAT_API_URL @"http://catfacts-api.appspot.com/api/facts?number=100"

@interface C4QCatFactsTableViewController ()
@property (nonatomic) NSMutableArray *modelData;
@end

@implementation C4QCatFactsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // tell the table view to auto adjust the height of each cell
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 12.0;
    
    
    UINib *cellNib = [UINib nibWithNibName:@"CatTableViewCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:@"catFactIdentifier"];
    self.modelData = [[NSMutableArray alloc] init];
    
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    
    [manager GET:CAT_API_URL parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"loading");
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        NSError *error;
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:&error];
        
        //NSLog(@"%@", jsonDict);
        NSArray *facts = [jsonDict objectForKey:@"facts"];
        
        for ( NSString* fact in facts ) {
            

            [self.modelData addObject:fact];
        }
        
        [self.tableView reloadData];
        

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"fail:%@", error);
    }];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.modelData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"catFactIdentifier"];
    
    cell.factLabel.text= [self.modelData objectAtIndex:indexPath.row];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    C4QCatFactsDetailViewController *controller = (C4QCatFactsDetailViewController *)[self.storyboard instantiateViewControllerWithIdentifier: @"CatFactsDVC"];
    [self.navigationController pushViewController:controller animated:YES];
    controller.catFact = [self.modelData objectAtIndex:indexPath.row];
}




@end
