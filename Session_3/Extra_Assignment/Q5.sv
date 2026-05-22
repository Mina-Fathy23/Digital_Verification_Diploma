module struct();

    typedef bit [6:0] bits_7;

    typedef struct{
        bits_7 header;
        bits_7 cmd;
        bits_7 data;
        bits_7 crc;
    } frame;


    frame my_packet;

    my_packet.header = 7'h5A;
    my_packet.cmd = 7'h0;
    my_packet.data = 7'h0;
    my_packet.crc = 7'h0;

endmodule