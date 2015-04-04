//
//  main.m
//  ExtendedEuclideanAlgorithm
//
//  Created by Kyle Zhao on 4/3/15.
//  Copyright (c) 2015 Kyle Zhao. All rights reserved.
//

#import <Foundation/Foundation.h>

long long llgcd(long long a, long long b);
void llSwap(long long *a, long long *b);
BOOL calculate(long long a, long long b, long long c, long long *xReturn, long long *yReturn, long long *gcdReturn);
void evaluate(int n1,int n2, long long a, long long b, long long c, long long X, long long Y, long long gcd);


int main(int argc, const char * argv[]) {
    @autoreleasepool {
        long long a, b, c, x, y, gcd;
        
        a = 139;
        b = 64;
        c = -7;
        
        NSLog(@"%lldx + %lldy = %lld",a,b,c);
        
        if (calculate(a, b, c, &x, &y, &gcd)) {
            NSLog(@"x:%lld y:%lld gcd:%lld",x,y,gcd);
            
            long long a0 =a;
            long long b0 =b;
            
            a=llabs(a);
            b=llabs(b);
            
            if (a0>0 && b0>0) {
                NSLog(@"%@", [NSString stringWithFormat:@"x = %lld - %lldn",x*(c/gcd),b/gcd]);
                NSLog(@"%@", [NSString stringWithFormat:@"y = %lld + %lldn",y*(c/gcd),a/gcd]);
                NSLog(@"%@", [NSString stringWithFormat:@"GCD(%lld,%lld)=%lld",a,b,gcd]);
            } else if (a0>0 && b0<0) {
                NSLog(@"%@", [NSString stringWithFormat:@"x = %lld + %lldn",x*(c/gcd),b/gcd]);
                NSLog(@"%@", [NSString stringWithFormat:@"y = %lld + %lldn",y*(c/gcd),a/gcd]);
                NSLog(@"%@", [NSString stringWithFormat:@"GCD(%lld,%lld)=%lld",a,b,gcd]);
            } else if (a0<0 && b0>0) {
                NSLog(@"%@", [NSString stringWithFormat:@"x = %lld - %lldn",x*(c/gcd),b/gcd]);
                NSLog(@"%@", [NSString stringWithFormat:@"y = %lld - %lldn",y*(c/gcd),a/gcd]);
                NSLog(@"%@", [NSString stringWithFormat:@"GCD(%lld,%lld)=%lld",a,b,gcd]);
            } else {
                NSLog(@"%@", [NSString stringWithFormat:@"x = %lld + %lldn",x*(c/gcd),b/gcd]);
                NSLog(@"%@", [NSString stringWithFormat:@"y = %lld - %lldn",y*(c/gcd),a/gcd]);
                NSLog(@"%@", [NSString stringWithFormat:@"GCD(%lld,%lld)=%lld",a,b,gcd]);
            }
        } else {
            printf("No Solutions");
        }
        
        evaluate(-8, 8, a, b, c, x, y, gcd);
    }
    return 0;
}

BOOL calculate(long long a, long long b, long long c, long long *xReturn, long long *yReturn, long long *gcdReturn) {
    
    NSMutableString *calcString = [[NSMutableString alloc] init];
    BOOL swapped = NO;
    long long x=a;
    long long y=b;
    long long c0=c;
    
    //x-y checker
    if(llabs(y)>llabs(x)){
        swapped = YES;
        llSwap(&x,&y);
    }
    
    //call gcd method
    long long gcd = llgcd(x, y);
    
    //no solutions
    if (c0%gcd!=0){
        return NO;
    }
    
    //save initilal values
    long long x0=x;
    long long y0=y;
    
    
    //----------------initializer
    long long r=x%y;
    if(r==0){
        *xReturn = swapped? 1 : 0;
        *yReturn = swapped? 0 : 1;
        *gcdReturn = y;
        return YES;
    }
    
    
    long long q=x/y;
    
    long long a0=1;
    long long a1=0;
    long long a2=1;
    
    long long b0=0;
    long long b1=1;
    long long b2=(-q)*b1+b0;
    
    x=y;
    y=r;
    q=x/y;
    
    //NSLog(@"%lld*(%lld) + %lld*(%lld) =%lld\n",x0,a2,y0,b2,r);
    //printf("%lld*(%lld) + %lld*(%lld) =%lld\n",x0,a2,y0,b2,r);
    [calcString appendFormat:@"%lld*(%lld) + %lld*(%lld) =%lld\n",x0,a2,y0,b2,r];
    //----------------initializer
    
    
    //----------------main loop
    while(1){
        r=x%y;
        if (r==0) {
            break;
        }
        q=x/y;
        
        a0=a1;
        a1=a2;
        a2=(-q)*a1+a0;
        
        b0=b1;
        b1=b2;
        b2=(-q)*b1+b0;
        
        x=y;
        y=r;
        
        //NSLog(@"%lld*(%lld) + %lld*(%lld) =%lld\n",x0,a2,y0,b2,r);
        //printf("%lld*(%lld) + %lld*(%lld) =%lld\n",x0,a2,y0,b2,r);
        [calcString appendFormat:@"%lld*(%lld) + %lld*(%lld) =%lld\n",x0,a2,y0,b2,r];
    }
    //----------------main loop

    *xReturn = swapped? b2 : a2;
    *yReturn = swapped? a2 : b2;
    *gcdReturn = gcd;
    
    //printf("S={%lld+%lldn + %lld-%lldn | nez}",x,y0/r,y,x0/r);
    
    return YES;
}

//2*3*5*7*11*13=30030
//13*17*19*23=96577
//1300000

void evaluate(int n1,int n2, long long a, long long b, long long c, long long X, long long Y, long long gcd){

    int from=n1;
    int to=n2;
    
    long long x;
    long long y;
    
    NSMutableString* stringCalc= [[NSMutableString alloc] init];
    
    for(int n=from;n<=to;n++){
        x = (X*c-b*n)/gcd;
        y = (Y*c+a*n)/gcd;
        //                                a     x       b   y      a*x+b*y
        [stringCalc appendFormat:@"n=%i  %lld(%lld) + %lld(%lld) = %lld\n",n,a,x,b,y,a*x+b*y];
        //printf("a(%lld) + b(%lld) = %lld\n",x,y,c);
    }
    NSLog(@"%@", stringCalc);
}


void llSwap(long long * a, long long *b) {
    long long x = *a;
    *a = *b;
    *b = x;
}

long long llgcd(long long a, long long b) {
    long long c = a%b;
    while (a) {
        c = a; a = b%a;  b = c;
    }
    return b < 0 ? -b : b;
}
