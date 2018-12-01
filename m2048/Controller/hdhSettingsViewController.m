//
//  hdhSettingsViewController.m
//  hdh048
//
//  Created by Danqing on 3/16/14.
//  Copyright (c) 2014 Danqing. All rights reserved.
//

#import "hdhSettingsViewController.h"
#import "hdhSettingsDetailViewController.h"

@interface hdhSettingsViewController ()

@end


@implementation hdhSettingsViewController {
  IBOutlet UITableView *_tableView;
  NSArray *_options;
  NSArray *_optionSelections;
  NSArray *_optionsNotes;
}


# pragma mark - Set up

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
    [self commonInit];
  }
  return self;
}


- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
  if (self = [super initWithCoder:aDecoder]) {
    [self commonInit];
  }
  return self;
}


- (void)commonInit
{
  _options = @[@"游戏样式", @"格子数量", @"主题风格"];
  
  _optionSelections = @[@[@"随机数字 2", @"随机数字 3", @"斐波拉契"],
                        @[@"3 x 3", @"4 x 4", @"5 x 5"],
                        @[@"默认", @"鲜亮", @"冰纷欢舞"]];
  _optionsNotes = @[@"对于Fibonacci游戏，可以使用高于或低于其一级的区块来连接区块，但不能与等于它的区域连接。 对于3的幂，您需要3个连续的区块才能触发合并!",
                    @"格子越小越难! 对于5 x 5格，如果您正在玩随机数字2，则每轮将添加两个数字.",
                    @"选择你最喜欢的外观，并获得自己2048年的感觉！ 更多（和更高质量）主题正在进行中，因此请定期查看!"];
}


- (void)viewDidLoad
{
  [super viewDidLoad];
  self.navigationController.navigationBar.tintColor = [GSTATE scoreBoardColor];
  // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [_tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if ([segue.identifier isEqualToString:@"Settings Detail Segue"]) {
    hdhSettingsDetailViewController *sdvc = segue.destinationViewController;
    
    NSInteger index = [_tableView indexPathForSelectedRow].row;
    sdvc.title = [_options objectAtIndex:index];
    sdvc.options = [_optionSelections objectAtIndex:index];
    sdvc.footer = [_optionsNotes objectAtIndex:index];
  }
}

# pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return section ? 1 : _options.count;
}


- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
  if (section) return @"";
  return @"请注意:改变上面的设置将重新启动游戏.";
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Settings Cell"];
  
  if (indexPath.section) {
    cell.textLabel.text = @"About 2048";
    cell.detailTextLabel.text = @"";
//    cell.removeFromSuperview;
      cell.hidden = YES;
  } else {
    cell.textLabel.text = [_options objectAtIndex:indexPath.row];
    
    NSInteger index = [Settings integerForKey:[_options objectAtIndex:indexPath.row]];
    cell.detailTextLabel.text = [[_optionSelections objectAtIndex:indexPath.row] objectAtIndex:index];
    cell.detailTextLabel.textColor = [GSTATE scoreBoardColor];
  }

  return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (indexPath.section) {
    [self performSegueWithIdentifier:@"About Segue" sender:nil];
  } else {
    [self performSegueWithIdentifier:@"Settings Detail Segue" sender:nil];
  }
}

@end
