import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.GregorianCalendar;

public class GregorianCalendarOverride extends GregorianCalendar {
    private Method m_actualMonthLengthMethod;

    GregorianCalendarOverride() {
        GregorianCalendar test = new GregorianCalendar();
        Class<?> calendarClass = test.getClass();
        try {
            m_actualMonthLengthMethod = calendarClass.getDeclaredMethod("actualMonthLength");
            m_actualMonthLengthMethod.setAccessible(true);
        } catch (NoSuchMethodException e) {
            e.printStackTrace();
        }
    }

    public int monthLength() {
        try {
            return (int)m_actualMonthLengthMethod.invoke(this);
        } catch (IllegalAccessException e) {
            e.printStackTrace();
        } catch (InvocationTargetException e) {
            e.printStackTrace();
        }

        return -1;
    }
}
