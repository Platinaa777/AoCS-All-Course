#include <iostream>
#include <pthread.h>
#include <unistd.h> 
#include <chrono>

struct ThreadInfo {
    int* buffer;
    bool* free_buffer;
    int index;
    int number;
};

struct SummatorInfo {
    int first_index;
    int second_index;
    int index_to_write;
    int* buffer;
    bool* free_buffer;
};

void* Summator(void* params) {
    SummatorInfo* data = (SummatorInfo*)params;
    auto first_ind = data->first_index;
    auto second_ind = data->second_index;
    auto buffer = data->buffer;
    auto free_buffer = data->free_buffer;

    auto time = std::rand() % 4 + 3; // [3;6]
    sleep(time);

    auto sum = buffer[first_ind] + buffer[second_ind];
    buffer[first_ind] = sum;
    buffer[second_ind] = 0;
    // note that two elements are available for new summator operations
    free_buffer[first_ind] = true;
    free_buffer[second_ind] = true;

    std::cout << "index_left=" << first_ind << "; index_right= " << second_ind << " after summator we have in index" << first_ind <<"= " 
              << buffer[first_ind] << "\n";

    return nullptr;
}

void* Produce(void* params) {
    ThreadInfo* data = (ThreadInfo*)params;
    auto time = std::rand() % 6 + 1;
    sleep(time);
    data->buffer[data->index] = data->number;
    std::cout << "thread " << data->index << " was slept " << time << " and wrote number=" << data->number << '\n';
    data->free_buffer[data->index] = true;

    return nullptr;
}

int main() {
    const int n = 20;
    ThreadInfo threads[n];
    SummatorInfo summators[n / 2];

    pthread_t thread[n];

    int* buffer = new int[n];
    bool* free_buffer = new bool[n];

    // launch threads
    for (int i = 0 ; i < 20; i++) {
        // fill buffer
        threads[i].buffer = buffer;
        threads[i].index = i;
        threads[i].number = i + 1;
        threads[i].free_buffer = free_buffer;
        pthread_create(&thread[i], nullptr, &Produce, (void*)&threads[i]) ;
    }
    
    // wait all threads
    for (int i = 0 ; i < n; i++) {
        pthread_join(thread[i], nullptr);
    }

    int i = 0;

    auto start = std::chrono::high_resolution_clock::now();

    while (1) {
        if (free_buffer[i] && buffer[i] != 0) {
            for (int j = 0; j < 20; ++j) {
                if (i != j && free_buffer[j] && buffer[j] != 0) {
                    // data for summator
                    summators[i % 10].first_index = i;
                    summators[i % 10].second_index = j;
                    summators[i % 10].buffer = buffer;
                    summators[i % 10].free_buffer = free_buffer;

                    // assign that we work with index i and j (sum elements)
                    free_buffer[i] = false;
                    free_buffer[j] = false;

                    pthread_create(&thread[i], nullptr, &Summator, (void*)&summators[i % 10]);
                    start = std::chrono::high_resolution_clock::now();
                    break;
                }
            }
        }
        i = (i + 1) % 20;
        if (std::chrono::duration_cast<std::chrono::seconds>(std::chrono::high_resolution_clock::now() - start).count() > 6) {
            break;
        }
    }

    for (int i = 0; i < 20; ++i) {
        if (buffer[i] != 0) {
            std::cout << "total sum=" << buffer[i] << "\n"; 
        }
    }
    return 0;
}