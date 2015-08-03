//
//  TagPicker2.m
//  ChatApp
//
//  Created by howard on 14-11-29.
//  Copyright (c) 2014年 juchuang. All rights reserved.
//

#import "TagPicker2.h"
#import "RegisterExtendViewController.h"
#define CELLTAG 1000
@interface TagPicker2 ()<UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray *dataArr;
    int currentSelectedIndex;
    NSArray*colorArr;
}

@end

@implementation TagPicker2

- (void)viewDidLoad {
     self.titleForNav = @"身份标签";
    [super viewDidLoad];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    currentSelectedIndex = 0;
    [self loadTagData];
    colorArr = @[[UIColor orangeColor],RGBA(145, 206, 110, 1),RGBA(101, 190, 230, 1),[UIColor redColor]];
    if(self.type==1) {
        [self setNavRightItemWith:@"确定" andImage:nil];
        [self.okButton setTitle:@"确定" forState:UIControlStateNormal];
    }
    
}
-(void)loadTagData
{
    
    NSString *token = [UserDefaultsUtils valueWithKey:USERDEFAULT_TOKEN];
    NSDictionary *paramDic =[NSDictionary dictionaryWithObjectsAndKeys:token,@"apptoken",@"2",@"rflag",nil];
    [self loadData:paramDic requestCode:kREQESUT_GETTAG showAnimation:YES];
}
-(void)finishReqestOk:(NSDictionary *)resultDic
{
    [super finishReqestOk:resultDic];
    
    NSString *requestCode = [resultDic objectForKey:@"requestCode"];
    if([requestCode isEqualToString:KREQESUT_MODIFYTAG]) {
        [self.view makeToast:@"设置成功" duration:2 position:@"center"];
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(finishAction) userInfo:nil repeats:NO];
    } else {
        dataArr =  [[resultDic objectForKey:@"data"] mutableCopy];
        for (NSDictionary *dic in dataArr) {
            if([[dic objectForKey:@"name"] isEqualToString:self.currentSelectedString]) {
                currentSelectedIndex = [[dic objectForKey:@"id"] intValue];
            }
        }
        [self.myTableView reloadData];
    }
}
-(void)finishAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ceil(dataArr.count/2.0);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    NSMutableArray *tempArr2 = [[NSMutableArray alloc]init];
    for(int i =indexPath.row*2;i< indexPath.row*2+2;i++) {
        if(i>=dataArr.count) {
            break;
        }
        [tempArr2 addObject:[dataArr objectAtIndex:i]];
    }
//    for(int i=0;i<2;i++) {
//        UIButton *button = (UIButton*)[cell.contentView viewWithTag:i+1];
//        UIImage * image = [XJApplicationUtil createImageWithColor:RGBA(107, 199, 247, 1)];
//        [button setBackgroundImage:image forState:UIControlStateSelected];
//        [button setSelected:NO];
//        button.hidden = YES;
//    }
    for(int i =0;i<tempArr2.count;i++) {
        NSString *text =  [[tempArr2 objectAtIndex:i] objectForKey:@"name"];
        UIButton *button = (UIButton*)[cell.contentView viewWithTag:i+CELLTAG];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:text forState:UIControlStateNormal];
        if ([[[tempArr2 objectAtIndex:i]objectForKey:@"id"]intValue]==currentSelectedIndex) {
            button.backgroundColor  = RGBA(77, 194, 241, 1);
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button.layer.borderColor = [[UIColor clearColor]CGColor];
        } else {
        
        button.layer.borderColor = [[colorArr objectAtIndex:(indexPath.row*2+i)%4] CGColor];
        button.layer.borderWidth = 1;
        button.backgroundColor = [UIColor whiteColor];
            [button setTitleColor:[colorArr objectAtIndex:(indexPath.row*2+i)%4] forState:UIControlStateNormal];

        }
                button.hidden = NO;
    }
    cell.contentView.tag = indexPath.row;
    return cell;
}
-(void)buttonAction:(UIButton*)sender
{
    int tag = sender.superview.tag*2 +sender.tag-CELLTAG;
    currentSelectedIndex = [[[dataArr objectAtIndex:tag] objectForKey:@"id"] intValue];
    [self.myTableView reloadData];
    
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
-(void)rightItemClick:(id)sender
{
    [self okAction:sender];
}
- (IBAction)okAction:(UIButton *)sender {
    if(currentSelectedIndex==0) {
        [self.view makeToast:@"请选择一个标签" duration:1 position:@"center"];
        return;
    }
    if(self.type==1) {
        
        NSString *token = [UserDefaultsUtils valueWithKey:USERDEFAULT_TOKEN];
        NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:[UserDefaultsUtils valueWithKey:UID],@"uid",token,@"apptoken",[NSString stringWithFormat:@"%d",currentSelectedIndex],@"tagid",@"2",@"rflag",nil];
        [self loadData:dic requestCode:KREQESUT_MODIFYTAG showAnimation:YES];
    } else {
        registerParam *rParam = [registerParam shareRegisterParam];
        rParam.identityTag = [NSString stringWithFormat:@"%d",currentSelectedIndex];
        RegisterExtendViewController *registerExtendViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"RegisterExtendViewController"];
        [self.navigationController pushViewController:registerExtendViewController animated:YES];
    }
}
@end
