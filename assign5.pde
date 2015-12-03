PImage start1,start2,img1,img2,enemy,fighter,hp,treasure,end1,end2,shoot;
PImage flame[]=new PImage[5];
int enemyCount=8;
int g1,g2,fx,fy,tx,ty,lift,gameState,boo,shoots,ex,shootSP,enemys,score;

int[] enemyX=new int[enemyCount];
int[] enemyY=new int[enemyCount];
int shootX[]=new int[5];
int shootY[]=new int[5];
int shootboolean[]=new int[5];

PFont f;

boolean up=false,down=false,left=false,right=false,space=false;

final int GAMESTART=0,GAMERUN=1,GAMELOSE=2;

void setup ()
{
  size(640,480);
  start1=loadImage("img/start1.png");
  start2=loadImage("img/start2.png");
  img1=loadImage("img/bg1.png");
  img2=loadImage("img/bg2.png");
  enemy=loadImage("img/enemy.png");
  fighter=loadImage("img/fighter.png");
  hp=loadImage("img/hp.png");
  treasure=loadImage("img/treasure.png");
  end1=loadImage("img/end1.png");
  end2=loadImage("img/end2.png");
  flame[0]=loadImage("img/flame1.png");
  flame[1]=loadImage("img/flame2.png");
  flame[2]=loadImage("img/flame3.png");
  flame[3]=loadImage("img/flame4.png");
  flame[4]=loadImage("img/flame5.png");
  shoot=loadImage("img/shoot.png");
  
  g1=0;
  g2=640;
  addEnemy(0);
  fx=width-50; 
  fy=height/2-25;
  tx=floor(random(600));
  ty=floor(random(400));
  lift=40;
  for(int i=0;i<5;i++)
  {
    shootY[i]=-60;
    shootboolean[i]=0;
  }
  shoots=0;
  shootSP=5;

  f=createFont("Arial",24);
  score=0;
  gameState=GAMESTART;
}

void draw()
{
switch(gameState)
  {
    case GAMESTART:
    if(mouseX>205&&mouseX<460&&mouseY>375&&mouseY<420)
    {
      image(start1,0,0);
      if(mousePressed)
        gameState=GAMERUN;      
    }
    else
      image(start2,0,0);
    break;
    case GAMERUN://*********************************************************
    
    g1%=1280;
    g2%=1280;
    image(img1,g1-640,0);
    image(img2,g2-640,0);
    g1+=1;
    g2+=1;
    
    if(enemyX[0]>=1040)
    {
      enemys++;
      enemys%=3;
      addEnemy(enemys);  
    }
    for(int i=0;i<enemyCount;++i)
    {
      if(enemyX[i]!=-1||enemyY[i]!=-1)
      {
        image(enemy,enemyX[i],enemyY[i]);
        enemyX[i]+=2;
      }
    }
    
    if(up&&fy>=0)
      fy-=3;
    if(down&&fy<height-50)
      fy+=3;
    if(left&&fx>=0)
      fx-=3;
    if(right&&fx<width-50)
      fx+=3;
    image(fighter,fx,fy);
    
    image(treasure,tx,ty);
    if(isHit(fx,fy,50,50,tx,ty,40,40))
    {
      if(lift<200)
        lift+=20;
      tx=floor(random(600));
      ty=floor(random(400));
    }
    fill(250,0,0);
    rect(5,5,lift+5,20);
    image(hp,2,2);
    
    for(int i=0;i<8;i++)
    {
      if(isHit(enemyX[i],enemyY[i],60,60,fx,fy,50,50))
      {
        enemyY[i]=-60;
        lift-=40;
        if(lift<=0)
          gameState=GAMELOSE;
      }
    }
    for(int i=0;i<8;i++)
    {
      for(int j=0;j<5;j++)
      {
        if(shootY[j]>0&&isHit(enemyX[i],enemyY[i],60,60,shootX[j],shootY[j],35,35))
        {
          enemyY[i]=-600;
          shootY[j]=-35;
          scoreChange(999);
        }
      }
    }
    
    for(int i=0;i<5;i++)
    {
      if(shootY[i]>0)
      {
        image(shoot,shootX[i],shootY[i]);
        shootX[i]-=shootSP;
        if(shootX[i]<=-35)      
          shootY[i]=-35;
        if(shootY[shoots]>0)
          shoots++;
        shoots%=5; 
      }
      if(space&&shootY[shoots]<0)
      {
        shootX[shoots]=fx;
        shootY[shoots]=fy+12;
        space=false;
      }
    }
    for(int i=0;i<5;i++)
    {
      if(closestEnemy(fx,fy)!=-1&&enemyX[closestEnemy(fx,fy)]<fx&&shootY[i]>0&&enemyY[i]>0)
      {
        if(enemyY[closestEnemy(fx,fy)]+20<shootY[i])
          shootY[i]--;
        else
          shootY[i]++;
      }
    }
    
    textFont(f,16);
    text("score:"+score,1,450);
    //--------------------------------------------------------------
    break;
    case GAMELOSE:
    if(205<mouseX&&mouseX<440&&305<mouseY&&mouseY<350)
    {
      image(end1,0,0);
      if(mousePressed)
      {
        ZZZ();
        gameState=GAMERUN;
      }
    }
    else
      image(end2,0,0);
    break;
  }
}

// 0 - straight, 1-slope, 2-dimond
void addEnemy(int type)
{  
  for(int i=0;i<enemyCount;++i)
  {
    enemyX[i]=-1;
    enemyY[i]=-1;
  }
  switch(type) 
  {
    case 0:
      addStraightEnemy();
      break;
    case 1:
      addSlopeEnemy();
      break;
    case 2:
      addDiamondEnemy();
      break;
  }
}

void addStraightEnemy()
{
  float t=random(height-enemy.height);
  int h=int(t);
  for (int i=0;i<5;++i) 
  {
    enemyX[i]=(i+1)*-80;
    enemyY[i]=h;
  }
}
void addSlopeEnemy()
{
  float t=random(height-enemy.height*5);
  int h=int(t);
  for (int i=0;i<5;++i) 
  {
    enemyX[i]=(i+1)*-80;
    enemyY[i]=h+i*40;
  }
}
void addDiamondEnemy()
{
  float t=random(enemy.height*3,height-enemy.height*3);
  int h =int(t);  
  int x_axis=1;
  for (int i=0;i<8;++i) 
  {
    if(i==0||i==7) 
    {
      enemyX[i]=x_axis*-80;
      enemyY[i]=h;
      x_axis++;
    }
    else if(i==1||i==5)
    {
      enemyX[i]=x_axis*-80;
      enemyY[i]=h+1*60;
      enemyX[i+1]=x_axis*-80;
      enemyY[i+1]=h-1*60;
      i++;
      x_axis++;      
    }
    else {
      enemyX[i]=x_axis*-80;
      enemyY[i]=h+2*60;
      enemyX[i+1]=x_axis*-80;
      enemyY[i+1]=h-2*60;
      i++;
      x_axis++;
    }
  }
}
//************************************************************************************************************
int closestEnemy(int x,int y)
{
  int s=640*640+480*480,re=-1;
  for(int i=0;i<8;i++)
  {
    if(s>(enemyX[i]-x)*(enemyX[i]-x)+(enemyY[i]-y)*(enemyY[i]-y))
    {
      re=i;
      s=(enemyX[i]-x)*(enemyX[i]-x)+(enemyY[i]-y)*(enemyY[i]-y);
    }
  }
  return re;
}
boolean isHit(int ax,int ay,int aw,int ah,int bx,int by,int bw,int bh)
{
  if(
  (ax<bx&&bx<ax+aw&&ay<by&&by<ay+ah)||
  (ax<bx+bw&&bx+bw<ax+aw&&ay<by&&by<ay+ah)||
  (ax<bx&&bx<ax+aw&&ay<by+bh&&by+bh<ay+ah)||
  (ax<bx+bw&&bx+bw<ax+aw&&ay<by+bh&&by+bh<ay+ah)
  )
    return true;
  return false;
}
void scoreChange(int value)
{
  score+=20;
}
void ZZZ()
{
  g1=0;
  g2=640;
  addEnemy(0);
  fx=width-50; 
  fy=height/2-25;
  tx=floor(random(600));
  ty=floor(random(400));
  lift=40;
  for(int i=0;i<5;i++)
  {
    shootY[i]=-60;
    shootboolean[i]=0;
  }
  shoots=0;
  score=0;
}
void keyPressed()
{
  if(key==32)
  {
    space=true;
  }
  if(key==CODED)
  {
    switch(keyCode)
    {
      case UP:
      up=true;
      break;
      case DOWN:
      down=true;
      break;
      case LEFT:
      left=true;
      break;
      case RIGHT:
      right=true;
      break;
    }
  }
}
void keyReleased()
{
  if(key==32)
    space=false;
  if(key==CODED)
  {
    switch(keyCode)
    {
      case UP:
      up=false;
      break;
      case DOWN:
      down=false;
      break;
      case LEFT:
      left=false;
      break;
      case RIGHT:
      right=false;
      break;
    }
  }
}
