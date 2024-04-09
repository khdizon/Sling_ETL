-- Package Function 

    CASE -- # Function: Package Details
        -- Core
	 	WHEN acnt_core_typ_cd = 'DOMESTIC' THEN 'Orange'
        WHEN acnt_core_typ_cd = 'DOMESTIC-MSS' THEN 'Blue'
		WHEN acnt_core_typ_cd = 'DOMESTIC/DOMESTIC-MSS' THEN 'Combo'
        --International
        WHEN acnt_core_typ_cd = 'INTERNATIONAL' THEN 'International'
        WHEN acnt_core_typ_cd = 'DOMESTIC/INTERNATIONAL' THEN 'Orange International'
        WHEN acnt_core_typ_cd = 'DOMESTIC-MSS/INTERNATIONAL' THEN 'Blue International'
        WHEN acnt_core_typ_cd = 'DOMESTIC/DOMESTIC-MSS/INTERNATIONAL' THEN 'Combo International'
        -- Latino
        WHEN acnt_core_typ_cd = 'LATINO' THEN 'Latino'
        WHEN acnt_core_typ_cd = 'DOMESTIC/LATINO' THEN 'Orange Latino'
        WHEN acnt_core_typ_cd = 'DOMESTIC-MSS/LATINO' THEN 'Blue Latino'
        WHEN acnt_core_typ_cd = 'DOMESTIC/DOMESTIC-MSS/LATINO' THEN 'Combo Latino'
        -- International/Latino/Combo
        WHEN acnt_core_typ_cd = 'INTERNATIONAL/LATINO' THEN 'International/Latino'
        WHEN acnt_core_typ_cd = 'DOMESTIC/INTERNATIONAL/LATINO' THEN 'Orange/International/Latino'
        WHEN acnt_core_typ_cd = 'DOMESTIC-MSS/INTERNATIONAL/LATINO' THEN 'Blue/International/Latino'
        WHEN acnt_core_typ_cd = 'DOMESTIC/DOMESTIC-MSS/INTERNATIONAL/LATINO' THEN 'Combo/Internation/Latino'
        -- Other
        ELSE 'Unknow'
    END AS package_name,



-- Package Function # 2 Using All the Core + Add ons
-- Churn by Entitlements

SELECT
    EXTRACT(YEAR FROM cal.clndr_dt) AS year,
    EXTRACT(MONTH FROM cal.clndr_dt) AS month,
    cal.clndr_dt AS date,
    CASE -- # Function: Package Details
        WHEN acnt_core_typ_cd IN (
            'DOMESTIC',
            'DOMESTIC/INTERNATIONAL',
            'DOMESTIC/LATINO',
            'DOMESTIC/INTERNATIONAL/LATINO'
        ) THEN 'Orange'
        WHEN acnt_core_typ_cd IN (
            'DOMESTIC-MSS',
            'DOMESTIC-MSS/INTERNATIONAL',
            'DOMESTIC-MSS/LATINO',
            'DOMESTIC-MSS/INTERNATIONAL/LATINO'
        ) THEN 'Blue'
        WHEN acnt_core_typ_cd IN (
            'DOMESTIC/DOMESTIC-MSS',
            'DOMESTIC/DOMESTIC-MSS/INTERNATIONAL',
            'DOMESTIC/DOMESTIC-MSS/LATINO',
            'DOMESTIC/DOMESTIC-MSS/INTERNATIONAL/LATINO'
        ) THEN 'Combo'
                WHEN acnt_core_typ_cd IN (
            'INTERNATIONAL/LATINO', 'INTERNATIONAL', 'LATINO'
        ) THEN 'International/Latino'
        -- Other
        ELSE 'Unknown'
    END AS package_name,
    COUNT(acnt_sk) AS subscribers
FROM 
    edw_ott.ott_drvd_acnt_prfl AS acnt_profile
    INNER JOIN dim.clndr_dim AS cal
    ON cal.clndr_dt BETWEEN acnt_profile.bgn_eff_dt AND acnt_profile.endg_eff_dt
        AND cal.clndr_dy_of_mnth = 1
WHERE 
    drvd_acnt_sts_cd IN ('Past Due','Cancel','Active') --# In place of cur_ind = 1
    AND pyng_ind = 1 --# Paying customer
    --AND acnt_core_typ_cd IN ('DOMESTIC-MSS', 'DOMESTIC/DOMESTIC-MSS', 'DOMESTIC')
    AND cal.clndr_dt BETWEEN '01-01-2022' AND current_date
GROUP BY 1,2,3,4
ORDER BY 3, subscribers DESC
