-- Step 1: Create 4 companies that don't exist in DB yet

INSERT OR IGNORE INTO `company` (`id`, `name`, `created_at`)
VALUES (
    lower(hex(randomblob(4)) || '-' || hex(randomblob(2)) || '-4' || substr(hex(randomblob(2)),2) || '-' || substr('89ab', abs(random()) % 4 + 1, 1) || substr(hex(randomblob(2)),2) || '-' || hex(randomblob(6))),
    '株式会社ULC',
    strftime('%s', 'now')
);

INSERT OR IGNORE INTO `company` (`id`, `name`, `created_at`)
VALUES (
    lower(hex(randomblob(4)) || '-' || hex(randomblob(2)) || '-4' || substr(hex(randomblob(2)),2) || '-' || substr('89ab', abs(random()) % 4 + 1, 1) || substr(hex(randomblob(2)),2) || '-' || hex(randomblob(6))),
    'ライフコア株式会社',
    strftime('%s', 'now')
);

INSERT OR IGNORE INTO `company` (`id`, `name`, `created_at`)
VALUES (
    lower(hex(randomblob(4)) || '-' || hex(randomblob(2)) || '-4' || substr(hex(randomblob(2)),2) || '-' || substr('89ab', abs(random()) % 4 + 1, 1) || substr(hex(randomblob(2)),2) || '-' || hex(randomblob(6))),
    '株式会社レックホーム',
    strftime('%s', 'now')
);

INSERT OR IGNORE INTO `company` (`id`, `name`, `created_at`)
VALUES (
    lower(hex(randomblob(4)) || '-' || hex(randomblob(2)) || '-4' || substr(hex(randomblob(2)),2) || '-' || substr('89ab', abs(random()) % 4 + 1, 1) || substr(hex(randomblob(2)),2) || '-' || hex(randomblob(6))),
    '西新町二丁目クリニック',
    strftime('%s', 'now')
);
