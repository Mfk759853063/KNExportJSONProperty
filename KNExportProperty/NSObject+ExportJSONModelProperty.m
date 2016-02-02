//
//  NSObject+ExportJSONModelProperty.m
//  KNExportProperty
//
//  Created by kwep_vbn on 16/2/2.
//  Copyright © 2016年 vbn. All rights reserved.
//

#define kKNPropertyType @"objectType"
#define kKNMemoryType @"objectMemoryType"

#import "NSObject+ExportJSONModelProperty.h"

@implementation NSObject (ExportJSONModelProperty)

- (void)printJSONPropertyCode:(NSDictionary *)json {
    
    if (![json isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    __block NSString *propertyPrefix = @"@property";
    __block NSString *memoryMark = @"strong";
    __block NSString *nonatomicMark = @"nonatomic";
    __block NSString *propertyType = @"";
    __block NSString *propertyKey = @"";
    __block NSMutableDictionary *sortDict = @{}.mutableCopy;
    // enumerate all object
    [json enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSDictionary *tempDict = [self getObjectMemoryTypeAndPropertyType:obj];
        memoryMark = tempDict[kKNMemoryType];
        propertyType = tempDict[kKNPropertyType];
        propertyKey = key;
        NSString *code = [NSString stringWithFormat:@"%@ (%@, %@) %@ %@;\n",propertyPrefix,memoryMark,nonatomicMark,propertyType,propertyKey];
        NSMutableArray *group = sortDict[propertyType];
        if (!group) {
            group = @[].mutableCopy;
            [sortDict setObject:group forKey:propertyType];
        }
        [group addObject:code];
    }];
    
    // sort
    NSArray *keys = [[sortDict allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    NSMutableDictionary *sortedDic = @{}.mutableCopy;
    [keys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [sortedDic setObject:sortDict[obj] forKey:obj];
    }];
    [sortedDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, NSArray * _Nonnull obj, BOOL * _Nonnull stop) {
       [obj enumerateObjectsUsingBlock:^(id  _Nonnull code, NSUInteger idx, BOOL * _Nonnull stop) {
           NSLog(@"%@",code);
       }];
    }];
}

- (NSDictionary *)getObjectMemoryTypeAndPropertyType:(id)object {
    
    if ([object isKindOfClass:[NSString class]]) {
        return @{kKNMemoryType:@"copy",kKNPropertyType:@"NSString*"};
    } else if ([object isKindOfClass:[NSArray class]]) {
        return @{kKNMemoryType:@"strong",kKNPropertyType:@"NSArray*"};
    } else if ([object isKindOfClass:[NSNumber class]] && [object isKindOfClass:NSClassFromString(@"__NSCFBoolean")]) {
        return @{kKNMemoryType:@"assgin",kKNPropertyType:@"BOOL"};
    } else if ([object isKindOfClass:[NSNumber class]] && !strcmp([object objCType], @encode(int))) {
        return @{kKNMemoryType:@"assgin",kKNPropertyType:@"NSInteger"};
    } else if ([object isKindOfClass:[NSNumber class]] && !strcmp([object objCType], @encode(unsigned int))) {
        return @{kKNMemoryType:@"assgin",kKNPropertyType:@"NSUInteger"};
    } else if ([object isKindOfClass:[NSNumber class]] && !strcmp([object objCType], @encode(long))) {
        return @{kKNMemoryType:@"assgin",kKNPropertyType:@"long"};
    } else if ([object isKindOfClass:[NSNumber class]] && !strcmp([object objCType], @encode(float))) {
        return @{kKNMemoryType:@"assgin",kKNPropertyType:@"float"};
    } else if ([object isKindOfClass:[NSNumber class]] && !strcmp([object objCType], @encode(double))) {
        return @{kKNMemoryType:@"assgin",kKNPropertyType:@"double"};
    } else if ([object isKindOfClass:[NSObject class]]){
        NSString *className = [NSString stringWithFormat:@"%s*", object_getClassName(object)];
        return @{kKNMemoryType:@"strong",kKNPropertyType:className};
    }
    return @{kKNMemoryType:@"strong",kKNPropertyType:@"unknown"};
}


@end
