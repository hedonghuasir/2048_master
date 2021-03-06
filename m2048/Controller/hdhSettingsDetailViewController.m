//
//  hdhSettingsDetailViewController.m
//  hdh048
//
//  Created by Danqing on 3/24/14.
//  Copyright (c) 2014 Danqing. All rights reserved.
//

#import "hdhSettingsDetailViewController.h"

@interface hdhSettingsDetailViewController ()

@end

@implementation hdhSettingsDetailViewController

- (id)initWithStyle:(UITableViewStyle)style
{
  if (self = [super initWithStyle:style]) {
    // Custom initialization
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.navigationController.navigationBar.tintColor = [GSTATE scoreBoardColor];
  [self.navigationController.navigationBar setBarTintColor:[UIColor darkGrayColor]];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

# pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return self.options.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
  return self.footer;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Settings Detail Cell"];
  
  cell.textLabel.text = [self.options objectAtIndex:indexPath.row];
  cell.accessoryType = ([Settings integerForKey:self.title] == indexPath.row) ?
  UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
  cell.tintColor = [GSTATE scoreBoardColor];
  
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [Settings setInteger:indexPath.row forKey:self.title];
  [self.tableView reloadData];
  GSTATE.needRefresh = YES;
}

@end
