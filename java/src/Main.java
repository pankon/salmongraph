import database.Database;

import java.awt.*;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;

public class Main extends Canvas {
    private void setup() {
        setSize(800, 600);
        setBackground(Color.blue);

        Frame frame = new Frame();
        frame.add(this);
        frame.setSize(1000, 800);
        frame.setVisible(true);
    }

    public void paint(Graphics g){
        g.setColor(Color.blue);
        g.drawLine(30, 30, 80, 80);
        g.drawRect(20, 150, 100, 100);
        g.fillRect(20, 150, 100, 100);
        g.fillOval(150, 20, 100, 100);
        Image img1 = Toolkit.getDefaultToolkit().getImage("sky.jpg");
        g.drawImage(img1, 140, 140, this);
    }

    private void datePlay() {
        Date date = new Date();
        GregorianCalendarOverride calendar = new GregorianCalendarOverride();
        calendar.setTime(date);

        System.out.println("ERA: " + calendar.get(Calendar.ERA));
        System.out.println("YEAR: " + calendar.get(Calendar.YEAR));
        System.out.println("MONTH: " + calendar.get(Calendar.MONTH));
        System.out.println("WEEK_OF_YEAR: " + calendar.get(Calendar.WEEK_OF_YEAR));
        System.out.println("WEEK_OF_MONTH: " + calendar.get(Calendar.WEEK_OF_MONTH));
        System.out.println("DATE: " + calendar.get(Calendar.DATE));
        System.out.println("DAY_OF_MONTH: " + calendar.get(Calendar.DAY_OF_MONTH));
        System.out.println("DAY_OF_YEAR: " + calendar.get(Calendar.DAY_OF_YEAR));
        System.out.println("DAY_OF_WEEK: " + calendar.get(Calendar.DAY_OF_WEEK));
        System.out.println("DAY_OF_WEEK_IN_MONTH: "
                + calendar.get(Calendar.DAY_OF_WEEK_IN_MONTH));

        System.out.println("Month length: " + calendar.monthLength());
    }

    public static void main(String[] args) {
        //new Main().setup();
        new Database("file");
    }
}
