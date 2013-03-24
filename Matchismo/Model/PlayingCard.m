//
//  PlayingCard.m
//  Matchismo
//
//  Created by Daniel Lohse on 3/23/13.
//  Copyright (c) 2013 dozeo GmbH. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

- (int)match:(NSArray *)otherCards
{
  int score = 0;
  NSCountedSet *counts = [[NSCountedSet alloc] initWithArray:@[self.suit, [self rankStringForRank:self.rank]]];
  
  for (PlayingCard *otherCard in otherCards) {
    [counts addObjectsFromArray:@[otherCard.suit, [self rankStringForRank:otherCard.rank]]];
  }

  for (NSString *object in counts) {
    //NSLog(@"Count for object %@: %d", object, [counts countForObject:object]);
    if ([counts countForObject:object] == 2) {
      score = [[[self class] validSuits] containsObject:object] ? 1 : 4; // 2-card game: score 1 if it's a suit, score 4 if it's a rank
    } else if ([counts countForObject:object] == 3) {
      score = [[[self class] validSuits] containsObject:object] ? 4 : 16; // 3-card game: score 4 if it's a suit, score 16 if it's a rank
      break;
    }
  }

  return score;
}

- (NSString *)contents
{
  return [[self rankStringForRank:self.rank] stringByAppendingString:self.suit];
}

@synthesize suit = _suit; // because we provide setter AND getter

+ (NSArray *)validSuits
{
  static NSArray *validSuits = nil;
  if (!validSuits) validSuits = @[@"♥",@"♦",@"♠",@"♣"];

  return validSuits;
}

- (void)setSuit:(NSString *)suit
{
  if ([[[self class] validSuits] containsObject:suit]) {
    _suit = suit;
  }
}

- (NSString *)suit
{
  return _suit ? _suit : @"?";
}

+ (NSArray *)rankStrings
{
  static NSArray *rankStrings = nil;
  if (!rankStrings) rankStrings = @[@"?", @"A", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K"];

  return rankStrings;
}

- (NSString *)rankStringForRank:(NSUInteger)rank
{
  return [[self class] rankStrings][rank];
}

+ (NSUInteger)maxRank
{
  return [self rankStrings].count - 1;
}

- (void)setRank:(NSUInteger)rank
{
  if (rank <= [[self class] maxRank]) {
    _rank = rank;
  }
}

@end
