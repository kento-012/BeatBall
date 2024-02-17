import processing.serial.*;

Serial myPort;
char inputChar;
int inputData;

//int NUM = 1;
int NUM = 1000;
//int NUM = 1500;
//int NUM = 2000;
ParticleVec3[] particles = new ParticleVec3[NUM];

float seconds = 0; //開始してからの経過時間
int count = 0; //心拍を打った回数
float heatSpeed = 0; //直近2回分の心拍数の間隔
int heartNum; //1分間の心拍数
float[] time = new float[2];



void setup() {
  size(600, 600, P3D);
  for (int i = 0; i < NUM; i++) {
    particles[i] = new ParticleVec3();
    particles[i].location.set(random(width), random(height), random(height/2));
    particles[i].gravity.set(0.0, 0.0, 0.0);
    particles[i].friction = 0.05;
    //particles[i].friction = 0.09;
  }

  String[] portList = Serial.list();
  for (int i=0; i < portList.length; i++) {
    println(i +" : "+portList[i]);
  }
  myPort = new Serial(this, portList[3], 115200);
  inputChar ='N';
  inputData = 0;

  //blendMode(SCREEN);
  //blendMode(ADD);
}

void draw() {
  //background(0);

  if ( myPort.available() > 0) {
    String inputString[] = split(myPort.readString(), ",");
    inputChar = inputString[0].charAt(0);
    inputData = int(inputString[1]);
    println(inputChar +", "+ inputData);
  }

  if (inputChar == 'P') {
    inputChar = 'N';
    for (int i = 0; i < NUM; i++) {
      float angle = random(PI * 2.0);
      float angle2 = random(PI * 2.0);
      float length = random(20);
      //float length = 10;
      PVector force = new PVector(cos(angle) * length, sin(angle) * length, cos(angle2) * length);
      //PVector force = new PVector(10.0, 10.0, 10.0);
      //PVector force = new PVector(10.0, 10.0);
      particles[i].addForce(force);

      //println(cos(angle) * length, sin(angle) * length, cos(angle2) * length);
    }


    count = count + 1;

    if (count%2 == 0) {
      //countが偶数の時に現在時間を代入
      time[0] = seconds;
    } else {
      //countが奇数の時に現在時間を代入
      time[1] = seconds;
    }
    //直近2回分の心拍数の間隔を計算
    heatSpeed = abs(time[0] - time[1]);
  }



  //fill(0, 20);
  fill(0, 20);
  rect(0, 0, width, height);
  //fill(255);
  filter(BLUR, 1.2);
  noStroke();
  for (int i = 0; i < NUM; i++) {
    particles[i].update();
    particles[i].draw();
    //particles[i].throughWalls();
    particles[i].bounceOffWalls();
  }

  parameter();
}


void parameter() {
  //秒数を取得
  seconds = millis()/1000.0;

  fill(255);
  textSize(20);
  //開始してからの経過時間
  text("seconds: " + seconds, 20, 30);
  //心拍を打った回数
  text("count: " + count, 20, 60);
  //直近2回分の心拍数の間隔
  text("heatSpeed: " + heatSpeed, 20, 90);
  //1分間の心拍数
  heartNum = int(60/heatSpeed);
  if (heatSpeed >= 0.1) {
    text(heartNum + " beats per minute.", 20, 120);
  }
}

//クリックで操作可能にするなら有効にする
//void mousePressed() {
//  inputChar = 'P';
//}
