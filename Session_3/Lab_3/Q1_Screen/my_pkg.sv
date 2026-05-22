package my_pkg;

    parameter HEIGHT = 10;
    parameter WIDTH  = 10;
    parameter PERCENT_WHITE = 20;

    typedef enum bit {BLACK, WHITE} colors_t;

    class screen;

        rand colors_t pixels [HEIGHT][WIDTH];

        constraint color_c{
            foreach (pixels[i, j]){
                pixels[i][j] dist{WHITE:/PERCENT_WHITE, BLACK:/(100 - PERCENT_WHITE)};
            }
        }

        function print_screen();
            for(int i = 0; i < HEIGHT; i++)begin
                $display("%p", pixels[i]);
            end
        endfunction
        
    endclass

endpackage