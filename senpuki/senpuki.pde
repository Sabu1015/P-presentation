//4-26 2620160515 竹永正輝
//2016/7/20
//扇風機の模倣
//Main sketchをクリックして扇風機ボタン、方向キーで移動、+-でズーム
//child sketchでも動かせる
//ALTで視点変換、Q押しながらマウスによる自由な移動、
//RESET Camera又は０でカメラ視点を初期に戻す
//パネルのcaseをクリック又は数字１～３でテーブル作成
//<条件分岐> キー判定など
//<繰り返し> 扇風機のボタン部分など
//<関数> 扇風機、テーブルを呼び出すものなど
//<配列> テーブルの判定

int flag=-1; //キー判定、何がしたいか
int transx=0; //画面の移動
int transy=0; //画面の移動
int zoom=-200; //カメラズーム
int zoomplus=5; //カメラズーム増分
int dx; //画面の相対距離
int dy; //画面の相対距離
float count=0; //回転の増分
float countplus=1; //回転補正
float funrotate=0; //扇風機ファンの回転
int rotation=0; //ボタンの位置
float click=0; //扇風機のボタンクリック数
int eyex=350; //カメラを動かした後の向きx & 初期カメラ位置
int eyey=250; //カメラを動かした後の向きy
int keycolor=0; //パネル色変更

int []base=new int [3]; //テーブルの配列

// Based on code by GeneKao (https://github.com/GeneKao)

ChildApplet child;
boolean mousePressedOnParent = false;
Arcball arcball, arcball2;  

void settings() {
  size(700, 500, P3D);
  smooth();
}

void setup() {
  surface.setTitle("Main sketch");
  arcball = new Arcball(this, 300);
  child = new ChildApplet();
  for (int i=0; i<3; i++) {
    base[i]=0;
  }
}


void draw() {
  background(255);
  arcball.run();
  keyflag();
  senpuki();
  coolhantei();
  human();
  if (base[0]==1) {
    table0();
  } else if (base[1]==1) {
    table1();
  } else if (base[2]==1) {
    table2();
  }
}

void keyPressed() {
  if (key=='q') {
    flag=1;
    dx=mouseX-transx;
    dy=mouseY-transy;
  } else if (keyCode==ALT) {
    flag=0;
  } else if (keyCode==LEFT) {
    transx-=5;
    keycolor=3;
  } else if (keyCode==RIGHT) {
    transx+=5;
    keycolor=4;
  } else if (keyCode==UP) {
    transy-=5;
    keycolor=1;
  } else if (keyCode==DOWN) {
    transy+=5;
    keycolor=2;
  } else if (key=='+') {
    zoom+=zoomplus;
    keycolor=5;
  } else if (key=='-') {
    zoom-=zoomplus;
    keycolor=6;
  } else if (key=='0') {
    eyex=350;
    eyey=250;
    keycolor=7;
  } else if (key=='1') {
    keycolor=8;
    if (base[0]==0) {
      base[0]=1;
    } else if (base[0]==1) {
      base[0]=0;
    }
  } else if (key=='2') {
    keycolor=9;
    if (base[1]==0) {
      base[1]=1;
    } else if (base[1]==1) {
      base[1]=0;
    }
  } else if (key=='3') {
    keycolor=10;
    if (base[2]==0) {
      base[2]=1;
    } else if (base[2]==1) {
      base[2]=0;
    }
  }
}

void keyReleased() {
  flag=-1;
  keycolor=0;
}

void keyflag() { //カメラ制御・移動保持
  if (flag==-1) {
    camera(eyex, eyey, 100, 
      width/2.0, height/2.0, 0, 
      0, 1, 0);
  }
  if (flag==0) {
    camera(mouseX, mouseY, 100, 
      width/2.0, height/2.0, 0, 
      0, 1, 0);
    eyex=mouseX;
    eyey=mouseY;
  }
  if (flag==1) {
    camera(eyex, eyey, 100, 
      width/2.0, height/2.0, 0, 
      0, 1, 0);
    transx=mouseX-dx;
    transy=mouseY-dy;
  }
}

void senpuki() {
  pushMatrix();
  stroke(0);
  fill(255);
  translate(width/2+transx, height/2+transy, -100+ zoom);
  box(100, 50, 50);

  for (int i=0; i<26; i++) {
    translate(0, 0, 1);
    ellipse(0, 0, 30, 30);
  }
  rotate(radians(click*45));
  ellipse(0, -10, 10, 10);
  rotate(radians(-click*45));
  translate(0, -75, -26);
  fill(255);
  rotateY(count/200);
  box(100, 100, 50);
  translate(0, 0, 26);
  fill(100);
  ellipse(0, 0, 70, 70);
  ellipse(0, 0, 50, 50);
  ellipse(0, 0, 30, 30);
  translate(0, 0, 300); //扇風機の風目安
  //  sphere(30);
  translate(0, 0, -300);

  //ファン
  fill(100);
  translate(0, 0, 1);
  rotate(radians(funrotate));
  triangle(0, 0, 30, 15, 30, -15);
  rotate(PI/2);
  triangle(0, 0, 30, 15, 30, -15);
  rotate(PI/2);
  triangle(0, 0, 30, 15, 30, -15);
  rotate(PI/2);
  triangle(0, 0, 30, 15, 30, -15);
  rotate(radians(funrotate));

  //基本動作
  if (click%8==1) {
    count+=0.5;
    funrotate+=10;
  } else if (click%8==2) {
    count+=1;
    funrotate+=25;
  } else if (click%8==3) {
    count+=2;
    funrotate+=35;
  } else if (click%8==5) {
    funrotate+=10;
  } else if (click%8==6) {
    funrotate+=25;
  } else if (click%8==7) {
    funrotate+=35;
  } else {
    countplus=0;
    funrotate=0;
  }
  //右の折り返し
  if (count>200) {
    //    println("OK");

    if (click%8==1) {
      countplus=-1;
    } else if (click%8==2) {
      countplus=-2;
    } else if (click%8==3) {
      countplus=-4;
    } else {
    }
    //左の折り返し
  } else if (count<-200) {
    //    println("OK");
    countplus=0;
  }

  count=count+countplus;
  popMatrix();
  fill(0, 0, 255);
  fill(255, 0, 0);
}

void human() {
  pushMatrix();
  noStroke();
  scale(1.2);
  translate(mouseX-50, height/2, 20);
  sphere(20); //頭
  translate(0, 40);
  box(20, 40, 20); //胴体
  translate(-20, 35);
  rotate(PI/8);
  box(15, 40, 20); //足
  rotate(-PI/8);
  translate(40, 0);
  rotate(-PI/8);
  box(15, 40, 20);
  rotate(PI/8);
  translate(-20, -70);
  rotate(PI/7);
  translate(25, 0);
  box(10, 60, 20); //手
  translate(0, -30);
  sphere(10);
  translate(0, 30);
  translate(-25, 0);
  rotate(-PI/7*2);
  translate(-25, 0);
  box(10, 60, 20);
  translate(0, -30);
  sphere(10);
  popMatrix();
}

void coolhantei() {
  translate(0, 0, 50);
  if (click%8==1 || click%8==2 ||click%8==3 ||click%8==5 ||click%8==6 ||click%8==7) {
    if (count<50 &&count>-50) {
      //基本位置からのおおよその冷房範囲
      //      rect(width/2+transx-6, height/2+transy-6, 12, 12);
      if (mouseX<width/2+transx+50 &&mouseX>width/2+transx-50 ) {
        fill(0, 0, 255);
      } else {
        fill(255, 0, 0);
      }
    }
  }
  translate(0, 0, -50);
}


void table0() {
  pushMatrix();
  translate(width/2+transx, height/2+transy+30, -100+ zoom);
  scale(2);
  stroke(0);
  fill(255);
  box(150, 10, 150);
  translate(-50, 35, -50);
  box(20, 70, 20);
  translate(0, 0, 100);
  box(20, 70, 20);
  translate(100, 0, 0);
  box(20, 70, 20);
  translate(0, 0, -100);
  box(20, 70, 20);
  popMatrix();
}

void table1() {
  pushMatrix();
  translate(width/2+transx, height/2+transy+100, -150+ zoom);
  scale(1.5);
  stroke(0);
  fill(#9B4805);
  box(150, 150, 10);
  translate(0, 0, 20);
  box(100, 100, 20);
  translate(0, -45, 55);
  box(90, 10, 90);
  popMatrix();
}

void table2() {
  pushMatrix();
  translate(width/2+transx, height/2+transy+30, -100+zoom);
  stroke(0);
  fill(255);
  box(150, 10, 110);
  translate(0, 30, -20);
  box(130, 50, 15);
  translate(50, -10, 40);
  box(10, 30, 60);
  translate(-100, 0, 0);
  box(10, 30, 60);
  translate(0, 65, -20);
  box(10, 100, 15);  
  translate(100, 0, 0);
  box(10, 100, 15);
  translate(0, 55, 40);
  box(10, 10, 100);
  translate(-100, 0, 0);
  box(10, 10, 100);
  popMatrix();
}

void mousePressed() {
  arcball.mousePressed();
  click+=1;
}

void mouseDragged() {
  arcball.mouseDragged();
}

///////////////////////////////////////////
//二つ目のウィンドウの操作
class ChildApplet extends PApplet {
  //JFrame frame;

  public ChildApplet() {
    super();
    PApplet.runSketch(new String[]{this.getClass().getName()}, this);
  }

  public void settings() {
    size(400, 400, P3D);
    smooth();
  }
  public void setup() { 
    surface.setTitle("Child sketch (Controller)");
    arcball2 = new Arcball(this, 300);
  }

  public void draw() {
    background(255);
    arcball2.run();
    key();
  }

  void key() {
    fill(255);
    translate(-width/2, -height/2);
    translate(100, 120);
    rectMode(CENTER);  
    rect(0, -55, 50, 50);

    rotate(PI/2);
    rect(0, -55, 50, 50);
    rotate(PI/2);
    rect(0, -55, 50, 50);
    rotate(PI/2);
    rect(0, -55, 50, 50);
    rotate(PI/2);
    translate(-30, 200);
    rect(0, 0, 50, 50);
    translate(60, 0);
    rect(0, 0, 50, 50);
    translate(-25, 60);
    rect(0, 0, 150, 35);
    translate(25, -60);
    translate(100, 0);
    for (int i=-50; i<100; i+=50) {
      rect(70, i, 150, 50);
    }
    translate(-100, 0);
    textSize(30);
    if (keycolor==1) {
      fill(0, 200, 200);
    } else {
      fill(100);
    }
    text("↑", -40, -245);
    if (keycolor==2) {
      fill(0, 200, 200);
    } else {
      fill(100);
    }
    text("↓", -40, -130);
    if (keycolor==3) {
      fill(0, 200, 200);
    } else {
      fill(100);
    }
    text("←", -100, -190);
    if (keycolor==4) {
      fill(0, 200, 200);
    } else {
      fill(100);
    }
    text("→", 10, -190);
    if (keycolor==5) {
      fill(0, 200, 200);
    } else {
      fill(100);
    }
    text("+", -70, 10);
    if (keycolor==6) {
      fill(0, 200, 200);
    } else {
      fill(100);
    }
    text("-", -10, 10);
    textSize(20);
    if (keycolor==7) {
      fill(255, 255, 0);
    } else {
      fill(0);
    }
    text(" Camera RESET", -100, 70);
    if (keycolor==8) {
      fill(255, 255, 0);
    } else {
      fill(0);
    }
    text("Case.1", 130, -45);
    if (keycolor==9) {
      fill(255, 255, 0);
    } else {
      fill(0);
    }
    text("Case.2", 130, 10);
    if (keycolor==10) {
      fill(255, 255, 0);
    } else {
      fill(0);
    }
    text("Case.3", 130, 60);
    fill(255);
    ellipse(170, -200, 100, 100);
    translate(170, -200);
    rotate(radians(click*45));
    ellipse(0, -30, 20, 20);
 //   println(mouseX+":"+mouseY);
  }

  void mouseReleased() {
    keycolor=0;
  }

  void keyPressed() {
    if (key=='q') {
      flag=1;
      dx=mouseX-transx;
      dy=mouseY-transy;
    } else if (keyCode==ALT) {
      flag=0;
    } else if (keyCode==LEFT) {
      transx-=5;
      keycolor=3;
    } else if (keyCode==RIGHT) {
      transx+=5;
      keycolor=4;
    } else if (keyCode==UP) {
      transy-=5;
      keycolor=1;
    } else if (keyCode==DOWN) {
      transy+=5;
      keycolor=2;
    } else if (key=='+') {
      zoom+=zoomplus;
      keycolor=5;
    } else if (key=='-') {
      zoom-=zoomplus;
      keycolor=6;
    } else if (key=='0') {
      eyex=350;
      eyey=250;
      keycolor=7;
    } else if (key=='1') {
      keycolor=8;
      if (base[0]==0) {
        base[0]=1;
      } else if (base[0]==1) {
        base[0]=0;
      }
    } else if (key=='2') {
      keycolor=9;
      if (base[1]==0) {
        base[1]=1;
      } else if (base[1]==1) {
        base[1]=0;
      }
    } else if (key=='3') {
      keycolor=10;
      if (base[2]==0) {
        base[2]=1;
      } else if (base[2]==1) {
        base[2]=0;
      }
    }
  }
  void keyReleased() {
    keycolor=0;
  }
  public void mousePressed() {
    if ( mouseX>75 && mouseX<125 && mouseY>40 && mouseY<90) {
      transy-=5;
      keycolor=1;
    } else if ( mouseX>75 && mouseX<125 && mouseY>150 && mouseY<200) {
      transy+=5;
      keycolor=2;
    } else if ( mouseX>20 && mouseX<70 && mouseY>95 && mouseY<145) {
      transx-=5;
      keycolor=3;
    } else if ( mouseX>130 && mouseX<180 && mouseY>95 && mouseY<145) {
      transx+=5;
      keycolor=4;
    } else if ( mouseX>45 && mouseX<95 && mouseY>295 && mouseY<345) {
      zoom+=zoomplus;
      keycolor=5;
    } else if ( mouseX>105 && mouseX<155 && mouseY>295 && mouseY<345) {
      zoom-=zoomplus;
      keycolor=6;
    } else if ( mouseX>30 && mouseX<180 && mouseY>100 && mouseY<398) {
      keycolor=7;
      eyex=350;
      eyey=250;
    } else if ( mouseX>225 && mouseX<375 &&mouseY>245 ) {
      for (int i=0; i<3; i++) {
        if ((mouseY-245)/50==i) {
          keycolor=8+i;
          if (base[i]==0) {
            base[(mouseY-245)/50]=1;
          } else if (base[i]==1) {
            base[(mouseY-245)/50]=0;
          }
        }
      }
    } else if (dist(mouseX, mouseY, 300, 125)<=50) {
      click+=1;
      delay(100);
    } else {
      keycolor=0;
    }
  }

  public void mouseDragged() {
  }
}