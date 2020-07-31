package database;

import java.io.*;
import java.util.Date;

public class Database {
    /*
     * free list
     *  blocks of size 0x100
     * year blocks
     *      [ millenia ] BTree
     *      [ century ] BTree
     *      [ decade ] BTree
     *      [n_years] [year][offset]
     * month blocks
     *      [12 pointers]
     * day blocks
     */

    private MemoryManager m_memoryManager;

    public Database(String fileName) {
        m_memoryManager = new MemoryManager(fileName, 0x100);
        setup();
    }

    private void setup() {
        for (int i = 0; i < 10; i++) {
            Block test = m_memoryManager.allocBlock();
            test.writeInt(0x0, i);
            if (i != test.readInt(0x0)) {
                System.out.println("readint failed");
            }
            test.writeInt(0xa, 10);
            test.writeInt(0x1a, 0x45968345);
            test.writeString(0x1a + 4, "a valuable string");
            if (!"a valuable string".equals(test.readString(0x1a + 4))) {
                System.out.println("read string failed");
            }

            m_memoryManager.writeBlock(test);
            if (0 == i % 2) {
                m_memoryManager.freeBlock(test);
            }
        }
    }

    public long getDateData(Date date, double latitude, double longitude) {
        return 0;
    }

    public boolean setDateData(Date date, double latitude, double longitude, long value) {
        return true;
    }
}
