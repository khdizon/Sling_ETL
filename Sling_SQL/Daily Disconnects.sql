-- Daily Disconnects
-- V1: 9th April 2024

WITH disconnects AS 
    (SELECT
        drvd_acnt_dcnct_dt,
        count(acnt_sk) as disco_count
            FROM edw_ott.ott_drvd_acnt_prfl as detailed_acnt
                WHERE drvd_acnt_sts_cd in ('De-Active')
                    AND drvd_acnt_dcnct_dt between detailed_acnt.bgn_eff_dt and detailed_acnt.endg_eff_dt 
                    AND pyng_ind = 1
                    AND drvd_acnt_dcnct_dt between '2020-01-01' and current_date - 1
                    AND drvd_tst_acnt_ind = 0
                    AND frmr_typ_cd <> '-1'
                    ---and drvd_5_dlr_acnt_ind =1
        GROUP BY 1
    ),

pause AS 
    (SELECT
        bgn_eff_dt,
        count(acnt_sk) as pause_count
            FROM edw_ott.ott_drvd_acnt_prfl as detailed_acnt
                WHERE drvd_acnt_sts_cd in ('Paused')
                    AND bgn_eff_dt between detailed_acnt.bgn_eff_dt and detailed_acnt.endg_eff_dt 
                    AND pyng_ind = 1
                    --and detailed_acnt.drvd_5_dlr_acnt_ind =1
                    and bgn_eff_dt between '2020-01-01' and current_date - 1
        GROUP BY 1
    )


SELECT
    drvd_acnt_dcnct_dt AS disconnect_date,
    disconnects.disco_count AS disconnected,
    pause.pause_count AS paused,
    disconnects.disco_count + pause.pause_count AS total_disco

FROM disconnects

LEFT JOIN pause
    ON disconnects.drvd_acnt_dcnct_dt = pause.bgn_eff_dt

GROUP BY 1,2,3,4
ORDER BY 1