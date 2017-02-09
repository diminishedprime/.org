#include "03_vector.h"
#include <cmath>
#include <iostream>

using namespace std;

double sqrt_sum(Vector& v) {
  double sum = 0;

  for(int i = 0; i != v.size(); ++i) {
    sum+=sqrt(v[i]);
  }
  return sum;
}

int main() {

  Vector v(4);
  for (int i = 0; i < 4; ++i) {
    cin >> v[i];
  }

  double answer = sqrt_sum(v);
  cout << "The answer was: " << answer;

}
