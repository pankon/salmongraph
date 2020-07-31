package database;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.attribute.FileAttribute;
import java.util.UUID;

import static org.junit.jupiter.api.Assertions.*;

class MemoryManagerTest {
    MemoryManager m_memoryManager;
    Path m_tempFilePath;
    String m_tempFile;

    @BeforeEach
    void setUp() throws IOException {
        m_tempFilePath = Files.createTempDirectory("MemoryManagerTest");
        m_tempFile =  m_tempFilePath.resolve(UUID.randomUUID().toString() + ".db").toAbsolutePath().toString();
        m_memoryManager = new MemoryManager(m_tempFile,0x100);
    }

    @AfterEach
    void tearDown() throws IOException {
        Path val = Path.of(m_tempFile);
        File file = new File(val.toAbsolutePath().toString());
        file.delete();
    }

    @Test
    void readNextFree() {
    }

    @Test
    void allocBlock() {
        Block block = m_memoryManager.allocBlock();
        for (int i = 0; i < block.m_length; i += 4) {
            assert(block.readInt(i) == 0);
        }
    }

    @Test
    void writeBlock() {
        Block block = m_memoryManager.allocBlock();
        for (int i = 0; i < block.m_length; i += 4) {
            assert(block.readInt(i) == 0);
        }
        block.writeInt(0x1f, 0x57_23_45_87);
        block.writeInt(0x1f + 4, 0xff_ff_ff_ff);
        block.writeFloat(0x1f + 8, (float) 0.324);
        block.writeString(0x0, "some string");

        assertEquals(0xff_ff_ff_ff, block.readInt(0x1f + 4));
        assertEquals(0x57_23_45_87, block.readInt(0x1f));
        assertEquals((float) 0.324, block.readFloat(0x1f + 8));
        assertEquals("some string", block.readString(0x0));

    }

    @Test
    void readBlockAround() {
        Block block = m_memoryManager.allocBlock();
        block.writeInt(0, 1230);
        m_memoryManager.writeBlock(block);
        block = m_memoryManager.readBlockAround(block.m_offset + 40);
        assertEquals(1230, block.readInt(0));
    }
}