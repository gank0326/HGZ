//
//  TagPicker3.m
//  ChatApp
//
//  Created by howard on 14-11-29.
//  Copyright (c) 2014年 juchuang. All rights reserved.
//

#import "TagPicker3.h"

@interface TagPicker3 ()<UITextFieldDelegate>
{
    NSMutableArray *hotArr;
    NSMutableArray *allArr;
    NSArray*colorArr;
//    NSString *currentSelectedString;
    NSMutableArray *currentSelectedArr;
}

@end

@implementation TagPicker3

- (void)viewDidLoad {
    self.titleForNav = @"个性标签";
    [self setIsSupportTapHideKeyboard:YES];
    [super viewDidLoad];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    currentSelectedArr = [[NSMutableArray alloc]init];
    if(self.currentDataArr&&self.currentDataArr.count>=1) {
        currentSelectedArr = self.currentDataArr;
    }
    // Do any additional setup after loading the view.
    hotArr = [[NSMutableArray alloc]init];
    allArr = [[NSMutableArray alloc]init];
    colorArr = @[[UIColor orangeColor],RGBA(145, 206, 110, 1),RGBA(101, 190, 230, 1),[UIColor redColor]];
    [self loadTagData];
    [self setNavRightItemWith:@"完成" andImage:nil];
}
-(void)loadTagData
{
    
    NSString *token = [UserDefaultsUtils valueWithKey:USERDEFAULT_TOKEN];
    NSDictionary *paramDic =[NSDictionary dictionaryWithObjectsAndKeys:token,@"apptoken",@"3",@"rflag",nil];
    [self loadData:paramDic requestCode:kREQESUT_GETTAG showAnimation:YES];
}
-(void)finishReqestOk:(NSDictionary *)resultDic
{
    [super finishReqestOk:resultDic];
    NSString *requestCode = [resultDic objectForKey:@"requestCode"];
    if([requestCode isEqualToString:kREQESUT_GETTAG]) {
        NSMutableArray *tempArr  =  [[resultDic objectForKey:@"data"] mutableCopy];
        for (NSDictionary *dic in tempArr) {
            if([[dic objectForKey:@"ifhot"] intValue]==1) {
                [hotArr addObject:dic];
            } else {
                [allArr addObject:dic];
            }
        }
        [self updateView];
    } else if([requestCode isEqualToString:kREQESUT_MODIFYCUSTOMTAG]) {
        [self.view makeToast:@"设置成功" duration:2 position:@"center"];
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(finishAction) userInfo:nil repeats:NO];
    }else {
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
-(void)finishAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)updateView
{
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 300,40)];
    titleLabel.text = @"热门标签";
    titleLabel.font = [UIFont systemFontOfSize:18.0];
    [self.myScrollView addSubview:titleLabel];
    NSMutableArray *hotDataArr = [[NSMutableArray alloc]init];
    for (int i=0; i<ceil(hotArr.count/5.0); i++) {
       NSMutableArray *tempArr1 =[[ NSMutableArray alloc]init];
        for(int k = i*5;k<i*5+3;k++) {
            if (k<hotArr.count) {
                [tempArr1 addObject:[hotArr objectAtIndex:k]];
            }
            
        }

        NSMutableArray *tempArr2 = [[ NSMutableArray alloc]init];
        for(int k = i*5+3;k<i*5+5;k++) {
            if (k<hotArr.count) {
                [tempArr2 addObject:[hotArr objectAtIndex:k]];
            }
            
        }
        if(tempArr1.count>0) {
            [hotDataArr addObject:tempArr1];
        }
        if(tempArr2.count>0) {
            [hotDataArr addObject:tempArr2];
        }

    }
    
    
    for (int i=0; i<hotDataArr.count; i++) {
        NSArray *tempArr = [hotDataArr objectAtIndex:i];
        for(int j=0;j<tempArr.count;j++) {
            NSString *msg = [[tempArr objectAtIndex:j] objectForKey:@"name"];
            UIButton *button;
            if(i%2==0) {
                button= [[UIButton alloc]initWithFrame:CGRectMake(j*88+j*10+20, i*31+i*10+40, 88, 31)];
            } else {
                button= [[UIButton alloc]initWithFrame:CGRectMake(j*140+j*10+20, i*31+i*10+40, 140, 31)];
            }
            
            [button setTitle:msg forState:UIControlStateNormal];
    
            
             [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            button.layer.borderWidth = 1.0;
            if([currentSelectedArr containsObject:msg]) {
                button.layer.borderColor = [[UIColor clearColor] CGColor];
                button.backgroundColor = RGBA(77, 194, 241, 1);
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            } else {
                [button setTitleColor:[colorArr objectAtIndex:(i*2+j)%4] forState:UIControlStateNormal];
                button.layer.borderColor  = [[colorArr objectAtIndex:(i*2+j)%4] CGColor];
                button.backgroundColor = [UIColor whiteColor];
            }
            
            [self.myScrollView addSubview:button];
        }
        
    }
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 70+hotDataArr.count*31, 300,40)];
    titleLabel.text = @"全部标签";
    titleLabel.font = [UIFont systemFontOfSize:18.0];
    [self.myScrollView addSubview:titleLabel];
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"+",@"name", nil];
    [allArr addObject:dic];
    NSMutableArray *allDataArr = [[NSMutableArray alloc]init];
    for (int i=0; i<ceil(allArr.count/5.0); i++) {
        NSMutableArray *tempArr1 =[[ NSMutableArray alloc]init];
        for(int k = i*5;k<i*5+3;k++) {
            if (k<allArr.count) {
                [tempArr1 addObject:[allArr objectAtIndex:k]];
            }
            
        }
        NSMutableArray *tempArr2 = [[ NSMutableArray alloc]init];
        for(int k = i*5+3;k<i*5+5;k++) {
            if (k<allArr.count) {
                [tempArr2 addObject:[allArr objectAtIndex:k]];
            }
            
        }
        if(tempArr1.count>0) {
            [allDataArr addObject:tempArr1];
        }
        if(tempArr2.count>0) {
            [allDataArr addObject:tempArr2];
        }
        
    }
    for (int i=0; i<allDataArr.count; i++) {
        NSArray *tempArr = [allDataArr objectAtIndex:i];
        for(int j=0;j<tempArr.count;j++) {
            NSString *msg = [[tempArr objectAtIndex:j] objectForKey:@"name"];
            
            UIButton *button;
            if(i%2==0) {
                button= [[UIButton alloc]initWithFrame:CGRectMake(j*88+j*10+20, i*31+i*10+titleLabel.frame.origin.y+40, 88, 31)];
            } else {
                button= [[UIButton alloc]initWithFrame:CGRectMake(j*140+j*10+20, i*31+i*10+titleLabel.frame.origin.y+40, 140, 31)];
            }
            
            [button setTitle:msg forState:UIControlStateNormal];
            
            button.layer.borderWidth = 1.0;
            if([currentSelectedArr containsObject:msg]) {
                button.layer.borderColor = [[UIColor clearColor] CGColor];
                button.backgroundColor = RGBA(77, 194, 241, 1);
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            } else {
                [button setTitleColor:[colorArr objectAtIndex:(i*2+j)%4] forState:UIControlStateNormal];
                button.layer.borderColor  = [[colorArr objectAtIndex:(i*2+j)%4] CGColor];
                button.backgroundColor = [UIColor whiteColor];
            }
            
            if([@"+" isEqualToString:msg]) {
                [button addTarget:self action:@selector(addCustomTag) forControlEvents:UIControlEventTouchUpInside];
            } else {
                [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            }
            [self.myScrollView addSubview:button];
        }
        
    }
    [self.myScrollView setContentSize:CGSizeMake(320,(hotDataArr.count+allDataArr.count)*41+100)];
    
}
-(void)buttonAction:(UIButton*)button
{
    NSString*tempString = [button titleForState:UIControlStateNormal];
    if([currentSelectedArr containsObject:tempString]) {
        [currentSelectedArr removeObject:tempString];
    } else {
        [currentSelectedArr addObject:tempString];
    }
    [allArr removeLastObject];
    for(UIView *view in self.myScrollView.subviews) {
        [view removeFromSuperview];
    }
    [self updateView];
    
}
-(void)updateDataArr:(NSString*)string
{
    if([currentSelectedArr containsObject:string]) {
    } else {
        [currentSelectedArr addObject:string];
    }
    [allArr removeLastObject];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:string,@"name", nil];
    [allArr addObject:dic];
    for(UIView *view in self.myScrollView.subviews) {
        [view removeFromSuperview];
    }
    [self updateView];
}
-(void)addCustomTag
{
    UINib *viewNib = [UINib nibWithNibName:@"CustomTagView" bundle:nil];
    [viewNib instantiateWithOwner:self options:nil];
    TagPicker3 *mySelf = self;
    [self.customTagPickerView setTapOkBlock:^(NSString*string) {
        [mySelf updateDataArr:string];
    }];
    [self.navigationController.view addSubview:self.customTagPickerView];
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
    if(currentSelectedArr.count<=0) {
        [self.view makeToast:@"请选择一项" duration:1 position:@"center"];
        return;
    }
    NSString *currentString = [currentSelectedArr componentsJoinedByString:@","];
    if(self.type==1) {
        NSString *token = [UserDefaultsUtils valueWithKey:USERDEFAULT_TOKEN];
        NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:[UserDefaultsUtils valueWithKey:UID],@"uid",token,@"apptoken",currentString,@"tagname",@"3",@"rflag",nil];
        [self loadData:dic requestCode:kREQESUT_MODIFYCUSTOMTAG showAnimation:YES];
        
    } else {
        NSString *token = [UserDefaultsUtils valueWithKey:USERDEFAULT_TOKEN];
        NSMutableDictionary *dic2 = [[NSMutableDictionary alloc]init];
        registerParam *rParam = [registerParam shareRegisterParam];
        [dic2 setObject:rParam.workTag forKey:@"growthtag"];
        [dic2 setObject:rParam.identityTag forKey:@"pertag"];
        [dic2 setObject:currentString forKey:@"custtag"];
        [dic2 setObject:token forKey:@"apptoken"];
        [dic2 setObject:[UserDefaultsUtils valueWithKey:UID] forKey:@"uid"];
        [dic2 setObject:rParam.nickName forKey:@"nickname"];
        [dic2 setObject:[NSString stringWithFormat:@"%d",rParam.sexTag] forKey:@"gender"];
        if(rParam.photoImage) {
            [dic2 setObject: [NSString stringWithFormat:@"data:image/jpg;base64,%@",[CommonUtils toBase64String:UIImageJPEGRepresentation(rParam.photoImage, 0.7)]] forKey:@"icon"];
        } else {
             [dic2 setObject: [NSString stringWithFormat:@"data:image/jpg;base64,%@",[CommonUtils toBase64String:UIImageJPEGRepresentation([UIImage imageNamed:@"defaultPhoto.png"], 0.7)]] forKey:@"icon"];
        }
        [self loadData:dic2 requestCode:kREQESUT_REGISTER_EXTEND showAnimation:YES];
    }
    
    
}


@end
