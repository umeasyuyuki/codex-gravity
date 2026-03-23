CREATE TABLE `account` (
	`userId` text NOT NULL,
	`type` text NOT NULL,
	`provider` text NOT NULL,
	`providerAccountId` text NOT NULL,
	`refresh_token` text,
	`access_token` text,
	`expires_at` integer,
	`token_type` text,
	`scope` text,
	`id_token` text,
	`session_state` text,
	PRIMARY KEY(`provider`, `providerAccountId`),
	FOREIGN KEY (`userId`) REFERENCES `user`(`id`) ON UPDATE no action ON DELETE cascade
);
--> statement-breakpoint
CREATE TABLE `applicant` (
	`id` text PRIMARY KEY NOT NULL,
	`company_id` text NOT NULL,
	`name` text NOT NULL,
	`applied_at` integer NOT NULL,
	`is_unique_applicant` integer DEFAULT false,
	`is_valid_applicant` integer DEFAULT false,
	`doc_declined` integer DEFAULT false,
	`doc_rejected_mk` integer DEFAULT false,
	`doc_rejected_client` integer DEFAULT false,
	`scheduling_interview` integer DEFAULT false,
	`interview_declined_before` integer DEFAULT false,
	`primary_no_show` integer DEFAULT false,
	`primary_scheduled` integer DEFAULT false,
	`primary_conducted` integer DEFAULT false,
	`primary_declined_after` integer DEFAULT false,
	`primary_rejected` integer DEFAULT false,
	`sec_scheduled` integer DEFAULT false,
	`sec_declined_before` integer DEFAULT false,
	`sec_no_show` integer DEFAULT false,
	`sec_conducted` integer DEFAULT false,
	`sec_declined_after` integer DEFAULT false,
	`sec_rejected` integer DEFAULT false,
	`offered` integer DEFAULT false,
	`offer_declined` integer DEFAULT false,
	`joined` integer DEFAULT false,
	`created_at` integer DEFAULT (strftime('%s', 'now')),
	`updated_at` integer DEFAULT (strftime('%s', 'now')),
	FOREIGN KEY (`company_id`) REFERENCES `company`(`id`) ON UPDATE no action ON DELETE cascade
);
--> statement-breakpoint
CREATE TABLE `call_log` (
	`id` text PRIMARY KEY NOT NULL,
	`applicant_id` text NOT NULL,
	`caller_id` text NOT NULL,
	`call_count` integer NOT NULL,
	`note` text,
	`called_at` integer DEFAULT (strftime('%s', 'now')),
	`created_at` integer DEFAULT (strftime('%s', 'now')),
	FOREIGN KEY (`applicant_id`) REFERENCES `applicant`(`id`) ON UPDATE no action ON DELETE cascade,
	FOREIGN KEY (`caller_id`) REFERENCES `user`(`id`) ON UPDATE no action ON DELETE cascade
);
--> statement-breakpoint
CREATE TABLE `company` (
	`id` text PRIMARY KEY NOT NULL,
	`name` text NOT NULL,
	`created_at` integer DEFAULT (strftime('%s', 'now')),
	`updated_at` integer DEFAULT (strftime('%s', 'now'))
);
--> statement-breakpoint
CREATE TABLE `interview` (
	`id` text PRIMARY KEY NOT NULL,
	`applicant_id` text NOT NULL,
	`phase` text NOT NULL,
	`interview_date` integer NOT NULL,
	`created_at` integer DEFAULT (strftime('%s', 'now')),
	FOREIGN KEY (`applicant_id`) REFERENCES `applicant`(`id`) ON UPDATE no action ON DELETE cascade
);
--> statement-breakpoint
CREATE TABLE `session` (
	`sessionToken` text PRIMARY KEY NOT NULL,
	`userId` text NOT NULL,
	`expires` integer NOT NULL,
	FOREIGN KEY (`userId`) REFERENCES `user`(`id`) ON UPDATE no action ON DELETE cascade
);
--> statement-breakpoint
CREATE TABLE `user` (
	`id` text PRIMARY KEY NOT NULL,
	`name` text,
	`email` text NOT NULL,
	`emailVerified` integer,
	`image` text
);
--> statement-breakpoint
CREATE TABLE `verificationToken` (
	`identifier` text NOT NULL,
	`token` text NOT NULL,
	`expires` integer NOT NULL,
	PRIMARY KEY(`identifier`, `token`)
);
