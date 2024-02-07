-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema jep18d
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `jep18d` ;

-- -----------------------------------------------------
-- Schema jep18d
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `jep18d` DEFAULT CHARACTER SET utf8 ;
SHOW WARNINGS;
USE `jep18d` ;

-- -----------------------------------------------------
-- Table `jep18d`.`job`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `jep18d`.`job` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `jep18d`.`job` (
  `job_id` TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `job_title` VARCHAR(45) NOT NULL,
  `job_notes` VARCHAR(255) NULL,
  PRIMARY KEY (`job_id`))
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `jep18d`.`employee`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `jep18d`.`employee` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `jep18d`.`employee` (
  `emp_id` SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `job_id` TINYINT UNSIGNED NOT NULL,
  `emp_ssn` CHAR(9) NOT NULL,
  `emp_fname` VARCHAR(15) NOT NULL,
  `emp_lname` VARCHAR(30) NOT NULL,
  `emp_dob` DATE NOT NULL,
  `emp_start_date` DATE NOT NULL,
  `emp_end_date` DATE NULL,
  `emp_salary` DECIMAL(8,2) NOT NULL,
  `emp_street` VARCHAR(30) NOT NULL,
  `emp_city` VARCHAR(20) NOT NULL,
  `emp_state` CHAR(2) NOT NULL,
  `emp_zip` CHAR(9) NOT NULL,
  `emp_phone` BIGINT UNSIGNED NOT NULL,
  `emp_email` VARCHAR(100) NOT NULL,
  `emp_notes` VARCHAR(255) NULL,
  PRIMARY KEY (`emp_id`),
  INDEX `fk_employee_job1_idx` (`job_id` ASC) VISIBLE,
  UNIQUE INDEX `emp_ssn_UNIQUE` (`emp_ssn` ASC) VISIBLE,
  CONSTRAINT `fk_employee_job1`
    FOREIGN KEY (`job_id`)
    REFERENCES `jep18d`.`job` (`job_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `jep18d`.`emp_hist`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `jep18d`.`emp_hist` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `jep18d`.`emp_hist` (
  `eht_id` MEDIUMINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `emp_id` SMALLINT UNSIGNED NULL,
  `eht_date` DATETIME NOT NULL DEFAULT current_timestamp,
  `eht_type` ENUM('i', 'u', 'd') NOT NULL DEFAULT 'i',
  `eht_job_id` TINYINT UNSIGNED NOT NULL,
  `eht_emp_salary` DECIMAL(8,2) NOT NULL,
  `eht_usr_changed` VARCHAR(30) NOT NULL,
  `eht_reason` VARCHAR(45) NOT NULL,
  `eht__notes` VARCHAR(255) NULL,
  PRIMARY KEY (`eht_id`),
  INDEX `fk_emp_hist_employee1_idx` (`emp_id` ASC) VISIBLE,
  CONSTRAINT `fk_emp_hist_employee1`
    FOREIGN KEY (`emp_id`)
    REFERENCES `jep18d`.`employee` (`emp_id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `jep18d`.`benefit`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `jep18d`.`benefit` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `jep18d`.`benefit` (
  `ben_id` TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `ben_name` VARCHAR(45) NOT NULL,
  `ben_notes` VARCHAR(255) NULL,
  PRIMARY KEY (`ben_id`))
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `jep18d`.`plan`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `jep18d`.`plan` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `jep18d`.`plan` (
  `pln_id` SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `emp_id` SMALLINT UNSIGNED NOT NULL,
  `ben_id` TINYINT UNSIGNED NOT NULL,
  `pln_type` ENUM('single', 'spouse', 'family') NOT NULL,
  `pln_cost` DECIMAL(6,2) UNSIGNED NOT NULL,
  `pln_election_date` DATE NOT NULL,
  `pln_notes` VARCHAR(255) NULL,
  PRIMARY KEY (`pln_id`),
  INDEX `fk_plan_employee1_idx` (`emp_id` ASC) VISIBLE,
  INDEX `fk_plan_benefit1_idx` (`ben_id` ASC) VISIBLE,
  CONSTRAINT `fk_plan_employee1`
    FOREIGN KEY (`emp_id`)
    REFERENCES `jep18d`.`employee` (`emp_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_plan_benefit1`
    FOREIGN KEY (`ben_id`)
    REFERENCES `jep18d`.`benefit` (`ben_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `jep18d`.`dependent`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `jep18d`.`dependent` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `jep18d`.`dependent` (
  `dep_id` SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `emp_id` SMALLINT UNSIGNED NOT NULL,
  `dep_added` DATE NOT NULL,
  `dep_ssn` CHAR(9) NOT NULL,
  `dep_fname` VARCHAR(15) NOT NULL,
  `dep_lname` VARCHAR(30) NOT NULL,
  `dep_dob` DATE NOT NULL,
  `dep_relation` VARCHAR(20) NOT NULL,
  `dep_street` VARCHAR(30) NOT NULL,
  `dep_city` VARCHAR(20) NOT NULL,
  `dep_state` CHAR(2) NOT NULL,
  `dep_zip` CHAR(9) NOT NULL,
  `dep_phone` BIGINT UNSIGNED NOT NULL,
  `dep_email` VARCHAR(100) NULL,
  `dep_notes` VARCHAR(255) NULL,
  PRIMARY KEY (`dep_id`),
  INDEX `fk_dependent_employee_idx` (`emp_id` ASC) VISIBLE,
  UNIQUE INDEX `dep_ssn_UNIQUE` (`dep_ssn` ASC) VISIBLE,
  CONSTRAINT `fk_dependent_employee`
    FOREIGN KEY (`emp_id`)
    REFERENCES `jep18d`.`employee` (`emp_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

SHOW WARNINGS;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- -----------------------------------------------------
-- Data for table `jep18d`.`job`
-- -----------------------------------------------------
START TRANSACTION;
USE `jep18d`;
INSERT INTO `jep18d`.`job` (`job_id`, `job_title`, `job_notes`) VALUES (DEFAULT, 'secretary', NULL);
INSERT INTO `jep18d`.`job` (`job_id`, `job_title`, `job_notes`) VALUES (DEFAULT, 'cashier', NULL);
INSERT INTO `jep18d`.`job` (`job_id`, `job_title`, `job_notes`) VALUES (DEFAULT, 'manager', NULL);
INSERT INTO `jep18d`.`job` (`job_id`, `job_title`, `job_notes`) VALUES (DEFAULT, 'janitor', NULL);
INSERT INTO `jep18d`.`job` (`job_id`, `job_title`, `job_notes`) VALUES (DEFAULT, 'it', NULL);

COMMIT;


-- -----------------------------------------------------
-- Data for table `jep18d`.`employee`
-- -----------------------------------------------------
START TRANSACTION;
USE `jep18d`;
INSERT INTO `jep18d`.`employee` (`emp_id`, `job_id`, `emp_ssn`, `emp_fname`, `emp_lname`, `emp_dob`, `emp_start_date`, `emp_end_date`, `emp_salary`, `emp_street`, `emp_city`, `emp_state`, `emp_zip`, `emp_phone`, `emp_email`, `emp_notes`) VALUES (DEFAULT, 2, '123456789', 'Jerome', 'Wilkins', '1989-06-01', '2022-08-15', NULL, 92293.22, 'P.O. Box 792, 2386 Purus, Av.', 'Helena', 'MD', '669711234', 9634617260, 'eget.nisi@aol.com', '');
INSERT INTO `jep18d`.`employee` (`emp_id`, `job_id`, `emp_ssn`, `emp_fname`, `emp_lname`, `emp_dob`, `emp_start_date`, `emp_end_date`, `emp_salary`, `emp_street`, `emp_city`, `emp_state`, `emp_zip`, `emp_phone`, `emp_email`, `emp_notes`) VALUES (DEFAULT, 3, '123456987', 'Angela', 'Dawson', '1992-02-07', '2015-04-29', NULL, 72828.50, '414-1725 Ad St.', 'Kailua', 'WY', '375392345', 5154915665, 'lectus.sit@outlook.net', '');
INSERT INTO `jep18d`.`employee` (`emp_id`, `job_id`, `emp_ssn`, `emp_fname`, `emp_lname`, `emp_dob`, `emp_start_date`, `emp_end_date`, `emp_salary`, `emp_street`, `emp_city`, `emp_state`, `emp_zip`, `emp_phone`, `emp_email`, `emp_notes`) VALUES (DEFAULT, 4, '123456123', 'Sonia', 'Carpenter', '1997-01-07', '2023-03-12', '2012-08-30', 71114.08, '949-9554 Per St.', 'Tuscaloosa', 'MS', '230813456', 8255122821, 'ultrices.posuere@yahoo.org', '');
INSERT INTO `jep18d`.`employee` (`emp_id`, `job_id`, `emp_ssn`, `emp_fname`, `emp_lname`, `emp_dob`, `emp_start_date`, `emp_end_date`, `emp_salary`, `emp_street`, `emp_city`, `emp_state`, `emp_zip`, `emp_phone`, `emp_email`, `emp_notes`) VALUES (DEFAULT, 1, '123456321', 'Carter', 'Lawson', '1995-11-29', '2010-06-16', NULL, 101154.12, '171-2370 Pede Ave', 'Dallas', 'NV', '413124567', 9033761881, 'tempus.non@outlook.couk', '');
INSERT INTO `jep18d`.`employee` (`emp_id`, `job_id`, `emp_ssn`, `emp_fname`, `emp_lname`, `emp_dob`, `emp_start_date`, `emp_end_date`, `emp_salary`, `emp_street`, `emp_city`, `emp_state`, `emp_zip`, `emp_phone`, `emp_email`, `emp_notes`) VALUES (DEFAULT, 3, '123456456', 'Sybill', 'Barton', '2000-03-19', '2020-11-15', NULL, 142112.85, '5928 Aliquet St.', 'Akron', 'DE', '249855678', 2118468493, 'viverra.maecenas@icloud.ca', '');
INSERT INTO `jep18d`.`employee` (`emp_id`, `job_id`, `emp_ssn`, `emp_fname`, `emp_lname`, `emp_dob`, `emp_start_date`, `emp_end_date`, `emp_salary`, `emp_street`, `emp_city`, `emp_state`, `emp_zip`, `emp_phone`, `emp_email`, `emp_notes`) VALUES (DEFAULT, 5, '123456654', 'Craig', 'Buckley', '2000-09-07', '2012-09-26', '2009-03-06', 147605.79, 'P.O. Box 980, 6607 A Avenue', 'Hilo', 'MA', '571756789', 1555981632, 'est.tempor.bibendum@hotmail.org', '');

COMMIT;


-- -----------------------------------------------------
-- Data for table `jep18d`.`emp_hist`
-- -----------------------------------------------------
START TRANSACTION;
USE `jep18d`;
INSERT INTO `jep18d`.`emp_hist` (`eht_id`, `emp_id`, `eht_date`, `eht_type`, `eht_job_id`, `eht_emp_salary`, `eht_usr_changed`, `eht_reason`, `eht__notes`) VALUES (DEFAULT, 1, '2001-03-19 09:30:00', 'i', 1, 50000, 'test', 'promotion', NULL);
INSERT INTO `jep18d`.`emp_hist` (`eht_id`, `emp_id`, `eht_date`, `eht_type`, `eht_job_id`, `eht_emp_salary`, `eht_usr_changed`, `eht_reason`, `eht__notes`) VALUES (DEFAULT, 2, '2003-05-10 10:45:00', 'u', 4, 60000, 'test', 'demotion', NULL);
INSERT INTO `jep18d`.`emp_hist` (`eht_id`, `emp_id`, `eht_date`, `eht_type`, `eht_job_id`, `eht_emp_salary`, `eht_usr_changed`, `eht_reason`, `eht__notes`) VALUES (DEFAULT, 3, '2005-07-18 12:00:00', 'i', 5, 70000, 'test', 'dept. change', NULL);
INSERT INTO `jep18d`.`emp_hist` (`eht_id`, `emp_id`, `eht_date`, `eht_type`, `eht_job_id`, `eht_emp_salary`, `eht_usr_changed`, `eht_reason`, `eht__notes`) VALUES (DEFAULT, 4, '2009-11-11 14:30:00', 'i', 2, 80000, 'test', 'job change', NULL);
INSERT INTO `jep18d`.`emp_hist` (`eht_id`, `emp_id`, `eht_date`, `eht_type`, `eht_job_id`, `eht_emp_salary`, `eht_usr_changed`, `eht_reason`, `eht__notes`) VALUES (DEFAULT, 5, '2010-02-27 15:40:00', 'u', 3, 90000, 'test', 'new plan', 'current_timestamp example');

COMMIT;


-- -----------------------------------------------------
-- Data for table `jep18d`.`benefit`
-- -----------------------------------------------------
START TRANSACTION;
USE `jep18d`;
INSERT INTO `jep18d`.`benefit` (`ben_id`, `ben_name`, `ben_notes`) VALUES (DEFAULT, 'medical', NULL);
INSERT INTO `jep18d`.`benefit` (`ben_id`, `ben_name`, `ben_notes`) VALUES (DEFAULT, 'dental', NULL);
INSERT INTO `jep18d`.`benefit` (`ben_id`, `ben_name`, `ben_notes`) VALUES (DEFAULT, '401k', NULL);
INSERT INTO `jep18d`.`benefit` (`ben_id`, `ben_name`, `ben_notes`) VALUES (DEFAULT, 'life insurance', NULL);
INSERT INTO `jep18d`.`benefit` (`ben_id`, `ben_name`, `ben_notes`) VALUES (DEFAULT, 'vision', NULL);

COMMIT;


-- -----------------------------------------------------
-- Data for table `jep18d`.`plan`
-- -----------------------------------------------------
START TRANSACTION;
USE `jep18d`;
INSERT INTO `jep18d`.`plan` (`pln_id`, `emp_id`, `ben_id`, `pln_type`, `pln_cost`, `pln_election_date`, `pln_notes`) VALUES (DEFAULT, 1, 2, 'single', 500, '2013-01-02', NULL);
INSERT INTO `jep18d`.`plan` (`pln_id`, `emp_id`, `ben_id`, `pln_type`, `pln_cost`, `pln_election_date`, `pln_notes`) VALUES (DEFAULT, 2, 3, 'spouse', 1000, '2012-03-04', NULL);
INSERT INTO `jep18d`.`plan` (`pln_id`, `emp_id`, `ben_id`, `pln_type`, `pln_cost`, `pln_election_date`, `pln_notes`) VALUES (DEFAULT, 3, 4, 'family', 1500, '2011-05-06', NULL);
INSERT INTO `jep18d`.`plan` (`pln_id`, `emp_id`, `ben_id`, `pln_type`, `pln_cost`, `pln_election_date`, `pln_notes`) VALUES (DEFAULT, 4, 5, 'single', 200, '2010-07-08', NULL);
INSERT INTO `jep18d`.`plan` (`pln_id`, `emp_id`, `ben_id`, `pln_type`, `pln_cost`, `pln_election_date`, `pln_notes`) VALUES (DEFAULT, 5, 1, 'spouse', 600, '2009-09-10', NULL);

COMMIT;


-- -----------------------------------------------------
-- Data for table `jep18d`.`dependent`
-- -----------------------------------------------------
START TRANSACTION;
USE `jep18d`;
INSERT INTO `jep18d`.`dependent` (`dep_id`, `emp_id`, `dep_added`, `dep_ssn`, `dep_fname`, `dep_lname`, `dep_dob`, `dep_relation`, `dep_street`, `dep_city`, `dep_state`, `dep_zip`, `dep_phone`, `dep_email`, `dep_notes`) VALUES (DEFAULT, 1, '2010-02-11', '167782930', 'Cullen', 'Keith', '1997-04-06', 'father', 'P.O. Box 780, 104 Augue, Av.', 'Erie', 'OH', '704529876', 3327012704, 'consectetuer.rhoncus@google.net', '');
INSERT INTO `jep18d`.`dependent` (`dep_id`, `emp_id`, `dep_added`, `dep_ssn`, `dep_fname`, `dep_lname`, `dep_dob`, `dep_relation`, `dep_street`, `dep_city`, `dep_state`, `dep_zip`, `dep_phone`, `dep_email`, `dep_notes`) VALUES (DEFAULT, 3, '2015-03-04', '762652629', 'Finn', 'Maynard', '201-08-05', 'spouse', '492-6261 Proin Avenue', 'Chicago', 'OH', '138158765', 0521831298, 'vehicula.aliquet.libero@outlook.org', '');
INSERT INTO `jep18d`.`dependent` (`dep_id`, `emp_id`, `dep_added`, `dep_ssn`, `dep_fname`, `dep_lname`, `dep_dob`, `dep_relation`, `dep_street`, `dep_city`, `dep_state`, `dep_zip`, `dep_phone`, `dep_email`, `dep_notes`) VALUES (DEFAULT, 2, '2016-01-23', '315055074', 'Maggy', 'Navarro', '2012-12-25', 'son', 'Ap #732-1146 In Road', 'Rutland', 'UT', '454897654', 5579654552, NULL, '');
INSERT INTO `jep18d`.`dependent` (`dep_id`, `emp_id`, `dep_added`, `dep_ssn`, `dep_fname`, `dep_lname`, `dep_dob`, `dep_relation`, `dep_street`, `dep_city`, `dep_state`, `dep_zip`, `dep_phone`, `dep_email`, `dep_notes`) VALUES (DEFAULT, 6, '2021-07-10', '390074556', 'Tatiana', 'Alford', '1991-05-23', 'father', '307-4679 Nisl Avenue', 'Naperville', 'IL', '852376543', 1180221687, 'libero.est@icloud.org', '');
INSERT INTO `jep18d`.`dependent` (`dep_id`, `emp_id`, `dep_added`, `dep_ssn`, `dep_fname`, `dep_lname`, `dep_dob`, `dep_relation`, `dep_street`, `dep_city`, `dep_state`, `dep_zip`, `dep_phone`, `dep_email`, `dep_notes`) VALUES (DEFAULT, 4, '2019-06-19', '153307443', 'Sonya', 'Chang', '1994-11-23', 'father', 'Ap #242-9384 Pede. St.', 'Kansas City', 'HI', '544445432', 7656618240, NULL, '');
INSERT INTO `jep18d`.`dependent` (`dep_id`, `emp_id`, `dep_added`, `dep_ssn`, `dep_fname`, `dep_lname`, `dep_dob`, `dep_relation`, `dep_street`, `dep_city`, `dep_state`, `dep_zip`, `dep_phone`, `dep_email`, `dep_notes`) VALUES (DEFAULT, 5, '2011-10-12', '823177791', 'Aphrodite', 'Owen', '2015-09-08', 'daughter', 'P.O. Box 494, 8964 Nec Avenue', 'Augusta', 'WI', '439124321', 5568531926, 'ut.nisi.a@icloud.edu', '');

COMMIT;

