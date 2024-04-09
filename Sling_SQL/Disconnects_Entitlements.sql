-- Daily Disconnects
-- V1: 9th April 2024

WITH disconnects AS 
    (SELECT
        drvd_acnt_dcnct_dt,
        count(acnt_sk) as disco_count,
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
        END AS package_name
            FROM edw_ott.ott_drvd_acnt_prfl as acnt_profile
                WHERE drvd_acnt_sts_cd in ('De-Active')
                    AND drvd_acnt_dcnct_dt between acnt_profile.bgn_eff_dt and acnt_profile.endg_eff_dt 
                    AND pyng_ind = 1
                    AND drvd_acnt_dcnct_dt between '2024-04-01' and current_date - 1
                    AND drvd_tst_acnt_ind = 0
                    AND frmr_typ_cd <> '-1'
                    ---and drvd_5_dlr_acnt_ind =1a
        GROUP BY 1,3
    ),

pause AS 
    (SELECT
        bgn_eff_dt,
        count(acnt_sk) as pause_count,
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
        END AS package_name
            FROM edw_ott.ott_drvd_acnt_prfl as acnt_profile
                WHERE drvd_acnt_sts_cd in ('Paused')
                    AND bgn_eff_dt between acnt_profile.bgn_eff_dt and acnt_profile.endg_eff_dt 
                    AND pyng_ind = 1
                    --and detailed_acnt.drvd_5_dlr_acnt_ind =1
                    and bgn_eff_dt between '2024-04-01' and current_date - 1
        GROUP BY 1,3
    ),


BOP AS 
    (SELECT
        cal.clndr_dt AS date,
        count(acnt_sk) AS subscribers,
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
            END AS package_name

            FROM edw_ott.ott_drvd_acnt_prfl as acnt_profile
                INNER JOIN dim.clndr_dim AS cal 
                    ON cal.clndr_dt BETWEEN acnt_profile.bgn_eff_dt AND acnt_profile.endg_eff_dt
                    --AND cal.clndr_dy_of_mnth = 1
            WHERE drvd_acnt_sts_cd in ('Past Due','Cancel','Active')
                AND pyng_ind = 1
                AND cal.clndr_dt between '2024-01-01' and current_date-1
        GROUP BY 1,3
        ORDER BY 1
    )

SELECT
    drvd_acnt_dcnct_dt AS disconnect_date,
    disconnects.package_name,
    BOP.subscribers AS package_subs,
    disconnects.disco_count AS disconnected,
    pause.pause_count AS paused,
    disconnects.disco_count + count(pause.pause_count) AS total_disco,
    ROUND((CAST(total_disco AS DECIMAL)) / CAST(package_subs AS DECIMAL) * 100, 2) AS disco_rate

FROM disconnects

LEFT JOIN pause
    ON disconnects.drvd_acnt_dcnct_dt = pause.bgn_eff_dt
    AND disconnects.package_name = pause.package_name

LEFT JOIN BOP
    ON disconnects.drvd_acnt_dcnct_dt = BOP.date
    AND disconnects.package_name = BOP.package_name

GROUP BY 1,2,3,4,5
ORDER BY 1
