% Use this editor as a MiniZinc scratch book
int:masterRoll; % length of master roll
int:nOrders; % no of orders
int:maxRollQuantity; % sum of all order quantity, used for an upper bound on the number of master rolls used
int:maxOrderQuantity; % maximum number of order placed

set of int: rollNo=1..maxRollQuantity;
set of int: orderNo=1..nOrders;

array[orderNo] of int: orderLength; % lengths wanted by customers
array[orderNo] of int: orderQuantity; % quantity of items for each length

% each element of the array represents the number of order quantities that can be cut
% from each master roll for a single order length 
array[rollNo,orderNo] of var 0..maxOrderQuantity: cut;

% get total length of stocks needed
int:totalOrders=sum(i in orderNo)(orderLength[i]*orderQuantity[i]);

% get a lower bound on the number of rolls used
int: rollLowerBound = round(totalOrders / masterRoll);
% decision variable representing number of variables used
var rollLowerBound..maxRollQuantity: rollsUsed; 
var int:unused=maxRollQuantity-rollsUsed;

% indicate if a Master Roll is unused or not, used for output
array[rollNo] of var 0..1: isUsed;

constraint totalOrders <= masterRoll*rollsUsed; 

% each cut[i,j] must be less than original order quantity
constraint forall(i in rollNo, j in orderNo)(cut[i,j] <= orderQuantity[j]);

% put 1 in the corresponding index of isUsed if a master roll is used otherwise put 0
constraint forall(i in rollNo)(if sum(j in orderNo)(cut[i,j]) > 0 then isUsed[i] = 1 else isUsed[i] = 0 endif);

% sum of order lengths cut from a roll must not exceed the length of a master roll
constraint forall(i in rollNo)(
              (sum(j in orderNo)(cut[i,j]*orderLength[j]))<= masterRoll
            );
% sum of order quantities cut from each roll must be equal to original customer order
constraint forall(i in orderNo)(
              sum(j in rollNo)(cut[j,i])== orderQuantity[i]
            );

%var int: waste = sum([cut[i,j] | i in rollNo, j in orderNo where isUsed[i] = 1]);

solve minimize rollsUsed; % minimize the number of rolls used

output
["Total length needed: " ++ show(totalOrders) ++ " Units\n" ++  show(orderLength) ++ "\n"]  ++
[" "++show(cut[i,j]) ++ if j == nOrders then " ---Roll "++show(i)++"\t"++ show(isUsed[i]) ++"\n" else "  " endif | i in rollNo, j in orderNo where fix(isUsed[i]) == 1]++
["\nRolls Needed="]++[show(rollsUsed)]++[" Unused="++show(unused)]