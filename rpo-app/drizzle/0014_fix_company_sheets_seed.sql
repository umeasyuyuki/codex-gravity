-- Step 2: Insert missing company_sheet records
-- All use FROM company c WHERE c.id = '...' pattern for D1 compatibility

-- 株式会社大阪機器工作所
INSERT OR IGNORE INTO `company_sheet` (`id`, `company_id`, `spreadsheet_id`, `gid`, `sheet_name`, `enabled`)
SELECT lower(hex(randomblob(4)) || '-' || hex(randomblob(2)) || '-4' || substr(hex(randomblob(2)),2) || '-' || substr('89ab', abs(random()) % 4 + 1, 1) || substr(hex(randomblob(2)),2) || '-' || hex(randomblob(6))),
       c.id, '1eVO3Ix9o08M17w87wOdJiOLfd668oEXjfKbpcnmm-J0', 465742923, NULL, 1
FROM `company` c WHERE c.id = 'fc3c788e-bac3-4591-84fa-d23b3efb4a1b' AND NOT EXISTS (SELECT 1 FROM `company_sheet` cs WHERE cs.company_id = c.id);

-- TKC株式会社
INSERT OR IGNORE INTO `company_sheet` (`id`, `company_id`, `spreadsheet_id`, `gid`, `sheet_name`, `enabled`)
SELECT lower(hex(randomblob(4)) || '-' || hex(randomblob(2)) || '-4' || substr(hex(randomblob(2)),2) || '-' || substr('89ab', abs(random()) % 4 + 1, 1) || substr(hex(randomblob(2)),2) || '-' || hex(randomblob(6))),
       c.id, '1paHNHLJjBxBIgbY1ki7IoocqKBKpFGmlDvT4ormpOl4', 465742923, NULL, 1
FROM `company` c WHERE c.id = 'e48d8668-8aaf-422e-b7d3-b2b85b7bd906' AND NOT EXISTS (SELECT 1 FROM `company_sheet` cs WHERE cs.company_id = c.id);

-- TKC株式会社 自動アプローチからの応募者
INSERT OR IGNORE INTO `company_sheet` (`id`, `company_id`, `spreadsheet_id`, `gid`, `sheet_name`, `enabled`)
SELECT lower(hex(randomblob(4)) || '-' || hex(randomblob(2)) || '-4' || substr(hex(randomblob(2)),2) || '-' || substr('89ab', abs(random()) % 4 + 1, 1) || substr(hex(randomblob(2)),2) || '-' || hex(randomblob(6))),
       c.id, '1paHNHLJjBxBIgbY1ki7IoocqKBKpFGmlDvT4ormpOl4', 465742923, NULL, 1
FROM `company` c WHERE c.id = '2e8457a4-41fb-4a15-8d19-492c763e359f' AND NOT EXISTS (SELECT 1 FROM `company_sheet` cs WHERE cs.company_id = c.id);

-- TKC株式会社（関西プロスタッフ）
INSERT OR IGNORE INTO `company_sheet` (`id`, `company_id`, `spreadsheet_id`, `gid`, `sheet_name`, `enabled`)
SELECT lower(hex(randomblob(4)) || '-' || hex(randomblob(2)) || '-4' || substr(hex(randomblob(2)),2) || '-' || substr('89ab', abs(random()) % 4 + 1, 1) || substr(hex(randomblob(2)),2) || '-' || hex(randomblob(6))),
       c.id, '1paHNHLJjBxBIgbY1ki7IoocqKBKpFGmlDvT4ormpOl4', 465742923, NULL, 1
FROM `company` c WHERE c.id = 'ec413de7-9681-43b0-947e-b76c106c39f4' AND NOT EXISTS (SELECT 1 FROM `company_sheet` cs WHERE cs.company_id = c.id);

-- YMD株式会社
INSERT OR IGNORE INTO `company_sheet` (`id`, `company_id`, `spreadsheet_id`, `gid`, `sheet_name`, `enabled`)
SELECT lower(hex(randomblob(4)) || '-' || hex(randomblob(2)) || '-4' || substr(hex(randomblob(2)),2) || '-' || substr('89ab', abs(random()) % 4 + 1, 1) || substr(hex(randomblob(2)),2) || '-' || hex(randomblob(6))),
       c.id, '1paHNHLJjBxBIgbY1ki7IoocqKBKpFGmlDvT4ormpOl4', 465742923, NULL, 1
FROM `company` c WHERE c.id = '1d71000d-6895-4c26-ae91-86337a780ceb' AND NOT EXISTS (SELECT 1 FROM `company_sheet` cs WHERE cs.company_id = c.id);

-- 株式会社ミナミ住設
INSERT OR IGNORE INTO `company_sheet` (`id`, `company_id`, `spreadsheet_id`, `gid`, `sheet_name`, `enabled`)
SELECT lower(hex(randomblob(4)) || '-' || hex(randomblob(2)) || '-4' || substr(hex(randomblob(2)),2) || '-' || substr('89ab', abs(random()) % 4 + 1, 1) || substr(hex(randomblob(2)),2) || '-' || hex(randomblob(6))),
       c.id, '1LgbrIA6oGUPA9E8QAgzL2kgQJlJ6yAzGi7KVQd8R3oQ', 465742923, NULL, 1
FROM `company` c WHERE c.id = '0152ba19-4474-4aa9-8f99-471949a3b27f' AND NOT EXISTS (SELECT 1 FROM `company_sheet` cs WHERE cs.company_id = c.id);

-- 株式会社エム・ワイ・ジー（大阪ガスサービスショップ）
INSERT OR IGNORE INTO `company_sheet` (`id`, `company_id`, `spreadsheet_id`, `gid`, `sheet_name`, `enabled`)
SELECT lower(hex(randomblob(4)) || '-' || hex(randomblob(2)) || '-4' || substr(hex(randomblob(2)),2) || '-' || substr('89ab', abs(random()) % 4 + 1, 1) || substr(hex(randomblob(2)),2) || '-' || hex(randomblob(6))),
       c.id, '14zZaFjh2URJb9s4IilYILmsUwSBbf2m-B2gbo3p5XHM', 465742923, NULL, 1
FROM `company` c WHERE c.id = '3514c87e-bb22-4d4b-affc-b7c6313853c9' AND NOT EXISTS (SELECT 1 FROM `company_sheet` cs WHERE cs.company_id = c.id);

-- 株式会社ハーツ堺支店
INSERT OR IGNORE INTO `company_sheet` (`id`, `company_id`, `spreadsheet_id`, `gid`, `sheet_name`, `enabled`)
SELECT lower(hex(randomblob(4)) || '-' || hex(randomblob(2)) || '-4' || substr(hex(randomblob(2)),2) || '-' || substr('89ab', abs(random()) % 4 + 1, 1) || substr(hex(randomblob(2)),2) || '-' || hex(randomblob(6))),
       c.id, '1vnPNPiaBEBR7-mbBmk8pXvYuAjyTrTDsP7GdX5ukB9k', 465742923, NULL, 1
FROM `company` c WHERE c.id = '6f64c1b3-5a04-46ea-a5a3-b212c275b3b2' AND NOT EXISTS (SELECT 1 FROM `company_sheet` cs WHERE cs.company_id = c.id);

-- 株式会社ハーツ羽曳野支店
INSERT OR IGNORE INTO `company_sheet` (`id`, `company_id`, `spreadsheet_id`, `gid`, `sheet_name`, `enabled`)
SELECT lower(hex(randomblob(4)) || '-' || hex(randomblob(2)) || '-4' || substr(hex(randomblob(2)),2) || '-' || substr('89ab', abs(random()) % 4 + 1, 1) || substr(hex(randomblob(2)),2) || '-' || hex(randomblob(6))),
       c.id, '1vnPNPiaBEBR7-mbBmk8pXvYuAjyTrTDsP7GdX5ukB9k', 465742923, NULL, 1
FROM `company` c WHERE c.id = 'e1e48283-2a94-4b8b-8aba-b750ab6b0dca' AND NOT EXISTS (SELECT 1 FROM `company_sheet` cs WHERE cs.company_id = c.id);

-- 東京ハーツ (without 株式会社 prefix)
INSERT OR IGNORE INTO `company_sheet` (`id`, `company_id`, `spreadsheet_id`, `gid`, `sheet_name`, `enabled`)
SELECT lower(hex(randomblob(4)) || '-' || hex(randomblob(2)) || '-4' || substr(hex(randomblob(2)),2) || '-' || substr('89ab', abs(random()) % 4 + 1, 1) || substr(hex(randomblob(2)),2) || '-' || hex(randomblob(6))),
       c.id, '1vnPNPiaBEBR7-mbBmk8pXvYuAjyTrTDsP7GdX5ukB9k', 465742923, NULL, 1
FROM `company` c WHERE c.id = '385a6a52-75fc-42de-88d2-1c9773273a0b' AND NOT EXISTS (SELECT 1 FROM `company_sheet` cs WHERE cs.company_id = c.id);

-- エース建設株式会社
INSERT OR IGNORE INTO `company_sheet` (`id`, `company_id`, `spreadsheet_id`, `gid`, `sheet_name`, `enabled`)
SELECT lower(hex(randomblob(4)) || '-' || hex(randomblob(2)) || '-4' || substr(hex(randomblob(2)),2) || '-' || substr('89ab', abs(random()) % 4 + 1, 1) || substr(hex(randomblob(2)),2) || '-' || hex(randomblob(6))),
       c.id, '1VID7MYQRePbmDLwCfO-NSjCWuqd_hXtKQBJNSwjOQyA', 465742923, NULL, 1
FROM `company` c WHERE c.id = 'b284b38c-de26-4d17-a7a0-80559daf68a2' AND NOT EXISTS (SELECT 1 FROM `company_sheet` cs WHERE cs.company_id = c.id);

-- ＯＧ建設株式会社
INSERT OR IGNORE INTO `company_sheet` (`id`, `company_id`, `spreadsheet_id`, `gid`, `sheet_name`, `enabled`)
SELECT lower(hex(randomblob(4)) || '-' || hex(randomblob(2)) || '-4' || substr(hex(randomblob(2)),2) || '-' || substr('89ab', abs(random()) % 4 + 1, 1) || substr(hex(randomblob(2)),2) || '-' || hex(randomblob(6))),
       c.id, '1DqtfrVYNIk6x0xrIU7-OLHApOyZqMGplvm1gCDoXPvw', 465742923, NULL, 1
FROM `company` c WHERE c.id = 'c32f1299-dc82-46d4-a570-546de7fdb29e' AND NOT EXISTS (SELECT 1 FROM `company_sheet` cs WHERE cs.company_id = c.id);

-- 仁美工業株式会社
INSERT OR IGNORE INTO `company_sheet` (`id`, `company_id`, `spreadsheet_id`, `gid`, `sheet_name`, `enabled`)
SELECT lower(hex(randomblob(4)) || '-' || hex(randomblob(2)) || '-4' || substr(hex(randomblob(2)),2) || '-' || substr('89ab', abs(random()) % 4 + 1, 1) || substr(hex(randomblob(2)),2) || '-' || hex(randomblob(6))),
       c.id, '15_8pWdEmCZF4MIX4AmF-3KQXtXfnphpaALmvgdLasBw', 465742923, NULL, 1
FROM `company` c WHERE c.id = '1acbb9c8-5730-4f1a-b62b-32b4bae0cd05' AND NOT EXISTS (SELECT 1 FROM `company_sheet` cs WHERE cs.company_id = c.id);

-- 株式会社オルグージョ・ジャパン
INSERT OR IGNORE INTO `company_sheet` (`id`, `company_id`, `spreadsheet_id`, `gid`, `sheet_name`, `enabled`)
SELECT lower(hex(randomblob(4)) || '-' || hex(randomblob(2)) || '-4' || substr(hex(randomblob(2)),2) || '-' || substr('89ab', abs(random()) % 4 + 1, 1) || substr(hex(randomblob(2)),2) || '-' || hex(randomblob(6))),
       c.id, '1QN2XzsVWcilQ0Cstm-Pg5HYv09b55uUKv0ZVilpdoCU', 465742923, NULL, 1
FROM `company` c WHERE c.id = '12bc7020-f60a-447e-bfe7-f7ca091744fc' AND NOT EXISTS (SELECT 1 FROM `company_sheet` cs WHERE cs.company_id = c.id);

-- 株式会社 大雄工業
INSERT OR IGNORE INTO `company_sheet` (`id`, `company_id`, `spreadsheet_id`, `gid`, `sheet_name`, `enabled`)
SELECT lower(hex(randomblob(4)) || '-' || hex(randomblob(2)) || '-4' || substr(hex(randomblob(2)),2) || '-' || substr('89ab', abs(random()) % 4 + 1, 1) || substr(hex(randomblob(2)),2) || '-' || hex(randomblob(6))),
       c.id, '1qSkYWmKoLmwT2lIYDF_8HBEAfaD1KeTqqpKlOJLompI', 465742923, NULL, 1
FROM `company` c WHERE c.id = '00b29fa9-17b9-444b-bb63-c5e92132f95e' AND NOT EXISTS (SELECT 1 FROM `company_sheet` cs WHERE cs.company_id = c.id);

-- 株式会社 徳信商会
INSERT OR IGNORE INTO `company_sheet` (`id`, `company_id`, `spreadsheet_id`, `gid`, `sheet_name`, `enabled`)
SELECT lower(hex(randomblob(4)) || '-' || hex(randomblob(2)) || '-4' || substr(hex(randomblob(2)),2) || '-' || substr('89ab', abs(random()) % 4 + 1, 1) || substr(hex(randomblob(2)),2) || '-' || hex(randomblob(6))),
       c.id, '1baWrUIfKt9LytQlJmJL7W8Hft9hA-PDyd-pVgNFdMXw', 465742923, NULL, 1
FROM `company` c WHERE c.id = '85813c88-0f49-469b-a191-7c31cd5f9445' AND NOT EXISTS (SELECT 1 FROM `company_sheet` cs WHERE cs.company_id = c.id);

-- 株式会社 北野田ガスセンター
INSERT OR IGNORE INTO `company_sheet` (`id`, `company_id`, `spreadsheet_id`, `gid`, `sheet_name`, `enabled`)
SELECT lower(hex(randomblob(4)) || '-' || hex(randomblob(2)) || '-4' || substr(hex(randomblob(2)),2) || '-' || substr('89ab', abs(random()) % 4 + 1, 1) || substr(hex(randomblob(2)),2) || '-' || hex(randomblob(6))),
       c.id, '1yE31V0Y4OT9mM-8cc1y5YiK5PwjD5t4b1ERD6hLVpXw', 465742923, NULL, 1
FROM `company` c WHERE c.id = '34784a73-5385-45fd-b673-e4ecf3dd9b03' AND NOT EXISTS (SELECT 1 FROM `company_sheet` cs WHERE cs.company_id = c.id);

-- 株式会社有明 自動アプローチからの応募者
INSERT OR IGNORE INTO `company_sheet` (`id`, `company_id`, `spreadsheet_id`, `gid`, `sheet_name`, `enabled`)
SELECT lower(hex(randomblob(4)) || '-' || hex(randomblob(2)) || '-4' || substr(hex(randomblob(2)),2) || '-' || substr('89ab', abs(random()) % 4 + 1, 1) || substr(hex(randomblob(2)),2) || '-' || hex(randomblob(6))),
       c.id, '1-1DWyCMHRgmfSUNTd_xCGGSyA_g0ENHPeqZP1EVbju8', 465742923, NULL, 1
FROM `company` c WHERE c.id = '4e5eff07-d2a6-46ec-b618-dc157469dfe7' AND NOT EXISTS (SELECT 1 FROM `company_sheet` cs WHERE cs.company_id = c.id);

-- New companies (use SELECT by name)

-- 株式会社ULC
INSERT OR IGNORE INTO `company_sheet` (`id`, `company_id`, `spreadsheet_id`, `gid`, `sheet_name`, `enabled`)
SELECT lower(hex(randomblob(4)) || '-' || hex(randomblob(2)) || '-4' || substr(hex(randomblob(2)),2) || '-' || substr('89ab', abs(random()) % 4 + 1, 1) || substr(hex(randomblob(2)),2) || '-' || hex(randomblob(6))),
       c.id, '1kDs6q2B1SgXKzYszN5tpV23CKaj8hyO6k5WGLYN1kvE', 465742923, NULL, 1
FROM `company` c WHERE c.name = '株式会社ULC' AND NOT EXISTS (SELECT 1 FROM `company_sheet` cs WHERE cs.company_id = c.id);

-- ライフコア株式会社
INSERT OR IGNORE INTO `company_sheet` (`id`, `company_id`, `spreadsheet_id`, `gid`, `sheet_name`, `enabled`)
SELECT lower(hex(randomblob(4)) || '-' || hex(randomblob(2)) || '-4' || substr(hex(randomblob(2)),2) || '-' || substr('89ab', abs(random()) % 4 + 1, 1) || substr(hex(randomblob(2)),2) || '-' || hex(randomblob(6))),
       c.id, '1hSn-ihHRgo6sY9SWBxHjpo9aBgihgwRp_PSV4c2XmBo', 465742923, NULL, 1
FROM `company` c WHERE c.name = 'ライフコア株式会社' AND NOT EXISTS (SELECT 1 FROM `company_sheet` cs WHERE cs.company_id = c.id);

-- 株式会社レックホーム
INSERT OR IGNORE INTO `company_sheet` (`id`, `company_id`, `spreadsheet_id`, `gid`, `sheet_name`, `enabled`)
SELECT lower(hex(randomblob(4)) || '-' || hex(randomblob(2)) || '-4' || substr(hex(randomblob(2)),2) || '-' || substr('89ab', abs(random()) % 4 + 1, 1) || substr(hex(randomblob(2)),2) || '-' || hex(randomblob(6))),
       c.id, '1PQEQG1NhZL6HY6r8QToYMe6xOe4augONxsbP_guxGvI', 465742923, NULL, 1
FROM `company` c WHERE c.name = '株式会社レックホーム' AND NOT EXISTS (SELECT 1 FROM `company_sheet` cs WHERE cs.company_id = c.id);

-- 西新町二丁目クリニック
INSERT OR IGNORE INTO `company_sheet` (`id`, `company_id`, `spreadsheet_id`, `gid`, `sheet_name`, `enabled`)
SELECT lower(hex(randomblob(4)) || '-' || hex(randomblob(2)) || '-4' || substr(hex(randomblob(2)),2) || '-' || substr('89ab', abs(random()) % 4 + 1, 1) || substr(hex(randomblob(2)),2) || '-' || hex(randomblob(6))),
       c.id, '1MTL76bmjOlBAdQ-AcBk7tJkIlMip_X5apfmzQ6nF6xA', 465742923, NULL, 1
FROM `company` c WHERE c.name = '西新町二丁目クリニック' AND NOT EXISTS (SELECT 1 FROM `company_sheet` cs WHERE cs.company_id = c.id);

-- エニタイムフィットネス全店舗 → same spreadsheet

INSERT OR IGNORE INTO `company_sheet` (`id`, `company_id`, `spreadsheet_id`, `gid`, `sheet_name`, `enabled`)
SELECT lower(hex(randomblob(4)) || '-' || hex(randomblob(2)) || '-4' || substr(hex(randomblob(2)),2) || '-' || substr('89ab', abs(random()) % 4 + 1, 1) || substr(hex(randomblob(2)),2) || '-' || hex(randomblob(6))),
       c.id, '1_t1zLBmwOBJ48ySObioIxSlwOYyVmsYaxSiIQF6DJkE', 465742923, NULL, 1
FROM `company` c WHERE c.id = 'c36386c8-0463-45ee-9b54-dcb39b8653a3' AND NOT EXISTS (SELECT 1 FROM `company_sheet` cs WHERE cs.company_id = c.id);

INSERT OR IGNORE INTO `company_sheet` (`id`, `company_id`, `spreadsheet_id`, `gid`, `sheet_name`, `enabled`)
SELECT lower(hex(randomblob(4)) || '-' || hex(randomblob(2)) || '-4' || substr(hex(randomblob(2)),2) || '-' || substr('89ab', abs(random()) % 4 + 1, 1) || substr(hex(randomblob(2)),2) || '-' || hex(randomblob(6))),
       c.id, '1_t1zLBmwOBJ48ySObioIxSlwOYyVmsYaxSiIQF6DJkE', 465742923, NULL, 1
FROM `company` c WHERE c.id = '47520fda-cfdb-4c48-95b4-4ca726e52c96' AND NOT EXISTS (SELECT 1 FROM `company_sheet` cs WHERE cs.company_id = c.id);

INSERT OR IGNORE INTO `company_sheet` (`id`, `company_id`, `spreadsheet_id`, `gid`, `sheet_name`, `enabled`)
SELECT lower(hex(randomblob(4)) || '-' || hex(randomblob(2)) || '-4' || substr(hex(randomblob(2)),2) || '-' || substr('89ab', abs(random()) % 4 + 1, 1) || substr(hex(randomblob(2)),2) || '-' || hex(randomblob(6))),
       c.id, '1_t1zLBmwOBJ48ySObioIxSlwOYyVmsYaxSiIQF6DJkE', 465742923, NULL, 1
FROM `company` c WHERE c.id = '04bc254a-0741-475b-b0b8-940e678deced' AND NOT EXISTS (SELECT 1 FROM `company_sheet` cs WHERE cs.company_id = c.id);

INSERT OR IGNORE INTO `company_sheet` (`id`, `company_id`, `spreadsheet_id`, `gid`, `sheet_name`, `enabled`)
SELECT lower(hex(randomblob(4)) || '-' || hex(randomblob(2)) || '-4' || substr(hex(randomblob(2)),2) || '-' || substr('89ab', abs(random()) % 4 + 1, 1) || substr(hex(randomblob(2)),2) || '-' || hex(randomblob(6))),
       c.id, '1_t1zLBmwOBJ48ySObioIxSlwOYyVmsYaxSiIQF6DJkE', 465742923, NULL, 1
FROM `company` c WHERE c.id = 'da83755b-de63-4d18-b84d-659b2b362dac' AND NOT EXISTS (SELECT 1 FROM `company_sheet` cs WHERE cs.company_id = c.id);

INSERT OR IGNORE INTO `company_sheet` (`id`, `company_id`, `spreadsheet_id`, `gid`, `sheet_name`, `enabled`)
SELECT lower(hex(randomblob(4)) || '-' || hex(randomblob(2)) || '-4' || substr(hex(randomblob(2)),2) || '-' || substr('89ab', abs(random()) % 4 + 1, 1) || substr(hex(randomblob(2)),2) || '-' || hex(randomblob(6))),
       c.id, '1_t1zLBmwOBJ48ySObioIxSlwOYyVmsYaxSiIQF6DJkE', 465742923, NULL, 1
FROM `company` c WHERE c.id = 'e4ff302a-0c0a-4757-b3a2-e58c50edf5e3' AND NOT EXISTS (SELECT 1 FROM `company_sheet` cs WHERE cs.company_id = c.id);

INSERT OR IGNORE INTO `company_sheet` (`id`, `company_id`, `spreadsheet_id`, `gid`, `sheet_name`, `enabled`)
SELECT lower(hex(randomblob(4)) || '-' || hex(randomblob(2)) || '-4' || substr(hex(randomblob(2)),2) || '-' || substr('89ab', abs(random()) % 4 + 1, 1) || substr(hex(randomblob(2)),2) || '-' || hex(randomblob(6))),
       c.id, '1_t1zLBmwOBJ48ySObioIxSlwOYyVmsYaxSiIQF6DJkE', 465742923, NULL, 1
FROM `company` c WHERE c.id = 'b3fa70b9-baf2-4024-a093-96c50548f3a8' AND NOT EXISTS (SELECT 1 FROM `company_sheet` cs WHERE cs.company_id = c.id);

INSERT OR IGNORE INTO `company_sheet` (`id`, `company_id`, `spreadsheet_id`, `gid`, `sheet_name`, `enabled`)
SELECT lower(hex(randomblob(4)) || '-' || hex(randomblob(2)) || '-4' || substr(hex(randomblob(2)),2) || '-' || substr('89ab', abs(random()) % 4 + 1, 1) || substr(hex(randomblob(2)),2) || '-' || hex(randomblob(6))),
       c.id, '1_t1zLBmwOBJ48ySObioIxSlwOYyVmsYaxSiIQF6DJkE', 465742923, NULL, 1
FROM `company` c WHERE c.id = 'afb166ff-55c3-4de3-be60-400e3d103e75' AND NOT EXISTS (SELECT 1 FROM `company_sheet` cs WHERE cs.company_id = c.id);

INSERT OR IGNORE INTO `company_sheet` (`id`, `company_id`, `spreadsheet_id`, `gid`, `sheet_name`, `enabled`)
SELECT lower(hex(randomblob(4)) || '-' || hex(randomblob(2)) || '-4' || substr(hex(randomblob(2)),2) || '-' || substr('89ab', abs(random()) % 4 + 1, 1) || substr(hex(randomblob(2)),2) || '-' || hex(randomblob(6))),
       c.id, '1_t1zLBmwOBJ48ySObioIxSlwOYyVmsYaxSiIQF6DJkE', 465742923, NULL, 1
FROM `company` c WHERE c.id = 'aadc859f-9399-4558-85f3-c32ddb197fa0' AND NOT EXISTS (SELECT 1 FROM `company_sheet` cs WHERE cs.company_id = c.id);

INSERT OR IGNORE INTO `company_sheet` (`id`, `company_id`, `spreadsheet_id`, `gid`, `sheet_name`, `enabled`)
SELECT lower(hex(randomblob(4)) || '-' || hex(randomblob(2)) || '-4' || substr(hex(randomblob(2)),2) || '-' || substr('89ab', abs(random()) % 4 + 1, 1) || substr(hex(randomblob(2)),2) || '-' || hex(randomblob(6))),
       c.id, '1_t1zLBmwOBJ48ySObioIxSlwOYyVmsYaxSiIQF6DJkE', 465742923, NULL, 1
FROM `company` c WHERE c.id = '053616a7-5b54-49f9-9405-b8b2cf716756' AND NOT EXISTS (SELECT 1 FROM `company_sheet` cs WHERE cs.company_id = c.id);

INSERT OR IGNORE INTO `company_sheet` (`id`, `company_id`, `spreadsheet_id`, `gid`, `sheet_name`, `enabled`)
SELECT lower(hex(randomblob(4)) || '-' || hex(randomblob(2)) || '-4' || substr(hex(randomblob(2)),2) || '-' || substr('89ab', abs(random()) % 4 + 1, 1) || substr(hex(randomblob(2)),2) || '-' || hex(randomblob(6))),
       c.id, '1_t1zLBmwOBJ48ySObioIxSlwOYyVmsYaxSiIQF6DJkE', 465742923, NULL, 1
FROM `company` c WHERE c.id = 'cc2d3af7-f432-4efa-81e5-21fbb3a0ad1a' AND NOT EXISTS (SELECT 1 FROM `company_sheet` cs WHERE cs.company_id = c.id);

INSERT OR IGNORE INTO `company_sheet` (`id`, `company_id`, `spreadsheet_id`, `gid`, `sheet_name`, `enabled`)
SELECT lower(hex(randomblob(4)) || '-' || hex(randomblob(2)) || '-4' || substr(hex(randomblob(2)),2) || '-' || substr('89ab', abs(random()) % 4 + 1, 1) || substr(hex(randomblob(2)),2) || '-' || hex(randomblob(6))),
       c.id, '1_t1zLBmwOBJ48ySObioIxSlwOYyVmsYaxSiIQF6DJkE', 465742923, NULL, 1
FROM `company` c WHERE c.id = '016e104d-f1ad-44a9-8c59-06933c3aac31' AND NOT EXISTS (SELECT 1 FROM `company_sheet` cs WHERE cs.company_id = c.id);

INSERT OR IGNORE INTO `company_sheet` (`id`, `company_id`, `spreadsheet_id`, `gid`, `sheet_name`, `enabled`)
SELECT lower(hex(randomblob(4)) || '-' || hex(randomblob(2)) || '-4' || substr(hex(randomblob(2)),2) || '-' || substr('89ab', abs(random()) % 4 + 1, 1) || substr(hex(randomblob(2)),2) || '-' || hex(randomblob(6))),
       c.id, '1_t1zLBmwOBJ48ySObioIxSlwOYyVmsYaxSiIQF6DJkE', 465742923, NULL, 1
FROM `company` c WHERE c.id = '6bc2d84b-c5b8-44b7-83de-bf190e4fe5d9' AND NOT EXISTS (SELECT 1 FROM `company_sheet` cs WHERE cs.company_id = c.id);

INSERT OR IGNORE INTO `company_sheet` (`id`, `company_id`, `spreadsheet_id`, `gid`, `sheet_name`, `enabled`)
SELECT lower(hex(randomblob(4)) || '-' || hex(randomblob(2)) || '-4' || substr(hex(randomblob(2)),2) || '-' || substr('89ab', abs(random()) % 4 + 1, 1) || substr(hex(randomblob(2)),2) || '-' || hex(randomblob(6))),
       c.id, '1_t1zLBmwOBJ48ySObioIxSlwOYyVmsYaxSiIQF6DJkE', 465742923, NULL, 1
FROM `company` c WHERE c.id = '3f40f1a3-3bb8-458e-880e-a74290974726' AND NOT EXISTS (SELECT 1 FROM `company_sheet` cs WHERE cs.company_id = c.id);

INSERT OR IGNORE INTO `company_sheet` (`id`, `company_id`, `spreadsheet_id`, `gid`, `sheet_name`, `enabled`)
SELECT lower(hex(randomblob(4)) || '-' || hex(randomblob(2)) || '-4' || substr(hex(randomblob(2)),2) || '-' || substr('89ab', abs(random()) % 4 + 1, 1) || substr(hex(randomblob(2)),2) || '-' || hex(randomblob(6))),
       c.id, '1_t1zLBmwOBJ48ySObioIxSlwOYyVmsYaxSiIQF6DJkE', 465742923, NULL, 1
FROM `company` c WHERE c.id = '0086f870-1db2-4b7e-ae92-2b3e51ae0a55' AND NOT EXISTS (SELECT 1 FROM `company_sheet` cs WHERE cs.company_id = c.id);

INSERT OR IGNORE INTO `company_sheet` (`id`, `company_id`, `spreadsheet_id`, `gid`, `sheet_name`, `enabled`)
SELECT lower(hex(randomblob(4)) || '-' || hex(randomblob(2)) || '-4' || substr(hex(randomblob(2)),2) || '-' || substr('89ab', abs(random()) % 4 + 1, 1) || substr(hex(randomblob(2)),2) || '-' || hex(randomblob(6))),
       c.id, '1_t1zLBmwOBJ48ySObioIxSlwOYyVmsYaxSiIQF6DJkE', 465742923, NULL, 1
FROM `company` c WHERE c.id = '655b86a5-99d4-4a66-849f-4f8a145da40b' AND NOT EXISTS (SELECT 1 FROM `company_sheet` cs WHERE cs.company_id = c.id);

INSERT OR IGNORE INTO `company_sheet` (`id`, `company_id`, `spreadsheet_id`, `gid`, `sheet_name`, `enabled`)
SELECT lower(hex(randomblob(4)) || '-' || hex(randomblob(2)) || '-4' || substr(hex(randomblob(2)),2) || '-' || substr('89ab', abs(random()) % 4 + 1, 1) || substr(hex(randomblob(2)),2) || '-' || hex(randomblob(6))),
       c.id, '1_t1zLBmwOBJ48ySObioIxSlwOYyVmsYaxSiIQF6DJkE', 465742923, NULL, 1
FROM `company` c WHERE c.id = '0a188042-1122-4dea-84dc-444f5a57e3f4' AND NOT EXISTS (SELECT 1 FROM `company_sheet` cs WHERE cs.company_id = c.id);

INSERT OR IGNORE INTO `company_sheet` (`id`, `company_id`, `spreadsheet_id`, `gid`, `sheet_name`, `enabled`)
SELECT lower(hex(randomblob(4)) || '-' || hex(randomblob(2)) || '-4' || substr(hex(randomblob(2)),2) || '-' || substr('89ab', abs(random()) % 4 + 1, 1) || substr(hex(randomblob(2)),2) || '-' || hex(randomblob(6))),
       c.id, '1_t1zLBmwOBJ48ySObioIxSlwOYyVmsYaxSiIQF6DJkE', 465742923, NULL, 1
FROM `company` c WHERE c.id = '1f401355-59ac-4d4c-b90c-fcdba6ed2c73' AND NOT EXISTS (SELECT 1 FROM `company_sheet` cs WHERE cs.company_id = c.id);

INSERT OR IGNORE INTO `company_sheet` (`id`, `company_id`, `spreadsheet_id`, `gid`, `sheet_name`, `enabled`)
SELECT lower(hex(randomblob(4)) || '-' || hex(randomblob(2)) || '-4' || substr(hex(randomblob(2)),2) || '-' || substr('89ab', abs(random()) % 4 + 1, 1) || substr(hex(randomblob(2)),2) || '-' || hex(randomblob(6))),
       c.id, '1_t1zLBmwOBJ48ySObioIxSlwOYyVmsYaxSiIQF6DJkE', 465742923, NULL, 1
FROM `company` c WHERE c.id = '776ffbab-68e0-4e1f-89bb-e57e571fcec3' AND NOT EXISTS (SELECT 1 FROM `company_sheet` cs WHERE cs.company_id = c.id);

INSERT OR IGNORE INTO `company_sheet` (`id`, `company_id`, `spreadsheet_id`, `gid`, `sheet_name`, `enabled`)
SELECT lower(hex(randomblob(4)) || '-' || hex(randomblob(2)) || '-4' || substr(hex(randomblob(2)),2) || '-' || substr('89ab', abs(random()) % 4 + 1, 1) || substr(hex(randomblob(2)),2) || '-' || hex(randomblob(6))),
       c.id, '1_t1zLBmwOBJ48ySObioIxSlwOYyVmsYaxSiIQF6DJkE', 465742923, NULL, 1
FROM `company` c WHERE c.id = 'f43afae8-0ff1-41f8-8887-191d5845f2f3' AND NOT EXISTS (SELECT 1 FROM `company_sheet` cs WHERE cs.company_id = c.id);

INSERT OR IGNORE INTO `company_sheet` (`id`, `company_id`, `spreadsheet_id`, `gid`, `sheet_name`, `enabled`)
SELECT lower(hex(randomblob(4)) || '-' || hex(randomblob(2)) || '-4' || substr(hex(randomblob(2)),2) || '-' || substr('89ab', abs(random()) % 4 + 1, 1) || substr(hex(randomblob(2)),2) || '-' || hex(randomblob(6))),
       c.id, '1_t1zLBmwOBJ48ySObioIxSlwOYyVmsYaxSiIQF6DJkE', 465742923, NULL, 1
FROM `company` c WHERE c.id = '2eccf4ca-e528-4e58-be0e-ba807476a866' AND NOT EXISTS (SELECT 1 FROM `company_sheet` cs WHERE cs.company_id = c.id);

INSERT OR IGNORE INTO `company_sheet` (`id`, `company_id`, `spreadsheet_id`, `gid`, `sheet_name`, `enabled`)
SELECT lower(hex(randomblob(4)) || '-' || hex(randomblob(2)) || '-4' || substr(hex(randomblob(2)),2) || '-' || substr('89ab', abs(random()) % 4 + 1, 1) || substr(hex(randomblob(2)),2) || '-' || hex(randomblob(6))),
       c.id, '1_t1zLBmwOBJ48ySObioIxSlwOYyVmsYaxSiIQF6DJkE', 465742923, NULL, 1
FROM `company` c WHERE c.id = 'cbd6724b-1450-4899-a370-167e4fa33fb6' AND NOT EXISTS (SELECT 1 FROM `company_sheet` cs WHERE cs.company_id = c.id);

INSERT OR IGNORE INTO `company_sheet` (`id`, `company_id`, `spreadsheet_id`, `gid`, `sheet_name`, `enabled`)
SELECT lower(hex(randomblob(4)) || '-' || hex(randomblob(2)) || '-4' || substr(hex(randomblob(2)),2) || '-' || substr('89ab', abs(random()) % 4 + 1, 1) || substr(hex(randomblob(2)),2) || '-' || hex(randomblob(6))),
       c.id, '1_t1zLBmwOBJ48ySObioIxSlwOYyVmsYaxSiIQF6DJkE', 465742923, NULL, 1
FROM `company` c WHERE c.id = '52401ab1-2728-4d35-9fd8-72775921cba2' AND NOT EXISTS (SELECT 1 FROM `company_sheet` cs WHERE cs.company_id = c.id);

INSERT OR IGNORE INTO `company_sheet` (`id`, `company_id`, `spreadsheet_id`, `gid`, `sheet_name`, `enabled`)
SELECT lower(hex(randomblob(4)) || '-' || hex(randomblob(2)) || '-4' || substr(hex(randomblob(2)),2) || '-' || substr('89ab', abs(random()) % 4 + 1, 1) || substr(hex(randomblob(2)),2) || '-' || hex(randomblob(6))),
       c.id, '1_t1zLBmwOBJ48ySObioIxSlwOYyVmsYaxSiIQF6DJkE', 465742923, NULL, 1
FROM `company` c WHERE c.id = '29de1428-755c-41ce-8181-81f6d94f6ee2' AND NOT EXISTS (SELECT 1 FROM `company_sheet` cs WHERE cs.company_id = c.id);

INSERT OR IGNORE INTO `company_sheet` (`id`, `company_id`, `spreadsheet_id`, `gid`, `sheet_name`, `enabled`)
SELECT lower(hex(randomblob(4)) || '-' || hex(randomblob(2)) || '-4' || substr(hex(randomblob(2)),2) || '-' || substr('89ab', abs(random()) % 4 + 1, 1) || substr(hex(randomblob(2)),2) || '-' || hex(randomblob(6))),
       c.id, '1_t1zLBmwOBJ48ySObioIxSlwOYyVmsYaxSiIQF6DJkE', 465742923, NULL, 1
FROM `company` c WHERE c.id = 'ab8dee71-bd03-4d7f-aa07-e76396efd411' AND NOT EXISTS (SELECT 1 FROM `company_sheet` cs WHERE cs.company_id = c.id);

INSERT OR IGNORE INTO `company_sheet` (`id`, `company_id`, `spreadsheet_id`, `gid`, `sheet_name`, `enabled`)
SELECT lower(hex(randomblob(4)) || '-' || hex(randomblob(2)) || '-4' || substr(hex(randomblob(2)),2) || '-' || substr('89ab', abs(random()) % 4 + 1, 1) || substr(hex(randomblob(2)),2) || '-' || hex(randomblob(6))),
       c.id, '1_t1zLBmwOBJ48ySObioIxSlwOYyVmsYaxSiIQF6DJkE', 465742923, NULL, 1
FROM `company` c WHERE c.id = '19e014b3-8f63-4d2e-ba9c-6225f0bb6f70' AND NOT EXISTS (SELECT 1 FROM `company_sheet` cs WHERE cs.company_id = c.id);

INSERT OR IGNORE INTO `company_sheet` (`id`, `company_id`, `spreadsheet_id`, `gid`, `sheet_name`, `enabled`)
SELECT lower(hex(randomblob(4)) || '-' || hex(randomblob(2)) || '-4' || substr(hex(randomblob(2)),2) || '-' || substr('89ab', abs(random()) % 4 + 1, 1) || substr(hex(randomblob(2)),2) || '-' || hex(randomblob(6))),
       c.id, '1_t1zLBmwOBJ48ySObioIxSlwOYyVmsYaxSiIQF6DJkE', 465742923, NULL, 1
FROM `company` c WHERE c.id = '2ceb7b4a-fd73-4b4d-b1e7-8f292e5ecca4' AND NOT EXISTS (SELECT 1 FROM `company_sheet` cs WHERE cs.company_id = c.id);

INSERT OR IGNORE INTO `company_sheet` (`id`, `company_id`, `spreadsheet_id`, `gid`, `sheet_name`, `enabled`)
SELECT lower(hex(randomblob(4)) || '-' || hex(randomblob(2)) || '-4' || substr(hex(randomblob(2)),2) || '-' || substr('89ab', abs(random()) % 4 + 1, 1) || substr(hex(randomblob(2)),2) || '-' || hex(randomblob(6))),
       c.id, '1_t1zLBmwOBJ48ySObioIxSlwOYyVmsYaxSiIQF6DJkE', 465742923, NULL, 1
FROM `company` c WHERE c.id = 'c1c9e4d7-b702-41aa-ac5f-58bb86a03922' AND NOT EXISTS (SELECT 1 FROM `company_sheet` cs WHERE cs.company_id = c.id);

INSERT OR IGNORE INTO `company_sheet` (`id`, `company_id`, `spreadsheet_id`, `gid`, `sheet_name`, `enabled`)
SELECT lower(hex(randomblob(4)) || '-' || hex(randomblob(2)) || '-4' || substr(hex(randomblob(2)),2) || '-' || substr('89ab', abs(random()) % 4 + 1, 1) || substr(hex(randomblob(2)),2) || '-' || hex(randomblob(6))),
       c.id, '1_t1zLBmwOBJ48ySObioIxSlwOYyVmsYaxSiIQF6DJkE', 465742923, NULL, 1
FROM `company` c WHERE c.id = 'd7727930-07f3-4b82-9a9f-686516f014e8' AND NOT EXISTS (SELECT 1 FROM `company_sheet` cs WHERE cs.company_id = c.id);

INSERT OR IGNORE INTO `company_sheet` (`id`, `company_id`, `spreadsheet_id`, `gid`, `sheet_name`, `enabled`)
SELECT lower(hex(randomblob(4)) || '-' || hex(randomblob(2)) || '-4' || substr(hex(randomblob(2)),2) || '-' || substr('89ab', abs(random()) % 4 + 1, 1) || substr(hex(randomblob(2)),2) || '-' || hex(randomblob(6))),
       c.id, '1_t1zLBmwOBJ48ySObioIxSlwOYyVmsYaxSiIQF6DJkE', 465742923, NULL, 1
FROM `company` c WHERE c.id = '0d1f4166-0be1-4076-bd50-33b6fa8911d8' AND NOT EXISTS (SELECT 1 FROM `company_sheet` cs WHERE cs.company_id = c.id);

INSERT OR IGNORE INTO `company_sheet` (`id`, `company_id`, `spreadsheet_id`, `gid`, `sheet_name`, `enabled`)
SELECT lower(hex(randomblob(4)) || '-' || hex(randomblob(2)) || '-4' || substr(hex(randomblob(2)),2) || '-' || substr('89ab', abs(random()) % 4 + 1, 1) || substr(hex(randomblob(2)),2) || '-' || hex(randomblob(6))),
       c.id, '1_t1zLBmwOBJ48ySObioIxSlwOYyVmsYaxSiIQF6DJkE', 465742923, NULL, 1
FROM `company` c WHERE c.id = '7386136e-961d-4b86-af70-639cd5eec05a' AND NOT EXISTS (SELECT 1 FROM `company_sheet` cs WHERE cs.company_id = c.id);

INSERT OR IGNORE INTO `company_sheet` (`id`, `company_id`, `spreadsheet_id`, `gid`, `sheet_name`, `enabled`)
SELECT lower(hex(randomblob(4)) || '-' || hex(randomblob(2)) || '-4' || substr(hex(randomblob(2)),2) || '-' || substr('89ab', abs(random()) % 4 + 1, 1) || substr(hex(randomblob(2)),2) || '-' || hex(randomblob(6))),
       c.id, '1_t1zLBmwOBJ48ySObioIxSlwOYyVmsYaxSiIQF6DJkE', 465742923, NULL, 1
FROM `company` c WHERE c.id = 'c5d8a7ee-1936-4fc2-8561-4528d973e7fe' AND NOT EXISTS (SELECT 1 FROM `company_sheet` cs WHERE cs.company_id = c.id);
