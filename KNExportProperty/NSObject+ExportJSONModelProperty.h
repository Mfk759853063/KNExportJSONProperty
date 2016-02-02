//
//  NSObject+ExportJSONModelProperty.h
//  KNExportProperty
//
//  Created by kwep_vbn on 16/2/2.
//  Copyright © 2016年 vbn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "objc/runtime.h"

@interface NSObject (ExportJSONModelProperty)

- (void)printJSONPropertyCode:(NSDictionary *)json;

@end
