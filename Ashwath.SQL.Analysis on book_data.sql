create database ashwath2024;
use ashwath2024;
show tables;
select*from genre;
select*from authors;
select*from Books_table;
ALTER TABLE books_table
ADD PRIMARY KEY (book_ID);
ALTER TABLE books_table
ADD FOREIGN KEY (Genre_ID) REFERENCES genre(Genre_ID);
ALTER TABLE books_table
ADD FOREIGN KEY (author_ID) REFERENCES authors(author_ID);

#1.Select all books along with their authors and genres

SELECT b.book_title, a.author_name, g.genre_name
FROM books_table b
INNER JOIN authors a ON b.author_id = a.author_id
INNER JOIN genre g ON b.genre_id = g.genre_id;

#2.Select all books written by michael crichton:
SELECT b.book_title, a.author_name
FROM books_table b
INNER JOIN authors a ON b.author_id = a.author_id
WHERE a.author_name = 'michael crichton';

#3.Select the total price of books published after 2000:

SELECT SUM(price) AS total_price
FROM books_table
WHERE year_of_publication > 2000;

#4.Count the number of books in each genre:

SELECT g.genre_name, COUNT(*) AS book_count
FROM books_table b
INNER JOIN genre g ON b.genre_id = g.genre_id
GROUP BY g.genre_name;

#5.Select the average publication year of books:

SELECT AVG(year_of_publication) AS avg_publication_year
FROM books_table;

#6.Select the title of the book with the highest price:

SELECT book_title AS highest_price_book
FROM books_table
WHERE price = (SELECT MAX(price) FROM books_table);
 
#7.Select the title and price of the cheapest book in the Historical Fiction genre:

SELECT book_title AS cheapest_mystery_book, price
FROM books_table b
INNER JOIN genre g ON b.genre_id = g.genre_id
WHERE g.genre_name = 'historical fiction'
ORDER BY price ASC
LIMIT 1;

#8.Select authors who were born before 1920 along with the titles of their books:

SELECT a.year_of_birth,a.author_name, b.book_title 
FROM authors a
INNER JOIN books_table b ON a.author_id = b.author_id
WHERE a.year_of_birth > 1950;

#9.Select books along with their authors and genres, sorted by publication year in descending order:

SELECT b.book_title, a.author_name, g.genre_name, b.year_of_publication
FROM books_table b
INNER JOIN authors a ON b.author_id = a.author_id
INNER JOIN genre g ON b.genre_id = g.genre_id
ORDER BY b.year_of_publication DESC;

#10.Select the titles of books along with their authors where the author's name starts with 'M':

SELECT b.book_title, a.author_name
FROM books_table b
INNER JOIN authors a ON b.author_id = a.author_id
WHERE a.author_name LIKE 'M%';

#11.Select authors who have not published any books in the Military Fiction:

SELECT a.author_name
FROM authors a
LEFT JOIN books_table b ON a.author_id = b.author_id
LEFT JOIN genre g ON b.genre_id = g.genre_id AND g.genre_name = 'military fiction'
WHERE g.genre_id IS NULL;

#12.Select books with a price higher than the average price of all books:

SELECT *
FROM books_table
WHERE price > (SELECT AVG(price) FROM books_table);

#13.Select authors along with the count of their books, but only for authors born after 1900:

SELECT author_name,
       (SELECT COUNT(*) FROM books_table WHERE author_id = authors.author_id) AS book_count
FROM authors
WHERE author_id IN (
    SELECT author_id
    FROM authors
    WHERE year_of_birth > 1950
);

#14.Select authors along with the count of their books, but only for authors whose average book price is above $15:

SELECT author_name,
       (SELECT COUNT(*) FROM books_table WHERE author_id = authors.author_id) AS book_count
FROM authors
GROUP BY author_name
HAVING AVG((SELECT price FROM books_table WHERE author_id = authors.author_id)) > 15;

#Select authors along with the count of their books, but only for authors whose average book price is greater than the overall average book price:

SELECT author_name,
       (SELECT COUNT(*) FROM books_table WHERE author_id = authors.author_id) AS book_count
FROM authors
GROUP BY author_name
HAVING AVG((SELECT price FROM books_table WHERE author_id = authors.author_id)) > (SELECT AVG(price) FROM books_table);
