package database;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.RandomAccessFile;
import java.util.concurrent.Semaphore;

public class MemoryManager {
    private String m_fileName;
    private RandomAccessFile m_outputStream;
    private long m_freeListBegin = 0;
    private int m_blockSize = 0;

    MemoryManager(String filename, int blockSize) {
        m_fileName = filename;
        m_blockSize = blockSize;
        long firstFree = readNextFree();
        if (-1 == firstFree) {
            initFreeList();
        }
    }

    public void initFreeList() {
        open();
        try {
            m_outputStream.seek(0);
            m_outputStream.writeLong(m_blockSize);
        } catch (IOException e) {
            e.printStackTrace();
        }
        close();
    }

    public long readNextFree() {
        open();

        long next = -1;
        try {
            if (0 == m_outputStream.length()) {
                return next;
            }

            m_outputStream.seek(0);
            next = m_outputStream.readLong();
        } catch (IOException e) {
            e.printStackTrace();
        }

        close();
        return next;
    }

    public Block allocBlock() {
        long next = readNextFree();
        open();
        try {
            long next_next = -1;
            if (-1 == next) {
                // grow action, no blocks are free
                next = m_outputStream.length();
                m_outputStream.setLength(next + m_blockSize);
            } else {
                if (m_outputStream.length() - m_blockSize < next) {
                    m_outputStream.setLength(next + m_blockSize);
                } else {
                    m_outputStream.seek(next);
                    next_next = m_outputStream.readLong();
                }
            }

            m_outputStream.seek(0);
            m_outputStream.writeLong(next_next);
            m_outputStream.seek(next);
            m_outputStream.writeLong(-1);
        } catch (IOException e) {
            e.printStackTrace();
        }
        close();

        return new Block(new byte[m_blockSize - 8], next, m_blockSize - 8);
    }

    public void writeBlock(Block block) {
        open();
        try {
            m_outputStream.seek(block.m_offset + 8);
            m_outputStream.write(block.m_data);
        } catch (IOException e) {
            e.printStackTrace();
        }
        close();
    }

    public Block readBlockAround(long offset) {
        Block block = null;
        open();
        try {
            long actualOffset = offset / m_blockSize * m_blockSize;
            m_outputStream.seek(actualOffset + 8);
            byte[] data = new byte[m_blockSize - 8];
            if (m_blockSize - 8 != m_outputStream.read(data)) {
                throw new IOException("corrupted db, could not read data");
            }
            block = new Block(data, actualOffset, m_blockSize - 8);

            m_outputStream.write(block.m_data);
        } catch (IOException e) {
            e.printStackTrace();
        }
        close();

        return block;
    }

    public void freeBlock(Block block) {
        long nextFreeBlock = readNextFree();
        open();
        try {
            m_outputStream.seek(block.m_offset);
            m_outputStream.writeLong(nextFreeBlock);
            m_outputStream.seek(0);
            m_outputStream.writeLong(block.m_offset);
        } catch (IOException e) {
            e.printStackTrace();
        }
        close();
    }

    public void open() {

        try {
            m_outputStream = new RandomAccessFile(m_fileName, "rw");
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }
    }

    public void close() {
        if (null != m_outputStream) {
            try {
                m_outputStream.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }
}
