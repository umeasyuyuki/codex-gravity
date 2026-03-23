ALTER TABLE `applicant` ADD `gender` text;
--> statement-breakpoint
ALTER TABLE `applicant` ADD `assignee_user_id` text;
--> statement-breakpoint
ALTER TABLE `applicant` ADD `response_status` text;
--> statement-breakpoint
ALTER TABLE `applicant` ADD `connected_at` integer;
--> statement-breakpoint
ALTER TABLE `applicant` ADD `next_action_date` integer;
--> statement-breakpoint
ALTER TABLE `applicant` ADD `final_declined_before` integer DEFAULT 0;
--> statement-breakpoint
ALTER TABLE `applicant` ADD `final_no_show` integer DEFAULT 0;
--> statement-breakpoint
ALTER TABLE `applicant` ADD `final_declined_after` integer DEFAULT 0;
--> statement-breakpoint
ALTER TABLE `applicant` ADD `final_rejected` integer DEFAULT 0;
--> statement-breakpoint
ALTER TABLE `applicant` ADD `joined_date` integer;
