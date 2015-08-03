//
//  TagPicker1.m
//  ChatApp
//
//  Created by howard on 14-11-29.
//  Copyright (c) 2014年 juchuang. All rights reserved.
//

#import "TagPicker1.h"
#import "TagPicker2.h"

@interface TagPicker1 (){
    NSMutableArray *dataArr;
    int currentSelectedIndex;
}

@end

@implementation TagPicker1

- (void)viewDidLoad {
    self.titleForNav = @"创业标签";
    [super viewDidLoad];
    dataArr = [[NSMutableArray alloc]init];
    [self loadTagData];
    currentSelectedIndex = 0;
}
-(void)loadTagData
{
    
    NSString *token = [UserDefaultsUtils valueWithKey:USERDEFAULT_TOKEN];
    NSDictionary *paramDic =[NSDictionary dictionaryWithObjectsAndKeys:token,@"apptoken",@"1",@"rflag",nil];
    [self loadData:paramDic requestCode:kREQESUT_GETTAG showAnimation:YES];
}
-(void)finishReqestOk:(NSDictionary *)resultDic
{
    [super finishReqestOk:resultDic];
    dataArr =  [[resultDic objectForKey:@"data"] mutableCopy];
    NSArray *colorArr = @[[UIColor orangeColor],RGBA(145, 206, 110, 1),RGBA(101, 190, 230, 1),[UIColor redColor]];
    for (int i=0;i<4;i++ ) {
        UIButton *button = (UIButton*)[self.stateView viewWithTag:i+1];
        button.layer.borderWidth = 1;
        button.layer.borderColor = [[colorArr objectAtIndex:i] CGColor];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:[[dataArr objectAtIndex:i] objectForKey:@"name"] forState:UIControlStateNormal];
    }
}
-(void)buttonAction:(UIButton*)button
{
    NSArray *colorArr = @[[UIColor orangeColor],RGBA(145, 206, 110, 1),RGBA(101, 190, 230, 1),[UIColor redColor]];
    int tag = (int)button.tag;
    currentSelectedIndex = [[[dataArr objectAtIndex:tag-1] objectForKey:@"id"] intValue];
    for (int i=0;i<4;i++ ) {
        UIButton *button = (UIButton*)[self.stateView viewWithTag:i+1];
        button.layer.borderColor = [[colorArr objectAtIndex:i] CGColor];
        button.backgroundColor = [UIColor whiteColor];
        [button setTitleColor:[colorArr objectAtIndex:i] forState:UIControlStateNormal];
    }
    button.backgroundColor  = RGBA(77, 194, 241, 1);
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.layer.borderColor = [[UIColor clearColor]CGColor];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)okAction:(UIButton *)sender {
    if(currentSelectedIndex==0) {
        [self.view makeToast:@"请选择一个标签" duration:1 position:@"center"];
        return;
    }
    registerParam *rParam = [registerParam shareRegisterParam];
    rParam.workTag = [NSString stringWithFormat:@"%d",currentSelectedIndex];
    TagPicker2 *tagPicker2 = [self.storyboard instantiateViewControllerWithIdentifier:@"TagPicker2"];
    [self.navigationController pushViewController:tagPicker2 animated:YES];
}
@end
