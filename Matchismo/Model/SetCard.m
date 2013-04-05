//
//  SetCard.m
//  Matchismo
//
//  Created by Daniel Lohse on 4/3/13.
//  Copyright (c) 2013 dozeo GmbH. All rights reserved.
//

#import "SetCard.h"

@implementation SetCard

- (int)match:(NSArray *)otherCards
{
  int score = 0;
  NSCountedSet *suitCounts  = [[NSCountedSet alloc] initWithArray:@[self.suit]];
  NSCountedSet *rankCounts  = [[NSCountedSet alloc] initWithArray:@[@(self.rank)]];
  NSCountedSet *colorCounts = [[NSCountedSet alloc] initWithArray:@[self.color]];
  NSCountedSet *shadeCounts = [[NSCountedSet alloc] initWithArray:@[@(self.shading)]];

  // sort each property of the card into a counted set (suit, rank, color, shade)
  // 1. If all 4 NSCountedSets have a count of 1 OR 3 then it's a set

  for (SetCard *otherCard in otherCards) {
    [suitCounts  addObject:otherCard.suit];
    [rankCounts  addObject:@(otherCard.rank)];
    [colorCounts addObject:otherCard.color];
    [shadeCounts addObject:@(otherCard.shading)];
  }

  if ([suitCounts  count] == 2) score -= 1;
  if ([rankCounts  count] == 2) score -= 1;
  if ([colorCounts count] == 2) score -= 1;
  if ([shadeCounts count] == 2) score -= 1;

  if (score == 0) {
    for (NSCountedSet *set in @[suitCounts, rankCounts, colorCounts, shadeCounts]) {
      if ([set count] == 1) { // semi high-score: property the same for all 3 cards (same suit, rank, color, or shading)
        score += 2;
      } else if ([set count] == 3) { // high-score: property different for all 3 cards (different suit, rank, color, or shading)
        score += 4;
      }
    }
  }

  return score;
}

+ (NSArray *)validSuits
{
  static NSArray *validSuits = nil;
  if (!validSuits) validSuits = @[@"▲", @"●", @"■"];

  return validSuits;
}

+ (NSArray *)rankStrings
{
  static NSArray *rankStrings = nil;
  if (!rankStrings) rankStrings = @[@"?", @"1", @"2", @"3"];

  return rankStrings;
}

+ (NSArray *)validColors
{
  static NSArray *validColors = nil;
  if (!validColors) validColors = @[@"redColor", @"greenColor", @"blueColor"];

  return validColors;
}

+ (NSArray *)validShades
{
  static NSArray *validShades = nil;
  if (!validShades) validShades = @[@0, @0.3, @1];

  return validShades;
}

- (NSString *)contents
{
  return [@"" stringByPaddingToLength:self.rank withString:self.suit startingAtIndex:0];
}

@end
