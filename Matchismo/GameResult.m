//
//  GameResult.m
//  Matchismo
//
//  Created by Daniel Lohse on 3/26/13.
//  Copyright (c) 2013 dozeo GmbH. All rights reserved.
//

#import "GameResult.h"

@interface GameResult()
@property (readwrite, nonatomic) NSDate *start;
@property (readwrite, nonatomic) NSDate *end;
@end

@implementation GameResult

#define ALL_RESULTS_KEY @"GameResult_AllResults"
#define START_KEY @"StartDate"
#define END_KEY   @"EndDate"
#define GAME_KEY  @"Game"
#define SCORE_KEY @"Score"

+ (NSArray *)allGameResults
{
  NSMutableArray *allGameResults = [[NSMutableArray alloc] init];
  for (id plist in [[[NSUserDefaults standardUserDefaults] dictionaryForKey:ALL_RESULTS_KEY] allValues]) {
    GameResult *gameResult = [[GameResult alloc] initFromPropertyList:plist];
    [allGameResults addObject:gameResult];
  }

  return allGameResults;
}

// convenience initializer
- (id)initFromPropertyList:(id)plist
{
  self = [self init];
  if (self) {
    if ([plist isKindOfClass:[NSDictionary class]]) {
      NSDictionary *resultDictionary = (NSDictionary *)plist;
      _start = resultDictionary[START_KEY];
      _end   = resultDictionary[END_KEY];
      _game  = resultDictionary[GAME_KEY];
      if (!_game) _game = @"Card Game";
      _score = [resultDictionary[SCORE_KEY] intValue];
      if (!_start || !_end) self = nil;
    }
  }

  return self;
}

- (void)synchronize
{
  NSMutableDictionary *mutableGameResultsFromUserDefaults = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:ALL_RESULTS_KEY] mutableCopy];
  if (!mutableGameResultsFromUserDefaults) mutableGameResultsFromUserDefaults = [[NSMutableDictionary alloc] init];
  mutableGameResultsFromUserDefaults[[self.start description]] = [self asPropertyList];
  [[NSUserDefaults standardUserDefaults] setObject:mutableGameResultsFromUserDefaults forKey:ALL_RESULTS_KEY];
  [[NSUserDefaults standardUserDefaults] synchronize];
}


- (id)asPropertyList
{
  return @{ START_KEY: self.start, END_KEY: self.end, SCORE_KEY: @(self.score), GAME_KEY: self.game };
}

// designated initializer
- (id)initWithGame:(NSString *)game
{
  self = [super init];
  if (self) {
    _game  = game;
    _start = [NSDate date];
    _end   = _start;
  }
  
  return self;
}

- (NSTimeInterval)duration
{
  return [self.end timeIntervalSinceDate:self.start];
}

- (void)setScore:(int)score
{
  _score = score;
  self.end = [NSDate date];
  [self synchronize];
}

@end
