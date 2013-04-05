//
//  GameResultViewController.m
//  Matchismo
//
//  Created by Daniel Lohse on 3/25/13.
//  Copyright (c) 2013 dozeo GmbH. All rights reserved.
//

#import "GameResultViewController.h"
#import "GameResult.h"
#import "GameResultsTableView.h"

@interface GameResultViewController() <UITableViewDataSource>
@property (nonatomic, strong) NSArray *allGameResults;
@property (weak, nonatomic) IBOutlet GameResultsTableView *gameResultsTableView;
@end

@implementation GameResultViewController

@synthesize allGameResults = _allGameResults; // needed because we're implementing both getter and setter

- (NSArray *)allGameResults
{
  if (!_allGameResults) _allGameResults = [GameResult allGameResults];

  return _allGameResults;
}

- (void)setAllGameResults:(NSArray *)allGameResults
{
  _allGameResults = allGameResults;

  [self.gameResultsTableView reloadData]; // refresh table view
}

- (void)updateUI
{
  self.allGameResults = nil; // needs to be reloaded every time this view is refreshed
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [self.allGameResults count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GameResultCell" forIndexPath:indexPath];
  GameResult *result = self.allGameResults[indexPath.item];
  cell.detailTextLabel.text = [NSString stringWithFormat:@"%d points in %0gs", result.score, round(result.duration)];
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateStyle:NSDateFormatterShortStyle];
  [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
  cell.textLabel.text = [NSString stringWithFormat:@"%@ on %@", result.game, [dateFormatter stringFromDate:result.end]];

  return cell;
}

- (void)sortGameResultsByKey:(NSString *)key ascending:(BOOL)ascending
{
  self.allGameResults = [self.allGameResults sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:key ascending:ascending]]];
}

- (IBAction)orderResultsByDate
{
  [self sortGameResultsByKey:@"end" ascending:NO];
}

- (IBAction)orderResultsByScore
{
  [self sortGameResultsByKey:@"score" ascending:NO];
}

- (IBAction)orderResultsByDuration
{
  [self sortGameResultsByKey:@"duration" ascending:NO];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];

  [self updateUI];
  [self sortGameResultsByKey:@"score" ascending:NO];
}

- (void)setup
{
  // initialization that can't wait until viewDidLoad
}

- (void)awakeFromNib
{
  [self setup];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  [self setup];

  return self;
}

@end
