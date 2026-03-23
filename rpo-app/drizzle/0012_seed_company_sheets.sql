-- Seed company_sheet records from existing GAS configuration
-- Uses INSERT OR IGNORE to be idempotent (won't fail if already seeded)

INSERT OR IGNORE INTO `company_sheet` (`id`, `company_id`, `spreadsheet_id`, `gid`, `sheet_name`, `enabled`)
SELECT lower(hex(randomblob(4)) || '-' || hex(randomblob(2)) || '-4' || substr(hex(randomblob(2)),2) || '-' || substr('89ab', abs(random()) % 4 + 1, 1) || substr(hex(randomblob(2)),2) || '-' || hex(randomblob(6))),
       c.id,
       '1eVO3Ix9o08M17w87wOdJiOLfd668oEXjfKbpcnmm-J0',
       465742923,
       NULL,
       1
FROM `company` c WHERE c.name = '大阪機器工作所' AND NOT EXISTS (SELECT 1 FROM `company_sheet` cs WHERE cs.company_id = c.id);

INSERT OR IGNORE INTO `company_sheet` (`id`, `company_id`, `spreadsheet_id`, `gid`, `sheet_name`, `enabled`)
SELECT lower(hex(randomblob(4)) || '-' || hex(randomblob(2)) || '-4' || substr(hex(randomblob(2)),2) || '-' || substr('89ab', abs(random()) % 4 + 1, 1) || substr(hex(randomblob(2)),2) || '-' || hex(randomblob(6))),
       c.id,
       '1paHNHLJjBxBIgbY1ki7IoocqKBKpFGmlDvT4ormpOl4',
       465742923,
       NULL,
       1
FROM `company` c WHERE c.name = 'TKC株式会社/YMD株式会社' AND NOT EXISTS (SELECT 1 FROM `company_sheet` cs WHERE cs.company_id = c.id);

INSERT OR IGNORE INTO `company_sheet` (`id`, `company_id`, `spreadsheet_id`, `gid`, `sheet_name`, `enabled`)
SELECT lower(hex(randomblob(4)) || '-' || hex(randomblob(2)) || '-4' || substr(hex(randomblob(2)),2) || '-' || substr('89ab', abs(random()) % 4 + 1, 1) || substr(hex(randomblob(2)),2) || '-' || hex(randomblob(6))),
       c.id,
       '1mCCVIsDxYsv0VNV4yJ3-o4hQ7gyt-ic6mZ_xqdNZD_c',
       465742923,
       NULL,
       1
FROM `company` c WHERE c.name = 'AYKサービス株式会社' AND NOT EXISTS (SELECT 1 FROM `company_sheet` cs WHERE cs.company_id = c.id);

INSERT OR IGNORE INTO `company_sheet` (`id`, `company_id`, `spreadsheet_id`, `gid`, `sheet_name`, `enabled`)
SELECT lower(hex(randomblob(4)) || '-' || hex(randomblob(2)) || '-4' || substr(hex(randomblob(2)),2) || '-' || substr('89ab', abs(random()) % 4 + 1, 1) || substr(hex(randomblob(2)),2) || '-' || hex(randomblob(6))),
       c.id,
       '1kDs6q2B1SgXKzYszN5tpV23CKaj8hyO6k5WGLYN1kvE',
       465742923,
       NULL,
       1
FROM `company` c WHERE c.name = '株式会社ULC' AND NOT EXISTS (SELECT 1 FROM `company_sheet` cs WHERE cs.company_id = c.id);

INSERT OR IGNORE INTO `company_sheet` (`id`, `company_id`, `spreadsheet_id`, `gid`, `sheet_name`, `enabled`)
SELECT lower(hex(randomblob(4)) || '-' || hex(randomblob(2)) || '-4' || substr(hex(randomblob(2)),2) || '-' || substr('89ab', abs(random()) % 4 + 1, 1) || substr(hex(randomblob(2)),2) || '-' || hex(randomblob(6))),
       c.id,
       '1vnPNPiaBEBR7-mbBmk8pXvYuAjyTrTDsP7GdX5ukB9k',
       465742923,
       NULL,
       1
FROM `company` c WHERE c.name = '株式会社ハーツ' AND NOT EXISTS (SELECT 1 FROM `company_sheet` cs WHERE cs.company_id = c.id);

INSERT OR IGNORE INTO `company_sheet` (`id`, `company_id`, `spreadsheet_id`, `gid`, `sheet_name`, `enabled`)
SELECT lower(hex(randomblob(4)) || '-' || hex(randomblob(2)) || '-4' || substr(hex(randomblob(2)),2) || '-' || substr('89ab', abs(random()) % 4 + 1, 1) || substr(hex(randomblob(2)),2) || '-' || hex(randomblob(6))),
       c.id,
       '1lnBf9iw-qAicp_ATetjVPaBIVz8NFGHD5gyjdloV6w0',
       465742923,
       NULL,
       1
FROM `company` c WHERE c.name = '株式会社前田営工センター' AND NOT EXISTS (SELECT 1 FROM `company_sheet` cs WHERE cs.company_id = c.id);

INSERT OR IGNORE INTO `company_sheet` (`id`, `company_id`, `spreadsheet_id`, `gid`, `sheet_name`, `enabled`)
SELECT lower(hex(randomblob(4)) || '-' || hex(randomblob(2)) || '-4' || substr(hex(randomblob(2)),2) || '-' || substr('89ab', abs(random()) % 4 + 1, 1) || substr(hex(randomblob(2)),2) || '-' || hex(randomblob(6))),
       c.id,
       '1-1DWyCMHRgmfSUNTd_xCGGSyA_g0ENHPeqZP1EVbju8',
       465742923,
       NULL,
       1
FROM `company` c WHERE c.name = '株式会社有明' AND NOT EXISTS (SELECT 1 FROM `company_sheet` cs WHERE cs.company_id = c.id);

INSERT OR IGNORE INTO `company_sheet` (`id`, `company_id`, `spreadsheet_id`, `gid`, `sheet_name`, `enabled`)
SELECT lower(hex(randomblob(4)) || '-' || hex(randomblob(2)) || '-4' || substr(hex(randomblob(2)),2) || '-' || substr('89ab', abs(random()) % 4 + 1, 1) || substr(hex(randomblob(2)),2) || '-' || hex(randomblob(6))),
       c.id,
       '1LgbrIA6oGUPA9E8QAgzL2kgQJlJ6yAzGi7KVQd8R3oQ',
       465742923,
       NULL,
       1
FROM `company` c WHERE c.name = 'ミナミ住設' AND NOT EXISTS (SELECT 1 FROM `company_sheet` cs WHERE cs.company_id = c.id);

INSERT OR IGNORE INTO `company_sheet` (`id`, `company_id`, `spreadsheet_id`, `gid`, `sheet_name`, `enabled`)
SELECT lower(hex(randomblob(4)) || '-' || hex(randomblob(2)) || '-4' || substr(hex(randomblob(2)),2) || '-' || substr('89ab', abs(random()) % 4 + 1, 1) || substr(hex(randomblob(2)),2) || '-' || hex(randomblob(6))),
       c.id,
       '1hSn-ihHRgo6sY9SWBxHjpo9aBgihgwRp_PSV4c2XmBo',
       465742923,
       NULL,
       1
FROM `company` c WHERE c.name = 'ライフコア株式会社' AND NOT EXISTS (SELECT 1 FROM `company_sheet` cs WHERE cs.company_id = c.id);

INSERT OR IGNORE INTO `company_sheet` (`id`, `company_id`, `spreadsheet_id`, `gid`, `sheet_name`, `enabled`)
SELECT lower(hex(randomblob(4)) || '-' || hex(randomblob(2)) || '-4' || substr(hex(randomblob(2)),2) || '-' || substr('89ab', abs(random()) % 4 + 1, 1) || substr(hex(randomblob(2)),2) || '-' || hex(randomblob(6))),
       c.id,
       '14zZaFjh2URJb9s4IilYILmsUwSBbf2m-B2gbo3p5XHM',
       465742923,
       NULL,
       1
FROM `company` c WHERE c.name = '株式会社エムワイジー' AND NOT EXISTS (SELECT 1 FROM `company_sheet` cs WHERE cs.company_id = c.id);

INSERT OR IGNORE INTO `company_sheet` (`id`, `company_id`, `spreadsheet_id`, `gid`, `sheet_name`, `enabled`)
SELECT lower(hex(randomblob(4)) || '-' || hex(randomblob(2)) || '-4' || substr(hex(randomblob(2)),2) || '-' || substr('89ab', abs(random()) % 4 + 1, 1) || substr(hex(randomblob(2)),2) || '-' || hex(randomblob(6))),
       c.id,
       '1PQEQG1NhZL6HY6r8QToYMe6xOe4augONxsbP_guxGvI',
       465742923,
       NULL,
       1
FROM `company` c WHERE c.name = '株式会社レックホーム' AND NOT EXISTS (SELECT 1 FROM `company_sheet` cs WHERE cs.company_id = c.id);

INSERT OR IGNORE INTO `company_sheet` (`id`, `company_id`, `spreadsheet_id`, `gid`, `sheet_name`, `enabled`)
SELECT lower(hex(randomblob(4)) || '-' || hex(randomblob(2)) || '-4' || substr(hex(randomblob(2)),2) || '-' || substr('89ab', abs(random()) % 4 + 1, 1) || substr(hex(randomblob(2)),2) || '-' || hex(randomblob(6))),
       c.id,
       '1vnPNPiaBEBR7-mbBmk8pXvYuAjyTrTDsP7GdX5ukB9k',
       465742923,
       NULL,
       1
FROM `company` c WHERE c.name = '株式会社東京ハーツ' AND NOT EXISTS (SELECT 1 FROM `company_sheet` cs WHERE cs.company_id = c.id);

INSERT OR IGNORE INTO `company_sheet` (`id`, `company_id`, `spreadsheet_id`, `gid`, `sheet_name`, `enabled`)
SELECT lower(hex(randomblob(4)) || '-' || hex(randomblob(2)) || '-4' || substr(hex(randomblob(2)),2) || '-' || substr('89ab', abs(random()) % 4 + 1, 1) || substr(hex(randomblob(2)),2) || '-' || hex(randomblob(6))),
       c.id,
       '1MTL76bmjOlBAdQ-AcBk7tJkIlMip_X5apfmzQ6nF6xA',
       465742923,
       NULL,
       1
FROM `company` c WHERE c.name = '西新町二丁目クリニック' AND NOT EXISTS (SELECT 1 FROM `company_sheet` cs WHERE cs.company_id = c.id);

INSERT OR IGNORE INTO `company_sheet` (`id`, `company_id`, `spreadsheet_id`, `gid`, `sheet_name`, `enabled`)
SELECT lower(hex(randomblob(4)) || '-' || hex(randomblob(2)) || '-4' || substr(hex(randomblob(2)),2) || '-' || substr('89ab', abs(random()) % 4 + 1, 1) || substr(hex(randomblob(2)),2) || '-' || hex(randomblob(6))),
       c.id,
       '1_t1zLBmwOBJ48ySObioIxSlwOYyVmsYaxSiIQF6DJkE',
       465742923,
       NULL,
       1
FROM `company` c WHERE c.name = 'ウェルネス・コーチ（エニタイム）' AND NOT EXISTS (SELECT 1 FROM `company_sheet` cs WHERE cs.company_id = c.id);

INSERT OR IGNORE INTO `company_sheet` (`id`, `company_id`, `spreadsheet_id`, `gid`, `sheet_name`, `enabled`)
SELECT lower(hex(randomblob(4)) || '-' || hex(randomblob(2)) || '-4' || substr(hex(randomblob(2)),2) || '-' || substr('89ab', abs(random()) % 4 + 1, 1) || substr(hex(randomblob(2)),2) || '-' || hex(randomblob(6))),
       c.id,
       '1svT2wawOkPTilKGeTiB4fCtRw4EMuJwF_gWuLTAhpck',
       465742923,
       NULL,
       1
FROM `company` c WHERE c.name = '株式会社SHINYUU' AND NOT EXISTS (SELECT 1 FROM `company_sheet` cs WHERE cs.company_id = c.id);

INSERT OR IGNORE INTO `company_sheet` (`id`, `company_id`, `spreadsheet_id`, `gid`, `sheet_name`, `enabled`)
SELECT lower(hex(randomblob(4)) || '-' || hex(randomblob(2)) || '-4' || substr(hex(randomblob(2)),2) || '-' || substr('89ab', abs(random()) % 4 + 1, 1) || substr(hex(randomblob(2)),2) || '-' || hex(randomblob(6))),
       c.id,
       '1ItZ4uTDJwRfSMihUUcVRc9KLGMN7vldDnp8NWSUJ7KE',
       465742923,
       NULL,
       1
FROM `company` c WHERE c.name = '株式会社アースデザイン' AND NOT EXISTS (SELECT 1 FROM `company_sheet` cs WHERE cs.company_id = c.id);

INSERT OR IGNORE INTO `company_sheet` (`id`, `company_id`, `spreadsheet_id`, `gid`, `sheet_name`, `enabled`)
SELECT lower(hex(randomblob(4)) || '-' || hex(randomblob(2)) || '-4' || substr(hex(randomblob(2)),2) || '-' || substr('89ab', abs(random()) % 4 + 1, 1) || substr(hex(randomblob(2)),2) || '-' || hex(randomblob(6))),
       c.id,
       '1VID7MYQRePbmDLwCfO-NSjCWuqd_hXtKQBJNSwjOQyA',
       465742923,
       NULL,
       1
FROM `company` c WHERE c.name = 'エース建設' AND NOT EXISTS (SELECT 1 FROM `company_sheet` cs WHERE cs.company_id = c.id);

INSERT OR IGNORE INTO `company_sheet` (`id`, `company_id`, `spreadsheet_id`, `gid`, `sheet_name`, `enabled`)
SELECT lower(hex(randomblob(4)) || '-' || hex(randomblob(2)) || '-4' || substr(hex(randomblob(2)),2) || '-' || substr('89ab', abs(random()) % 4 + 1, 1) || substr(hex(randomblob(2)),2) || '-' || hex(randomblob(6))),
       c.id,
       '1DqtfrVYNIk6x0xrIU7-OLHApOyZqMGplvm1gCDoXPvw',
       465742923,
       NULL,
       1
FROM `company` c WHERE c.name = 'OG建設' AND NOT EXISTS (SELECT 1 FROM `company_sheet` cs WHERE cs.company_id = c.id);

INSERT OR IGNORE INTO `company_sheet` (`id`, `company_id`, `spreadsheet_id`, `gid`, `sheet_name`, `enabled`)
SELECT lower(hex(randomblob(4)) || '-' || hex(randomblob(2)) || '-4' || substr(hex(randomblob(2)),2) || '-' || substr('89ab', abs(random()) % 4 + 1, 1) || substr(hex(randomblob(2)),2) || '-' || hex(randomblob(6))),
       c.id,
       '15_8pWdEmCZF4MIX4AmF-3KQXtXfnphpaALmvgdLasBw',
       465742923,
       NULL,
       1
FROM `company` c WHERE c.name = '仁美工業' AND NOT EXISTS (SELECT 1 FROM `company_sheet` cs WHERE cs.company_id = c.id);

INSERT OR IGNORE INTO `company_sheet` (`id`, `company_id`, `spreadsheet_id`, `gid`, `sheet_name`, `enabled`)
SELECT lower(hex(randomblob(4)) || '-' || hex(randomblob(2)) || '-4' || substr(hex(randomblob(2)),2) || '-' || substr('89ab', abs(random()) % 4 + 1, 1) || substr(hex(randomblob(2)),2) || '-' || hex(randomblob(6))),
       c.id,
       '1QN2XzsVWcilQ0Cstm-Pg5HYv09b55uUKv0ZVilpdoCU',
       465742923,
       NULL,
       1
FROM `company` c WHERE c.name = '株式会社オルグージョジャパン' AND NOT EXISTS (SELECT 1 FROM `company_sheet` cs WHERE cs.company_id = c.id);

INSERT OR IGNORE INTO `company_sheet` (`id`, `company_id`, `spreadsheet_id`, `gid`, `sheet_name`, `enabled`)
SELECT lower(hex(randomblob(4)) || '-' || hex(randomblob(2)) || '-4' || substr(hex(randomblob(2)),2) || '-' || substr('89ab', abs(random()) % 4 + 1, 1) || substr(hex(randomblob(2)),2) || '-' || hex(randomblob(6))),
       c.id,
       '1ruFJltIrt_QoH_ooAuDKV0mnpf6KFP6cwgrgi-EOMf4',
       465742923,
       NULL,
       1
FROM `company` c WHERE c.name = '株式会社太田不動産' AND NOT EXISTS (SELECT 1 FROM `company_sheet` cs WHERE cs.company_id = c.id);

INSERT OR IGNORE INTO `company_sheet` (`id`, `company_id`, `spreadsheet_id`, `gid`, `sheet_name`, `enabled`)
SELECT lower(hex(randomblob(4)) || '-' || hex(randomblob(2)) || '-4' || substr(hex(randomblob(2)),2) || '-' || substr('89ab', abs(random()) % 4 + 1, 1) || substr(hex(randomblob(2)),2) || '-' || hex(randomblob(6))),
       c.id,
       '1aL2AN8TQY38VAvgNhzZA1UmJ20lQ5JY5liZwBpTeU_Y',
       465742923,
       NULL,
       1
FROM `company` c WHERE c.name = '株式会社大豊工業所' AND NOT EXISTS (SELECT 1 FROM `company_sheet` cs WHERE cs.company_id = c.id);

INSERT OR IGNORE INTO `company_sheet` (`id`, `company_id`, `spreadsheet_id`, `gid`, `sheet_name`, `enabled`)
SELECT lower(hex(randomblob(4)) || '-' || hex(randomblob(2)) || '-4' || substr(hex(randomblob(2)),2) || '-' || substr('89ab', abs(random()) % 4 + 1, 1) || substr(hex(randomblob(2)),2) || '-' || hex(randomblob(6))),
       c.id,
       '1qSkYWmKoLmwT2lIYDF_8HBEAfaD1KeTqqpKlOJLompI',
       465742923,
       NULL,
       1
FROM `company` c WHERE c.name = '株式会社大雄工業' AND NOT EXISTS (SELECT 1 FROM `company_sheet` cs WHERE cs.company_id = c.id);

INSERT OR IGNORE INTO `company_sheet` (`id`, `company_id`, `spreadsheet_id`, `gid`, `sheet_name`, `enabled`)
SELECT lower(hex(randomblob(4)) || '-' || hex(randomblob(2)) || '-4' || substr(hex(randomblob(2)),2) || '-' || substr('89ab', abs(random()) % 4 + 1, 1) || substr(hex(randomblob(2)),2) || '-' || hex(randomblob(6))),
       c.id,
       '1baWrUIfKt9LytQlJmJL7W8Hft9hA-PDyd-pVgNFdMXw',
       465742923,
       NULL,
       1
FROM `company` c WHERE c.name = '株式会社徳信商会（高石）' AND NOT EXISTS (SELECT 1 FROM `company_sheet` cs WHERE cs.company_id = c.id);

INSERT OR IGNORE INTO `company_sheet` (`id`, `company_id`, `spreadsheet_id`, `gid`, `sheet_name`, `enabled`)
SELECT lower(hex(randomblob(4)) || '-' || hex(randomblob(2)) || '-4' || substr(hex(randomblob(2)),2) || '-' || substr('89ab', abs(random()) % 4 + 1, 1) || substr(hex(randomblob(2)),2) || '-' || hex(randomblob(6))),
       c.id,
       '1yE31V0Y4OT9mM-8cc1y5YiK5PwjD5t4b1ERD6hLVpXw',
       465742923,
       NULL,
       1
FROM `company` c WHERE c.name = '株式会社北野田ガスセンター' AND NOT EXISTS (SELECT 1 FROM `company_sheet` cs WHERE cs.company_id = c.id);

INSERT OR IGNORE INTO `company_sheet` (`id`, `company_id`, `spreadsheet_id`, `gid`, `sheet_name`, `enabled`)
SELECT lower(hex(randomblob(4)) || '-' || hex(randomblob(2)) || '-4' || substr(hex(randomblob(2)),2) || '-' || substr('89ab', abs(random()) % 4 + 1, 1) || substr(hex(randomblob(2)),2) || '-' || hex(randomblob(6))),
       c.id,
       '1SBMnQqcohUXxnMYitVqXJneyMI74eDvqFdeyYBKwJlw',
       465742923,
       NULL,
       1
FROM `company` c WHERE c.name = '株式会社Uca' AND NOT EXISTS (SELECT 1 FROM `company_sheet` cs WHERE cs.company_id = c.id);
