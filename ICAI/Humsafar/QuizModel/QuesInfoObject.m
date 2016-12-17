//
//  QuizResponseObject.m
//
//  Created by   on 17/12/16
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "QuesInfoObject.h"


NSString *const kQuizResponseObjectIsMarkedForReview = @"isMarkedForReview";
NSString *const kQuizResponseObjectOption3 = @"option3";
NSString *const kQuizResponseObjectCorrectOption = @"correctOption";
NSString *const kQuizResponseObjectModuleName = @"moduleName";
NSString *const kQuizResponseObjectOption2 = @"option2";
NSString *const kQuizResponseObjectOptionMarked = @"optionMarked";
NSString *const kQuizResponseObjectLevel = @"level";
NSString *const kQuizResponseObjectQuestionInstruction = @"questionInstruction";
NSString *const kQuizResponseObjectQuestionText = @"questionText";
NSString *const kQuizResponseObjectOption4 = @"option4";
NSString *const kQuizResponseObjectQuestionId = @"questionId";
NSString *const kQuizResponseObjectOption1 = @"option1";


@interface QuesInfoObject ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation QuesInfoObject

@synthesize isMarkedForReview = _isMarkedForReview;
@synthesize option3 = _option3;
@synthesize correctOption = _correctOption;
@synthesize moduleName = _moduleName;
@synthesize option2 = _option2;
@synthesize optionMarked = _optionMarked;
@synthesize level = _level;
@synthesize questionInstruction = _questionInstruction;
@synthesize questionText = _questionText;
@synthesize option4 = _option4;
@synthesize questionId = _questionId;
@synthesize option1 = _option1;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
            self.isMarkedForReview = [self objectOrNilForKey:kQuizResponseObjectIsMarkedForReview fromDictionary:dict];
            self.option3 = [self objectOrNilForKey:kQuizResponseObjectOption3 fromDictionary:dict];
            self.correctOption = [self objectOrNilForKey:kQuizResponseObjectCorrectOption fromDictionary:dict];
            self.moduleName = [self objectOrNilForKey:kQuizResponseObjectModuleName fromDictionary:dict];
            self.option2 = [self objectOrNilForKey:kQuizResponseObjectOption2 fromDictionary:dict];
            self.optionMarked = [self objectOrNilForKey:kQuizResponseObjectOptionMarked fromDictionary:dict];
            self.level = [self objectOrNilForKey:kQuizResponseObjectLevel fromDictionary:dict];
            self.questionInstruction = [self objectOrNilForKey:kQuizResponseObjectQuestionInstruction fromDictionary:dict];
            self.questionText = [self objectOrNilForKey:kQuizResponseObjectQuestionText fromDictionary:dict];
            self.option4 = [self objectOrNilForKey:kQuizResponseObjectOption4 fromDictionary:dict];
            self.questionId = [self objectOrNilForKey:kQuizResponseObjectQuestionId fromDictionary:dict];
            self.option1 = [self objectOrNilForKey:kQuizResponseObjectOption1 fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.isMarkedForReview forKey:kQuizResponseObjectIsMarkedForReview];
    [mutableDict setValue:self.option3 forKey:kQuizResponseObjectOption3];
    [mutableDict setValue:self.correctOption forKey:kQuizResponseObjectCorrectOption];
    [mutableDict setValue:self.moduleName forKey:kQuizResponseObjectModuleName];
    [mutableDict setValue:self.option2 forKey:kQuizResponseObjectOption2];
    [mutableDict setValue:self.optionMarked forKey:kQuizResponseObjectOptionMarked];
    [mutableDict setValue:self.level forKey:kQuizResponseObjectLevel];
    [mutableDict setValue:self.questionInstruction forKey:kQuizResponseObjectQuestionInstruction];
    [mutableDict setValue:self.questionText forKey:kQuizResponseObjectQuestionText];
    [mutableDict setValue:self.option4 forKey:kQuizResponseObjectOption4];
    [mutableDict setValue:self.questionId forKey:kQuizResponseObjectQuestionId];
    [mutableDict setValue:self.option1 forKey:kQuizResponseObjectOption1];

    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description 
{
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}


#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];

    self.isMarkedForReview = [aDecoder decodeObjectForKey:kQuizResponseObjectIsMarkedForReview];
    self.option3 = [aDecoder decodeObjectForKey:kQuizResponseObjectOption3];
    self.correctOption = [aDecoder decodeObjectForKey:kQuizResponseObjectCorrectOption];
    self.moduleName = [aDecoder decodeObjectForKey:kQuizResponseObjectModuleName];
    self.option2 = [aDecoder decodeObjectForKey:kQuizResponseObjectOption2];
    self.optionMarked = [aDecoder decodeObjectForKey:kQuizResponseObjectOptionMarked];
    self.level = [aDecoder decodeObjectForKey:kQuizResponseObjectLevel];
    self.questionInstruction = [aDecoder decodeObjectForKey:kQuizResponseObjectQuestionInstruction];
    self.questionText = [aDecoder decodeObjectForKey:kQuizResponseObjectQuestionText];
    self.option4 = [aDecoder decodeObjectForKey:kQuizResponseObjectOption4];
    self.questionId = [aDecoder decodeObjectForKey:kQuizResponseObjectQuestionId];
    self.option1 = [aDecoder decodeObjectForKey:kQuizResponseObjectOption1];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_isMarkedForReview forKey:kQuizResponseObjectIsMarkedForReview];
    [aCoder encodeObject:_option3 forKey:kQuizResponseObjectOption3];
    [aCoder encodeObject:_correctOption forKey:kQuizResponseObjectCorrectOption];
    [aCoder encodeObject:_moduleName forKey:kQuizResponseObjectModuleName];
    [aCoder encodeObject:_option2 forKey:kQuizResponseObjectOption2];
    [aCoder encodeObject:_optionMarked forKey:kQuizResponseObjectOptionMarked];
    [aCoder encodeObject:_level forKey:kQuizResponseObjectLevel];
    [aCoder encodeObject:_questionInstruction forKey:kQuizResponseObjectQuestionInstruction];
    [aCoder encodeObject:_questionText forKey:kQuizResponseObjectQuestionText];
    [aCoder encodeObject:_option4 forKey:kQuizResponseObjectOption4];
    [aCoder encodeObject:_questionId forKey:kQuizResponseObjectQuestionId];
    [aCoder encodeObject:_option1 forKey:kQuizResponseObjectOption1];
}

- (id)copyWithZone:(NSZone *)zone
{
    QuesInfoObject *copy = [[QuesInfoObject alloc] init];
    
    if (copy) {

        copy.isMarkedForReview = [self.isMarkedForReview copyWithZone:zone];
        copy.option3 = [self.option3 copyWithZone:zone];
        copy.correctOption = [self.correctOption copyWithZone:zone];
        copy.moduleName = [self.moduleName copyWithZone:zone];
        copy.option2 = [self.option2 copyWithZone:zone];
        copy.optionMarked = [self.optionMarked copyWithZone:zone];
        copy.level = [self.level copyWithZone:zone];
        copy.questionInstruction = [self.questionInstruction copyWithZone:zone];
        copy.questionText = [self.questionText copyWithZone:zone];
        copy.option4 = [self.option4 copyWithZone:zone];
        copy.questionId = [self.questionId copyWithZone:zone];
        copy.option1 = [self.option1 copyWithZone:zone];
    }
    
    return copy;
}


@end
