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

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
