//
//  NSString+pinyin.m
//  CFStringTransform汉字转拼音
//
//  Created by 马文星 on 15/10/30.
//  Copyright © 2015年 马文星. All rights reserved.
//

#import "NSString+pinyin.h"
#import <objc/runtime.h>

@implementation NSString (pinyin)


//pinyin
-(NSString*)transformToPinyin{
    NSMutableString *mutableString=[NSMutableString stringWithString:self];
    CFStringTransform((CFMutableStringRef)mutableString,NULL,kCFStringTransformToLatin,false);
    mutableString = (NSMutableString*)[mutableString stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:[NSLocale currentLocale]];
   mutableString = [[mutableString stringByReplacingOccurrencesOfString:@" " withString:@""] mutableCopy];
    return mutableString.lowercaseString;
}


//- (NSString *)transformToPinyinFirstLetter {
//    NSMutableString *stringM = [NSMutableString string];
//    
//    
//    NSString *temp  =  nil;
//    for(int i =0; i < [self length]; i++){
//        
//        temp = [self substringWithRange:NSMakeRange(i, 1)];
//        
//        NSMutableString *mutableString=[NSMutableString stringWithString:temp];
//        
//        CFStringTransform((CFMutableStringRef)mutableString,NULL,kCFStringTransformToLatin,false);
//        
//        mutableString = (NSMutableString*)[mutableString stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:[NSLocale currentLocale]];
//        
//        mutableString =  [[mutableString substringToIndex:1] mutableCopy];
//        
//        [stringM appendString:(NSString *)mutableString];
//        
//    }
//    
//    return stringM.lowercaseString;
//}


+ (void)load
{
    Method stringByAddingPercentEscapesUsingEncoding = class_getInstanceMethod(self, @selector(stringByAddingPercentEscapesUsingEncoding:));
    Method newstringByAddingPercentEscapesUsingEncoding = class_getInstanceMethod(self, @selector(newstringByAddingPercentEscapesUsingEncoding:));
    method_exchangeImplementations(stringByAddingPercentEscapesUsingEncoding, newstringByAddingPercentEscapesUsingEncoding);
}

- (NSString*)newstringByAddingPercentEscapesUsingEncoding:(NSStringEncoding)enc
{
    NSString* s=[self newstringByAddingPercentEscapesUsingEncoding:enc];
    if (s==nil) {
        NSString* news = [self substringToIndex:self.length-1];
        s = [news newstringByAddingPercentEscapesUsingEncoding:enc];
    }
    return s;
}

- (void)stringValue
{
    
}

@end
