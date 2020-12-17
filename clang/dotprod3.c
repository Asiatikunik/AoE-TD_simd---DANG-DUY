double dotprod_unroll3(double *restrict a, double *restrict b, unsigned long long n) {
	double d1 = 0.0;
	double d2 = 0.0;
	double d3 = 0.0;
	
	for (unsigned long long i = 0; i < n; i += 3) {
		d1 += (a[i]* b[i]);
		d2 += (a[i + 1] * b[i + 1]);
		d3 += (a[i + 2] * b[i + 2]);
	}
	
	return (d1 + d2 + d3);
}