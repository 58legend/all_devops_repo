merge 				-- заливати свою гілку в MAIN
pull request 		-- Запит на стягування 
file not staged 	-- Git не стежить за файлами, їх ігнорує. Використай git add 1.txt щоб почав стейджити
origin				-- Той код, який вже на GitHub, в інтернеті.

Підключаємось
	git config --global --list 			- Глянути чи ми підключені. Якщо ні, то підключаємось
		git config --global user.name 58legend
		git config --global user.email 58legend@gmail.com
	git clone https://github.com/58legend/reposit_1.git
	


Створюємо новий репозиторій
	Створюємо директорію на диск (поки підключати її нікуди не тре, звичайна папка)
	git init 		- ініціалізувати папку, сказати що це має в майбутньому бути репозиторій.
	git status 		- глянути статус
	git add . 		- Добавити всі файли в репозиторій
	git add 1.txt	- Добавити лише файл 1.txt в репозиторій, зробити щоб Git за ним слідкував. Інші файли він ігноруватиме
	git rm --cached 1.txt		- Дістати з репозиторія (add навпаки)
	add / rm 		- діє на папки, і на файли в середині. Але якщо спершу зробити add, потім створити в директорії файл, то на нього не розповсюджуватиметься

	git commit -m "firs commit" - Добавити комміт. Але ще не запушити
	git push 		- Залити в інтернет
	git pull orgin master - дістати собі на комп
	git push https://<TOKEN>@github.com/<USER_NAME>/<REPOSITORY_NAME>.git