import ajd4jp.*;//カレンダーの情報
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;

Application app;
Tab tab1, tab2, tab3;
PFont meiryo, segoe, segoe20, segoe25, segoe60;
Boolean l_mousepressed = false;
void setup() 
{
  size(480, 640);
  noStroke();
  smooth();
  app = new Alarm();
  tab1 = new Tab(0, height-62, new Alarm());
  tab2 = new Tab(161, height-62, new ACalendar());
  tab3 = new Tab(322, height-62, new BCalendar());
  textFont(createFont("メイリオ", 48, true));
  meiryo = createFont("Meiryo", 48, true);
  segoe = loadFont(dataPath("fonts/SegoeUI-Light-48.vlw"));
  segoe20 = loadFont(dataPath("fonts/SegoeUI-Light-20.vlw"));
  segoe25 = loadFont(dataPath("fonts/SegoeUI-Light-25.vlw"));
  segoe60 = loadFont(dataPath("fonts/SegoeUI-Light-60.vlw"));
}

void draw() 
{
  background(255);
  app.Run();
}

//数値から文字に変換する
String convertMonth(int m)
{
  String month = "";
  switch(m) {
  case 1: 
    month = "January"; 
    break;
  case 2: 
    month = "February"; 
    break;
  case 3: 
    month = "March"; 
    break;
  case 4: 
    month = "April"; 
    break;
  case 5: 
    month = "May"; 
    break;
  case 6: 
    month = "June"; 
    break;
  case 7: 
    month = "July"; 
    break;
  case 8: 
    month = "August"; 
    break;
  case 9: 
    month = "September"; 
    break;
  case 10: 
    month = "October"; 
    break;
  case 11: 
    month = "November"; 
    break;
  case 12: 
    month = "December"; 
    break;
  }
  return month;
}

//左クリックして離した時に判定がつく関数
Boolean LeftClick()
{
  Boolean leftclick = false;
  if (mouseButton == LEFT) {
    l_mousepressed = true;
  } else {
    if (l_mousepressed == true ) {
      leftclick = true;
    }
    l_mousepressed = false;
  }
  return leftclick;
}
