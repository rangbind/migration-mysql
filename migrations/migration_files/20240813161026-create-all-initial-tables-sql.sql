CREATE TABLE `user` (
  `userId` INT NOT NULL AUTO_INCREMENT,
  `username` VARCHAR(45) NOT NULL,
  `fullName` VARCHAR(100)  NULL,
  `email` VARCHAR(100) NOT NULL,
  `displayName` VARCHAR(100)  NULL,
  `userStatus` ENUM('REGISTERED', 'ACTIVE') DEFAULT 'REGISTERED',
  `registeredPlatform` ENUM('WEB', 'IOS', 'ANDROID') DEFAULT 'WEB',
  `stripeCustomerId` VARCHAR(25) DEFAULT NULL,
  `almUserId` VARCHAR(45) NULL DEFAULT NULL,
  `stripeCustomerCurrency` ENUM('USD', 'EUR', 'GBP') DEFAULT NULL
  `createdAt` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `registeredAt` DATETIME DEFAULT NULL,
  `updatedAt` DATETIME DEFAULT NULL,
  PRIMARY KEY (`userId`),
  UNIQUE KEY `email_UNIQUE` (`email`)
);

CREATE TABLE `stripe-subscription` (
  `subscriptionId` INT NOT NULL AUTO_INCREMENT,
  `userId` INT NOT NULL,
  `stripeSubscriptionId` VARCHAR(50) DEFAULT NULL,
  `subscriptionFrequency` ENUM('MONTHLY', 'YEARLY') NOT NULL,
  `subscriptionStatus` ENUM('ACTIVE','PENDING','FAILED','CANCELLED') NOT NULL,
  `subscribedAt` DATETIME DEFAULT NULL,
  `trialEndDate` DATETIME DEFAULT NULL,
  `cancelledDate` DATETIME DEFAULT NULL,
  `checkoutSessionId` VARCHAR(100) NOT NULL,
  `updatedAt` DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`subscriptionId`),
  FOREIGN KEY (`userId`) REFERENCES user(`userId`)
);

CREATE TABLE `stripe-webhook-events` (
  `eventId` INT NOT NULL AUTO_INCREMENT,
  `eventName` VARCHAR(100) NOT NULL,
  `description` TEXT DEFAULT NULL,
  `createdAt` DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`eventId`)
);

CREATE TABLE `stripe-webhook-events-log` (
  `eventLogId` INT NOT NULL AUTO_INCREMENT,
  `eventId` INT NOT NULL,
  `stripeUserId` TEXT NOT NULL,
  `status` ENUM('SUCCESS', 'FAILED') DEFAULT NULL,
  `eventResponse` JSON NOT NULL,
  `createdAt` DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`eventLogId`),
  FOREIGN KEY (`eventId`) REFERENCES `stripe-webhook-events`(`eventId`)
);

CREATE TABLE `role` (
  `roleId` INT NOT NULL AUTO_INCREMENT,
  `roleName` ENUM('LEARNER','ADMIN','AUTHOR','INSTRUCTOR','INTEGRATION ADMIN') NOT NULL,
  `createdAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` DATETIME NULL,
PRIMARY KEY (`roleId`));

CREATE TABLE `user-role` (
  `userRoleId` INT NOT NULL AUTO_INCREMENT,
  `userId` INT NOT NULL,
  `roleId` INT NOT NULL,
  `createdAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` DATETIME DEFAULT NULL,
  PRIMARY KEY (`userRoleId`),
  KEY `roleId_idx` (`roleId`),
  KEY `userId_idx` (`userId`),
  CONSTRAINT `roleId` FOREIGN KEY (`roleId`) REFERENCES `role` (`roleId`),
  CONSTRAINT `userId` FOREIGN KEY (`userId`) REFERENCES `user` (`userId`)
);

CREATE TABLE `user-verification-code` (
  `userVerificationCodeId` INT NOT NULL AUTO_INCREMENT,
  `email` VARCHAR(100) NOT NULL,
  `password` VARCHAR(45) NOT NULL,
  `code` VARCHAR(6) NOT NULL,
  `resendCountLeft` INT NOT NULL DEFAULT '3',
  `codeType` enum('SIGN_UP') NOT NULL,
  `isCodeVerified` TINYINT(1) DEFAULT '0',
  `createdAt` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `registeredPlatform` VARCHAR(45) DEFAULT NULL,
  PRIMARY KEY (`userVerificationCodeId`),
  UNIQUE KEY `email_UNIQUE` (`email`)
);

CREATE TABLE `user-setting` (
  `userSettingId` INT NOT NULL AUTO_INCREMENT,
  `userId` INT NOT NULL,
  `timezone` VARCHAR(30),
  `enableOtherNotification` boolean DEFAULT 1,
  `enableDailyRemainder` boolean DEFAULT 1,
  `local` VARCHAR(10) DEFAULT 'en_US',
  `createdAt` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`userSettingId`),
  FOREIGN KEY (`userId`) REFERENCES user(`userId`)
);

CREATE TABLE `subscription-plan` (
  `planId` INT NOT NULL AUTO_INCREMENT,
  `plan` ENUM('MONTHLY', 'YEARLY') NOT NULL,
  `planPlatform` ENUM('WEB', 'IOS', 'ANDROID') NOT NULL,
  `currency` ENUM('USD', 'EUR', 'GBP') NOT NULL,
  `description` TEXT NOT NULL,
  `updatedBy` INT DEFAULT NULL,
  `createdAt` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` DATETIME DEFAULT NULL,
  PRIMARY KEY (`planId`),
  FOREIGN KEY (`updatedBy`) REFERENCES user(`userId`)
);

CREATE TABLE `device-details` (
  `deviceId` INT NOT NULL AUTO_INCREMENT,
  `deviceIdentifier` VARCHAR(100) NOT NULL,
  `deviceType` enum('ANDROID','IOS','WEB') NOT NULL,
  `deviceModel` VARCHAR(50) DEFAULT NULL,
  `userId` INT NOT NULL,
  `loggedIn` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `createdAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`deviceId`),
  UNIQUE KEY `deviceIdentifier_UNIQUE` (`deviceIdentifier`),
  KEY `device-details_ibfk-1_idx` (`userId`) /*!80000 INVISIBLE */,
  FOREIGN KEY (`userId`) REFERENCES user(`userId`)
);

CREATE TABLE `alm-board-mapping` (
  `boardMappingId` INT NOT NULL AUTO_INCREMENT,
  `programId` VARCHAR(100) DEFAULT NULL,  
  `contextId` enum('VIDEOS', 'BULLETINS', 'BOOKS', 'CATALOGUES', 'PODCAST', 'RECOMENDED_CONTENTS', 'RELATED_CONTENTS','USER') DEFAULT NULL,
  `type` enum('DISCUSSION','NOTES') NOT NULL DEFAULT 'DISCUSSION',
  `almBoardId` VARCHAR(45) NOT NULL,
  `createdBy` INT NOT NULL,
  `createdAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` DATETIME DEFAULT NULL,
  PRIMARY KEY (`boardMappingId`),
  FOREIGN KEY (`createdBy`) REFERENCES user(`userId`)
);

CREATE TABLE `discussion-post-mapping` (
  `postMappingId` INT NOT NULL AUTO_INCREMENT,
  `almBoardId` VARCHAR(100) NOT NULL,
  `weekId` VARCHAR(10) DEFAULT NULL,
  `courseId` VARCHAR(100) DEFAULT NULL,
  `almPostId` VARCHAR(45) NOT NULL,
  `createdBy` INT NOT NULL,
  `createdAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` DATETIME DEFAULT NULL,
  PRIMARY KEY (`postMappingId`),
  FOREIGN KEY (`createdBy`) REFERENCES user(`userId`)
);

CREATE TABLE `user-bookmarks` (
  `bookmarkId` INT NOT NULL AUTO_INCREMENT,
  `userId` INT NOT NULL,
  `almMappingId` VARCHAR(45) NOT NULL,
  `almMappingType` VARCHAR(45) NOT NULL,
  `isDeleted` TINYINT NOT NULL DEFAULT '0',
  `createdAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` DATETIME DEFAULT NULL,
  PRIMARY KEY (`bookmarkId`),
  UNIQUE KEY `almMappingId_UNIQUE` (`almMappingId`),
  KEY `userId_idx` (`userId`),
  CONSTRAINT `userId1` FOREIGN KEY (`userId`) REFERENCES `user` (`userId`) ON DELETE RESTRICT ON UPDATE RESTRICT
);

CREATE TABLE `note-post-mapping` (
  `notesPostId` INT NOT NULL AUTO_INCREMENT,
  `programId` VARCHAR(45) DEFAULT NULL,
  `contextId` VARCHAR(45) DEFAULT NULL,
  `almPostId` VARCHAR(45) NOT NULL,
  `commentsCount` INT NOT NULL DEFAULT 0,
  `programName` VARCHAR(150) DEFAULT NULL,
  `almBoardId` VARCHAR(45) NOT NULL,
  `createdAt` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` DATETIME DEFAULT NULL,
  PRIMARY KEY (`notesPostId`)
);

CREATE TABLE `note-comment-mapping` (
  `notesCommentId` INT NOT NULL AUTO_INCREMENT,
  `almPostId` VARCHAR(45) NOT NULL,
  `weekId` VARCHAR(45) DEFAULT NULL,
  `courseId` VARCHAR(45) DEFAULT NULL,
  `almCommentId` VARCHAR(45) NOT NULL,
  `notesCreated` TINYINT NOT NULL DEFAULT '0',
  `courseName` VARCHAR(200) DEFAULT NULL,
  `createdAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` DATETIME DEFAULT NULL,
  `sequenceId` INT NULL DEFAULT 0,
  PRIMARY KEY (`notesCommentId`)
);

CREATE TABLE `email-change-code-verification` (
  `emailChangeCodeVerificationId` INT NOT NULL AUTO_INCREMENT,
  `userId` INT NOT NULL,
  `newEmail` VARCHAR(45) NOT NULL,
  `code` VARCHAR(45) NOT NULL,
  `attempLeft` INT NOT NULL DEFAULT 3,
  `isVerified` TINYINT NOT NULL DEFAULT '0',
  `createdAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` DATETIME NOT NULL,
  PRIMARY KEY (`emailChangeCodeVerificationId`),
  UNIQUE KEY `userId_UNIQUE` (`userId`),
  KEY `email-change-userid_idx` (`userId`),
  CONSTRAINT `email-change-userid` FOREIGN KEY (`userId`) REFERENCES `user` (`userId`)
);