//Todays scheduleのクラス
class Alarm extends Application
{
  private AJD ajd;
  private Month mon = null;
  private String[] e_week = {
    "SUNDAY", "MONDAY", "TUESDAY", "WEDNESDAY", "THURSDAY", "FRIDAY", "SATURDAY"
  };
  private String[] j_week = {
    "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"
  };
  private String week = "";
  private int weekIndex = 0;
  private String[][] lectures = {
    {
      "線形代数学Ⅰ", "余暇と健康Ⅱ", "", "", ""
    }
    , 
    {
      "解析学Ⅰ", "数学総合演習Ⅰ", "", "", ""
    }
    , 
    {
      "CommunicationⅠ", "", "", "ロボットの科学技術", "認知科学"
    }
    , 
    {
      "情報表現入門", "情報表現入門", "情報表現入門", "物理学入門", ""
    }
    , 
    {
      "", "科学技術リテラシ", "CommunicationⅠ", "情報機器概論", ""
    }
    , 
    {
      "", "", "", "", ""
    }
    , 
    {
      "", "", "", "", ""
    }
  };
  public Alarm()
  {
    try {
      ajd = new AJD(year(), month(), day());
      mon = new Month(year(), month());
    }
    catch( AJDException e ) {
    }
    StringBuilder sb = new StringBuilder();
    sb.append(ajd.getWeek());
    String s = sb.toString();
    for (int i=0; i<e_week.length; i++) {
      if (e_week[i].equals(s)) {
        week = j_week[i];
        weekIndex = i-1;
        break;
      }
    }
  }

  public void Run()
  {
    fill(#0E7AC4);
    rect(0, 0, width, 70);
    fill(#F5F5F5);
    textFont(segoe, 40);
    text("Today's schedule", 100, 50);
    fill(#737373);
    textFont(segoe60);
    text(int(hour())+":"+nf(int(minute()), 2), 20, 135);
    textFont(segoe25);
    fill(#737373);
    text(week, 180, 105);
    text(convertMonth(int(month()))+"  "+ajd.getDay(), 180, 140);
    fill(#0E7AC4);
    textFont(segoe, 30);
    text("Lectures", 20, 200);
    drawLectures();
    goSchedule();
    goStudyMgr();
    stroke(#F5F5F5);
    strokeWeight(2);
    line(5, 150, width-5, 150);
    stroke(#0E7AC4);
    strokeWeight(1);
    line(5, 210, width-5, 210);
    noStroke();
    tab1.Update(#0E7AC4);
    tab2.Update(#0E7AC4);
    tab3.Update(#0E7AC4);
  }
  
  //時間割を描画
  private void drawLectures()
  {
    textFont(segoe25, 22);
    fill(#009EEC);
    text("1st ( 9:00 - 10:30)", 20, 240);
    textFont(meiryo, 22);
    text(lectures[weekIndex][0], 200, 240);

    fill(#40BFC1);
    textFont(segoe25, 22);
    text("2nd (10:40 - 12:10)", 20, 280);
    textFont(meiryo, 22);
    text(lectures[weekIndex][1], 200, 280);

    fill(#009EEC);
    textFont(segoe25, 22);
    text("3rd (13:10 - 14:40)", 20, 320);
    textFont(meiryo, 22);
    text(lectures[weekIndex][2], 200, 320);

    fill(#40BFC1);
    textFont(segoe25, 22);
    text("4th (14:50 - 16:20)", 20, 360);
    textFont(meiryo, 22);
    text(lectures[weekIndex][3], 200, 360);

    fill(#009EEC);
    textFont(segoe25, 22);
    text("5th (16:30 - 18:00)", 20, 400);
    textFont(meiryo, 22);
    text(lectures[weekIndex][4], 200, 400);
  }
  
  //スケジュールに飛ぶ枠
  private void goSchedule()
  {
    textFont(segoe, 32);
    if (mouseX >20 && mouseX < 220 && mouseY > 450 && mouseY < 510) {
      noStroke();
      fill(#d04233);
      rect(20, 450, 200, 60);
      fill(255);
      text("Schedule", 50, 490);
      if (LeftClick()) app = new DayCalendar(ajd);
    } else {
      stroke(#d04233);
      fill(255);
      rect(20, 450, 200, 60);
      fill(#d04233);
      text("Schedule", 50, 490);
      noStroke();
    }
  }
  //勉強スケジュールに飛ぶ枠
  private void goStudyMgr()
  {
    textFont(segoe, 32);
    if (mouseX >250 && mouseX < 450 && mouseY > 450 && mouseY < 510) {
      noStroke();
      fill(#27B399);
      rect(250, 450, 200, 60);
      fill(255);
      text("Assignment", 270, 490);
      if (LeftClick()) app = new StudyManager(ajd);
    } else {
      stroke(#27B399);
      fill(255);
      rect(250, 450, 200, 60);
      fill(#27B399);
      text("Assignment", 270, 490);
      noStroke();
    }
  }
}
