-- MySQL dump 10.13  Distrib 8.0.19, for Linux (x86_64)
--
-- Host: localhost    Database: abstractwallet
-- ------------------------------------------------------
-- Server version	8.0.19

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `account_details`
--

DROP TABLE IF EXISTS `account_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `account_details` (
  `id_pk` int NOT NULL AUTO_INCREMENT,
  `user_id_fk` int NOT NULL,
  `user_details_id_fk` int NOT NULL,
  `bank_master_id_fk` int NOT NULL,
  `account_no` char(12) NOT NULL,
  `account_balance` double NOT NULL,
  `income_tax_number` char(10) NOT NULL,
  `account_opening_date` datetime NOT NULL,
  `currency_ticker` varchar(4) NOT NULL,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_pk`),
  KEY `user_details_pk_fk_const` (`user_details_id_fk`),
  KEY `user_id_pk_fk` (`user_id_fk`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `account_details`
--

LOCK TABLES `account_details` WRITE;
/*!40000 ALTER TABLE `account_details` DISABLE KEYS */;
INSERT INTO `account_details` VALUES (1,1,1,9,'003558008876',824469.5,'4829901084','2020-03-08 00:00:00','INR','0000-00-00 00:00:00'),(2,2,2,9,'270365500638',424219.79,'2083386200','2020-03-08 00:00:00','USD','0000-00-00 00:00:00'),(3,3,3,10,'533074805951',599956.26,'1282977856','2020-03-08 00:00:00','EUR','0000-00-00 00:00:00'),(4,4,4,6,'731258783797',117557.33,'6456352137','2020-03-08 00:00:00','AUD','0000-00-00 00:00:00'),(5,5,5,10,'359502423130',288855.01,'3138902075','2020-03-08 00:00:00','CAD','0000-00-00 00:00:00'),(6,6,6,2,'795554898923',342153.32,'2173343141','2020-03-08 00:00:00','INR','0000-00-00 00:00:00'),(7,7,7,6,'485064210112',424941.12,'7080240160','2020-03-08 00:00:00','CAD','0000-00-00 00:00:00'),(8,8,8,3,'518569490010',623744.03,'2617010736','2020-03-08 00:00:00','USD','0000-00-00 00:00:00'),(9,9,9,7,'841478410516',773309.01,'9520070572','2020-03-08 00:00:00','EUR','0000-00-00 00:00:00'),(10,10,10,3,'001498029143',272761.97,'0431365095','2020-03-08 00:00:00','AUD','0000-00-00 00:00:00');
/*!40000 ALTER TABLE `account_details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bank_master`
--

DROP TABLE IF EXISTS `bank_master`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bank_master` (
  `id_pk` int NOT NULL AUTO_INCREMENT,
  `bank_code` varchar(10) NOT NULL COMMENT 'Its IFSC/Swift Code',
  `bank_name` varchar(255) NOT NULL,
  `branch` varchar(255) NOT NULL,
  PRIMARY KEY (`id_pk`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bank_master`
--

LOCK TABLES `bank_master` WRITE;
/*!40000 ALTER TABLE `bank_master` DISABLE KEYS */;
INSERT INTO `bank_master` VALUES (1,'IFSC00001','HDFC Bank','Delhi'),(2,'IFSC00002','State Bank of India','Mumbai'),(3,'IFSC00003','ICICI Bank Limited','Gurgaon'),(4,'IFSC00004','Axis Bank ','Ghaziabad'),(5,'IFSC00005','Kotak Mahindra Bank','Meerut'),(6,'IFSC00006','IndusInd Bank ','Muzaffarnagar'),(7,'IFSC00007','Bank of Baroda','Bhopal'),(8,'IFSC00008','Yes Bank','Indore'),(9,'IFSC00009','Punjab National Bank','Ahmedabad'),(10,'IFSC00010','Canara Bank','Faridabad');
/*!40000 ALTER TABLE `bank_master` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `beneficiary_details`
--

DROP TABLE IF EXISTS `beneficiary_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `beneficiary_details` (
  `id_pk` int NOT NULL AUTO_INCREMENT,
  `user_id_fk` int NOT NULL,
  `beneficiary_account_no` char(20) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `bank_code` varchar(10) NOT NULL,
  `beneficiary_alias` varchar(50) NOT NULL,
  PRIMARY KEY (`id_pk`)
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `beneficiary_details`
--

LOCK TABLES `beneficiary_details` WRITE;
/*!40000 ALTER TABLE `beneficiary_details` DISABLE KEYS */;
INSERT INTO `beneficiary_details` VALUES (1,1,'270365500638','2020-03-08 17:00:00','IFSC00009','Kevin'),(2,1,'518569490010','2020-03-08 17:00:00','IFSC00003','Nathaniel'),(3,1,'795554898923','2020-03-08 17:00:00','IFSC00002','David'),(4,1,'533074805951','2020-03-08 17:00:00','IFSC00010','Kelly'),(5,2,'485064210112','2020-03-08 17:02:58','IFSC00006','Boris'),(6,2,'003558008876','2020-03-08 17:02:58','IFSC00009','Vipul'),(7,2,'533074805951','2020-03-08 17:02:58','IFSC00010','Kelly'),(8,2,'795554898923','2020-03-08 17:02:58','IFSC00002','David'),(9,3,'518569490010','2020-03-08 17:21:10','IFSC00003','Nathaniel'),(10,3,'359502423130','2020-03-08 17:21:10','IFSC00010','Margarita'),(11,3,'270365500638','2020-03-08 17:21:10','IFSC00009','Kevin'),(12,3,'731258783797','2020-03-08 17:21:10','IFSC00006','Krystal'),(13,4,'518569490010','2020-03-08 17:21:10','IFSC00003','Nathaniel'),(14,4,'270365500638','2020-03-08 17:21:10','IFSC00009','Kevin'),(15,4,'841478410516','2020-03-08 17:21:10','IFSC00007','Yvette'),(16,4,'001498029143','2020-03-08 17:21:10','IFSC00003','Orion'),(17,5,'731258783797','2020-03-08 17:21:10','IFSC00006','Krystal'),(18,5,'003558008876','2020-03-08 17:21:10','IFSC00009','Vipul'),(19,5,'270365500638','2020-03-08 17:21:10','IFSC00009','Kevin'),(20,5,'485064210112','2020-03-08 17:21:10','IFSC00006','Boris'),(21,6,'359502423130','2020-03-08 17:21:10','IFSC00010','Margarita'),(22,6,'270365500638','2020-03-08 17:21:10','IFSC00009','Kevin'),(23,6,'518569490010','2020-03-08 17:21:10','IFSC00003','Nathaniel'),(24,6,'003558008876','2020-03-08 17:21:10','IFSC00009','Vipul'),(25,7,'270365500638','2020-03-08 17:21:10','IFSC00009','Kevin'),(26,7,'841478410516','2020-03-08 17:21:10','IFSC00007','Yvette'),(27,7,'533074805951','2020-03-08 17:21:10','IFSC00010','Kelly'),(28,7,'731258783797','2020-03-08 17:21:10','IFSC00006','Krystal'),(29,8,'485064210112','2020-03-08 17:21:10','IFSC00006','Boris'),(30,8,'731258783797','2020-03-08 17:21:10','IFSC00006','Krystal'),(31,8,'001498029143','2020-03-08 17:21:10','IFSC00003','Orion'),(32,8,'841478410516','2020-03-08 17:21:10','IFSC00007','Yvette'),(33,9,'533074805951','2020-03-08 17:21:10','IFSC00010','Kelly'),(34,9,'795554898923','2020-03-08 17:21:10','IFSC00002','David'),(35,9,'270365500638','2020-03-08 17:21:10','IFSC00009','Kevin'),(36,9,'003558008876','2020-03-08 17:21:10','IFSC00009','Vipul'),(37,10,'731258783797','2020-03-08 17:21:10','IFSC00006','Krystal'),(38,10,'359502423130','2020-03-08 17:21:10','IFSC00010','Margarita'),(39,10,'270365500638','2020-03-08 17:21:10','IFSC00009','Kevin'),(40,10,'003558008876','2020-03-08 17:21:10','IFSC00009','Vipul');
/*!40000 ALTER TABLE `beneficiary_details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ci_sessions`
--

DROP TABLE IF EXISTS `ci_sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ci_sessions` (
  `id` varchar(40) NOT NULL,
  `ip_address` varchar(45) NOT NULL,
  `timestamp` int unsigned NOT NULL DEFAULT '0',
  `data` blob NOT NULL,
  PRIMARY KEY (`id`,`ip_address`),
  KEY `ci_sessions_timestamp` (`timestamp`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ci_sessions`
--

LOCK TABLES `ci_sessions` WRITE;
/*!40000 ALTER TABLE `ci_sessions` DISABLE KEYS */;
/*!40000 ALTER TABLE `ci_sessions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `country_master`
--

DROP TABLE IF EXISTS `country_master`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `country_master` (
  `id_pk` int NOT NULL AUTO_INCREMENT,
  `country_id` varchar(10) NOT NULL,
  `country_name` varchar(50) NOT NULL,
  `currency_ticker` varchar(3) NOT NULL,
  PRIMARY KEY (`id_pk`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `country_master`
--

LOCK TABLES `country_master` WRITE;
/*!40000 ALTER TABLE `country_master` DISABLE KEYS */;
INSERT INTO `country_master` VALUES (1,'IND','India','INR'),(2,'AUS','Australia','AUD'),(3,'CAN','Canada','CAD'),(4,'USA','United States of America','USD'),(5,'UK','United Kingdom','EUR');
/*!40000 ALTER TABLE `country_master` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `otp_master`
--

DROP TABLE IF EXISTS `otp_master`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `otp_master` (
  `id_pk` int NOT NULL AUTO_INCREMENT,
  `user_details_id_fk` int NOT NULL,
  `otp_no` char(6) NOT NULL,
  `otp_timestamp` int NOT NULL,
  `otp_purpose` char(1) NOT NULL,
  `otp_ref` varchar(15) NOT NULL,
  `remaining_attempts` int NOT NULL DEFAULT '5',
  `verified` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id_pk`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `otp_master`
--

LOCK TABLES `otp_master` WRITE;
/*!40000 ALTER TABLE `otp_master` DISABLE KEYS */;
/*!40000 ALTER TABLE `otp_master` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `session_master`
--

DROP TABLE IF EXISTS `session_master`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `session_master` (
  `id_pk` int NOT NULL AUTO_INCREMENT,
  `session_id` TEXT NOT NULL,
  `cust_id` char(8) NOT NULL,
  `last_access` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`id_pk`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `session_master`
--

LOCK TABLES `session_master` WRITE;
/*!40000 ALTER TABLE `session_master` DISABLE KEYS */;
/*!40000 ALTER TABLE `session_master` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `transaction_master`
--

DROP TABLE IF EXISTS `transaction_master`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `transaction_master` (
  `id_pk` int NOT NULL AUTO_INCREMENT,
  `trans_date` date NOT NULL,
  `src_acct` char(15) NOT NULL,
  `dst_acct` char(15) NOT NULL,
  `trans_remark` varchar(30) NOT NULL,
  `trans_amt` double NOT NULL,
  `trans_ref` char(10) NOT NULL,
  PRIMARY KEY (`id_pk`),
  UNIQUE KEY `id_pk` (`id_pk`),
  UNIQUE KEY `id_pk_2` (`id_pk`),
  UNIQUE KEY `id_pk_3` (`id_pk`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `transaction_master`
--

LOCK TABLES `transaction_master` WRITE;
/*!40000 ALTER TABLE `transaction_master` DISABLE KEYS */;
/*!40000 ALTER TABLE `transaction_master` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `id_pk` int NOT NULL AUTO_INCREMENT,
  `password` varchar(100) NOT NULL,
  `account_type` tinyint NOT NULL DEFAULT '0' COMMENT '0=Saving,1=Current',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `is_active` tinyint(1) NOT NULL DEFAULT '1' COMMENT '0=inactive,1=active',
  `user_role` varchar(10) NOT NULL,
  `device_os` varchar(10) NOT NULL,
  `host` varchar(50) NOT NULL,
  `cust_id` char(8) NOT NULL,
  `device_id` varchar(20) NOT NULL,
  PRIMARY KEY (`id_pk`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1,'4a6c79e78b71627b823378f96b6e44b4',0,'2020-03-08 11:59:22','2020-03-08 11:59:22',1,'USER','iOS','lucideustech.com','BNK45046','UHDGGF735SVHFVSX'),(2,'4a6c79e78b71627b823378f96b6e44b4',0,'2020-03-08 11:59:29','2020-03-08 11:59:29',1,'USER','iOS','lucideustech.com','BNK41565','UHDGGF735SVHFVSX'),(3,'4a6c79e78b71627b823378f96b6e44b4',0,'2020-03-08 12:03:20','2020-03-08 12:03:20',1,'USER','iOS','lucideustech.com','BNK68264','UHDGGF735SVHFVSX'),(4,'4a6c79e78b71627b823378f96b6e44b4',0,'2020-03-08 12:06:20','2020-03-08 12:06:20',1,'USER','iOS','lucideustech.com','BNK84080','UHDGGF735SVHFVSX'),(5,'4a6c79e78b71627b823378f96b6e44b4',0,'2020-03-08 12:11:27','2020-03-08 12:11:27',1,'USER','iOS','lucideustech.com','BNK08666','UHDGGF735SVHFVSX'),(6,'4a6c79e78b71627b823378f96b6e44b4',0,'2020-03-08 12:14:27','2020-03-08 12:14:27',1,'USER','iOS','lucideustech.com','BNK20631','UHDGGF735SVHFVSX'),(7,'4a6c79e78b71627b823378f96b6e44b4',0,'2020-03-08 12:18:44','2020-03-08 12:18:44',1,'USER','iOS','lucideustech.com','BNK96193','UHDGGF735SVHFVSX'),(8,'4a6c79e78b71627b823378f96b6e44b4',0,'2020-03-08 12:21:23','2020-03-08 12:21:23',1,'USER','iOS','lucideustech.com','BNK50526','UHDGGF735SVHFVSX'),(9,'4a6c79e78b71627b823378f96b6e44b4',0,'2020-03-08 12:28:14','2020-03-08 12:28:14',1,'USER','iOS','lucideustech.com','BNK95587','UHDGGF735SVHFVSX'),(10,'4a6c79e78b71627b823378f96b6e44b4',0,'2020-03-08 12:35:16','2020-03-08 12:35:16',1,'USER','iOS','lucideustech.com','BNK95180','UHDGGF735SVHFVSX');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_details`
--

DROP TABLE IF EXISTS `user_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_details` (
  `id_pk` int NOT NULL AUTO_INCREMENT,
  `user_id_fk` int NOT NULL,
  `fname` varchar(20) NOT NULL,
  `lname` varchar(20) NOT NULL,
  `address` varchar(100) NOT NULL,
  `dob` date NOT NULL,
  `mobile_no` char(10) NOT NULL,
  `email` varchar(50) NOT NULL,
  `aadhar_id` char(12) NOT NULL,
  `pan_card_id` char(10) NOT NULL,
  `wallet_id` char(10) NOT NULL,
  `gender` int NOT NULL COMMENT 'Male=1,Female=2,Others=3',
  `country_id` char(3) NOT NULL,
  `avatar` VARCHAR(250),
  PRIMARY KEY (`id_pk`),
  KEY `user_id_pk_fk_const` (`user_id_fk`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_details`
--

LOCK TABLES `user_details` WRITE;
/*!40000 ALTER TABLE `user_details` DISABLE KEYS */;
INSERT INTO `user_details` VALUES (1,1,'Vipul','Malhotra','19, Ambika Villas, Virar Thiruvananthapuram','1990-11-14','9690008703','vipul.malhotra@ubmail.com','100051650609','7230745428','4489238790',1,'IND',''),(2,2,'Kevin','Winkel','1088 Hillhaven Drive, Los Angeles, CA 90017','2001-04-12','3238245428','kevin.winkel@ubmail.com','409631107754','0437232270','1304616359',1,'USA',''),(3,3,'Kelly','Campbell','194 Tina ClubClarkburghDN2 5AU','1983-07-04','0192299898','kelly.campbell@ubmail.com','084512943929','4320024956','1065208538',2,'UK',''),(4,4,'Krystal','Langworth','26141 Bernhard SquareCrooksfurt, NT R7K 4G8','1995-08-04','1081533578','krystal.langworth@ubmail.com','087605257670','2202661800','9062907004',1,'AUS',''),(5,5,'Margarita','Mann','387 Christina CourtMitchellton, AB N9Y-2L3','1991-06-29','4087658970','margarita.mann@ubmail.com','570630845299','3165831863','0701067746',2,'CAN',''),(6,6,'David','Mahabir','94, Kusum Society, Marathahalli Ranchi - 416560','1989-09-18','7190473876','david.mahabir@ubmail.com','322421230507','0535052879','9305910677',1,'IND',''),(7,7,'Boris','Gerhold','78005 Buford ManorsJastview, AB H2H0C9','1990-04-10','9083884662','boris.gerhold@ubmail.com','280755930525','5640445738','8580304600',1,'CAN',''),(8,8,'Nathaniel','Runolfsson','972 Fannie ViaNorth Karolannmouth, SC 21360','1981-11-11','2912835653','nathaniel.runolfsson@ubmail.com','613698367545','0189010909','1904008575',1,'USA',''),(9,9,'Yvette','Cooper','94 Souterhead Road, LOSGAINTIR, HS3 0PZ','1999-03-29','8116423130','yvette.cooper@ubmail.com','097852583194','7887733110','1753791897',2,'UK',''),(10,10,'Orion','Glover','Unit 81 0 Jeffery ParkwayGutkowskiland, TAS 7274','1981-08-13','7017128990','orion.glover@ubmail.com','510200402330','0070419647','6064583077',2,'AUS','');
/*!40000 ALTER TABLE `user_details` ENABLE KEYS */;
UNLOCK TABLES;

DROP TABLE IF EXISTS `loan_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `loan_details` (
  `id_pk` int NOT NULL AUTO_INCREMENT,
  `user_id_fk` int NOT NULL,
  `amount` varchar(20) NOT NULL,
  `roi` varchar(20) NOT NULL,
  `type` TEXT NOT NULL,
  `tenure` varchar(200) NOT NULL,
  `AppliedDate` char(10) NOT NULL,
  PRIMARY KEY (`id_pk`),
  KEY `user_id_pk_fk_const` (`user_id_fk`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `wallet`
--

DROP TABLE IF EXISTS `wallet`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wallet` (
  `wallet_id` int NOT NULL AUTO_INCREMENT,
  `wallet_bal` int NOT NULL,
  `updated_at` datetime NOT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`wallet_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wallet`
--

LOCK TABLES `wallet` WRITE;
/*!40000 ALTER TABLE `wallet` DISABLE KEYS */;
/*!40000 ALTER TABLE `wallet` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2020-03-08 17:25:38
