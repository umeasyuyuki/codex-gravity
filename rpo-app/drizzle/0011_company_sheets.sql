CREATE TABLE `company_sheet` (
	`id` text PRIMARY KEY NOT NULL,
	`company_id` text NOT NULL,
	`spreadsheet_id` text NOT NULL,
	`gid` integer DEFAULT 0,
	`sheet_name` text,
	`enabled` integer DEFAULT 1,
	`created_at` integer DEFAULT (strftime('%s', 'now')),
	FOREIGN KEY (`company_id`) REFERENCES `company`(`id`) ON DELETE cascade
);
