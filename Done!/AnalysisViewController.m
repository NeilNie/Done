//
//  AnalysisViewController.m
//  Done!
//
//  Created by Yongyang Nie on 5/4/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import "AnalysisViewController.h"

@interface AnalysisViewController ()

@end

@implementation AnalysisViewController

#pragma mark - UITableView Delegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GraphTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"idGraphCell" forIndexPath:indexPath];
    
    switch (indexPath.row) {
        case 0:
            [cell setUpGraphType:PNLineGraph];
            break;
        case 1:
            [cell setUpGraphType:PNPieGraph];
            break;
            
        default:
            break;
    }
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 340;
}

#pragma mark - Life Cycle

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:YES];
}

- (void)viewDidLoad {

    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.table registerNib:[UINib nibWithNibName:@"GraphTableViewCell" bundle:nil] forCellReuseIdentifier:@"idGraphCell"];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
