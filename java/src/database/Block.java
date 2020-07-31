package database;

public class Block {
    byte[] m_data;
    long m_offset;
    long m_length;

    Block(byte[] data, long offset, long length) {
        m_data = data;
        m_offset = offset;
        m_length = length;
    }

    public void writeInt(int offset, int value) {
        for (int i = 3; i > -1; i--) {
            m_data[offset + i] = (byte) (value & 0xff);
            value >>= 8;
        }
    }

    public int readInt(int offset) {
        return ((m_data[offset] << 24) & 0xff_00_00_00)
                | ((m_data[offset + 1] << 16) & 0xff_00_00)
                | ((m_data[offset + 2] << 8) & 0xff_00)
                | (m_data[offset + 3] & 0xff);
    }

    public void writeFloat(int offset, float value) {
        writeInt(offset, Float.floatToIntBits(value));
    }

    public float readFloat(int offset) {
        return Float.intBitsToFloat(readInt(offset));
    }

    public void writeString(int offset, String value) {
        int stringLength = value.length();
        writeInt(offset, stringLength);
        for (int i = 0; i < stringLength; i++) {
            m_data[offset + 4 + i] = (byte)value.charAt(i);
        }
    }

    public String readString(int offset) {
        int stringLength = readInt(offset);
        StringBuilder string = new StringBuilder(stringLength);
        for (int i = 0; i < stringLength; i++) {
            string.append((char)m_data[offset + 4 + i]);
        }

        return string.toString();
    }
}
