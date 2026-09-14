CREATE TABLE oyuncaklar(
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	isim TEXT NOT NULL,
	cesit TEXT,
	fiyat INTEGER CHECK(fiyat > 0),
	renk TEXT DEFAULT 'Kırmızı'
)

INSERT INTO oyuncaklar(isim, cesit, fiyat)
VALUES ('Şimşek', 'araba', 50);

INSERT INTO oyuncaklar(isim, cesit, fiyat, renk)
VALUES  ('Ayıcık', 'peluş', 80, 'Kahverengi'),
		('Kale Seti','lego', 150, 'Gri'), 
		('Zıpzıp', 'top', 20, 'Sarı'), 
		('Barbi', 'bebek', 90, 'Pembe');

		
SELECT * FROM oyuncaklar;

SELECT isim, fiyat FROM oyuncaklar
WHERE fiyat>=80;

SELECT * FROM oyuncaklar
ORDER BY fiyat DESC
LIMIT 2;

SELECT * FROM oyuncaklar
WHERE isim LIKE 'Z%';

SELECT * FROM oyuncaklar
WHERE cesit = 'araba' OR cesit = 'top';


UPDATE oyuncaklar SET renk='mavi'
WHERE isim='Şimşek';

DELETE FROM oyuncaklar
WHERE isim = 'Zıpzıp';


-- delete from oyuncaklar tahminen bütün verileri silecektir

ALTER TABLE oyuncaklar
ADD COLUMN 'Kimin' TEXT;

UPDATE oyuncaklar SET Kimin='ALİ'
WHERE isim='Kale Seti';

ALTER TABLE oyuncaklar
RENAME COLUMN cesit to 'Tür';
