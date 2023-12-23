Задача об инвентаризации по книгам. 

После нового года в библиотеке университета обнаружилась пропажа каталога. После поиска и наказания, виноватых ректор дал указание восстановить каталог силами студентов. Фонд библиотека представляет собой прямоугольное помещение, в котором находится M рядов по N шкафов
по K книг в каждом шкафу.

 Требуется создать многопоточное приложение, составляющее каталог. При решении использовать метод
«портфель задач», причем в качестве отдельного потока задается
внесение в каталог записи об отдельной книге.

Примечание. Каталог — это список книг, упорядоченный (отсортированный) по названию книги (в данном случае в качестве
названия можно взять и целое число — не обязательно использовать ASCII строку символов). Каждая строка каталога содержит идентифицирующее значение (номер или строку), местоположение книги, включающее номер ряда, номер шкафа, номер книги в шкафу. 

Перед запуском потоков по составлению каталогов
необходимо случайным образом расположить книги в шкафах, используя генератор случайных чисел.