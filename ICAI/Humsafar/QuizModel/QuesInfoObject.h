//
//  QuizResponseObject.h
//
//  Created by   on 17/12/16
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface QuesInfoObject : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *isMarkedForReview;
@property (nonatomic, strong) NSString *option3;
@property (nonatomic, strong) NSString *correctOption;
@property (nonatomic, strong) NSString *moduleName;
@property (nonatomic, strong) NSString *option2;
@property (nonatomic, strong) NSString *optionMarked;
@property (nonatomic, strong) NSString *level;
@property (nonatomic, strong) NSString *questionInstruction;
@property (nonatomic, strong) NSString *questionText;
@property (nonatomic, strong) NSString *option4;
@property (nonatomic, strong) NSString *questionId;
@property (nonatomic, strong) NSString *option1;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
