CREATE INDEX IF NOT EXISTS `idx_applicant_company_id` ON `applicant` (`company_id`);
--> statement-breakpoint
CREATE INDEX IF NOT EXISTS `idx_applicant_applied_at` ON `applicant` (`applied_at`);
--> statement-breakpoint
CREATE INDEX IF NOT EXISTS `idx_applicant_company_applied_created` ON `applicant` (`company_id`, `applied_at`, `created_at`);
--> statement-breakpoint
CREATE INDEX IF NOT EXISTS `idx_applicant_company_name` ON `applicant` (`company_id`, `name`);
--> statement-breakpoint
CREATE INDEX IF NOT EXISTS `idx_call_log_applicant_id` ON `call_log` (`applicant_id`);
--> statement-breakpoint
CREATE INDEX IF NOT EXISTS `idx_interview_applicant_id` ON `interview` (`applicant_id`);
