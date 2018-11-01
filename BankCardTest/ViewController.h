//
//  ViewController.h
//  BankCardTest
//
//  Created by weicz on 2018/10/26.
//  Copyright © 2018年 SAIC FINANCE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *tfBankCard;
// 开户行
@property (weak, nonatomic) IBOutlet UITextField *tfBankCardCategory;
// 银行卡类型
@property (weak, nonatomic) IBOutlet UITextField *tfBankCardType;



@end

