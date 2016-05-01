//
//  FJSRegisterController.m
//  Home
//
//  Created by fujisheng on 16/3/18.
//  Copyright © 2016年 fujisheng. All rights reserved.
//

#import "FJSRegisterController.h"
#import "FJSConst.h"
#import "UIView+FJSAdd.h"
#import "MBProgressHUD+MJ.h"
#import "FJSUtil.h"
#import <SMS_SDK/SMSSDK.h>
#import <SMS_SDK/Extend/SMSSDKCountryAndAreaCode.h>
#import <SMS_SDK/Extend/SMSSDK+DeprecatedMethods.h>
#import <SMS_SDK/Extend/SMSSDK+ExtexdMethods.h>
#import <MOBFoundation/MOBFoundation.h>
#import "FJSApiRequest.h"
#import "FJSDiscoverViewController.h"
#import "FJSHomeContext.h"
#import "FJSUserProfile.h"
#import <Eta/Eta.h>

#import "CZTabBarController.h"

@interface FJSRegisterController()<UITextFieldDelegate>

@property (strong,nonatomic) UITextField            *accountField;
@property (strong,nonatomic) UITextField            *validField;
@property (strong,nonatomic) UIButton               *validNumberBtn;
@property (strong,nonatomic) UITextField            *passwordField;
@property (strong,nonatomic) UIButton               *registerBtn;
@property (strong,nonatomic) UIView                 *containerView;

@end

@implementation FJSRegisterController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self layoutUI];
}

#pragma mark - 构建UI
- (void)layoutUI
{
    [self.containerView addSubview:self.accountField];
    [self.containerView addSubview:self.validField];
    [self.containerView addSubview:self.validNumberBtn];
    [self.containerView addSubview:self.passwordField];
    [self.containerView addSubview:self.registerBtn];
    [self.view addSubview:self.containerView];
    
    self.containerView.height = self.registerBtn.bottom;
    self.containerView.center = self.view.center;
}

- (UIView *)containerView
{
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.width = self.view.width - 20 * 2;
    }
    return _containerView;
}

- (UITextField *)accountField
{
    if (!_accountField) {
        _accountField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, self.containerView.width, 30)];
        _accountField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _accountField.keyboardType = UIKeyboardTypeNumberPad;
        _accountField.placeholder = @"请输入手机号";
        _accountField.borderStyle = UITextBorderStyleRoundedRect;
        _accountField.delegate = self;
        
        [_accountField addTarget:self action:@selector(accountTextChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _accountField;
}

- (UITextField *)validField
{
    if (!_validField) {
        _validField = [[UITextField alloc] initWithFrame:CGRectMake(0, _accountField.bottom + 10, self.containerView.width * 0.5, 30)];
        _validField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _validField.placeholder = @"请输入验证码";
        _validField.borderStyle = UITextBorderStyleRoundedRect;
        _validField.delegate = self;
        
        [_validField addTarget:self action:@selector(passwordOrValidTextChange) forControlEvents:UIControlEventEditingChanged];
    }
    return _validField;
}

- (UIButton *)validNumberBtn
{
    if (!_validNumberBtn) {
        _validNumberBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_validNumberBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_validNumberBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_validNumberBtn setBackgroundColor:[UIColor lightGrayColor]];
        _validNumberBtn.layer.cornerRadius = 5;
        _validNumberBtn.alpha = 0.5;
        
        _validNumberBtn.width = 100;
        _validNumberBtn.height = 30;
        _validNumberBtn.right = _accountField.right;
        _validNumberBtn.top = _validField.top;
        
        [_validNumberBtn addTarget:self action:@selector(getValidNumber:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _validNumberBtn;
}

- (UITextField *)passwordField
{
    if (!_passwordField) {
        _passwordField = [[UITextField alloc] initWithFrame:CGRectMake(0, self.validField.bottom + 10, self.containerView.width, 30)];
        _passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _passwordField.placeholder = @"请输入6位以上密码";
        _passwordField.borderStyle = UITextBorderStyleRoundedRect;
        _passwordField.secureTextEntry = YES;
        _passwordField.delegate = self;
        
        [_passwordField addTarget:self action:@selector(passwordOrValidTextChange) forControlEvents:UIControlEventEditingChanged];
    }
    return _passwordField;
}

- (UIButton *)registerBtn
{
    if (!_registerBtn) {
        _registerBtn = [[UIButton alloc] initWithFrame:CGRectMake(25,self.passwordField.bottom + 20, self.containerView.width - 25 * 2, 30)];
        [_registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_registerBtn setBackgroundColor:[UIColor lightGrayColor]];
        [_registerBtn setTitle:@"注册" forState:UIControlStateNormal];
        _registerBtn.contentMode = UIViewContentModeCenter;
        _registerBtn.layer.cornerRadius = 5;
        _registerBtn.enabled = NO;
        _registerBtn.alpha = 0.5;
        
        [_registerBtn addTarget:self action:@selector(goRegister:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registerBtn;
}

#pragma mark - 收起键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.accountField resignFirstResponder];
    [self.validField resignFirstResponder];
    [self.passwordField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - 事件交互

#pragma mark 手机号输入框文本改变
- (void)accountTextChange:(UITextField *)textField
{
    if ([textField.text length] == 11) {
        if ([FJSUtil isPhoneNumberMatch:textField.text]) {
            self.validNumberBtn.enabled = YES;
            self.validNumberBtn.alpha = 1.0;
        }
    } else {
        self.validNumberBtn.enabled = NO;
        self.validNumberBtn.alpha = 0.5;
    }
    
    [self passwordOrValidTextChange];
}

#pragma mark 密码输入框文本改变
- (void)passwordOrValidTextChange
{
    if ([self.validField.text length] != 4 ||
        [self.passwordField.text length] < 6 ||
        ![FJSUtil isPhoneNumberMatch:self.accountField.text]) {
        self.registerBtn.enabled = NO;
        self.registerBtn.alpha = 0.5;
    } else {
        self.registerBtn.enabled = YES;
        self.registerBtn.alpha = 1.0;
    }
}

- (void)getValidNumber:(UIButton *)validBtn
{
    __weak FJSRegisterController *regViewController = self;
    
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:self.accountField.text
                                   zone:@"86"
                       customIdentifier:nil
                                 result:^(NSError *error) {
         [regViewController getVerificationCodeResultHandler:self.accountField.text zone:@"86" error:error];
         
     }];
}

- (void)getVerificationCodeResultHandler:(NSString *)phoneNumber zone:(NSString *)zone error:(NSError *)error
{
    
    if (!error){
        [MBProgressHUD showSuccess:@"验证码发送成功"];
    }
    else {
        [MBProgressHUD showError:@"验证码发送失败"];
    }
}

- (void)goRegister:(UIButton *)registerBtn
{
    [SMSSDK commitVerificationCode:self.validField.text phoneNumber:self.accountField.text zone:@"86" result:^(NSError *error) {
        
        if (!error) {
            NSMutableDictionary *bodyDict = [[NSMutableDictionary alloc] init];
            bodyDict[@"phone_number"] = self.accountField.text;
            bodyDict[@"password"] = self.passwordField.text;
            NSTimeInterval timeInterval = [[NSDate dateWithTimeIntervalSinceNow:8 * 60 * 60] timeIntervalSince1970];
            bodyDict[@"register_date"] = @(round(timeInterval) * 1000);
            
            [MBProgressHUD showMessage:@"正在注册中"];
            
            [FJSApiRequest postRequestWithUrl:API_registerUrl bodyDict:bodyDict successBlock:^(id responseData) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUD];
                    // 创建tabBarVc
                    CZTabBarController *tabBarVc = [[CZTabBarController alloc] init];
                    // 设置窗口的根控制器
                    FJSKeyWindow.rootViewController = tabBarVc;
                });
                
                NSDictionary *dict = [responseData objectForKey:@"userProfile"];
                FJSUserProfile *userProfile = [FJSUserProfile eta_modelFromDictionary:dict];
                
                [[EtaContext shareInstance] saveModel:userProfile];
                [FJSHomeContext shareContext].currentUserProfile = userProfile;

            } failBlock:^(NSError *error) {
                
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:@"注册失败"];
                
                NSLog(@"%@",error);
            }];
        }
        else {
            NSLog(@"%@",error);
            [MBProgressHUD showError:@"验证失败"];
            
        }
    }];
}

@end
