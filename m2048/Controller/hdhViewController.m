//
//  hdhViewController.m
//  hdh048
//
//  Created by Danqing on 3/16/14.
//  Copyright (c) 2014 Danqing. All rights reserved.
//

#import "hdhViewController.h"
#import "hdhSettingsViewController.h"

#import "hdhScene.h"
#import "hdhGameManager.h"
#import "hdhScoreView.h"
#import "hdhOverlay.h"
#import "hdhGridView.h"
#import <AVOSCloud/AVUser.h>
#import "LCLoginViewController.h"
#import "DKSHTMLController.h"

@interface hdhViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *loading;
@end


@implementation hdhViewController {
  IBOutlet UIButton *_restartButton;
  IBOutlet UIButton *_settingsButton;
  IBOutlet UILabel *_targetScore;
  IBOutlet UILabel *_subtitle;
  IBOutlet hdhScoreView *_scoreView;
  IBOutlet hdhScoreView *_bestView;

  hdhScene *_scene;

  IBOutlet hdhOverlay *_overlay;
  IBOutlet UIImageView *_overlayBackground;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  [self updateState];
  
  _bestView.score.text = [NSString stringWithFormat:@"%ld", (long)[Settings integerForKey:@"Best Score"]];
  
  _restartButton.layer.cornerRadius = [GSTATE cornerRadius];
  _restartButton.layer.masksToBounds = YES;
  
  _settingsButton.layer.cornerRadius = [GSTATE cornerRadius];
  _settingsButton.layer.masksToBounds = YES;
  
  _overlay.hidden = YES;
  _overlayBackground.hidden = YES;
  
//   Configure the view.
  SKView * skView = (SKView *)self.view;
  
  // Create and configure the scene.
  hdhScene * scene = [hdhScene sceneWithSize:skView.bounds.size];
  scene.scaleMode = SKSceneScaleModeAspectFill;

//  // Present the scene.
  [skView presentScene:scene];
  [self updateScore:0];
  [scene startNewGame];
//
  _scene = scene;
  _scene.controller = self;
}
- (void)updateState
{
  [_scoreView updateAppearance];
  [_bestView updateAppearance];

  _restartButton.backgroundColor = [GSTATE buttonColor];
  _restartButton.titleLabel.font = [UIFont fontWithName:[GSTATE boldFontName] size:14];

  _settingsButton.backgroundColor = [GSTATE buttonColor];
  _settingsButton.titleLabel.font = [UIFont fontWithName:[GSTATE boldFontName] size:14];

  _targetScore.textColor = [GSTATE buttonColor];

  long target = [GSTATE valueForLevel:GSTATE.winningLevel];

  if (target > 100000) {
    _targetScore.font = [UIFont fontWithName:[GSTATE boldFontName] size:34];
  } else if (target < 10000) {
    _targetScore.font = [UIFont fontWithName:[GSTATE boldFontName] size:42];
  } else {
    _targetScore.font = [UIFont fontWithName:[GSTATE boldFontName] size:40];
  }

  _targetScore.text = [NSString stringWithFormat:@"%ld", target];

  _subtitle.textColor = [GSTATE buttonColor];
  _subtitle.font = [UIFont fontWithName:[GSTATE regularFontName] size:14];
  _subtitle.text = [NSString stringWithFormat:@"合并数字到达 %ld!", target];

//  _overlay.message.font = [UIFont fontWithName:[GSTATE boldFontName] size:36];
//  _overlay.keepPlaying.titleLabel.font = [UIFont fontWithName:[GSTATE boldFontName] size:17];
//  _overlay.restartGame.titleLabel.font = [UIFont fontWithName:[GSTATE boldFontName] size:17];

//  _overlay.message.textColor = [GSTATE buttonColor];
//  [_overlay.keepPlaying setTitleColor:[GSTATE buttonColor] forState:UIControlStateNormal];
//  [_overlay.restartGame setTitleColor:[GSTATE buttonColor] forState:UIControlStateNormal];
}

- (void)updateScore:(NSInteger)score
{
  _scoreView.score.text = [NSString stringWithFormat:@"%ld", (long)score];
  if ([Settings integerForKey:@"Best Score"] < score) {
    [Settings setInteger:score forKey:@"Best Score"];
    _bestView.score.text = [NSString stringWithFormat:@"%ld", (long)score];
  }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  // Pause Sprite Kit. Otherwise the dismissal of the modal view would lag.
  ((SKView *)self.view).paused = YES;
}


- (IBAction)restart:(id)sender
{
  [self hideOverlay];
  [self updateScore:0];
  [_scene startNewGame];
}


- (IBAction)keepPlaying:(id)sender
{
  [self hideOverlay];
}


- (IBAction)done:(UIStoryboardSegue *)segue
{
  ((SKView *)self.view).paused = NO;
  if (GSTATE.needRefresh) {
    [GSTATE loadGlobalState];
    [self updateState];
    [self updateScore:0];
    [_scene startNewGame];
  }
}


- (void)endGame:(BOOL)won
{
  _overlay.hidden = NO;
  _overlay.alpha = 0;
  _overlayBackground.hidden = NO;
  _overlayBackground.alpha = 0;

  if (!won) {
    _overlay.keepPlaying.hidden = YES;
    _overlay.message.text = @"游戏结束";
  } else {
    _overlay.keepPlaying.hidden = NO;
    _overlay.message.text = @"胜利!";
  }

  // Fake the overlay background as a mask on the board.
  _overlayBackground.image = [hdhGridView gridImageWithOverlay];

  // Center the overlay in the board.
  CGFloat verticalOffset = [[UIScreen mainScreen] bounds].size.height - GSTATE.verticalOffset;
  NSInteger side = GSTATE.dimension * (GSTATE.tileSize + GSTATE.borderWidth) + GSTATE.borderWidth;
  _overlay.center = CGPointMake(GSTATE.horizontalOffset + side / 2, verticalOffset - side / 2);

  [UIView animateWithDuration:0.5 delay:1.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
    _overlay.alpha = 1;
    _overlayBackground.alpha = 1;
  } completion:^(BOOL finished) {
    // Freeze the current game.
    ((SKView *)self.view).paused = YES;
  }];
}


- (void)hideOverlay
{
  ((SKView *)self.view).paused = NO;
  if (!_overlay.hidden) {
    [UIView animateWithDuration:0.5 animations:^{
      _overlay.alpha = 0;
      _overlayBackground.alpha = 0;
    } completion:^(BOOL finished) {
      _overlay.hidden = YES;
      _overlayBackground.hidden = YES;
    }];
  }
}


- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Release any cached data, images, etc that aren't in use.
}

@end
