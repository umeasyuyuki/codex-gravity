CREATE TABLE `company_alias` (
    `id` TEXT PRIMARY KEY NOT NULL,
    `company_id` TEXT NOT NULL REFERENCES `company`(`id`) ON DELETE CASCADE,
    `alias` TEXT NOT NULL,
    `created_at` INTEGER DEFAULT (strftime('%s', 'now'))
);

CREATE UNIQUE INDEX `company_alias_alias_unique` ON `company_alias` (`alias`);
CREATE INDEX `company_alias_company_id_idx` ON `company_alias` (`company_id`);
