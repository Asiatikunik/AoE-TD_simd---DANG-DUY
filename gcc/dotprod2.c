double dotprod_unroll2(double *restrict a, double *restrict b, unsigned long long n) {
	double d1 = 0.0;
	double d2 = 0.0;
	
	for (unsigned long long i = 0; i < n; i += 2) {
		d1 += (a[i]* b[i]);
		d2 += (a[i + 1] * b[i + 1]);
	}
	
	return (d1 + d2);
}