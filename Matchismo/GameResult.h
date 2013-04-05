//
//  GameResult.h
//  Matchismo
//
//  Created by Daniel Lohse on 3/26/13.
//  Copyright (c) 2013 dozeo GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameResult : NSObject

+ (NSArray *)allGameResults; // of GameResult

@property (readonly, nonatomic) NSDate *start;
@property (readonly, nonatomic) NSDate *end;
@property (readonly, nonatomic) NSTimeInterval duration;
@property (nonatomic) NSString *game;
@property (nonatomic) int score;

// designated initializer
- (id)initWithGame:(NSString *)game;
@end
