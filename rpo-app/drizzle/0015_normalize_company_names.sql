-- Step 1: 重複する方（全角スペース版）の応募者を半角スペース版に付け替え
UPDATE `applicant`
SET `company_id` = (
    SELECT `half`.`id`
    FROM `company` `full`
    JOIN `company` `half` ON `half`.`name` = REPLACE(`full`.`name`, '　', ' ')
    WHERE `full`.`id` = `applicant`.`company_id`
    AND `half`.`id` <> `full`.`id`
    LIMIT 1
)
WHERE `company_id` IN (
    SELECT `full`.`id`
    FROM `company` `full`
    WHERE `full`.`name` LIKE '%　%'
    AND EXISTS (
        SELECT 1 FROM `company` `half`
        WHERE `half`.`name` = REPLACE(`full`.`name`, '　', ' ')
        AND `half`.`id` <> `full`.`id`
    )
);

-- Step 2: company_sheet も同様に付け替え
UPDATE `company_sheet`
SET `company_id` = (
    SELECT `half`.`id`
    FROM `company` `full`
    JOIN `company` `half` ON `half`.`name` = REPLACE(`full`.`name`, '　', ' ')
    WHERE `full`.`id` = `company_sheet`.`company_id`
    AND `half`.`id` <> `full`.`id`
    LIMIT 1
)
WHERE `company_id` IN (
    SELECT `full`.`id`
    FROM `company` `full`
    WHERE `full`.`name` LIKE '%　%'
    AND EXISTS (
        SELECT 1 FROM `company` `half`
        WHERE `half`.`name` = REPLACE(`full`.`name`, '　', ' ')
        AND `half`.`id` <> `full`.`id`
    )
);

-- Step 3: 重複する全角スペース版の企業を削除
DELETE FROM `company`
WHERE `id` IN (
    SELECT `full`.`id`
    FROM `company` `full`
    WHERE `full`.`name` LIKE '%　%'
    AND EXISTS (
        SELECT 1 FROM `company` `half`
        WHERE `half`.`name` = REPLACE(`full`.`name`, '　', ' ')
        AND `half`.`id` <> `full`.`id`
    )
);

-- Step 4: 残りの全角スペースを半角スペースに正規化（重複なし分）
UPDATE `company`
SET `name` = REPLACE(`name`, '　', ' ')
WHERE `name` LIKE '%　%';

-- Step 5: 連続スペースを1つに統一
UPDATE `company`
SET `name` = REPLACE(`name`, '  ', ' ')
WHERE `name` LIKE '%  %';

UPDATE `company`
SET `name` = REPLACE(`name`, '  ', ' ')
WHERE `name` LIKE '%  %';

-- Step 6: trim
UPDATE `company`
SET `name` = TRIM(`name`)
WHERE `name` <> TRIM(`name`);
