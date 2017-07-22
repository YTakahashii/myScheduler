class BCalendar extends ACalendar
{
  public BCalendar()
  {
    super();
  }

  @Override
    public void Run() 
  {
    drawTop();
    drawAxies();
    LightBlock();
    drawCalendar();
    tab1.Update(#27B399);
    tab2.Update(#27B399);
    tab3.Update(#27B399);
  }
  protected void setPath(AJD day)
  {
    if (day != null) path = dataPath("assignments" +"/"+ day.getYear() + "/" + day.getMonth() +"/"+ day.getDay());
  }
  protected void drawTop()
  {
    fill(#27B399);
    rect(0, 0, width, 70);
    fill(#F5F5F5);
    textFont(segoe, 40);
    text(convertMonth(mon.getMonth())+" "+mon.getYear(), 150, 50);
    textFont(meiryo, 48);
    if (mouseX >10 && mouseX < 50 && mouseY > 0 && mouseY < 50) {
      if (LeftClick()) mon = mon.add(-1);
      fill(#C5D86D);
    } else {
      fill(#F5F5F5);
    }
    text("<", 10, 50);
    if (mouseX >430 && mouseX < 470 && mouseY > 0 && mouseY < 50) {
      if (LeftClick()) mon = mon.add(1);
      fill(#C5D86D);
    } else {
      fill(#F5F5F5);
    }
    text(">", 430, 50);
  }
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
          if (mouseButton == LEFT && days[c] != null) app = new StudyManager(days[c]);
        }
      }
    }
  }
}


class StudyManager extends Application
{
  AJD day = null;
  private String txtpath, dirpath;
  private String[] lines, scList;
  private String[][] ref;
  private int[] sIndexs, cIndexs;
  private File f_day, f_dir;
  private FileWriter fw;
  private int snum;
  private final int MAX_SNUM = 6;
  private int sindex = 0, cindex = 0;
  private String[] e_week = {
    "SUNDAY", "MONDAY", "TUESDAY", "WEDNESDAY", "THURSDAY", "FRIDAY", "SATURDAY"
  };
  private String[] j_week = {
    "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"
  };
  private String week = "";

  private String[] courseList = {
    "線形代数学", "解析学", "数学総合演習", "情報表現入門", "科学技術リテラシ", "認知科学", "ロボットの科学技術"
  };
  private  String[] categList = {
    "課題", "レポート", "テスト", "予習", "復習"
  };
  public StudyManager(AJD day)
  {
    this.day = day;
    dirpath = dataPath("assignments" +"/"+ day.getYear() + "/" + day.getMonth() +"/"+ day.getDay());
    txtpath = dataPath("assignments" +"/"+ day.getYear() + "/" + day.getMonth() +"/"+ day.getDay() + "/" + day.getDay() + ".txt");
    f_dir = new File(dirpath);
    f_day = new File(txtpath);
    lines = loadStrings("assignments/assignmentlist.txt");
    scList = lines;
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
      sIndexs = null;
      cIndexs = null;
    }
  }

  public void Run() 
  {
    drawTop();
    drawAdd();
    drawSchedule();
  }

  private void loadSchedule(String datapath)
  {
    lines = loadStrings(datapath);
    ref = new String[lines.length][2];
    sIndexs = new int[lines.length];
    cIndexs = new int[lines.length];

    for (int i=0; i<lines.length; i++) {
      ref[i] = lines[i].split(",");
    }

    for (int i=0; i<lines.length; i++) {
      sIndexs[i] = int(ref[i][0]);
      cIndexs[i] = int(ref[i][1]);
    }
    snum = lines.length;
  }

  private void addSchedule()
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
      fw.write(sindex+","+cindex+"\r\n");
      fw.close();
      snum++;
      app = new StudyManager(this.day);
      println("suc");
    }
    catch(IOException e) {
      println("error");
    }
  }

  private void drawSchedule()
  {
    fill(#737373);
    if (sIndexs != null) {
      for (int i=0; i<sIndexs.length; i++) {
        textFont(createFont("メイリオ", 30, true));
        text(categList[cIndexs[i]], 20, 115+i*60);
        text(courseList[sIndexs[i]], 170, 115+i*60);
      }
    }
  }
  private void drawTop()
  {
    fill(#27B399);
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
      if (mouseButton == LEFT) app = new BCalendar();
    } else {
      fill(#F5F5F5);
    }
    ellipse(420, 35, 55, 55);
    fill(#27B399);
    rect(404, 20, 31, 4);
    stroke(#27B399);
    for (int i=0; i<5; i++) {
      line(404+i*7.5, 24, 404+i*7.5, 45);
      if (i<3) line(404, 31+i*7, 432, 31+i*7);
    }
  }

  private void drawAdd()
  {
    fill(#27B399);
    textFont(segoe, 30);

    text("Add Assignment", 50, 470);

    stroke(#27B399);
    strokeWeight(1);
    line(5, 480, width-5, 480);
    fill(#F5F5F5);
    rect(55, 495, 413, 60);
    rect(55, 565, 250, 60);
    noStroke();
    fill(#27B399);
    textFont(createFont("メイリオ", 30, true));
    text(courseList[sindex], 70, 535);
    text(categList[cindex], 70, 610);
    textFont(segoe, 48);
    //科目リスト
    if (mouseX > 5 && mouseX < 45 && mouseY > 495 && mouseY < 525) {
      fill(#27B399);
      noStroke();
      rect(5, 495, 40, 30);
      fill(#F5F5F5);
      textFont(meiryo, 20);
      text("↑", 15, 518);
      stroke(#27B399);
      rect(5, 526, 39, 29);
      fill(#27B399);
      text("↓", 15, 549);
      noStroke();
      if (LeftClick()) sindex = (sindex+1)%courseList.length;
    } else if (mouseX > 5 && mouseX < 45 && mouseY > 526 && mouseY < 556) {
      fill(#27B399);
      noStroke();
      rect(5, 526, 40, 30);
      textFont(meiryo, 20);
      stroke(#27B399);
      fill(#F5F5F5);
      rect(5, 495, 39, 29);
      fill(#27B399);
      text("↑", 15, 518);
      fill(#F5F5F5);
      text("↓", 15, 549);
      noStroke();
      if (LeftClick()) sindex = (sindex+courseList.length-1)%courseList.length;
    } else {
      stroke(#27B399);
      fill(#F5F5F5);
      rect(5, 495, 39, 29);
      rect(5, 526, 39, 29);
      fill(#27B399);
      textFont(meiryo, 20);
      text("↑", 15, 518);
      text("↓", 15, 549);
      noStroke();
    }
    //種類
    if (mouseX > 5 && mouseX < 45 && mouseY > 565 && mouseY < 595) {
      fill(#27B399);
      noStroke();
      rect(5, 565, 40, 30);
      fill(#F5F5F5);
      textFont(meiryo, 20);
      text("↑", 15, 588);
      stroke(#27B399);
      rect(5, 596, 39, 29);
      fill(#27B399);
      text("↓", 15, 619);
      noStroke();
      if (LeftClick()) cindex = (cindex+1)%categList.length;
    } else if (mouseX > 5 && mouseX < 45 && mouseY > 596 && mouseY < 626) {
      fill(#27B399);
      noStroke();
      rect(5, 596, 40, 30);
      textFont(meiryo, 20);
      stroke(#27B399);
      fill(#F5F5F5);
      rect(5, 565, 39, 29);
      fill(#27B399);
      text("↑", 15, 588);
      fill(#F5F5F5);
      text("↓", 15, 619);
      noStroke();
      if (LeftClick()) cindex = (cindex+categList.length-1)%categList.length;
    } else {
      stroke(#27B399);
      fill(#F5F5F5);
      rect(5, 565, 39, 29);
      rect(5, 596, 39, 29);
      fill(#27B399);
      textFont(meiryo, 20);
      text("↑", 15, 588);
      text("↓", 15, 619);
      noStroke();
    }

    //addボタン
    if (mouseX > 340 && mouseX < 470 && mouseY > 565 && mouseY < 625) {
      fill(#27B399);
      rect(340, 565, 130, 60);
      fill(#F5F5F5);
      textFont(segoe, 36);
      text("Add", 372, 607);
      if (LeftClick()) {
        addSchedule();
      }
    } else {
      stroke(#27B399);
      fill(#F5F5F5);
      rect(340, 565, 129, 59);
      noStroke();
      fill(#27B399);
      textFont(segoe, 36);
      text("Add", 372, 607);
    }
  }
}
