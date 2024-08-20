INSERT INTO role(roleName, updatedAt) VALUES ('LEARNER', now());
INSERT INTO role(roleName, updatedAt) VALUES ('ADMIN', now());
INSERT INTO role(roleName, updatedAt) VALUES ('AUTHOR', now());
INSERT INTO role(roleName, updatedAt) VALUES ('INSTRUCTOR', now());
INSERT INTO role(roleName, updatedAt) VALUES ('INTEGRATION ADMIN', now());

INSERT INTO `subscription-plan`(`plan`, `planPlatform`, `currency`, `description`)
VALUES('MONTHLY', 'WEB', 'USD', 'New content,Be the first to know,Get curated content,Program reminders,Class badges,Learn with experts');

INSERT INTO `subscription-plan`(`plan`, `planPlatform`, `currency`, `description`)
VALUES('YEARLY', 'WEB', 'USD', 'New content,Be the first to know,Get curated content,Program reminders,Class badges,Learn with experts');

INSERT INTO `subscription-plan`(`plan`, `planPlatform`, `currency`, `description`)
VALUES('MONTHLY', 'WEB', 'EUR', 'New content,Be the first to know,Get curated content,Program reminders,Class badges,Learn with experts');

INSERT INTO `subscription-plan`(`plan`, `planPlatform`, `currency`, `description`)
VALUES('YEARLY', 'WEB', 'EUR', 'New content,Be the first to know,Get curated content,Program reminders,Class badges,Learn with experts');


INSERT INTO `subscription-plan`(`plan`, `planPlatform`, `currency`, `description`)
VALUES('MONTHLY', 'WEB', 'GBP', 'New content,Be the first to know,Get curated content,Program reminders,Class badges,Learn with experts');

INSERT INTO `subscription-plan`(`plan`, `planPlatform`, `currency`, `description`)
VALUES('YEARLY', 'WEB', 'GBP', 'New content,Be the first to know,Get curated content,Program reminders,Class badges,Learn with experts');