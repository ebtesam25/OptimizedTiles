% run with Gecode solver
int: floorLength; % total length of the floor
int: budget; % customer budget
int: nColors; % no of colors
enum COLORS; % will contain the colors
int: minQuantity; % minimum quantity for each color
int: minCutLength; % minimum number of length that can be cut
int: masterRoll; % length of master roll
array[COLORS] of int: cost; % cost of each color

array[COLORS] of var minQuantity..1000: quantity; % no of quantity needed for each color
array[COLORS] of var int: length; % no of cut length needed for each color

% length must be greater than a certain value
constraint forall(i in COLORS)(length[i] >= minCutLength);
% length of a color cut can't be greater than the length of that color's masterRoll
constraint forall(i in COLORS)(length[i] <= masterRoll);
% total length of all colors must be equal to floorLength
constraint sum(i in COLORS)(length[i] * quantity[i]) = floorLength;
% total cost must be within the budget
constraint sum(i in COLORS)(length[i] * quantity[i] * cost[i]) <= budget;

% objective to minimize
% calculate total cost
var int: total_cost = sum(i in COLORS)(length[i] * quantity[i] * cost[i]);

solve minimize total_cost;

output
["Total Cost: " ++ show(total_cost) ++ "\nQuantities= "] ++
["\(quantity[i]) \t" | i in COLORS] ++ ["\nLengths= "] ++
["\(length[i]) \t" | i in COLORS]