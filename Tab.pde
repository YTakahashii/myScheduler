//画面下にある切り替えタブのクラス
class Tab 
{
  private float x, y, w, h;
  private Application a;
  private String name = "";
  public Tab(float x, float y, Application a)
  {
    this.x = x;
    this.y = y;
    w = 158;
    h = 60;
    this.a = a;
    if (a instanceof Alarm) {
      name = "Today's\r\nSchedule";
    } else if (a instanceof ACalendar && !(a instanceof BCalendar)) {
      name = "Schedule\r\nCalendar";
    } else {
      name = "Assignment\r\nCalendar";
    }
  }

  public void Update(color col)
  {
    fill(col);
    rect(x, y, w, h);
    if ((mouseX >= x && mouseX <= x+w && mouseY >= y && mouseY <= y+h) || (app.getClass() == a.getClass())) {
      fill(col);
      rect(x, y, w, h);
      fill(#F5F5F5);
      textFont(segoe20);
      text(name, x+10, y+20);
    } else {
      stroke(col);
      fill(255);
      rect(x, y, w-1, h-1);
      fill(col);
      textFont(segoe20);
      text(name, x+10, y+20);
      noStroke();
    }
    if (mouseX >= x && mouseX <= x+w && mouseY >= y && mouseY <= y+h && mouseButton == LEFT && app != a) {
      app = a;
    }
  }
}
