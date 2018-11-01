//
//  ViewController.m
//  BankCardTest
//
//  Created by weicz on 2018/10/26.
//  Copyright © 2018年 SAIC FINANCE. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () {
    NSString *cardNum;
    NSArray *dicArr;
    
    NSString *bankName;
    NSString *bankCode;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    [self getBankCardCheckCode:@"1234"];
    
    dicArr = [self getLocalFileData];
}

- (IBAction)btnGetDataClick:(id)sender {
    
    cardNum = _tfBankCard.text;
    if (cardNum != nil && ![cardNum isEqualToString:@""] && [self checkBankCard:cardNum]) {
        for (int i = 0; i < dicArr.count; i++) {
            NSDictionary *dic = dicArr[i];
            NSArray *patterns = [dic objectForKey:@"patterns"];
            for (int j=0; j<patterns.count; j++) {
                NSString *reg = [patterns[j] objectForKey:@"reg"];
                BOOL isMatched = [self isCorrect:reg :cardNum];
                if (isMatched) {
                    bankName = [dic objectForKey:@"bankName"];
                    bankCode = [dic objectForKey:@"bankCode"];
                }
            }
        }
        if ([bankName isEqualToString:@""]) {
            self.tfBankCardCategory.text = @"未知";
        } else {
            self.tfBankCardCategory.text = bankName;
        }
    }
}

/**
 * 校验银行卡号是否合法
 */
- (BOOL)checkBankCard:(NSString *)bankCard {
    
    if (bankCard.length < 15 || bankCard.length > 19) {
        return NO;
    }
    NSString *bit = [self getBankCardCheckCode:[bankCard substringToIndex:bankCard.length - 1]];
    if ([@"N" isEqualToString:bit]) {
        return NO;
    }
    unichar str = [bankCard characterAtIndex:bankCard.length - 1];
    NSString *tempStr = [NSString stringWithFormat:@"%c", str];
    return [bit isEqualToString:tempStr];
}

- (NSString *)getBankCardCheckCode:(NSString *)nonCheckCodeBankCard {
    NSString *nonCheckCodeBankCardTrim = [nonCheckCodeBankCard stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (nonCheckCodeBankCard == nil || nonCheckCodeBankCardTrim.length == 0) {
        return @"N";
    }
    NSMutableArray *temArr = [[NSMutableArray alloc] init];
    for (int i = 0; i<nonCheckCodeBankCardTrim.length; i++) {
        unichar str = [nonCheckCodeBankCardTrim characterAtIndex:i];
        NSString *tempStr = [NSString stringWithFormat:@"%c", str];
        [temArr addObject:tempStr];
    }

    int luhmSum = 0;
    for (NSInteger i = temArr.count-1, j=0; i >=0; i--, j++) {
        NSInteger k = [temArr[i] integerValue];
        if (j % 2 == 0) {
            k *= 2;
            k = k/ 10 + k % 10;
        }
        luhmSum += k;
    }
    return (luhmSum % 10 == 0) ? @"0" : [NSString stringWithFormat:@"%i", (10-luhmSum % 10)];
}

/**
 * 获取本地银行卡数据
 */
- (NSArray *)getLocalFileData {
    
    NSString *textFileContents = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"bankinfo" ofType:@"json"] encoding:NSUTF8StringEncoding error:nil];
    NSArray *dicArr = [self dictionaryWithJsonString:textFileContents];
    
    return dicArr;
}

/*!
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
- (NSArray *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSArray *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

/**
 * 根据正则表达式判断字符串是否符合校验规则
 * @pattern 正则表达式
 * @sourceStr 字符串
 */
- (BOOL)isCorrect:(NSString *)pattern :(NSString *)sourceStr {
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:sourceStr];
    return isMatch;
}


@end
