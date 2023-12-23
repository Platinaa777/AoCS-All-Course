#include <iostream>
#include <iomanip>
#include <limits>
#include <ctime>
#include <pthread.h>
#include <vector>

using ll = long long;

const int cntThread = 1000;

const long n = 10000000;
// const long n = 500000000;
// const int n = 100000000000;

void fillA(std::vector<ll> a);
void fillB(std::vector<ll> b);

struct ThreadInfo {
    std::vector<ll> a;
    std::vector<ll> b;
    int threadNum;
    ll sum;
} ;

void *func(void *param) {
    ThreadInfo* data = (ThreadInfo*)param;
    data->sum = 0.0;
    int k = 0;
    for(unsigned int i = data->threadNum ; i < n; i += cntThread) {
        data->sum += data->a[i] * data->b[i];
        if (data->threadNum == 2) {
            std::cout << k++ << '\n';
        }
    }
}

int main() {

    std::vector<ll> a(n, 0);
    std::vector<ll> b(n, 0);

    fillA(a);
    fillB(b);


    clock_t start_time =  clock(); // start time
    ll x = 0.0;
    // 1 thread
    for (int i = 0; i < n; ++i) {
        x += a[i] * b[i];
    }

    clock_t end_time = clock(); // end time

    pthread_t thread[cntThread];
    ThreadInfo threads[cntThread];

    clock_t start_time_4_thread =  clock(); // start time

    for (int i=0 ; i < cntThread ; i++) {
        // Формирование структуры для передачи потоку
        threads[i].a = a;
        threads[i].b = b;
        threads[i].threadNum = i;
        pthread_create(&thread[i], nullptr, func, (void*)&threads[i]) ;
    }
    
    for (int i = 0 ; i < cntThread; i++) {
        pthread_join(thread[i], nullptr);
    }

    clock_t end_time_4_thread = clock(); // end time

    std::cout << "Число элементов в векторе | число потоков | время\n";

    std::cout << "------------------------------------------------------\n";
    std::cout << "     " << n << "             |      " << 1 << "        | " 
              << end_time - start_time << '\n';

    std::cout << "------------------------------------------------------\n";
    std::cout << "     " << n << "             |      " << cntThread << "        | " 
              << end_time_4_thread - start_time_4_thread << '\n';

    return 0;
}

void fillA(std::vector<ll> a) {
    a[0] = 0;
    for (int i = 1; i < n; ++i) {
        a[i] = a[i - 1] + 1;
    }
}

void fillB(std::vector<ll> b) {
    for (int i = 0; i < n; ++i) {
        b[i] = n - i;
    }
}