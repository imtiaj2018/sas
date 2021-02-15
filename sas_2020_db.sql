/*
SQLyog Community
MySQL - 8.0.23 : Database - sas_2020_db
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
/*Table structure for table `brochure_pdfs` */

DROP TABLE IF EXISTS `brochure_pdfs`;

CREATE TABLE `brochure_pdfs` (
  `id` int NOT NULL AUTO_INCREMENT,
  `file_name` varchar(255) DEFAULT NULL,
  `display_name` varchar(255) DEFAULT NULL,
  `document_type` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `brochure_pdfs` */

insert  into `brochure_pdfs`(`id`,`file_name`,`display_name`,`document_type`,`created_at`,`updated_at`) values 
(5,'PROFILE_2020_v1_digital_12_13_2020_06_07_38PM.pdf','PROFILE_2020_v1_digital.pdf','.pdf','2020-12-13 18:07:38','2020-12-13 18:07:38');

/*Table structure for table `clients` */

DROP TABLE IF EXISTS `clients`;

CREATE TABLE `clients` (
  `id` int NOT NULL AUTO_INCREMENT,
  `file_name` varchar(255) DEFAULT NULL,
  `display_name` varchar(255) DEFAULT NULL,
  `client_name` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `clients` */

insert  into `clients`(`id`,`file_name`,`display_name`,`client_name`,`created_at`,`updated_at`) values 
(1,'client_1_12_18_2020_11_07_41PM.jpg','client_1.jpg','cosmogene','2020-12-18 17:37:41','2020-12-18 17:37:41'),
(2,'client_2_12_18_2020_11_08_05PM.jpg','client_2.jpg','skin n hue','2020-12-18 17:38:05','2020-12-18 17:38:05'),
(3,'client_3_12_18_2020_11_08_19PM.jpg','client_3.jpg','eco wood','2020-12-18 17:38:19','2020-12-18 17:38:19'),
(4,'client_4_12_18_2020_11_08_40PM.jpg','client_4.jpg','concept kitchen','2020-12-18 17:38:40','2020-12-18 17:38:40'),
(5,'client_5_12_18_2020_11_08_59PM.jpg','client_5.jpg','anshu jewellers','2020-12-18 17:38:59','2020-12-18 17:38:59'),
(6,'client_6_12_18_2020_11_09_16PM.jpg','client_6.jpg','smile creations','2020-12-18 17:39:16','2020-12-18 17:39:16'),
(7,'client_7_12_18_2020_11_09_32PM.jpg','client_7.jpg','sheikh','2020-12-18 17:39:32','2020-12-18 17:39:32'),
(8,'client_8_12_18_2020_11_09_54PM.jpg','client_8.jpg','mohar city','2020-12-18 17:39:54','2020-12-18 17:39:54'),
(9,'client_9_12_18_2020_11_10_07PM.jpg','client_9.jpg','grofers','2020-12-18 17:40:07','2020-12-18 17:40:07'),
(10,'client_10_12_18_2020_11_10_20PM.jpg','client_10.jpg','next..','2020-12-18 17:40:20','2020-12-18 17:40:20');

/*Table structure for table `project_images` */

DROP TABLE IF EXISTS `project_images`;

CREATE TABLE `project_images` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `file_name` varchar(255) DEFAULT NULL,
  `display_name` varchar(255) DEFAULT NULL,
  `image_size` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `project_images` */

insert  into `project_images`(`id`,`file_name`,`display_name`,`image_size`,`created_at`,`updated_at`) values 
(1,'project_1_l_12_18_2020_11_00_22PM.jpg','project_1_l.jpg','l','2020-12-18 17:30:22','2020-12-18 17:30:22'),
(2,'project_1_s_12_18_2020_11_00_36PM.jpg','project_1_s.jpg','s','2020-12-18 17:30:36','2020-12-18 17:30:36'),
(3,'project_2_l_12_18_2020_11_00_51PM.jpg','project_2_l.jpg','l','2020-12-18 17:30:51','2020-12-18 17:30:51'),
(4,'project_2_s_12_18_2020_11_01_07PM.jpg','project_2_s.jpg','s','2020-12-18 17:31:07','2020-12-18 17:31:07'),
(5,'project_3_l_12_18_2020_11_01_19PM.jpg','project_3_l.jpg','l','2020-12-18 17:31:19','2020-12-18 17:31:19'),
(6,'project_3_s_12_18_2020_11_01_34PM.jpg','project_3_s.jpg','s','2020-12-18 17:31:34','2020-12-18 17:31:34'),
(7,'project_4_l_12_18_2020_11_01_48PM.jpg','project_4_l.jpg','l','2020-12-18 17:31:48','2020-12-18 17:31:48'),
(8,'project_4_s_12_18_2020_11_02_01PM.jpg','project_4_s.jpg','s','2020-12-18 17:32:01','2020-12-18 17:32:01'),
(9,'project_5_l_12_18_2020_11_02_17PM.jpg','project_5_l.jpg','l','2020-12-18 17:32:17','2020-12-18 17:32:17'),
(10,'project_5_s_12_18_2020_11_02_33PM.jpg','project_5_s.jpg','s','2020-12-18 17:32:33','2020-12-18 17:32:33'),
(11,'project_6_l_12_18_2020_11_02_46PM.jpg','project_6_l.jpg','l','2020-12-18 17:32:46','2020-12-18 17:32:46'),
(12,'project_6_s_12_18_2020_11_02_58PM.jpg','project_6_s.jpg','s','2020-12-18 17:32:58','2020-12-18 17:32:58'),
(13,'project_7_l_12_18_2020_11_03_12PM.jpg','project_7_l.jpg','l','2020-12-18 17:33:12','2020-12-18 17:33:12'),
(14,'project_7_s_12_18_2020_11_03_30PM.jpg','project_7_s.jpg','s','2020-12-18 17:33:30','2020-12-18 17:33:30'),
(15,'project_8_l_12_18_2020_11_03_53PM.jpg','project_8_l.jpg','l','2020-12-18 17:33:53','2020-12-18 17:33:53'),
(16,'project_8_s_12_18_2020_11_04_07PM.jpg','project_8_s.jpg','s','2020-12-18 17:34:07','2020-12-18 17:34:07'),
(17,'project_9_l_12_18_2020_11_04_23PM.jpg','project_9_l.jpg','l','2020-12-18 17:34:23','2020-12-18 17:34:23'),
(18,'project_9_s_12_18_2020_11_04_38PM.jpg','project_9_s.jpg','s','2020-12-18 17:34:38','2020-12-18 17:34:38'),
(19,'project_10_l_12_18_2020_11_04_55PM.jpg','project_10_l.jpg','l','2020-12-18 17:34:55','2020-12-18 17:34:55'),
(20,'project_10_s_12_18_2020_11_05_26PM.jpg','project_10_s.jpg','s','2020-12-18 17:35:26','2020-12-18 17:35:26'),
(21,'project_11_l_12_18_2020_11_05_44PM.jpg','project_11_l.jpg','l','2020-12-18 17:35:44','2020-12-18 17:35:44'),
(22,'project_11_s_12_18_2020_11_06_17PM.jpg','project_11_s.jpg','s','2020-12-18 17:36:17','2020-12-18 17:36:17'),
(23,'project_12_l_12_18_2020_11_06_40PM.jpg','project_12_l.jpg','l','2020-12-18 17:36:40','2020-12-18 17:36:40'),
(24,'project_12_s_12_18_2020_11_06_52PM.jpg','project_12_s.jpg','s','2020-12-18 17:36:52','2020-12-18 17:36:52');

/*Table structure for table `schema_migrations` */

DROP TABLE IF EXISTS `schema_migrations`;

CREATE TABLE `schema_migrations` (
  `version` varchar(255) NOT NULL,
  PRIMARY KEY (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `schema_migrations` */

insert  into `schema_migrations`(`version`) values 
('20200911182640'),
('20200911182743'),
('20200914192507'),
('20200919115332');

/*Table structure for table `users` */

DROP TABLE IF EXISTS `users`;

CREATE TABLE `users` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `email` varchar(255) NOT NULL DEFAULT '',
  `encrypted_password` varchar(255) NOT NULL DEFAULT '',
  `reset_password_token` varchar(255) DEFAULT NULL,
  `reset_password_sent_at` datetime DEFAULT NULL,
  `remember_created_at` datetime DEFAULT NULL,
  `sign_in_count` int NOT NULL DEFAULT '0',
  `current_sign_in_at` datetime DEFAULT NULL,
  `last_sign_in_at` datetime DEFAULT NULL,
  `current_sign_in_ip` varchar(255) DEFAULT NULL,
  `last_sign_in_ip` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_users_on_email` (`email`),
  UNIQUE KEY `index_users_on_reset_password_token` (`reset_password_token`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Data for the table `users` */

insert  into `users`(`id`,`email`,`encrypted_password`,`reset_password_token`,`reset_password_sent_at`,`remember_created_at`,`sign_in_count`,`current_sign_in_at`,`last_sign_in_at`,`current_sign_in_ip`,`last_sign_in_ip`,`created_at`,`updated_at`) values 
(1,'imtiajromi@gmail.com','$2a$11$ht4FZI48kiOg5wZAFNOehOpt/Rz6qbUNvw8fC11xknC8aJmq.W6Bi',NULL,NULL,NULL,12,'2020-12-17 17:52:40','2020-12-17 17:22:24','106.211.133.74','106.211.133.74','2020-09-20 10:49:25','2020-12-17 17:52:40'),
(2,'syedmustaquealiahamed@gmail.com','$2a$11$ht4FZI48kiOg5wZAFNOehOpt/Rz6qbUNvw8fC11xknC8aJmq.W6Bi',NULL,NULL,NULL,2,'2020-09-20 11:00:48','2020-09-20 10:58:58','1.23.170.95','1.23.170.95','2020-09-20 10:58:57','2020-09-20 11:00:48');

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
