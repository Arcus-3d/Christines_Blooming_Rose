// Christine's Blooming Rose OpenSCAD source.
// Project Home: https://hackaday.io/project/163866
// Author: https://hackaday.io/daren
//
// Creative Commons License exists for this work. You may copy and alter the content
// of this file for private use only, and distribute it only with the associated
// Blooming Rose content. This license must be included with the file and content.
// For a copy of the current license, please visit http://creativecommons.org/licenses/by/2.0/


// Useful Globals.
// Circle complexity.  Turn down if things get slow for working, turn up for rendering.
$fn=60;
// For differencing to keep OpenSCAD sane.
extra = 0.01;
// I don't think I actually did any clearancing.  Leaving it cause it's funny.
// Clearance Clarence
clearance = 0.2;

// The stem OD.  I originally used a tube, so I needed this.
stem_d = 6.8;


// Uncomment each one of these, render, export to STL.
// petals(s=1.2); // actually too big.. I just did a range.
//petals(s=1.15);
//petals(s=1.1);
//petals(s=1.05);
//petals(s=1.0);
//petals(s=0.95);
//stem();
leaves();
//rose_center(); 
//base(w=48,l=48); // print in black..
//base_container(w=48,l=48,h=48); // if you don't use a vase, print this.

module leaves() {
	translate([0,-40,0]) difference() {
		union() {
			translate([0,0,stem_d/2]) {
				rotate([-90,0,0]) translate([0,0,2/2]) cube ([5.4,5.8,2.5+extra*2],center=true);
				hull() {
					rotate([-90,0,0]) translate([0,-0.6,2/2]) cube ([6.2,6.2,extra],center=true);
					translate([0,1,2]) rotate([90,0,0]) cylinder(r=stem_d/2,h=extra,center=true);
					translate([0,8,0]) rotate([90,0,0]) cylinder(r=stem_d/2,h=extra,center=true);
				}
			}
			translate([0,-2,0.4/2]) cube ([10,10,0.4],center=true);
			hull() {
				translate([0,8,stem_d/2]) rotate([90,0,0]) cylinder(r=stem_d/2,h=extra,center=true);
				translate([0,18,stem_d/2]) rotate([90,0,0]) cylinder(r=stem_d/2,h=extra,center=true);
			}
			hull() {
				translate([0,18,stem_d/2]) rotate([90,0,0]) cylinder(r=stem_d/2,h=extra,center=true);
				translate([0,30,stem_d/2.5]) rotate([90,0,0]) cylinder(r=stem_d/2.5,h=extra,center=true);
			}
			hull() {
				translate([0,30,stem_d/2.5]) rotate([90,0,0]) cylinder(r=stem_d/2.5,h=extra,center=true);
				translate([0,80,1.6/2]) rotate([90,0,0]) cylinder(r=1.6/2,h=extra,center=true);
			}
			hull() {
				translate([0,80,1.6/2]) rotate([90,0,0]) cylinder(r=1.6/2,h=extra,center=true);
				translate([0,95,0.8/2]) rotate([90,0,0]) cylinder(r=0.8,h=extra,center=true);
			}
			hull() {
				translate([0,95,0.8/2]) rotate([90,0,0]) cylinder(r=0.8,h=extra,center=true);
				translate([0,105,0.4/2]) rotate([90,0,0]) cylinder(r=0.4,h=extra,center=true);
			}
			for (k=[40,0,-40]) translate([0,30,0]) rotate([0,0,k]) translate([0,40-abs(k)/3,0]) scale([0.8-abs(k)/230,0.8-abs(k)/230,1]) union() {
				for (n=[-1,14,28]) for(m=[45,-45]) translate([0,n,0]) hull() {
					rotate([0,0,m]) translate([0,16-n/5,stem_d/20]) rotate([90,0,0]) cylinder(r=stem_d/10,h=extra,center=true);
					rotate([0,0,m]) translate([0,0,stem_d/8]) rotate([90,0,0]) cylinder(r=stem_d/4-n/40,h=extra,center=true);
				}
				linear_extrude(height=0.3) for (j=[1,0]) mirror([j,0]) for (i=[0:9:105]) rotate([0,0,i/2-45]) translate([7.5,i/2.5+7.5,0]) rotate([0,0,i/3+45]) circle(r=3.5,$fn=3,center=true);
				if (1) linear_extrude(height=0.3) hull() {
					translate([0,53]) rotate([0,0,180+30]) circle(r=1,$fn=3,center=true);
					translate([0,39]) circle(r=10,center=true);
					translate([0,27]) circle(r=17,center=true);
					translate([0,19]) circle(r=18.5,center=true);
					translate([0,12]) circle(r=17,center=true);
					translate([0,3]) circle(r=10.5,center=true);
				}
			}
				
			for (i=[40,-40]) translate([0,30,0]) rotate([0,0,-i]) translate([0,-35,0]) hull() {
				translate([0,35,stem_d/3]) rotate([90,0,0]) cylinder(r=stem_d/3,h=extra,center=true);
				translate([0,88,0.4/2]) rotate([90,0,0]) cylinder(r=0.8/2,h=extra,center=true);
			}
		}
		translate([0,0,-10]) cube([400,400,20],center=true);
	}
}

module petals(s=1.0,h=0.2) {
	difference() {
		union() {
			translate([0,0,h*2/2]) rotate([0,0,360/12]) cylinder(r=18/2*s,h=h*2,$fn=6,center=true);
			for (i=[0:120:359]) rotate([0,0,i]) {
				translate([24*s,0,0]) hull() {
					for (i=[-6,6]) translate([6*s,i,h/2]) cylinder(r=32/2,h=h,center=true);
					translate([18*s,0,h/2]) cylinder(r=32/2,h=h,center=true);
					translate([-14*s,0,h/2]) cube([0.4,6.5,h],center=true);
					translate([-10*s,0,h/2]) cylinder(r=4.0/2,h=h,center=true);
				}
				for (i=[3.6,-3.6]) hull() {
					translate([7.75*s,i,h*2/2]) cylinder(r=1.6/2,h=h*2,center=true);
					translate([25*s,i/4,h/2]) cylinder(r=1.6/2,h=h,center=true);
				}
			}
		}
		for (i=[0:60:359]) rotate([0,0,i+30]) {
			translate([12.5/2,0,1]) cylinder(r=1.6/2,h=2+extra,center=true);
			cube([5.4,5.8,4],center=true);
		}
		translate([-23,0,h*3/2]) cylinder(r=2/2,h=h*3+extra,center=true);
	}
		
}
 
module stem_top(r=13) {
	difference() {
		union() {
			hull() {
				translate([0,0,11]) sphere(r=7.5,center=true);
				translate([0,0,4.5]) scale([1,1,.85]) sphere(r=r,center=true);
				translate([0,0,1.5 - extra]) cylinder(r=r,h=5,center=true);
			}
			translate([0,0,.5 - extra]) cylinder(r1=r+0.8,r2=r,h=1,center=true);
			// stem top leaves for heat bending.
			for (i=[1:6]) rotate([0,0,60*i+30]) {
				hull() {
					translate([0,0,.8]) cylinder(r=1/2,h=1.6,center=true);
					translate([0,0,.8]) cylinder(r=12/2,h=0.2,center=true);
					translate([17,0,0.4/2])cylinder(r=12/2,h=0.4,center=true);
					translate([27,0,0.4/2])cylinder(r=1/2,h=0.4,center=true);
				}
				hull() {
					translate([17,0,0.6/2])cylinder(r=12/2,h=0.4,center=true);
					translate([24,0,0.4/2])cylinder(r=10/2,h=0.3,center=true);
					translate([42,0,0.3/2])cylinder(r=.5,h=0.2,center=true);
				}
			}
		}
		translate([0,0,-20+extra]) cube([100,100,40],center=true);
		// what the rose pushes on to actually close.
		if (1) hull() {
			translate([0,0,8]) sphere(r=7.6,center=true);
			translate([0,0,4.5]) scale([1,1,.85]) sphere(r=r-0.8,center=true);
			translate([0,0,1.5 - extra]) cylinder(r=r-0.8,h=5,center=true);
			translate([0,0,14/2]) cylinder(r=stem_d/2,h=14+extra,center=true);
		}
		translate([0,0,.6 - extra]) cylinder(r1=r+0.2,r2=r-1,h=1.2,center=true);
		translate([0,0,1.5]) cylinder(r=r-1,h=3,center=true);
		//translate([0,0,.75 - extra]) cylinder(r1=r,r2=r-1,h=2,center=true);
		//#translate([0,0,14/2]) cylinder(r=11.5/2,h=14+extra,center=true);
		translate([0,0,16]) cylinder(r=stem_d/2+0.2,h=8+extra,center=true);
	}
}




module base(w=48,l=48) {
	servo_offset=1;
	difference() {
		translate([servo_offset,10,30/2]) cube([w,l,30],center=true);
		translate([0,0,8/2-extra]) cylinder(r=stem_d/2+0.2,h=8,center=true);
		translate([0,0,2]) for (i=[-25,25]) rotate([i,0,0]) translate([0,-i/15,4]) cylinder(r=stem_d/2-0.8,h=12,center=true);
		for (i=[90,-90]) rotate([0,-15,i]) translate([-3.5,0,7]) {
			cube([6.4,6.4,5],center=true);
			cube([12,12,2],center=true);
		}
		difference() {
			translate([0,0,30/2+0.8]) cylinder(r=100/2,h=30,center=true);
			translate([0,0,6/2-extra]) cylinder(r2=(stem_d+5)/2,r1=(stem_d+4*3)/2 ,h=6,center=true);
			// servo mount
			difference() {
				union() {
					hull() {
						translate([servo_offset,15,28/2+8.8]) cube([w-5,6,19],center=true);
						translate([servo_offset,15,28/2+4.8]) cube([w-5,1.6,19],center=true);
					}
					translate([servo_offset,15,30/2]) cube([w-5,1.6,30],center=true);
				}
				translate([5.6+servo_offset,1.5,19.8]) rotate([90,0,0]) {
					9g_servo(display=1);
					translate([0,5,0]) 9g_servo(display=1);
				}
				scale([1,1,1.5]) rotate([90,0,0]) cylinder(r=6,h=40,center=true);
				
			}
			// arduino mount
			difference() {
				union() for (i=[-19.2/2,19.2/2]) translate([-w/2+5.4+1.2,i,30/2]) cube([5.4,2.4,30],center=true);
				translate([-w/2+5+2.4,0,30/2+6]) cube([1.6,19.2,30],center=true);
			}
			for (i=[w/2-2.5,-w/2+5/2]) translate([i+servo_offset,10,30/2]) cube([1.2,w,30],center=true);
			translate([servo_offset,0,6/2]) cube([w-5,1.2,6],center=true);
			
		}
			
	}
}

module base_container(w=48,l=48,h=48) {
	servo_offset=1;
	difference() {
		translate([0,0,(h+1.2)/2]) cube([w+ 2.0,l+2.0,h+1.2],center=true);
		difference() {
			translate([0,0,h/2+1.2+extra]) cube([w-0.4,l-0.4,h+extra],center=true);
			for (i=[-w/2,w/2]) translate([i,0,h-3]) hull() {
				cube([2,l+0.4,1],center=true);
				translate([i/200,0,-3]) cube([extra,l+0.4,1],center=true);
			}
		}
		translate([0,l/2,6/2+1.2]) rotate([90,0,0]) cylinder(r=2,h=40,center=true);
	}
}

module stem(l=230) {  
	difference() {
		union() {
			translate([0,0,stem_d/2]) rotate([90,0,0]) cylinder(r=stem_d/2,h=l,center=true);
			if (1) for (i=[l/12,l/2.2,l/1.35]) translate([0,-l/2 + i,1.95]) {
				rotate([106,0,50]) translate([0,0.32,4.7]) cylinder(r1=2,r2=0,h=7,center=true);
				translate([0,l/6,0]) rotate([106,0,-50]) translate([0,0.32,4.7]) cylinder(r1=2,r2=0,h=7,center=true);
			}
			for (i=[-l/10]) translate([0,i,stem_d/2]) rotate([0,0,0]) {
				hull() {
					rotate([19,0,0]) translate([0,0.5,10/2]) cube ([7.0,8.4,3.0],center=true);
					translate([0,2,5/2+ 0.8]) cube ([7.0,extra,8.4+extra*2],center=true);
					translate([0,2,0]) rotate([90,0,0]) cylinder(r=stem_d/2,h=14,center=true);
					rotate([19,0,0]) translate([0,2,8/2]) cylinder(r=stem_d/2,h=3.0,center=true);
					rotate([19,0,0]) translate([0,-1.9,8/2]) cylinder(r=stem_d/2.2,h=5.0,center=true);
				}
			}
			for (i=[-l/2+6,0,l/2-7]) translate([0,i,0.2/2]) cube([10,12,0.2],center=true);
		}
		for (i=[-l/10]) translate([0,i,stem_d/2]) rotate([0,0,0])  {
			hull() {
				rotate([19,0,0]) translate([0,0,8/2+ 0.8]) cube ([5.8,6.2,5.5+extra*2],center=true);
				translate([0,0,4/2+ 0.8]) cube ([5.8,7,6.2+extra*2],center=true);
			}
			hull() {
				translate([0,0,1]) rotate([90,0,0]) cylinder(r=stem_d/2-1.2,h=7,center=true);
				translate([0,-3.5,8/2]) rotate([15,0,0]) cylinder(r=stem_d/2-1.2,h=8,center=true);
			}
		}
		translate([0,0,stem_d/2]) rotate([90,0,0]) cylinder(r=stem_d/2-1.61,h=l+extra,center=true);
		translate([0,0,-10/2]) cube ([300,300,10],center=true);
		translate([0,l/2+2,stem_d/2]) for (i=[20,-20]) rotate([i,0,0]) cube([10,4,10],center=true);
	}
}

// not used atm..
module rose_center(h=12) {
	difference() {
		union() {
			petals(s=0.75);
			for (i=[1:3]) rotate([0,0,120*i]) hull() for (i=[5,-5]) {
				translate([0,i,0.4/2]) cylinder(r=1.6/2,h=0.4,center=true);
				translate([15,i/4,0.2/2]) cylinder(r=1.6/2,h=0.2,center=true);
			}
			hull() {
				translate([0,0,14/2]) rotate([0,0,30]) cylinder(r=9/2,h=14,$fn=6,center=true);
				translate([0,0,14]) rotate([0,0,30]) cylinder(r=2,h=6,center=true);
			}
		}
		for (i=[0:60:359]) rotate([0,0,i+30]) {
			translate([12.5/2,0,1]) cylinder(r=1.6/2,h=2+extra,center=true);
		}
		hull() {
			translate([0,0,14/2]) rotate([0,0,30]) cylinder(r=9/2-0.8,h=14+extra,$fn=6,center=true);
			translate([0,0,14-0.8]) rotate([0,0,30]) cylinder(r=2-0.8,h=6,center=true);
		}
		translate([0,0,18-0.8]) rotate([0,0,30]) cylinder(r=2,h=18,center=true);
		translate([0,0,13]) rotate([90,0,60]) cylinder(r=1,h=20+extra,center=true);
	}
}

module 9g_servo(){
	translate([-5.5,0,-29.25/2-3.65]) difference() {
		union() {
			translate([0,0,2.5*2+2.5/2-3/2]) cube([34,12.5,2.9], center=true);
			union() {	
				cube([24,12.9,23.4], center=true);
				translate([-1,0,2.95]) cube([5.2,5.8,25.75], center=true);
				translate([5.5,0,2.95]) cylinder(r=6.2, h=25.75, $fn=20, center=true);
			}		
			translate([-.5,0,1.75]) cylinder(r=1, h=25.75, $fn=20, center=true);
			translate([5.5,0,3.65]) cylinder(r=2.35, h=29.25, $fn=20, center=true);				
		}	
		for ( hole = [14,-14] ){
			translate([hole,0,4]) cylinder(r=2.1/2, h=12, $fn=20, center=true);
		}
	}
}

