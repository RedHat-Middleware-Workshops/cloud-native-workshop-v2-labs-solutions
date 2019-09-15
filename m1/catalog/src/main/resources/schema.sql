DROP TABLE IF EXISTS catalog;

CREATE TABLE catalog (
  itemId VARCHAR(256) NOT NULL PRIMARY KEY,
  name VARCHAR(256),
  description VARCHAR(2560),
  price DOUBLE PRECISION
);


insert into catalog (itemId, name, description, price) values ('329299', 'Red Fedora', 'Official Red Hat Fedora', 34.99);
insert into catalog (itemId, name, description, price) values ('329199', 'Forge Laptop Sticker', 'JBoss Community Forge Project Sticker', 8.50);
insert into catalog (itemId, name, description, price) values ('165613', 'Solid Performance Polo', 'Moisture-wicking, antimicrobial 100% polyester design wicks for life of garment. No-curl, rib-knit collar; special collar band maintains crisp fold; three-button placket with dyed-to-match buttons; hemmed sleeves; even bottom with side vents; Import. Embroidery. Red Pepper.',17.80);
insert into catalog (itemId, name, description, price) values ('165614', 'Ogio Caliber Polo', 'Moisture-wicking 100% polyester. Rib-knit collar and cuffs; Ogio jacquard tape inside neck; bar-tacked three-button placket with Ogio dyed-to-match buttons; side vents; tagless; Ogio badge on left sleeve. Import. Embroidery. Black.', 28.75);
insert into catalog (itemId, name, description, price) values ('165954', '16 oz. Vortex Tumbler', 'Double-wall insulated, BPA-free, acrylic cup. Push-on lid with thumb-slide closure; for hot and cold beverages. Holds 16 oz. Hand wash only. Imprint. Clear.', 6.00);
insert into catalog (itemId, name, description, price) values ('444434', 'Pebble Smart Watch', 'Smart glasses and smart watches are perhaps two of the most exciting developments in recent years.', 24.00);
insert into catalog (itemId, name, description, price) values ('444435', 'Oculus Rift', 'The world of gaming has also undergone some very unique and compelling tech advances in recent years. Virtual reality, the concept of complete immersion into a digital universe through a special headset, has been the white whale of gaming and digital technology ever since Geekstakes Oculus Rift GiveawayNintendo marketed its Virtual Boy gaming system in 1995.Lytro',106.00 );
insert into catalog (itemId, name, description, price) values ('444436', 'Lytro Camera', 'Consumers who want to up their photography game are looking at newfangled cameras like the Lytro Field camera, designed to take photos with infinite focus, so you can decide later exactly where you want the focus of each image to be.', 44.30);

