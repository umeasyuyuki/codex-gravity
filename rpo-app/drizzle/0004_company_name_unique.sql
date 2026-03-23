UPDATE `company`
SET `name` = trim(`name`)
WHERE `name` <> trim(`name`);
--> statement-breakpoint
UPDATE `applicant`
SET `company_id` = (
	SELECT `canonical`.`id`
	FROM `company` `current_company`
	JOIN `company` `canonical` ON `canonical`.`name` = `current_company`.`name`
	WHERE `current_company`.`id` = `applicant`.`company_id`
	ORDER BY `canonical`.`created_at` ASC, `canonical`.`id` ASC
	LIMIT 1
)
WHERE `company_id` IN (
	SELECT `c`.`id`
	FROM `company` `c`
	WHERE `c`.`id` <> (
		SELECT `canonical`.`id`
		FROM `company` `canonical`
		WHERE `canonical`.`name` = `c`.`name`
		ORDER BY `canonical`.`created_at` ASC, `canonical`.`id` ASC
		LIMIT 1
	)
);
--> statement-breakpoint
DELETE FROM `company`
WHERE `id` IN (
	SELECT `c`.`id`
	FROM `company` `c`
	WHERE `c`.`id` <> (
		SELECT `canonical`.`id`
		FROM `company` `canonical`
		WHERE `canonical`.`name` = `c`.`name`
		ORDER BY `canonical`.`created_at` ASC, `canonical`.`id` ASC
		LIMIT 1
	)
);
--> statement-breakpoint
CREATE UNIQUE INDEX IF NOT EXISTS `company_name_unique` ON `company` (`name`);
