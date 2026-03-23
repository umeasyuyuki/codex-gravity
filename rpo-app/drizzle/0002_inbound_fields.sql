ALTER TABLE `applicant` ADD `email` text;
--> statement-breakpoint
ALTER TABLE `applicant` ADD `applied_job` text;
--> statement-breakpoint
ALTER TABLE `applicant` ADD `applied_location` text;
--> statement-breakpoint
ALTER TABLE `applicant` ADD `source_gmail_message_id` text;
--> statement-breakpoint
ALTER TABLE `applicant` ADD `source_gmail_thread_id` text;
--> statement-breakpoint
CREATE UNIQUE INDEX `applicant_source_gmail_message_id_unique` ON `applicant` (`source_gmail_message_id`);
