PRAGMA foreign_key = ON;

CREATE TABLE uyeler(
	id  INTEGER PRIMARY KEY AUTOINCREMENT,
	ad TEXT NOT NULL,
	yas INTEGER CHECK(yas>13),
	sehir TEXT DEFAULT 'Erzincan',
	kayit_tarihi TEXT DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE kitaplar(
	id  INTEGER PRIMARY KEY AUTOINCREMENT,
	ad TEXT NOT NULL UNIQUE
);

CREATE TABLE odunc(
	uye_id INTEGER REFERENCES uyeler(id) ON DELETE CASCADE,
	kitap_id INTEGER REFERENCES kitaplar(id),
	gun INTEGER CHECK(gun>0),
	PRIMARY KEY (uye_id, kitap_id)
);

INSERT INTO kitaplar(ad) 
VALUES ('Suç ve Ceza'), ('Nutuk'), 
		('Toplum Sözleşmesi'), ('Kızıl Elma'), ('Çalıkuşu');

INSERT INTO uyeler (ad, yas, sehir) VALUES
('Ahmet Yılmaz', 24, 'Ankara'),
('Ayşe Demir', 19, 'İstanbul'),
('Fatma Çelik', 22, 'İzmir'),
('Can Şahin', 17, 'Bursa'),
('Ali Koç', 45, 'Antalya'),
('Elif Arslan', 20, 'Trabzon'),
('İrem Öztürk', 25, 'Adana'),
('Burak Korkmaz', 29, 'Konya'),
('Emre Doğan', 27, 'Samsun'),
('Selin Çetin', 21, 'Gaziantep'),
('Kerem Aksoy', 35, 'Kayseri'),
('Cemre Yalçın', 23, 'Eskişehir'),
('Onur Çakır', 30, 'Mersin'),
('Umut Şen', 22, 'Diyarbakır');

INSERT INTO uyeler (ad, yas) VALUES
('Mehmet Kaya', 31),
('Zeynep Aydın', 28),
('Mustafa Yıldız', 33),
('Merve Polat', 18),
('Deniz Güler', 26),
('Gamze Tekin', 19);

--INSERT INTO uyeler (ad, yas) VALUES ('berk demir', 10); CHECK CONSTRAINT failed  --> kısıt sağlanmadı

INSERT INTO odunc(uye_id, kitap_id, gun) VALUES
	(1,1,5), (1,5,35), (2,2,25), (2,4,12), (3,3,32), (3,2,45), (4,1,3), (4,5,23), (5,3,15), (5,2,13),
	(6,1,20), (6,4,29), (7,3,35), (7,5,4), (8,1,5), (8,2,22), (9,4,26), (9,5,33), (10,3,11), (10,1,28),
	(11,2,14), (11,5,42), (12,1,8), (12,3,27), (13,4,39), (13,2,5), (14,3,19), (14,5,31), (15,1,45), 
	(15,4,12), (16,2,3), (16,5,22), (17,3,37), (17,1,15), (18,4,28), (18,2,9), (19,5,33), (19,3,40), (20,1,18), (20,4,25);
	
SELECT u.ad AS Uye_Adi, k.ad AS Kitap_Adi, o.gun AS Kalan_Gun
FROM odunc o
JOIN uyeler u ON o.uye_id = u.id
JOIN kitaplar k on o.kitap_id = k.id
WHERE Kalan_Gun > 30;

SELECT k.ad AS Kitap_Adi
FROM uyeler u
JOIN odunc o ON o.uye_id = u.id
JOIN kitaplar k ON o.kitap_id = k.id
WHERE u.sehir = 'Erzincan';

--hiç kitap almamış üyeleri de(olsalardı) RIGHT JOIN ile gösterirdik

SELECT u.ad as Kisi, AVG(o.gun) as Ort_Sure, Count(*) as Kitap_Say, MAX(o.gun) as EnFazla_Sure
FROM odunc o
JOIN uyeler u ON u.id = o.uye_id
GROUP BY u.id
HAVING Ort_Sure >20; -- group by, having gerektirir

SELECT k.ad as Kitap, Count(*) as Alinma_Say
FROM odunc o
JOIN kitaplar k ON k.id = o.kitap_id
GROUP BY k.id;

SELECT sehir ,Count(*) as Sayi
FROM uyeler
GROUP BY sehir
ORDER BY Sayi DESC;

SELECT DISTINCT AD
FROM (
SELECT u.ad as AD, o.gun
FROM odunc o
JOIN uyeler u ON u.id = o.uye_id
WHERE o.gun > 30);

INSERT INTO kitaplar(ad) VALUES ('Satranç')

SELECT ad FROM kitaplar
WHERE ad NOT IN (
SELECT k.ad FROM odunc o
JOIN kitaplar k 
ON k.id = o.kitap_id
);

SELECT * 
FROM odunc 
WHERE gun > (SELECT AVG(gun) FROM odunc);

SELECT uye_id, kitap_id, gun,
    CASE 
        WHEN gun > 30 THEN 'Gecikmiş'
        WHEN gun BETWEEN 15 AND 30 THEN 'Uyarı'
        ELSE 'Normal'
    END AS durum
FROM odunc;

SELECT id, ad, yas,
    CASE 
        WHEN yas <= 18 THEN 'Genç'
        ELSE 'Yetişkin'
    END AS yas_grubu
FROM uyeler;

SELECT 
    CASE 
        WHEN gun > 30 THEN 'Gecikmiş'
        WHEN gun BETWEEN 15 AND 30 THEN 'Uyarı'
        ELSE 'Normal'
    END AS durum,
    COUNT(*) AS kayit_sayisi
FROM odunc
GROUP BY 
    CASE 
        WHEN gun > 30 THEN 'Gecikmiş'
        WHEN gun BETWEEN 15 AND 30 THEN 'Uyarı'
        ELSE 'Normal'
    END;
	
CREATE INDEX idx_uyeler_ad ON uyeler(ad);

ALTER TABLE uyeler ADD COLUMN eposta TEXT;

CREATE UNIQUE INDEX idx_uyeler_eposta ON uyeler(eposta);

--Aynı mail iki kişiye atanmaya çalışırsa Unique Constraint failed hatası alınır
