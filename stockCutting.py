import pymzn
import re

print("Select your preference: \n")
print(" Press 1 for optimization based on budget \n")
print(" Press 2 for optimization based on preference")

preference = int(input("Preference:"))

if preference == 1:
    soln = pymzn.minizinc('minCost.mzn', 'minCost_Data.dzn', solver=pymzn.cbc, output_mode='item')
    print(soln[0])

    lengths = soln[0].split("=")
    quantities = lengths[1].split("Lengths")
    x = re.sub("\s\s", ",", lengths[2])
    x2 = re.sub("\s", "", x)
    print(x2)
    y = re.sub("\s\s", ",", quantities[0])
    y2 = re.sub("\s", "", y)
    print(y2)
    file = open("stockdataBudget.dzn", "w")
    file.write("masterRoll=100;nOrders=3;orderLength=[")
    file.write(x2)
    file.write("];orderQuantity=[")
    file.write(y2)
    file.write("];")
    file.write("maxRollQuantity=sum(orderQuantity);maxOrderQuantity=max(orderQuantity);")
    file.close()
    fsol = pymzn.minizinc('StockCuttingOptimized.mzn', 'stockdataBudget.dzn', solver=pymzn.cbc, output_mode='item')
    print(fsol[0])


elif preference == 2:
    soln = pymzn.minizinc('maxLikeness.mzn', 'maxLikeness_Data.dzn', solver=pymzn.gecode, output_mode='item')
    print(soln[0])

    lengths=soln[0].split("=")
    quantities=lengths[1].split("Lengths")
    x = re.sub("\s\s", ",", lengths[2])
    x2 = re.sub("\s", "", x)
    print(x2)
    y = re.sub("\s\s", ",", quantities[0])
    y2=re.sub("\s","",y)
    print(y2)
    file=open("stockdataPreference.dzn","w")
    file.write("masterRoll=100;nOrders=3;orderLength=[")
    file.write(x2)
    file.write("];orderQuantity=[")
    file.write(y2)
    file.write("];")
    file.write("maxRollQuantity=sum(orderQuantity);maxOrderQuantity=max(orderQuantity);")
    file.close()
    fsol=pymzn.minizinc('StockCuttingOptimized.mzn', 'stockdataPreference.dzn', solver=pymzn.cbc, output_mode='item')
    print(fsol[0])






