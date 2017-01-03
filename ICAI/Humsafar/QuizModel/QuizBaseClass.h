//
//  QuizBaseClass.h
//
//  Created by   on 17/12/16
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface QuizBaseClass : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) double errorCode;
@property (nonatomic, strong) NSString *errorMessage;
@property (nonatomic, strong) NSArray *responseArray;

@property (nonatomic, strong) NSString *categoryId;
@property (nonatomic, strong) NSString *quizId;
@property (nonatomic, strong) NSString *studentId;
@property (nonatomic, strong) NSString *timeRemaining;
@property (nonatomic, strong) NSString *studentSessionId;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
