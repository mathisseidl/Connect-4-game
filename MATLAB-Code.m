%% Initiate serial port connection
arduino=serialport("COM5",250000,"Timeout",240); % Replace depending on your board

in1=readline(arduino);    % String sent from MKS board at startup
in2=readline(arduino);    % String sent from MKS board at startup

% There will be about a 2 second delay before the G code is executed
%% Absolute Positioning
writeline(arduino, "G90");
readline(arduino)

%% Define positions
chip_positions = [40 2 3; 40 2 7; 40 2 12; 40 2 16; 40 2 21; 40 2 25; 40 2 29; 40 2 34; 40 2 38; 40 2 43; 93 2 3; 93 2 7; 93 2 12; 93 2 16; 93 2 21; 93 2 25; 93 2 29; 93 2 34; 93 2 38; 93 2 43; 93 2 47; 146 2 3; 146 2 7; 146 2 12; 146 2 16; 146 2 21; 146 2 25; 146 2 29; 146 2 34; 146 2 38; 146 2 43; 146 2 47; 199 2 3; 199 2 7; 199 2 12; 199 2 16; 199 2 21; 199 2 25; 199 2 29; 199 2 34; 199 2 38; 199 2 43];
column_x_coords = [15, 50, 85, 120, 155, 190, 225]; % x-coord for each column, the y and z coords should be same for each column

y_top_of_board = 285; % height where you drop the chip into the slots
z_to_drop_at = 16; % depth you want to drop chip at
y_to_drop_at = 263;
y_out_of_slot = 20;

%% Game Loop
for chip_index = 1:42
   % current chip location
   current_x = chip_positions(chip_index, 1);
   current_y = chip_positions(chip_index, 2);
   current_z = chip_positions(chip_index, 3);
   % picking up chip
   % move in y
   writeline(arduino, sprintf("G1 Y%f Z%f F3000", current_y, current_y));
   readline(arduino)
   % move in x
   writeline(arduino, sprintf("G1 X%f F1000", current_x));
   readline(arduino)
    % move in z
   writeline(arduino, sprintf("G1 E%f F1000", current_z));
   readline(arduino)
  
   % move up in y so chip comes out
   writeline(arduino, sprintf("G1 Y%f Z%f F1000", y_out_of_slot, y_out_of_slot));
   readline(arduino)
   % move back to safe z
   writeline(arduino, sprintf("G1 E0 F1000")); % pull back to z=0 (taking chip with)
   readline(arduino)
   % move to y drop
  % writeline(arduino, sprintf("G1 Y%f Z%f F1000", y_top_of_board, y_top_of_board));
   writeline(arduino, "G1 Y285 Z285 F3000")
   readline(arduino)
  
   % user input
  target_column = input('Enter column (1-7) or 0 to quit: ');
  if target_column == 0 % user can enter 0 to stop say if someone wins
      break;
  end
   % move to desired column
  destination_x = column_x_coords(target_column);
 
   writeline(arduino, sprintf("G1 X%f F1000", destination_x));
   readline(arduino)
   % move in z and wait for movement to finish
   writeline(arduino, sprintf("G1 E%f F1000", z_to_drop_at));
   readline(arduino)
   writeline(arduino, sprintf("G1 Y%f Z%f F3000", y_to_drop_at, y_to_drop_at))
   readline(arduino)
    % move to a safe z before going to next chip so doesn't hit anything
   writeline(arduino, "G1 E0 F1000")
   readline(arduino)
end

%% Finish up
clear a;    % Disconnect and clear the serial port


