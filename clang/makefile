#Compiler
CL=clang

#Optimization flags
O1_FLAGS=-O1
O2_FLAGS=-O2
O3_FLAGS=-O3
O4_FLAGS=-Ofast
O5_FLAGS=-march=native -mtune=native -Ofast -funroll-loops -finline-functions -ftree-vectorize

#
all: file dotprod1_O1.s dotprod1_O2.s dotprod1_O3.s dotprod1_Ofast.s dotprod1_kamikaze.s dotprod2_O1.s dotprod2_O2.s dotprod2_O3.s dotprod2_Ofast.s dotprod2_kamikaze.s 

file:
	mkdir $(CL)
	mkdir $(CL)/dp1
	mkdir $(CL)/dp2

dotprod1_O1.s: dotprod1.c
	$(CL) -S $(O1_FLAGS) $< -o $(CL)/dp1/$@

dotprod1_O2.s: dotprod1.c
	$(CL) -S $(O2_FLAGS) $< -o $(CL)/dp1/$@

dotprod1_O3.s: dotprod1.c
	$(CL) -S $(O3_FLAGS) $< -o $(CL)/dp1/$@

dotprod1_Ofast.s: dotprod1.c
	$(CL) -S $(O4_FLAGS) $< -o $(CL)/dp1/$@

dotprod1_kamikaze.s: dotprod1.c
	$(CL) -S $(O5_FLAGS) $< -o $(CL)/dp1/$@


dotprod2_O1.s: dotprod2.c
	$(CL) -S $(O1_FLAGS) $< -o $(CL)/dp2/$@

dotprod2_O2.s: dotprod2.c
	$(CL) -S $(O2_FLAGS) $< -o $(CL)/dp2/$@

dotprod2_O3.s: dotprod2.c
	$(CL) -S $(O3_FLAGS) $< -o $(CL)/dp2/$@

dotprod2_Ofast.s: dotprod2.c
	$(CL) -S $(O4_FLAGS) $< -o $(CL)/dp2/$@

dotprod2_kamikaze.s: dotprod2.c
	$(CL) -S $(O5_FLAGS) $< -o $(CL)/dp2/$@


clean:
	rm -Rf $(CL)
