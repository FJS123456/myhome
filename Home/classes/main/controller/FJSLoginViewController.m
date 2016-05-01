//
//  FJSLoginViewController.m
//  Home
//
//  Created by fujisheng on 16/3/14.
//  Copyright © 2016年 fujisheng. All rights reserved.
//

#import "FJSLoginViewController.h"
#import "FJSConst.h"
#import "UIView+FJSAdd.h"
#import "FJSApiRequest.h"
#import "MBProgressHUD+MJ.h"
#import "FJSDiscoverViewController.h"
#import "FJSRegisterController.h"
#import "FJSUtil.h"
#import "FJSUserProfile.h"
#import "FJSHomeContext.h"
#import <Eta/Eta.h>

#import "CZTabBarController.h"

@interface FJSLoginViewController ()<UITextFieldDelegate>

@property (strong,nonatomic) UITextField            *accountField;
@property (strong,nonatomic) UITextField            *passwordField;
@property (strong,nonatomic) UIButton               *loginBtn;
@property (strong,nonatomic) UIButton               *registerBtn;
@property (strong,nonatomic) UIButton               *findPwdBtn;        //找回密码按钮
@property (strong,nonatomic) UIView                 *containerView;

@end

@implementation FJSLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"登陆";
    
    [self layoutUI];
}

#pragma mark - 构建UI

- (void)layoutUI
{
    [self.containerView addSubview:self.accountField];
    [self.containerView addSubview:self.passwordField];
    [self.containerView addSubview:self.loginBtn];
    [self.containerView addSubview:self.registerBtn];
    [self.containerView addSubview:self.findPwdBtn];
    [self.view addSubview:self.containerView];
    
    self.containerView.height = self.findPwdBtn.bottom;
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
        
        _accountField.text = @"15764352835";
    }
    return _accountField;
}

- (UITextField *)passwordField
{
    if (!_passwordField) {
        _passwordField = [[UITextField alloc] initWithFrame:CGRectMake(0, self.accountField.bottom + 10, self.containerView.width, 30)];
        _passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _passwordField.placeholder = @"请输入密码";
        _passwordField.borderStyle = UITextBorderStyleRoundedRect;
        _passwordField.secureTextEntry = YES;
        _passwordField.delegate = self;
        
        _passwordField.text = @"fujisheng";
    }
    return _passwordField;
}

- (UIButton *)loginBtn
{
    if (!_loginBtn) {
        _loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(25,self.passwordField.bottom + 30, self.containerView.width - 25 * 2, 30)];
        [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_loginBtn setBackgroundColor:[UIColor lightGrayColor]];
        [_loginBtn setTitle:@"登陆" forState:UIControlStateNormal];
        _loginBtn.contentMode = UIViewContentModeCenter;
        _loginBtn.layer.cornerRadius = 5;
        
        [_loginBtn addTarget:self action:@selector(userLogin:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginBtn;
}

- (UIButton *)registerBtn
{
    if (!_registerBtn) {
        _registerBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.loginBtn.left,self.loginBtn.bottom + 10, self.loginBtn.width, 30)];
        [_registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_registerBtn setBackgroundColor:[UIColor lightGrayColor]];
        [_registerBtn setTitle:@"注册" forState:UIControlStateNormal];
        _registerBtn.contentMode = UIViewContentModeCenter;
        _registerBtn.layer.cornerRadius = 5;
        
        [_registerBtn addTarget:self action:@selector(userRegister:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registerBtn;
}

- (UIButton *)findPwdBtn
{
    if (!_findPwdBtn) {
        _findPwdBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        _findPwdBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_findPwdBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_findPwdBtn setTitle:@"找回密码" forState:UIControlStateNormal];
        _findPwdBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        
        _findPwdBtn.width = 100;
        _findPwdBtn.height = 20;
        _findPwdBtn.right = self.registerBtn.right;
        _findPwdBtn.top = self.registerBtn.bottom + 10;

        [_findPwdBtn addTarget:self action:@selector(findPassword) forControlEvents:UIControlEventTouchUpInside];
     }
    
    return _findPwdBtn;
}

#pragma mark - 收起键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.accountField resignFirstResponder];
    [self.passwordField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - 事件交互
- (void)userRegister:(UIButton *)registerBtn
{
    FJSRegisterController *registerController = [[FJSRegisterController alloc] init];
    [self.navigationController pushViewController:registerController animated:YES];
}

- (void)userLogin:(UIButton *)loginBtn
{
    if (![FJSUtil isPhoneNumberMatch:self.accountField.text] || self.passwordField.text.length < 6) {
        [MBProgressHUD showError:@"请填写正确的手机号和密码"];
        return;
    }
    
    NSString *phoneNumber = self.accountField.text;
    NSString *password = self.passwordField.text;
    NSMutableDictionary *bodyDict = [NSMutableDictionary dictionary];
    bodyDict[@"phone_number"] = phoneNumber;
    bodyDict[@"password"] = password;
    
    [MBProgressHUD showMessage:@"正在登录中"];
    
    [FJSApiRequest postRequestWithUrl:API_loginUrl bodyDict:bodyDict successBlock:^(id responseData) {
        
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
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:@"登录失败"];
            });
            NSLog(@"%@",error);
        }
    }];
    
}

@end
