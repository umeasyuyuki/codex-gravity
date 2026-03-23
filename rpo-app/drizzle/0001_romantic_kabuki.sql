ALTER TABLE `applicant` ADD `primary_scheduled_date` integer;--> statement-breakpoint
ALTER TABLE `applicant` ADD `primary_conducted_date` integer;--> statement-breakpoint
ALTER TABLE `applicant` ADD `sec_scheduled_date` integer;--> statement-breakpoint
ALTER TABLE `applicant` ADD `sec_conducted_date` integer;--> statement-breakpoint
ALTER TABLE `applicant` ADD `final_scheduled` integer DEFAULT false;--> statement-breakpoint
ALTER TABLE `applicant` ADD `final_scheduled_date` integer;--> statement-breakpoint
ALTER TABLE `applicant` ADD `final_conducted` integer DEFAULT false;--> statement-breakpoint
ALTER TABLE `applicant` ADD `final_conducted_date` integer;--> statement-breakpoint
ALTER TABLE `call_log` ADD `is_connected` integer DEFAULT false;