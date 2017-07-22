//カレンダーのクラス
class ACalendar extends Application
{
  protected Month mon = null;
  protected AJD today = null;
  protected String path = "";
  public ACalendar()
  {
    try {
      mon = new Month(year(), month());
      today = new AJD(year(), month(), day());
    }
    catch( AJDException e ) {
    }
  }

  public void Run() 
  {
    drawTop();
    drawAxies();
    LightBlock();
    drawCalendar();
    tab1.Update(#d04233);
    tab2.Update(#d04233);
    tab3.Update(#d04233);
  }

  //枠線を描画
  protected void drawAxies()
  {
    String[] w = {
      "Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"
    };
    fill(#737373);
    stroke(#bdc3c7);
    textFont(meiryo, 18);
    for (int i=0; i<8; i++) {
      if (i < 7) text(w[i], 15+ float(i)*68.5, 100);
      line(float(i)*68.5, 110, float(i)*68.5, 530);
      if (i != 7) line(0, 110 + float(i)*70, width, 110 + float(i)*70);
    }
    noStroke();
  }
  
  //カレンダーの数値を描画
  protected void drawCalendar()
  {
    fill(#737373);
    textFont(meiryo, 14);
    for (int i=1;; i++) {
      AJD[] days = mon.getWeek( i, false );
      if (days == null) break;
      for (int j=0; j<days.length; j++) {

        if (j == 0) {
          fill(#F76B6B);
        } else if (j == 6) {
          fill(#71BCCE);
        } else {
          fill(#737373);
        }
        if (days[j] == null) {
        } else {
          textFont(meiryo, 14);
          text(days[j].getDay(), 45+j*68, 100+i*70);
        }
        setPath(days[j]);
        File f = new File(path);
        if (f.exists()) {
          textFont(meiryo, 20);
          fill(#F84545);
          text("☆", 10+j*68, 60+i*70);
        }
      }
    }
  }
  
  //日付のデータが格納されているフォルダのパスを取得
  protected void setPath(AJD day)
  {
    if (day != null) path = dataPath("schedules" +"/"+ day.getYear() + "/" + day.getMonth() +"/"+ day.getDay());
  }
  //画面上の帯の部分を描画する
  protected void drawTop()
  {
    fill(#d04233);
    rect(0, 0, width, 70);
    fill(#F5F5F5);
    textFont(segoe, 40);
    text(convertMonth(mon.getMonth())+" "+mon.getYear(), 150, 50);
    textFont(meiryo, 48);
    if (mouseX >10 && mouseX < 50 && mouseY > 0 && mouseY < 50) {
      if (LeftClick()) mon = mon.add(-1);
      fill(#F76B6B);
    } else {
      fill(#F5F5F5);
    }
    text("<", 10, 50);
    if (mouseX >430 && mouseX < 470 && mouseY > 0 && mouseY < 50) {
      if (LeftClick()) mon = mon.add(1);
      fill(#F76B6B);
    } else {
      fill(#F5F5F5);
    }
    text(">", 430, 50);
  }
  //マウスカーソルが重なった枠を黄色に照らす
  protected void LightBlock()
  {
    AJD[] days = new AJD[7];
    for (int i=0; i<7; i++) {
      days[i] = null;
    }
    fill(#FEF160);
    noStroke();
    for (int r=1;; r++) {
      days = mon.getWeek(r, false);
      if (days == null) break;
      for (int c=0; c<7; c++) {
        if (mouseX > float(c)*68.5 && mouseX < float(c+1)*68.5 && mouseY > 110 + float(r-1)*70 && mouseY < 110 + float(r)*70 && days[c] != null) {
          rect(float(c)*68.5, 110 + float(r-1)*70, 68.5, 70);
          if (mouseButton == LEFT && days[c] != null) app = new DayCalendar(days[c]);
        }
      }
    }
  }
}

//日付ごとのカレンダー
class DayCalendar extends Application
{
  private AJD day = null;
  private String txtpath, dirpath;
  private String[] lines, scList = {"起床","就寝","食事","買い物","掃除","風呂","余暇"};
  private String[][] ref;
  private int[] sIndexs;
  private int[][] time;
  private File f_day, f_dir;
  private FileWriter fw;
  private int snum;
  private final int MAX_SNUM = 6;
  private int sindex = 0, hour = 0, min = 0;
  private String[] e_week = {
    "SUNDAY", "MONDAY", "TUESDAY", "WEDNESDAY", "THURSDAY", "FRIDAY", "SATURDAY"
  };
  private String[] j_week = {
    "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"
  };
  private String week = "";
  public DayCalendar(AJD day)
  {
    this.day = day;
    dirpath = dataPath("schedules" +"/"+ day.getYear() + "/" + day.getMonth() +"/"+ day.getDay());
    txtpath = dataPath("schedules" +"/"+ day.getYear() + "/" + day.getMonth() +"/"+ day.getDay() + "/" + day.getDay() + ".txt");
    f_dir = new File(dirpath);
    f_day = new File(txtpath);
    
    StringBuilder sb = new StringBuilder();
    sb.append(day.getWeek());
    String s = sb.toString();
    for (int i=0; i<e_week.length; i++) {
      if (e_week[i].equals(s)) {
        week = j_week[i];
      }
    }
    snum = 0;
    if (f_dir.exists()) {
      loadSchedule(txtpath);
    } else {
      time = null;
      sIndexs = null;
    }
  }

  public void Run() 
  {
    drawTop();
    drawAdd();
    drawSchedule();
  }
  
  //スケジュールを読み込む
  private void loadSchedule(String datapath)
  {
    lines = loadStrings(datapath);
    ref = new String[lines.length][3];
    time = new int[lines.length][2];
    sIndexs = new int[lines.length];
    for (int i=0; i<lines.length; i++) {
      ref[i] = lines[i].split(",");
    }
    for (int i=0; i<lines.length; i++) {
      for (int j=0; j<2; j++) {
        time[i][j] = int(ref[i][j]);
      }
    }
    for (int i=0; i<lines.length; i++) {
      sIndexs[i] = int(ref[i][2]);
    }
    snum = lines.length;
    sortSchedule();
  }
  
  //スケジュールを時間順に並べ替える
  private void sortSchedule()
  {
    int tmpindex = 0, tmptime1 = 0, tmptime2 = 0;

    for (int i=0; i<sIndexs.length-1; i++) {
      for (int j = sIndexs.length-1; j > i; j--) {
        if (time[j-1][1] > time[j][1]) {
          tmptime1 = time[j][0];
          tmptime2 = time[j][1];
          tmpindex = sIndexs[j];
          time[j][0] = time[j-1][0];
          time[j][1] = time[j-1][1];
          sIndexs[j] = sIndexs[j-1];
          time[j-1][0] = tmptime1;
          time[j-1][1] = tmptime2;
          sIndexs[j-1] = tmpindex;
        }
      }
    }

    for (int i=0; i<time.length-1; i++) {
      for (int j = time.length-1; j > i; j--) {
        if (time[j-1][0] > time[j][0]) {
          tmptime1 = time[j][0];
          tmptime2 = time[j][1];
          tmpindex = sIndexs[j];
          time[j][0] = time[j-1][0];
          time[j][1] = time[j-1][1];
          sIndexs[j] = sIndexs[j-1];
          time[j-1][0] = tmptime1;
          time[j-1][1] = tmptime2;
          sIndexs[j-1] = tmpindex;
          println("a");
        }
      }
    }
  }
  
  //スケジュールを追加する
  private void addSchedule(int h, int m, int index)
  {
    if (snum >= MAX_SNUM) return;
    if (!f_dir.exists()) {
      f_dir.mkdirs();
      try {
        f_day.createNewFile();
      }
      catch(IOException e) {
      }
    }
    try {
      fw = new FileWriter(f_day, true);
      fw.write(hour+","+min+","+sindex+"\r\n");
      fw.close();
      snum++;
      app = new DayCalendar(this.day);
      println("suc");
    }
    catch(IOException e) {
      println("error");
    }
  }
  //スケジュールを描画する
  private void drawSchedule()
  {
    fill(#737373);
    if (time != null) {
      for (int i=0; i<time.length; i++) {
        text(nf(time[i][0], 2) + ":" + nf(time[i][1], 2), 20, 115+i*60);
      }
    }
    if (sIndexs != null) {
      for (int i=0; i<sIndexs.length; i++) {
        textFont(createFont("メイリオ", 30, true));
        text(scList[sIndexs[i]], 160, 115+i*60);
      }
    }
  }
  private void drawTop()
  {
    fill(#d04233);
    rect(0, 0, width, 70);
    fill(#F5F5F5);
    textFont(segoe);
    text(day.getDay(), 20, 50);
    textFont(segoe20);
    text(week, 80, 30);
    text(convertMonth(day.getMonth())+" "+day.getYear(), 80, 56);
    stroke(#F5F5F5);
    strokeWeight(2);
    for (int i=0; i<6; i++) {
      line(5, 130+i*60, width-5, 130+i*60);
    }
    strokeWeight(1);
    noStroke();
    if (mouseX > 392.5 && mouseX < 447.5 && mouseY > 7.5 && mouseY < 82.5) {
      fill(#666666);
      if (mouseButton == LEFT) app = new ACalendar();
    } else {
      fill(#F5F5F5);
    }
    ellipse(420, 35, 55, 55);
    fill(#d04233);
    rect(404, 20, 31, 4);
    stroke(#d04233);
    for (int i=0; i<5; i++) {
      line(404+i*7.5, 24, 404+i*7.5, 45);
      if (i<3) line(404, 31+i*7, 432, 31+i*7);
    }
  }
  
  //add scheduleを描画する
  private void drawAdd()
  {
    fill(#d04233);
    textFont(segoe, 30);
    text("Add Schedule", 50, 470);

    stroke(#d04233);
    strokeWeight(1);
    line(5, 480, width-5, 480);
    fill(#F5F5F5);
    rect(55, 495,413 , 60);
    noStroke();
    fill(#d04233);
    textFont(createFont("メイリオ", 30, true));
    text(scList[sindex], 70, 535);
    textFont(segoe, 48);
    text(nf(hour, 2), 70, 610);
    text(nf(min, 2), 220, 610);
    //スケジュールリスト
    if (mouseX > 5 && mouseX < 45 && mouseY > 495 && mouseY < 525) {
      fill(#d04233);
      noStroke();
      rect(5, 495, 40, 30);
      fill(#F5F5F5);
      textFont(meiryo, 20);
      text("↑", 15, 518);
      stroke(#d04233);
      rect(5, 526, 39, 29);
      fill(#d04233);
      text("↓", 15, 549);
      noStroke();
      if (LeftClick()) sindex = (sindex+1)%scList.length;
    } else if (mouseX > 5 && mouseX < 45 && mouseY > 526 && mouseY < 556) {
      fill(#d04233);
      noStroke();
      rect(5, 526, 40, 30);
      textFont(meiryo, 20);
      stroke(#d04233);
      fill(#F5F5F5);
      rect(5, 495, 39, 29);
      fill(#d04233);
      text("↑", 15, 518);
      fill(#F5F5F5);
      text("↓", 15, 549);
      noStroke();
      if (LeftClick()) sindex = (sindex+scList.length-1)%scList.length;
    } else {
      stroke(#d04233);
      fill(#F5F5F5);
      rect(5, 495, 39, 29);
      rect(5, 526, 39, 29);
      fill(#d04233);
      textFont(meiryo, 20);
      text("↑", 15, 518);
      text("↓", 15, 549);
      noStroke();
    }
    //時
    if (mouseX > 5 && mouseX < 45 && mouseY > 565 && mouseY < 595) {
      fill(#d04233);
      noStroke();
      rect(5, 565, 40, 30);
      fill(#F5F5F5);
      textFont(meiryo, 20);
      text("↑", 15, 588);
      stroke(#d04233);
      rect(5, 596, 39, 29);
      fill(#d04233);
      text("↓", 15, 619);
      noStroke();
      if (LeftClick()) hour = (hour+1+25)%25;
    } else if (mouseX > 5 && mouseX < 45 && mouseY > 596 && mouseY < 626) {
      fill(#d04233);
      noStroke();
      rect(5, 596, 40, 30);
      textFont(meiryo, 20);
      stroke(#d04233);
      fill(#F5F5F5);
      rect(5, 565, 39, 29);
      fill(#d04233);
      text("↑", 15, 588);
      fill(#F5F5F5);
      text("↓", 15, 619);
      noStroke();
      if (LeftClick()) hour = (hour-1+25)%25;
    } else {
      stroke(#d04233);
      fill(#F5F5F5);
      rect(5, 565, 39, 29);
      rect(5, 596, 39, 29);
      fill(#d04233);
      textFont(meiryo, 20);
      text("↑", 15, 588);
      text("↓", 15, 619);
      noStroke();
    }
    //分
    if (mouseX > 155 && mouseX < 195 && mouseY > 565 && mouseY < 595) {
      fill(#d04233);
      noStroke();
      rect(155, 565, 40, 30);
      fill(#F5F5F5);
      textFont(meiryo, 20);
      text("↑", 165, 588);
      stroke(#d04233);
      rect(155, 596, 39, 29);
      fill(#d04233);
      text("↓", 165, 619);
      noStroke();
      if (LeftClick()) min = (min+1+60)%60;
    } else if (mouseX > 155 && mouseX < 195 && mouseY > 596 && mouseY < 626) {
      fill(#d04233);
      noStroke();
      rect(155, 596, 40, 30);
      textFont(meiryo, 20);
      stroke(#d04233);
      fill(#F5F5F5);
      rect(155, 565, 39, 29);
      fill(#d04233);
      text("↑", 165, 588);
      fill(#F5F5F5);
      text("↓", 165, 619);
      noStroke();
      if (LeftClick()) min = (min-1+60)%60;
    } else {
      stroke(#d04233);
      fill(#F5F5F5);
      rect(155, 565, 39, 29);
      rect(155, 596, 39, 29);
      fill(#d04233);
      textFont(meiryo, 20);
      text("↑", 165, 588);
      text("↓", 165, 619);
      noStroke();
    }
    //addボタン
    if (mouseX > 340 && mouseX < 470 && mouseY > 565 && mouseY < 625) {
      fill(#d04233);
      rect(340, 565, 130, 60);
      fill(#F5F5F5);
      textFont(segoe, 36);
      text("Add", 372, 607);
      if (LeftClick()) {
        addSchedule(hour, min, sindex);
      }
    } else {
      stroke(#d04233);
      fill(#F5F5F5);
      rect(340, 565, 129, 59);
      noStroke();
      fill(#d04233);
      textFont(segoe, 36);
      text("Add", 372, 607);
    }
  }
}
