//
//  Card.m
//  Matchismo
//
//  Created by Daniel Lohse on 3/23/13.
//  Copyright (c) 2013 dozeo GmbH. All rights reserved.
//

#import "Card.h"

@implementation Card

- (NSString *)description
{
  return self.contents;
}

- (int)match:(NSArray *)otherCards
{
  int score = 0;

  for (Card *card in otherCards) {
    if ([card.contents isEqualToString:self.contents]) {
      score = 1;
    }
  }

  return score;
}

@end
