//
//  QuizBaseClass.m
//
//  Created by   on 17/12/16
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "QuizBaseClass.h"
#import "QuesInfoObject.h"


NSString *const kQuizBaseClassErrorCode = @"errorCode";
NSString *const kQuizBaseClassErrorMessage = @"errorMessage";
NSString *const kQuizBaseClassResponseObject = @"responseObject";


@interface QuizBaseClass ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation QuizBaseClass

@synthesize errorCode = _errorCode;
@synthesize errorMessage = _errorMessage;
@synthesize responseArray = _responseArray;


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
            self.errorCode = [[self objectOrNilForKey:kQuizBaseClassErrorCode fromDictionary:dict] doubleValue];
            self.errorMessage = [self objectOrNilForKey:kQuizBaseClassErrorMessage fromDictionary:dict];
    NSObject *receivedQuizResponseObject = [dict objectForKey:kQuizBaseClassResponseObject];
    NSMutableArray *parsedQuizResponseObject = [NSMutableArray array];
    if ([receivedQuizResponseObject isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedQuizResponseObject) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedQuizResponseObject addObject:[QuesInfoObject modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedQuizResponseObject isKindOfClass:[NSDictionary class]]) {
       [parsedQuizResponseObject addObject:[QuesInfoObject modelObjectWithDictionary:(NSDictionary *)receivedQuizResponseObject]];
    }

    self.responseArray = [NSArray arrayWithArray:parsedQuizResponseObject];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.errorCode] forKey:kQuizBaseClassErrorCode];
    [mutableDict setValue:self.errorMessage forKey:kQuizBaseClassErrorMessage];
    NSMutableArray *tempArrayForResponseObject = [NSMutableArray array];
    for (NSObject *subArrayObject in self.responseArray) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForResponseObject addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForResponseObject addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForResponseObject] forKey:kQuizBaseClassResponseObject];

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

    self.errorCode = [aDecoder decodeDoubleForKey:kQuizBaseClassErrorCode];
    self.errorMessage = [aDecoder decodeObjectForKey:kQuizBaseClassErrorMessage];
    self.responseArray = [aDecoder decodeObjectForKey:kQuizBaseClassResponseObject];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_errorCode forKey:kQuizBaseClassErrorCode];
    [aCoder encodeObject:_errorMessage forKey:kQuizBaseClassErrorMessage];
    [aCoder encodeObject:_responseArray forKey:kQuizBaseClassResponseObject];
}

- (id)copyWithZone:(NSZone *)zone
{
    QuizBaseClass *copy = [[QuizBaseClass alloc] init];
    
    if (copy) {

        copy.errorCode = self.errorCode;
        copy.errorMessage = [self.errorMessage copyWithZone:zone];
        copy.responseArray = [self.responseArray copyWithZone:zone];
    }
    
    return copy;
}


@end
