//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Daniel Lohse on 3/23/13.
//  Copyright (c) 2013 dozeo GmbH. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()
@property (readwrite, nonatomic) int score;
@property (readwrite, nonatomic) int lastMatchScore;
@property (readwrite, nonatomic) NSMutableArray *lastFlip;
@property (strong, nonatomic) NSMutableArray *cards; // of Card
@property (strong, nonatomic) NSString *mode; // @"2-card" or @"3-card"
@end

@implementation CardMatchingGame

- (NSMutableArray *)cards
{
  if (!_cards) _cards = [[NSMutableArray alloc] init];

  return _cards;
}

- (NSMutableArray *)lastFlip
{
  if (!_lastFlip) _lastFlip = [[NSMutableArray alloc] init];

  return _lastFlip;
}

- (Card *)cardAtIndex:(NSUInteger)index
{
  return (index < [self.cards count]) ? [self.cards objectAtIndex:index] : nil;
}

- (void)flipCardAtIndex:(NSUInteger)index
{
  Card *card = [self cardAtIndex:index];
  int dealScore = 0;
  if (card && !card.isUnplayable) {
    [self resetLastFlip];
    [self.lastFlip addObject:card];
    if (!card.isFaceUp) {
      NSMutableArray *otherCards = [[NSMutableArray alloc] init];
      for (Card *otherCard in self.cards) {
        if (otherCard.isFaceUp && !otherCard.isUnplayable) {
          [otherCards addObject:otherCard];
        }
      }
      dealScore += [self match:otherCards withCard:card];
    } else {
      [self.lastFlip removeObject:card];
    }
    card.faceUp = !card.isFaceUp;
    self.score += dealScore;
    self.lastMatchScore = dealScore;
  }
}

- (void)resetLastFlip
{
  if (([self.mode isEqualToString:@"3-card"] && [self.lastFlip count] == 3) ||
      ([self.mode isEqualToString:@"2-card"] && [self.lastFlip count] == 2)) {
    [self.lastFlip removeAllObjects];
  }
}

#define FLIP_COST 1
- (int)match:(NSMutableArray *)cards withCard:(Card *)card
{
  int dealScore = 0;
  dealScore -= FLIP_COST;

  if (![cards count]) return dealScore;
  if ([self.mode isEqualToString:@"3-card"] && [cards count] < 2) {
    return dealScore;
  }

  int matchScore = [card match:cards];
  if (matchScore > 0) {
    card.unplayable = YES;
    for (Card *otherCard in cards) { otherCard.unplayable = YES; }
    dealScore += matchScore;
  } else {
    for (Card *otherCard in cards) { otherCard.faceUp = NO; }
    card.faceUp = YES;
    dealScore += matchScore;
  }

  return dealScore;
}

- (NSArray *)gameModes
{
  return @[@"2-card", @"3-card"];
}

- (id)initWithCardCount:(NSUInteger)count
              usingDeck:(Deck *)deck
               gameMode:(NSString *)gameMode
{
  self = [super init];

  if (self && [[self gameModes] containsObject:gameMode]) {
    self.mode = gameMode;
    for (int i = 0; i < count; i++) {
      Card *card = [deck drawRandomCard];
      if (card) {
        self.cards[i] = card;
      } else {
        self = nil;
        break;
      }
    }
  }

  return self;
}

@end
