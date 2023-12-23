#include <iostream>
#include <vector>
#include <pthread.h>
#include <string>
#include <random>
#include <iomanip>
#include <fstream>
#include <cstring>

using library = std::vector<std::vector<std::vector<std::string>>>;
using libraryRow = std::vector<std::vector<std::string>>;

std::string generateRandom10LenStr() {
    std::random_device rd;
    std::mt19937 gen(rd());
    std::uniform_int_distribution<> dis('A', 'Z');

    std::string result;
    for (int i = 0; i < 10; ++i) {
        result += static_cast<char>(dis(gen));
    }

    return result;
}

void init(library& arr, int m, int n, int k) {
    std::cout << "\n--------------------------------------------------------\n";
    std::cout << "LIBRARY:\n";
    for (int z = 0; z < m; ++z) { // rows
        std::vector<std::vector<std::string>> shelfs;
        for (int i = 0; i < n; ++i) { // columns
            std::vector<std::string> books(k);
            for (int j = 0; j < k; ++j) { // books in 1 shelf
                books[j] = generateRandom10LenStr();
                std::cout << "name="<< books[j] << " row=" << z << " column=" << i << "numberInShelf=" << j << '\n';
            }
            shelfs.push_back(books);
        }
        arr.push_back(shelfs);
    }
    std::cout << "\n--------------------------------------------------------\n";
}

struct ThreadInfo {
    int id;
    int row;
    int column;
    int numberInShelf;
    std::string bookName;
};

struct BookInfo {
    std::string bookName;
    int bookRow;
    int bookShelf;
    int bookNumberInShelf;

    BookInfo(std::string name, int row, int shelf, int numberInShelf)
     : bookName(name), bookRow(row), bookShelf(shelf), bookNumberInShelf(numberInShelf) {}
};

struct CatalogElement {
    int id;
    BookInfo book;

    CatalogElement(int id, BookInfo book) : id(id), book(book) {}
};

struct Node {
    CatalogElement val;
    Node *next;
    Node(CatalogElement x) : val(x), next(nullptr) {}
    Node(CatalogElement x, Node *next) : val(x), next(next) {}
};

Node* CreateNode(int& cnt, BookInfo book) {
    return new Node(CatalogElement(++cnt, 
                    BookInfo(book.bookName,
                            book.bookRow,
                            book.bookShelf,
                            book.bookNumberInShelf)));
}

pthread_mutex_t mutex;

struct Catalog {
    static Node *root;
    static int cnt;

    // 1 thread can move on 1 row
    static void *fillCatalog(void *param) {
        ThreadInfo* data = (ThreadInfo*)param;
        auto row = data->row;
        auto column = data->column;
        auto numberInShelf = data->numberInShelf;
        auto bookName = data->bookName;

        pthread_mutex_lock(&mutex);
        insert(BookInfo(bookName, row, column, numberInShelf));
        pthread_mutex_unlock(&mutex);
        return nullptr;
    }

    static void insert(BookInfo book) {
        // the first book in catalog
        if (!root) {
            root = CreateNode(cnt, book);
            return;
        }

        // this book is less than first book in catalog
        if (book.bookName.compare(root->val.book.bookName) < 0) {
            auto cur = CreateNode(cnt, book);
            cur->next = root;
            root = cur;
            return;
        }

        // find appropriate place
        auto prev = root;
        auto cur = root->next;
        while (cur) {
            if (book.bookName.compare(cur->val.book.bookName) < 0) {
                auto next = cur;
                cur = CreateNode(cnt, book);
                cur->next = next;
                prev->next = cur;
                return;
            }
            cur = cur->next;
            prev = prev->next;
        }

        // insert in end of catalog
        cur = CreateNode(cnt, book);
        prev->next = cur;
    }

    void PrintCatalog() {
        auto cur = root;
        std::cout << "\nTOTAL CATALOG:\n";
        while(cur) {
            std::cout << "id=" << std::to_string(cur->val.id) << 
                        " name=" << cur->val.book.bookName << 
                        " row=" << std::to_string(cur->val.book.bookRow) << 
                        " column=" << std::to_string(cur->val.book.bookShelf) <<
                        " numberInShelf=" << std::to_string(cur->val.book.bookNumberInShelf)
                        << "\n";
            cur = cur->next;
        }
    }
};

int Catalog::cnt = 0;
Node* Catalog::root = nullptr;

void writeToFile(Catalog& catalog, std::string filename) {
    std::ofstream outputFile(filename); // open file to write 

    if (!outputFile.is_open()) {
        std::cout << "Unable to open output file" << std::endl;
        return;
    }

    outputFile << "\nTOTAL CATALOG:\n";
    auto cur = catalog.root;
    while(cur) {
        outputFile << "id=" << std::to_string(cur->val.id) << 
                    " name=" << cur->val.book.bookName << 
                    " row=" << std::to_string(cur->val.book.bookRow) << 
                    " column=" << std::to_string(cur->val.book.bookShelf) <<
                    " numberInShelf=" << std::to_string(cur->val.book.bookNumberInShelf)
                    << "\n";
        cur = cur->next;
    }

    outputFile.close(); // close file

    std::cout << "\nData has been written to output1.txt" << std::endl;
}


int main(int argc, char* argv[]) {
    int m,n,k;

    if (argc == 1) {
        std::cout << "Error input";
        return 0;
    }
    else if (strcmp(argv[1], "-file") != 0) {
        if (argc != 4 && argc != 6) {
            std::cout << "Error input";
            return 0;
        }
        m = std::stoi(argv[1]);
        n = std::stoi(argv[2]);
        k = std::stoi(argv[3]);
    } else {
        if (!(argc == 3 || argc == 5) || strcmp(argv[1], "-file") != 0) {
            std::cout << "Invalid syntax" << std::endl;
            return 0;
        }

        std::ifstream inputFile(argv[2]); // open file

        if (!inputFile.is_open()) {
            std::cout << "Unable to open file" << std::endl;
            return 0;
        }

        if (!(inputFile >> m >> n >> k)) { // read data
            std::cout << "Error reading file" << std::endl;
            return 0;
        }

        inputFile.close(); // close file    
    }
    // library of books
    library lib;
    // generate random books in library
    init(lib,m,n,k);
    
    Catalog catalog;
    pthread_t thread[m * n * k];
    ThreadInfo threads[m * n * k];

    pthread_mutex_init(&mutex, NULL);
    // launch threads
    int uniqIndex = 0;

    for (int i = 0 ; i < m; i++) {
        for (int j = 0; j < n; ++j) {
            for (int z = 0; z < k; ++z) {
                threads[uniqIndex].id = uniqIndex;
                threads[uniqIndex].row = i;
                threads[uniqIndex].column = j;
                threads[uniqIndex].numberInShelf = z;
                threads[uniqIndex].bookName = lib[i][j][z];
                pthread_create(&thread[uniqIndex], nullptr, &Catalog::fillCatalog, (void*)&threads[uniqIndex]);
                ++uniqIndex;
            }
        }
    }
    
    // wait all threads
    for (int i = 0 ; i < m * n * k; i++) {
        pthread_join(thread[i], nullptr);
    }

    pthread_mutex_destroy(&mutex);

    // print to console
    catalog.PrintCatalog();

    // write to file if it is nessesary 
    if (argc == 6 && strcmp(argv[4], "-o") == 0) {
        writeToFile(catalog, argv[5]);
    } else if (argc == 5 && strcmp(argv[3], "-o") == 0) {
        writeToFile(catalog, argv[4]);
    }

    return 0;
}