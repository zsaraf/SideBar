//
//  ViewController.m
//  SideBarMessAround
//
//  Created by Zachary Saraf on 7/16/13.
//  Copyright (c) 2013 Zachary Saraf. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) CGFloat xCoord;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleHorizontalPan:)];
    [self.view addGestureRecognizer:recognizer];
    [self.view setBackgroundColor:[UIColor blackColor]];
}

-(IBAction)handleHorizontalPan:(UIPanGestureRecognizer *)gesture
{
    CGFloat desiredFinalX = .75 * self.view.bounds.size.width;
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        self.xCoord = [gesture locationInView:self.tableView].x;
        NSLog(@"XCCOOORD begin: %f", self.xCoord);
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        if (self.xCoord < 0) return;
        CGRect frame = self.tableView.frame;
        frame.origin.x = [gesture locationInView:self.view].x -  self.xCoord;
        [gesture setTranslation:CGPointZero inView:self.view];
        [self.tableView setFrame:frame];
    } else if (gesture.state == UIGestureRecognizerStateEnded) {
        if (self.xCoord < 0){
            self.xCoord = 1;
            return;
        }
        CGPoint velocity = [gesture velocityInView:self.view];
        if (abs(velocity.x) < 250) {
            CGFloat endX = ([gesture locationInView:self.view].x > desiredFinalX/2) ? desiredFinalX : 0;
            NSLog(@"OKAY OKAY %f %f %f", [gesture locationInView:self.view].x, desiredFinalX/2, velocity.x);
            [UIView animateWithDuration:.3 animations:^{
                CGRect frame = self.tableView.frame;
                frame.origin.x = endX;
                [self.tableView setFrame:frame];
            }];
        } else {
            NSLog(@"velocity is greater than 100::: %f", velocity.x);
            CGFloat endX = (velocity.x > 0) ? desiredFinalX : 0;
            CGRect frame = self.tableView.frame;
            CGFloat diff = abs(endX - frame.origin.x);
            frame.origin.x = endX;
            CGFloat seconds = diff/velocity.x;
            [UIView animateWithDuration:seconds animations:^{
                [self.tableView setFrame:frame];
            }];
        }
        NSLog(@"ENDED");
        self.xCoord = 1;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"identifier";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    /*if ([cell.subviews count] == 0) {
        /*UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 50, cell.bounds.size.height)];
        [label setText:@"LABEL"];
        [cell addSubview:label];
        
    }*/
    [cell.textLabel setText:@"GOOOOD"];
    return cell;
}


@end
